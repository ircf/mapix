<?php
/**
 * Tests class for Mapix
 * REST Example : HELLOWORLD /mapix/test/test.php
 * @author IRCF
 */

class Tests{

	function __construct(){
		$this->name = '';
	}

	function setName($name){
		$this->name = $name;
	}

	function hello(){
		return 'hello '.$this->name;
	}

	function helloWorld(){
		$this->setName('world');
		return $this->hello();
	}

	function get(){
		return 'You GOT a test !';
	}

	function post(){
		return 'You POSTED a test !';
	}
}

/** Enable REST interface */
require_once('rest.php');
REST::register('Tests');
