<?php
/**
 * Mapix XRT parser (XML Request Transform)
 * @author IRCF
 */

require_once('config.php');
require_once('log.php');
require_once('cache.php');
require_once('serialize.php');
require_once('exslt.php');

class XRT{

	/** 
	 * XRT request handler
	 * Step -1: Initialisation
	 * Step 0 : Gather request parameters
	 * Step 1 : Read response from cache, if exists then goto step 5
	 * Step 2 : Create a http:request DOM document, see http XML Schema for more information TODO Create http XML Schema
	 * Step 3 : Load XSL index and transform http:request to HTTP response
	 * Step 4 : Parse http:header cache and write to cache if cache-control header has a numeric value (ttl)
	 * Step 5 : Parse and strip http:header elements
	 * Step 6 : Return HTTP response body
	 * TODO Remove http xmlns for http:parameter and http:session descendant nodes
	 * TODO Fix virtual-uri in mapix/non mapix URIs
	 * @return HTTP response body
	 */
	static function __callStatic($method, $arguments) {
		$options = Config::get();		
		/* Step 0 : Gather request parameters */
		$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
		$redirect_uri = $_SERVER['REDIRECT_URL'];
		$index = self::index($redirect_uri,$options);
		session_start();
		$options['request'] = array(
			'@' => array('xmlns' => 'exslt://mapix/core/http'),
			'method' => $method,
			'uri' => $uri,
			'parameter' => $arguments,
			'url' => $options['http']['root'].$uri,
			'virtual-uri' => trim(substr($redirect_uri,strlen(dirname($index)),strlen($redirect_uri)),'/'),// This works for mapix URIs
			//'virtual-uri' => trim(substr($uri,strlen(dirname($index)),strlen($uri)),'/'),// This works for non mapix URIs
			'redirect-uri' => $redirect_uri,
			'session' => $_SESSION
		);
		//print_r($options['request']);
		/* Step 1 : Read response from cache, if exists then goto step 5 */
		$response = Cache::get($options['request']['url'],$options);
		if (!$response){
			/* Step 2 : Create a http:request DOM document, see http XML Schema for more information TODO Create http XML Schema */
			$request = new DomDocument();
			$requestXml = Serialize::array2xml(array('request'=>$options['request']));
			Log::put('XML request : '.$requestXml);
			$request->loadXML($requestXml);
	 		/* Step 3 : Load XSL index and transform http:request to HTTP response */
			$template = new DomDocument();
			Log::put('XSL controller : '.$index);
			$template->load($options['file']['root'].$index);
			$xsltProcessor = new xsltprocessor();
			$xsltProcessor->registerPhpFunctions();
			stream_wrapper_register('exslt', 'EXSLT');
			$xsltProcessor->importStylesheet($template);
			$response = $xsltProcessor->transformToXml($request);
			/* Step 4 : Parse http:header cache and write to cache if cache-control header has a numeric value (ttl) */
			if (preg_match('/<http:header.*?name="cache-control".*?>([0-9]*)<\/http:header>/i', $response, $matches)){
				$options['cache']['ttl'] = $matches[1];
				$options['content'] = $response;
				Cache::put($options['request']['url'],$options);
			}
		}
	 	/* Step 5 : Parse and strip http:header elements */
		// TODO Regroup these two regexp
		$response = preg_replace_callback('/<http:header.*?name="(.*?)".*?>([^<]*)<\/http:header>/im',create_function('$matches','header($matches[1].":".$matches[2]);return "";'),$response);
		$response = preg_replace_callback('/<http:header.*?>([^<]*)<\/http:header>/im',create_function('$matches','header($matches[1]);return "";'),$response);
		/* Step 6 : Return HTTP response body */
		return trim($response);
	}

	/**
	 * Find the nearest index file from a given $uri
	 * @param $uri	Current URI
	 * @return URI of the nearest index file 
	 */
	static function index($uri, $options = array()){
		$options = Config::get($options);
		$uri = str_replace('\\','/',$uri);
		if (substr($uri,-1)!='/') $uri.='/';
		if ($uri=='/' || file_exists($options['file']['root'].$uri.$options['xrt']['index'])){
			$result = $uri.$options['xrt']['index'];
		}else{
			$result = self::index(dirname($uri),$options);
		}
		return $result;
	}
}

/** Enable REST interface */
require_once('rest.php');
REST::register('XRT');
