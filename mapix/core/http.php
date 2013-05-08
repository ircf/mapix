<?php
/**
 * Mapix HTTP client
 * @author IRCF
 */

require_once('config.php');
require_once('log.php');

class HTTP{

	/** 
	 * GET request handler
	 * @param $url		HTTP request URL
	 * @param $parameters	HTTP request parameters
	 * @option method	HTTP method (default : GET)
	 * @return HTTP response body
	 * TODO Handle relative URL (URI)
	 * TODO Fix http_query_vars()
	 */
	static function get($url,$parameters = array(),$options = array()) {
		$options = Config::get($options);
		if (!isset($options['method'])) $options['method'] = 'get';
		$response = Cache::get($url,$options);
		if (!$response){
			query_str($parameters,$parameters);
			$curl = curl_init();
			Log::put(Log::NOTICE,'HTTP '.$options['method'].' '.$url.'?'.$parameters);
			if ($options['method'] == 'post'){
				curl_setopt($curl, CURLOPT_URL, $url);
				curl_setopt($curl, CURLOPT_POST, 1);
				curl_setopt($curl, CURLOPT_POSTFIELDS, $parameters);
			}else{
				curl_setopt($curl, CURLOPT_CUSTOMREQUEST, $options['method']);
				curl_setopt($curl, CURLOPT_URL, $url.'?'.$parameters);
			}
			curl_setopt($curl, CURLOPT_COOKIE, session_name() . '=' . session_id());
			curl_setopt($curl, CURLOPT_TIMEOUT, 120);
			curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
			session_write_close();
			$response = curl_exec($curl);
			if (!$response){
				$response = $options['http']['404_header'];
			}else{
				$options['content'] = $response;
				if (isset($options['cache']['ttl'])) Cache::put($url,$options);
			}
		}
		return $response;
	}

	/**
	 * POST request handler
	 * @param $url		HTTP request URL
	 * @param $parameters	HTTP request parameters
	 * @return HTTP response body
	 */
	static function post($url,$parameters=array(),$options=array()){
		$options['method'] = 'post';
		return self::get($url,$parameters,$options);
	}
}
