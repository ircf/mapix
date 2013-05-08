<?php
/**
 * Text utilities for use in XSL templates (via EXSLT)
 */
class Text{

	/**
	 * Matches a string against a regexp pattern
	 * @param $string a string to look into
	 * @param $pattern a regexp pattern to look for
	 * @return TRUE if $pattern is found, FALSE otherwise
	 */
	static function match($string,$pattern){
		return preg_match($pattern,$string);
	}
}

