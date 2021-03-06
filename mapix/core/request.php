<?php
/**
 * Mapix Request helper class
 * @author IRCF
 */

//require_once('config.php');
//require_once('log.php');

class Request{
	
	/**
	 * Retrieve a GET parameter from current request
	 * @param $param	parameter name
	 * @return		parameter value
	 */
	function get($param=''){
		return isset($_GET[$param])?$_GET[$param]:null;
	}

	/**
	 * Retrieve a POST parameter from current request
	 * @param $param	parameter name
	 * @return		parameter value
	 */
	function post($param=''){
		return isset($_POST[$param])?$_POST[$param]:null;
	}

	/**
	 * Match URL from current request against a regexp pattern
	 * @param $pattern	regexp URL pattern to match
	 * @return		TRUE if matched, FALSE else
	 */
	function url($pattern=''){
	}

	/**
	 * Match URI from current request against a regexp pattern
	 * @param $pattern	regexp URI pattern to match
	 * @return		TRUE if matched, FALSE else
	 */
	function uri($pattern=''){
		$matches = array();
		$result = preg_match('/'.htmlspecialchars_decode($pattern).'/', $_SERVER['REQUEST_URI'], $matches);
		$_GET = array_merge($_GET, $matches);
		return $result===0?false:true;
	}
}
