<?php
/**
 * Serialize utility class
 * This class contains static methods to convert many data types
 * @author IRCF
 */

class Serialize{

	/** Formats */
	const NONE = null;
	const XML = 'application/xml';
	const TEXT = 'text/plain';
	const JSON = 'application/json';
	const NODE = 'application/node';

	/**
	 * Name of temporary nodes when need to serialize a indexed array or a node set
	 */
	const ROOT = 'xmlSerializedElement';

	/**
	 * Recursion marker in a serialized variable (empty = mute recursion)
	 */
	const RECURSION = '';

	/**
	 * Serialize an array into a XML string
	 * @param $variable	a string or an array
	 * @param $parentKey	name of the root node (recommended if $variable is an indexed array)
	 * @return a XML string representing the $variable
	 * TODO Fix RECURSION BUG : cannot serialize recursive arrays...
	 */
	static function array2xml($variable,$parentKey=0){
		if (is_array($variable)){
			$result = '';
			foreach($variable as $key => $value){
				$nodeName = is_numeric($key) ? $parentKey : $key;
				if (is_numeric($nodeName)) $nodeName = self::ROOT;
				$tag = !is_numeric($key) || (!is_array($value) && is_numeric($parentKey));
				if ($tag){
					$result.= '<' . $nodeName;
					if (is_array($value) && array_key_exists('@', $value)){
						foreach($value['@'] as $attKey=>$attValue){
							$result.= ' '.$attKey.'="'.$attValue.'"';
						}
						unset($value['@']);
					}
					$result.= '>';
				}
				if ($variable===$value){
					$result.= self::RECURSION;
				}else{
					$result.= self::array2xml($value,$key);
				}
				if ($tag){
					$result.= '</' . $nodeName . '>';
				}
			}
		}else{
			$result = $variable;
		}
		return $result;
	}

	/**
	 * Serialize a XML string into an array PHP
	 * The variable is wrapped into a temporary root node to allow serialization of node sets
	 * @param $variable a XML string
	 * @return a string or an array representing the $variable
	 * @see self::node2array()
	 */
	static function xml2array($variable){
		if (strpos($variable,'<')===false) return $variable;
		$dom = new DomDocument();
		$isXml = $dom->loadXML('<'.self::ROOT.'>'.trim(self::stripprologue($variable)).'</'.self::ROOT.'>');
		if (!$isXml) return $variable;
		$result = self::node2array($dom->documentElement);
		return $result[self::ROOT];
	}
	
	/**
	 * Serialize a DomNode into an array
	 * @param $node	a DomNode instance
	 * @param $displayXmlns	an integer indicating on how many levels must xmlns attributes be kept
	 * @return an array representing the $node
	 * @see self::xml2array()
	 */
	static function node2array($node,$displayXmlns=1){
		$result = array();
		$result[$node->nodeName] = array();
		$simpleNode = simplexml_import_dom($node);
		$nsArray = $simpleNode->getNamespaces();
		$nsDisplayedArray = array();
		foreach ($nsArray as $nsKey => $nsValue) {
			if ($node->prefix != $nsKey || $displayXmlns){
				$nsDisplayedArray["xmlns".(empty($nsKey)?"":":".$nsKey)] = $nsValue;
			}
		}
		if (count($nsDisplayedArray)>0){
			$result[$node->nodeName]["@"] = $nsDisplayedArray;
		}
		if ($node->hasAttributes()){
			if (count($nsDisplayedArray)<=0) $result[$node->nodeName]["@"] = array();
			foreach ($node->attributes as $attr) {
				$attrName = (empty($attr->prefix)?"":$attr->prefix.":").$attr->name;
				if (strpos($attrName,":") === 0 ) $attrName = substr($attrName,1,strlen($attrName)-1);
				$result[$node->nodeName]["@"][$attrName] = $attr->value;
			}
		}
		foreach($node->childNodes as $child) {
			if ($child->nodeType == XML_ELEMENT_NODE) {			
				if ($child->nodeName == self::ROOT){				
					$result[$node->nodeName][] = $child->nodeValue;
				}else{
					$tmp = self::node2array($child,max($displayXmlns-1,0));
					$result[$node->nodeName][] = $tmp;
				}
			}else{
				$result[$node->nodeName][] = $child->nodeValue;
			}
		}
		return $result;
	}

	/**
	 * Serialize a variable into a node (DomNode)
	 * @param $variable	a string or an array
	 * @param $parentKey	name of the parent node (recommended if $variable is an indexed array)
	 * @return a node representing the $variable
	 */
	static function array2node($variable,$parentKey=0){
		$dom = new DomDocument();
		$dom->loadXML('<'.self::ROOT.'>'.self::array2xml($variable,$parentKey).'</'.self::ROOT.'>');
		return $dom->documentElement;
	}

	/**
	 * Remove addtional backslashes from a string or an array
	 * @param $variable	a string or an array
	 * @return the $variable unescaped
	 */
	static function stripslashes($variable){		
		if (is_array($variable)){
			$result = array();
			foreach ($variable as $key => $value) {
				$result[$key] = self::stripslashes($value);
			}
		}else{
			$result = stripslashes($variable);
		}
		return $result;
	}

	/**
	 * Remove the XML and DOCTYPE tags in a XML string
	 * @param $xml	a XML string
	 * @return the $xml string without XML and DOCTYPE tags
	 */
	static function stripprologue($xml){
		$xml = preg_replace('/<\?xml (.*?)\?>/is','', $xml);
		$xml = preg_replace('/<!DOCTYPE (.*?)>/is','',$xml);
		return $xml;
	}

	/**
	 * Serialize a variable into a specific format (see format constants)
	 * @param $variable	a string or an array
	 * @param $format	a format constant (self::XML,self::TEXT,self::JSON,self::DOM)
	 * @return the serialized $variable
	 */
	static function array2format($variable, $format = self::NONE){
		if (is_array($variable)){
			switch($format){
				case self::XML :
					$variable = self::array2xml($variable);
					break;
				case self::TEXT :
					$variable = serialize($variable);
					break;
				case self::JSON :
					$variable = json_encode($variable);
					break;
				case self::NODE :
					$variable = self::array2node($variable);
					break;
				default :
					break;
			}
		}
		return $variable;
	}
}
