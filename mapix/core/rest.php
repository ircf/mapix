<?php
/**
 * Mapix REST API
 * Enables execution of class methods using the singleton pattern
 * @author IRCF
 */

require_once('log.php');
require_once('serialize.php');

class REST{

	/**
	 * Register class for remote execution :
	 * if class path matches request URL then execute requested method and echo result, else do nothing
	 * @param $className	a string representing the class name
	 * @option $format	a constant representing the output format
	 * @see Serialize format constants
	 */
	static function register($className,$options=array()){
		$className = strtolower($className);
		$scriptName = strtolower(basename(str_replace('.php', '', $_SERVER['SCRIPT_NAME'])));
		if ($scriptName == $className){
			echo self::execute($className, strtolower($_SERVER['REQUEST_METHOD']), $_REQUEST, isset($options['format'])?$options['format']:null);
		}	
	}

	/**
	 * Execute a dynamic or static method :
	 * - Dynamic methods : First create or get a singleton instance, then execute method
	 * - Static method : Execute method
	 * @param $className	a string representing the class name
	 * @param $methodName	a string representing the method name
	 * @param $arguments	an array representing arguments
	 * @return the result of method execution
	 */
	static function execute($className, $methodName, $arguments = array() , $format = Serialize::NONE ){
		//Log::put("REST::execute($className, $methodName, $arguments, $format)");
		$class = new ReflectionClass($className);
		if ($class->hasMethod($methodName)){
			$method = $class->getMethod($methodName);
			$object = $method->isStatic() ? $className : self::instance($className);
		}else{
			$object = $class->hasMethod('__callStatic') ? $className : self::instance($className);
		}
		$result = call_user_func_array(array($object, $methodName), $arguments);
		//print_r($result);
		$result = Serialize::array2format($result,$format);
		//print_r($result);
		return $result;
	}

	/**
	 * Create or get a singleton instance
	 * @param $class	a string representing class name
	 * @return the $class singleton instance
	 */
	static function instance($class){
		static $instances = array();
		if (!isset($instances[$class])){
			$instances[$class] = new $class;
		}
		return $instances[$class];
	}
}
