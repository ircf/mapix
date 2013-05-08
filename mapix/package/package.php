<?php
/**
 * Package manager service for Mapix CMS
 * TODO Execute triggers at install/uninstall
 * @author IRCF
 */

require_once('../core/config.php');
require_once("../core/log.php");
require_once('../core/http.php');
require_once('../core/serialize.php');
require_once("../file/file.php");

class Package{

	/**
	 * Get one or many package descriptors
	 * @param $uri	Package to get descriptor for (optional)
	 * TODO Use cache
	 */
	static function meta($uri = '', $options = array()){
		$options = Config::get($options);
		if (empty($uri)){
			$result = '';
			$packages = File::find('',array('pattern'=>'/.*\\'.$options['package']['descriptor'].'$/'));
			foreach ($packages as $package){
				$result.= File::get($package['file']['@']['uri']);
			}
		}else{
			$result = File::get($uri.'/'.$options['package']['descriptor']);
		}
		return Serialize::xml2array($result);
	}

	/**
	 * Uninstall one or many packages (remove package dir)
	 * @param $uri	Package to uninstall, use packages option if empty 
	 * @option $packages	Array of packages to uninstall, none if not set
	 */
	static function delete($uri = '', $options = array()){
		$result = false;
		$options = Config::get($options);
		if (!empty($url)) $options['packages'] = array("uri"=>$uri);
		try{
			foreach ($options['packages'] as $package){
				if (!File::delete($options['file']['root'].$package['uri'])){
					throw new Exception('Could not delete package '.$package['uri']);
				}
			}
			$result = true;
		}catch(Exception $e){
			Log::put(Log::ERROR,$e->getMessage());
		}
		return $result;
	}
	
	/**
	 * Install one or many packages
	 * download package archive and extract to install dir
	 * @param $uri	Package to install, use packages option if empty 
	 * @option $packages	Array of packages to install, none if not set
	 */
	static function put($uri = '', $options = array()){
		$result = false;
		$options = Config::get($options);
		try{
			foreach($options['packages'] as $package){
				$url = $options['package']['repository'].$package['uri'];
				HTTP::get($url,array('cache'=>array('ttl'=>60)));
				$archive = Cache::get($url,array('return_url'=>true));
				if (!$archive){
					throw new Exception('Could not download package '.$url);
				}
				if (!File::extract($archive,array('delete'=>true,'destination'=>$package['destination']))){
					throw new Exception('Could not extract package '.$package['uri'].' into '.$package['destination']);
				}
			}
			$result = true;
		}catch(Exception $e){
			Log::put(Log::ERROR,$e->getMessage());
		}
		return $result;
	}

	/**
	 * Upgrade one or many packages (same as installing new packages, files are overwritten)
	 * @param $uri	Package to upgrade, use packages option if empty 
	 * @option $packages	Array of packages to upgrade, none if not set
	 */
	static function post($uri = '', $options = array()){
		return self::put($uri,$options);
	}

	/**
	 * Get (download) one package
	 * Look for package archive in cache, if not found, then create archive and return archive content
	 */
	static function get($uri,$options=array()){
		$options = Config::get($options);
		$archive = Cache::get($options['http']['root'].$uri);
		if (!$archive){
			$archive = File::put($options['file']['root'].$options['cache']['dir'].$uri,array('type'=>File::ARCHIVE,'content'=>$options['file']['root'].$uri));
		}
		return $archive;
	}
}

