<?php
/**
 * Handles errors, warnings and debug messages
 * @author IRCF
 * TODO Implement file and mail logging
 */

require_once('config.php');

class Log{

	/** Log levels */
	const ERROR = E_USER_ERROR;
	const WARNING = E_USER_WARNING;
	const NOTICE = E_USER_NOTICE;
	const ALL = -1;
	const NONE = 0;

	/** Log types */
	const STDOUT = 0;
	const FILE = 1;

	/**
	 * Log handler
	 * @param $errno	log level
	 * @param $errstr	message to log
	 * @param $errfile	file where error was triggered
	 * @param $errline	line from file where error was triggered
	 * @return true if no error else exit
	 * TODO Use error_log() to log errors if option is enabled
	 */
	static function handler($errno, $errstr, $errfile, $errline){
		$options = Config::get();
		if ($options['log']['level']==self::ALL || $errno<=$options['log']['level']){
			echo sprintf($options['log']['template'],$errfile,$errline,$options['log']['labels'][$errno],htmlentities($errstr));
		}
		if ($errno==self::ERROR) exit(1);
		return true;
	}

	/**
	 * Add a message to log
	 * @param $message	String message to log
	 * @param $level	Log level (see constants ERROR, WARNING, NOTICE, ALL, NONE)
	 */
	static function put($message,$level = self::NOTICE,$options = array()){
		//echo ('message = '.$message.' level = '.$level.'<br/>');
		$options = Config::get($options);
		trigger_error($message,$level);
	}
}

/** Enables log handler */
set_error_handler('Log::handler');
