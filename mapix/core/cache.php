<?php
/**
 * Mapix cache handler
 * @author IRCF
 */

require_once('config.php');
require_once('log.php');

class Cache{

	/**
	 * Write a content in the cache directory, beginning with the cache prologue
	 * The cache prologue is a XML comment containing the cache begin/end timestamp
	 * @param url	The file to create
	 * @option content	The content to cache
	 * @return true if the file is created, false otherwise
	 * @see self::get()
	 */
	static function put($url,$options = array()){
		$options = Config::get($options);
		$result = false;
		if (!isset($options['cache']) || !isset($options['cache']['prologue']) || !isset($options['cache']['replace'])) return false;
		$url = str_replace('/',$options['cache']['replace'],$url);
		$url = str_replace(':',$options['cache']['replace'],$url);
		$file = @fopen($options['file']['root'].$options['cache']['dir'].$url,"w+");
		if ($file!=null){	
			$cacheBegin = time();
			$cacheEnd = $cacheBegin + $options['cache']['ttl'];
			fprintf($file,$options['cache']['prologue'],$cacheBegin,$cacheEnd);
			fwrite($file,$options['content']);
			@fclose($file);
			$result = true;
			Log::put(Log::NOTICE,'Wrote to cache '.$url);
		}
		return $result;
	}

	/**
	 * Check whether response exists in the cache directory, if not return false
	 * Otherwise, open the file and read the cache prologue
	 * If the cache is expired (cache end < now) then delete the file and return false,
	 * else read and return cached content 
	 * @param $url	The file to check for in the cache
	 * @option $return_url	boolean, return cached file URL instead of cached content
	 * @return FALSE if file is not cached,  cached file URL if $return_url is TRUE, cached content otherwise
	 * @see self::put()
	 */
	static function get($url,$options = array()){
		$options = Config::get($options);
		$result = false;
		if (!isset($options['cache']) || !isset($options['cache']['prologue']) || !isset($options['cache']['replace'])) return false;
		$url = str_replace('/',$options['cache']['replace'],$url);
		$url = str_replace(':',$options['cache']['replace'],$url);
		if (file_exists($options['file']['root'].$options['cache']['dir'].$url)){
			$file = @fopen($options['file']['root'].$options['cache']['dir'].$url,"r");
			fscanf($file,$options['cache']['prologue'],$cacheBegin,$cacheEnd);
			if ($cacheEnd > time()){
				if (isset($options['return_url']) && $options['return_url']){
					$result = $url;
				}else{
					$result = fread ($file, filesize($options['file']['root'].$options['cache']['dir'].$url));
				}
				@fclose($file);
				Log::put(Log::NOTICE,'Read from cache '.$url);
			}else{
				@fclose($file);
				@unlink($options['file']['root'].$options['cache']['dir'].$url);
				Log::put(Log::NOTICE,'Removed from cache '.$url);
			}
		}
		return $result;
	}
}
