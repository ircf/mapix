<?php
/**
 * Image handler service
 * Read informations and modify images (crop, resize, rotate...)
 * @author IRCF
 */

require_once("../file/file.php");

class Image extends File{

	/**
	 * Transform image using the convert program
	 * @param $uri		Image URI
	 * @option backup	make a backup before modifying
	 * @option resizeWidth	width to resize image
	 * @option cropWidth	width to crop image
	 * @option cropHeight	height to crop image
	 * @option cropX	X offset to crop image
	 * @option cropY	Y offset to crop image
	 * @option rotation	angle in degrees to rotate image
	 * @return TRUE if image is transformed, an error message otherwise
	 */
	static function transform($uri,$options=array()){
		$options = Config::get($options);
		if (isset($options['backup'])) File::backup($uri);
		$cmd = 'convert "'.$options['file_root'].$uri.'" ';
		$cmd.= '-resize '.$options['resize_width'].' ';
		$cmd.= '-crop '.$options['crop_width'].'x'.$options['crop_height'].'+'.$options['crop_x'].'+'.$options['crop_y'].' ';
		$cmd.= '-rotate '.$options['rotation'].' ';
		$cmd.= '"'.$options['file']['root'].$uri.'"';
		$error = exec($cmd);
		return empty($error)?true:$error;
	}

	/**
	 * Get image meta information
	 * @param $uri		Image URI
	 * @return an associative array containing file and image meta data
	 * @see parent::meta($uri,$options)
	 */
	static function meta($uri,$options=array()){
		$options = Config::get($options);
		$meta = parent::meta($uri,$options);
		$size = @getImageSize($options['file']['root'].$uri);		
		if ($size){
			$meta['file']['@']['width'] = $size[0];
			$meta['file']['@']['height'] = $size[1];
		}
		return $meta;
	}
}

