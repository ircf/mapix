<?php
/**
 * Session handler service
 * @author IRCF
 */

// Load Mapix core API
require_once("../core/rest.php");

// Define Session class
class Session extends REST{

	/**
	 * Start session
	 * @option id	Session id
	 */
	function __construct($options=array()){
		if (isset($options['id'])) session_id($options['id']);
		session_start();
	}

	/**
	 * Set a session variable
	 * @option variable	Variable name
	 * @option value	Value
	 * @option default	Default value (if value option not set or empty)
	 */
	function set($options=array()){
		if (!isset($options['default'])) $options['default'] = null;
		if (!isset($options['value']) || empty($options['value'])) $options['value'] = $options['default'];
		if (!isset($options['variable'])){
			$_SESSION[$options['variable']] = $options['value'];
			return true;
		}
		return false;
	}

	/**
	 * Unset and destroy a session variable
	 * @option variable	Variable name
	 */
	function unset($options=array()){
		if (isset($options['variable']) && isset($_SESSION[$options['variable']])){
			unset($_SESSION[$options['variable']]);
			return true;
		}
	}
}

// Enable REST execution for this class
Session::register();
