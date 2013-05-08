<?php
/**
 * Mapix EXSLT register and stream class
 * Automates EXSLT static functions declaration from a given PHP class
 * @author IRCF
 */

require_once('config.php');
require_once('rest.php');

class EXSLT{

	/**
	 * Generate EXSLT stylesheet
	 * @param $uri		URI of the PHP class (without the .php extension)
	 * @param $options	Core and EXSLT options
	 * @return a string containing the EXSLT declaration of all class static public methods
	 */
	static function get($uri, $options = array()){
		$options = Config::get($options);
		$strFunctions = '';
		$file = $options['file']['root'].$uri.'.php';
		if (file_exists($file)){
			require_once($file);
			$class = new ReflectionClass(basename($uri));
			$prefix = strtolower($class->getName());
			foreach($class->getMethods() as $method){
				//if ($method->isStatic() && $method->isPublic()){ // TODO Non-static methods can now be used...
					$params = $method->getParameters();
					$strParams = '';
					$strValues = '';
					foreach($params as $param){
						$strParams.= sprintf($options['exslt']['param'.($param->isOptional()?'_optional':'')],$param->getName());
						$strValues.= ',' . ($param->isOptional() && is_array($param->getDefaultValue())?'$'.$param->getName():'string($'.$param->getName().')');
					}
					$strFunctions.= sprintf($options['exslt']['function'],$prefix,$method->getName(),$strParams,$class->getName(),$method->getName(),$strValues);
				//}
			}
			return sprintf($options['exslt']['stylesheet'],$prefix,'exslt://'.$uri,$strFunctions);
		}else{
			return $options['http']['404_header'];
		}
	}

	/**
	 * Execute a method from XSL
	 * @param $className
	 * @param $methodName
	 * @param $args [...]
	 * @see REST::execute()
	 * TODO Handle param type conversion : nodeset -> array
	 * TODO Handle return type conversion : array -> nodeset
	 */
	static function execute(){
		$arguments = func_get_args();
		$className = array_shift($arguments);
		$methodName = array_shift($arguments);
		//foreach ($arguments as $i => $argument) if (empty($argument)) $arguments[$i] = null;
		$result = REST::execute($className,$methodName,$arguments,Serialize::NODE);
		return $result;
	}

	/** EXSLT stream handler */

	protected $position;
	protected $response;
	
	function __construct(){
		$this->position = 0;
		$this->response = '';
	}

	function stream_open($path, $mode, $options, &$opened_path){
		$this->response = self::get(str_replace('exslt://','',$path));
		return true;
	}

	function stream_read($count){
		$result = substr($this->response, $this->position, $count); 
		$this->position += $count;
		return $result;
	}

	function stream_write($data){
		return 0;
	}

	function url_stat(){
		return array();
	}

	function stream_eof(){
		return true;
	}
}
