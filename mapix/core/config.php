<?php
/**
 * Mapix core configuration class
 * @author IRCF
 */

class Config{

	/**
	 * Default static configuration
	 */
	static protected $default;

	/**
	 * Get/set Mapix core configuration options
	 * @param $options An array or querystring to add or override options
	 */
	static function get($options = array(),$uri = null){// TODO Switch params
		if (!isset(self::$default)){
			self::$default = array(
				'xrt' => array(
					'index' => 'controller.xsl',
				),
				'log' => array(
					'type' => Log::STDOUT,
					'level' => isset($_REQUEST['debug'])?Log::ALL:Log::NONE,
					'template' => '<p style="border:1px solid #ccc;background-color:#eee;padding:5px;font:12px sans-serif;text-align:left;"><span style="float:right;font:10px sans-serif;">%s (%s)</span><strong>%s</strong> : %s</p>',
					'labels' => array (
						E_ERROR              => 'Error',
						E_WARNING            => 'Warning',
						E_PARSE              => 'Parse Error',
						E_NOTICE             => 'Notice',
						E_CORE_ERROR         => 'Core Error',
						E_CORE_WARNING       => 'Core Warning',
						E_COMPILE_ERROR      => 'Compile Error',
						E_COMPILE_WARNING    => 'Compile Warning',
						E_USER_ERROR         => 'Mapix Error',
						E_USER_WARNING       => 'Mapix Warning',
						E_USER_NOTICE        => 'Mapix Notice',
						E_STRICT             => 'Runtime Notice',
						E_RECOVERABLE_ERROR => 'Catchable Fatal Error'
					)
				),
				'http' => array(
					'root' => 'http'.(isset($_SERVER['HTTPS']) && $_SERVER['HTTPS']=='on'?'s':'').'://'.$_SERVER['SERVER_NAME'],
					'404_header' => '<http:header>HTTP/1.0 404 Not Found</http:header>',
				),
				'file' => array(
					'root' => dirname(dirname(dirname(__FILE__))).'/',
					'xml' => array(
						'prologue' => '<?xml version="1" charset="utf-8"?>',
						'document_root' => '<%s xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="%s">'
					),
					'backup_rotation' => 5,
					'date_format' => 'Y-m-d H:i:s',
					'dir_size' => false
				),
				'exslt' => array(
					'stylesheet' => '<?xml version="1.0"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:func="http://exslt.org/functions" xmlns:php="http://php.net/xsl" xmlns:%s="%s" extension-element-prefixes="func">%s</xsl:stylesheet>',
					'function' => '<func:function name="%s:%s">%s<func:result select="php:function(\'EXSLT::execute\',\'%s\',\'%s\'%s)"/></func:function>',
					'param' => '<xsl:param name="%s"/>',
					'param_optional' => '<xsl:param name="%s" select="null"/>'
				),
				'cache' => array(
					'dir' => '/mapix/cache/',
					'prologue' => '<!-- Page cached from %d until %d -->\n',
					'replace' => '_',
				),
				'package' => array(
					'descriptor' => '.package',
				)
			);
		}
		if (is_string($options)) parse_str($options,$options);
		if (is_null($uri)){
			$config = self::$default;
		}else{
			$config = Serialize::xml2array(HTTP::get($uri));
		}
		return $config + $options;
	}
}
