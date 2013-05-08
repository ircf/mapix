<?php
/**
 * Mapix Session API
 * @author IRCF
 */

class Session{

	/**
	 * Start session
	 * @option id	Session id
	 */
	function __construct($options=array()){
		if (isset($options['id'])) session_id($options['id']);
		session_start();
	}

	/**
	 * Add a session variable
	 * @option name		Variable name
	 * @option value	Value
	 * @option default	Default value (if value option not set or empty)
	 */
	function put($options=array()){
		if (!isset($options['default'])) $options['default'] = null;
		if (!isset($options['value']) || empty($options['value'])) $options['value'] = $options['default'];
		if (isset($options['name'])){
			$_SESSION[$options['name']] = $options['value'];
			return true;
		}
		return false;
	}

	/**
	 * Modify a session variable
	 * @see	User::put()
	 */
	function post($options=array()){
		return $this->put($options);
	}

	/**
	 * Delete a session variable
	 * @param $url	variable name
	 */
	function delete($options=array()){
		if (isset($options['name']) && isset($_SESSION[$options['name']])){
			unset($_SESSION[$options['name']]);
			return true;
		}
		return false;
	}
}
