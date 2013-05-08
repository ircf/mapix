<?php
/**
 * File system utilities : Manipulate files and folders (CRUD, upload, backup, restore, extract, find...)
 * @author IRCF
 */

require_once('../core/config.php');

class File{
	
	/** File types */
	const ARCHIVE	= 'archive';
	const FOLDER 	= 'folder';
	const BINARY 	= 'binary';
	const IMAGE	= 'image';
	const TEXT	= 'text';
	const XML	= 'xml';
	const NOT_FOUND = 'not found';

	/**
	 * Get content of a file
	 * @param $uri	a file to get content from
	 * @return file content or an array containing folder meta data
	 * @see self::meta($uri,$options)
	 */
	static function get($uri,$options = array()){
		$options = Config::get($options);
		if (file_exists($options['file']['root'].$uri)){
			if (is_dir($options['file']['root'].$uri)){
				$result = array();
				foreach (scandir($options['file']['root'].$uri) as $file){
					//if ($file=='.' or $file=='..') continue;
					array_push($result,self::meta($uri.'/'.$file,$options));
				}
			}else{
				$result = file_get_contents($options['file']['root'].$uri);
			}
		}else{
			$result = $options['http']['404_header'];
		}
		return $result;	
	}

	/**
	 * Update content of a file
	 * @param $uri	URI of file to update
	 * @option $content	the new content
	 * @return TRUE if file is updated, FALSE otherwise
	 */
	static function post($uri,$options = array()){
		$options = Config::get($options);
		$options['content'] = stripslashes($options['content']);
		if (isset($options['backup'])) self::backup($uri,$options);
		$f = @fopen($options['file']['root'].$uri, 'w');
		$result = @fwrite($f,$options['content'])?1:0;
		@fclose($f);
		return $result;
	}

	/**
	 * Create a new file
	 * @param $uri	URI of file to create
	 * @option $type	A file type constant (self::FOLDER, self::ARCHIVE, ...)
	 * @option $content	The new content
	 * @return TRUE if file is created, FALSE otherwise
	 * TODO Implement file upload
	 */
	/*
	case "upload"	: // upload = (file), data = (extract archive,delete archive)
		$success = 0;
		$filePath = $GLOBALS["_MAPIX"]["root"]."/".$file."/".basename($upload["name"]);
		if($upload["error"] == 0) $success = @rename($upload["tmp_name"],$filePath);
		$message = "uploaded";
		// If upload failed or autoextract not checked then stop here
		if (!$success || empty($data[0])) break;
	*/
	static function put($uri,$options = array()){
		$options = Config::get($options);
		switch($options['type']){
			case self::FOLDER :
				$result = @mkdir($options['file']['root'].$uri);
				break;
			case self::ARCHIVE :
				// TODO Implement archive creation
				break;
			default :
				$result = @touch($options['file']['root'].$uri);
				$f = @fopen($options['file']['root'].$uri,'w+');
				if ($f != null){
					if ($options['type'] == self::XML){					
						// TODO Get the document root name instead of assuming it's the name of the xsd file
						// TODO Generate a complete instance of the xml schema (implement XmlSchema::generateInstance())
						$documentRoot = str_replace('.xsd','',basename($options['schema']));
						fprintf($f,$options['file']['xml']['prologue']);
						fprintf($f,$options['file']['xml']['document_root'],$documentRoot,$options['http']['root'].$options['schema'],$documentRoot);
					}
					fprintf($f,$options['content']);
					@fclose($f);
				}
				break;
		}
		return $result;
	}

	/**
	 * Backup a file with rotation
	 * @param $uri	URI of file to backup
	 * @option $backup_rotation	How many versions should be kept (default is 5)
	 * @return TRUE if file is backed up, FALSE otherwise
	 */
	static function backup($uri,$options = array()){
		$options = Config::get($options);
		$version = 0;	
		$lastBackupTime = 0;
		while($version<$options['file']['backup_rotation'] && file_exists($options['file']['root'].$uri."~".$version)){
			$backupTime = filemtime($options['file']['root'].$uri."~".$version);
			if ($backupTime <= $lastBackupTime) break;
			$lastBackupTime = $backupTime;					
			$version++;	
		}
		return @copy($options['file']['root'].$uri,$options['file']['root'].$uri."~".$version);
	}

	/**
	 * Delete a file or a folder recursively
	 * @param $uri	URI of file to delete
	 * @option $backup	Should we backup file before deleting ? (default is false)
	 * @return TRUE is file is deleted, FALSE otherwise
	 */
	static function delete($uri,$options = array()){
		$options = Config::get($options);
		if (isset($options['backup'])) self::backup($uri,$options);
		if (is_dir($options['file']['root'].$uri)){
			foreach (scandir($options['file']['root'].$uri) as $file){
				if ($file=='.' or $file=='..') continue;
				self::delete($options['file']['root'].$uri.'/'.$file,$options);
			}
			$result = @rmdir($options['file']['root'].$uri);		
		}else{
			$result = @unlink($options['file']['root'].$uri);
		}
		return $result;
	}

	/**
	 * Lock file
	 * @param $uri	URI of file to lock
	 * @return TRUE if file could be locked, FALSE otherwise
	 */
	static function lock($uri,$options = array()){
		$options = Config::get($options);
		return @touch(dirname($options['file']['root'].$uri)."/.lock.".basename($options['file']['root'].$uri));
	}

	/**
	 * Unlock file
	 * @param $uri	URI of file to unlock
	 * @return TRUE if file could be unlocked, FALSE otherwise
	 */
	static function unlock($uri,$options = array()){
		$options = Config::get($options);
		return @unlink(dirname($options['file']['root'].$uri)."/.lock.".basename($options['file']['root'].$uri));
	}

	/**
	 * Is file locked ?
	 * @param $uri	URI of file to test for
	 * @return TRUE if file is locked, FALSE otherwise
	 */
	static function isLocked($uri,$options = array()){
		$options = Config::get($options);
		return file_exists(dirname($options['file']['root'].$uri)."/.lock.".basename($options['file']['root'].$uri));
	}

	/**
	 * Extract a file archive
	 * @param $uri	a file archive to be extracted
	 * @option $destination	path to extract the file to
	 * @option $delete	should the file archive be deleted after extraction ?
	 * @return TRUE if file could be extracted, FALSE otherwise
	 */
	static function extract($uri,$options = array()){
		$options = Config::get($options);
		$zip = new ZipArchive();
		$result = $zip->open($options['file']['root'].$uri);
		if ($result) {
			$result = $zip->extractTo(isset($options['destination'])?$options['destination']:dirname($options['file']['root'].$uri));
			$zip->close();
			if ($options['delete']) self::delete($uri,$options);
		}
		return $result;
	}

	/**
	 * Get meta data from a file
	 * @param $uri	a file to get metadata from
	 * @option $date_format	a string containing the format to return created/modified date
	 * @option $dir_size should we compute dir sizes or not ? (default is FALSE because it is very slow)  
	 * @return	an associative array containing file metadata
	 */
	static function meta($uri,$options=array()){
		$options = Config::get($options);
		return array('file' => array('@' => array(
			'name' => basename($uri),
			'type' => self::type($uri,$options),
			'size' => $options['file']['dir_size']?self::size($uri,$options):filesize($options['file']['root'].$uri),
			'created' => date($options['file']['date_format'], filectime($options['file']['root'].$uri)),
			'modified' => date($options['file']['date_format'], filemtime($options['file']['root'].$uri)),
			'hidden' => strpos(basename($uri),'.') === 0 || strpos(basename($uri),'~')!==false,
			'locked' => self::isLocked($uri,$options),
			'uri' => $uri
		)));
	}

	/**
	 * Get a file type(s) : self::FOLDER, self::BINARY, self::IMAGE, self::TEXT, self::XML...
	 * @param $uri	a file to get type(s) from
	 * @return a string containing the file type(s) or self::NOT_FOUND if file is not found
	 * TODO Implement self::ARCHIVE type detection
	 */
	static function type($uri,$options = array()){
		$options = Config::get($options);
		if (is_dir($options['file']['root'].$uri)){
			$type = self::FOLDER;
		}elseif(file_exists($options['file']['root'].$uri)){
			/*$type = self::BINARY;
			if (@getImageSize($options['file']['root'].$uri)){
				$type.= ' '.self::IMAGE;
			}else{
				$type.= ' '.self::TEXT;
				$dom = new DomDocument();
				if (@$dom->load($options['file']['root'].$uri)){
					$type.= ' '.self::XML.' '.str_replace(':',' ',$dom->documentElement->nodeName);
				}
			}*/
			$type = str_replace('/',' ',mime_content_type($options['file']['root'].$uri));
			$dom = new DomDocument();
			if (@$dom->load($options['file']['root'].$uri)){ // TODO Find a way to avoid warnings (@ is not sufficient)
				$type.= ' '.str_replace(':',' ',$dom->documentElement->nodeName);
			}
		}else{
			$type = self::NOT_FOUND;
		}
		return $type;
	}

	/**
	 * Find files matching a regexp pattern
	 * @param $uri	a folder to start searching from
	 * @option $pattern	a regexp pattern to match against files
	 * @return	an array containing found files meta data or an empty array if there is no match
	 * @see self::meta($uri,$options)
	 */
	static function find($uri,$options = array()) {
		$options = Config::get($options);
		$result = array();
		if (is_dir($options['file']['root'].$uri)){
			foreach (scandir($options['file']['root'].$uri) as $file){
				if ($file=='.' or $file=='..') continue;
				//Log::put("file : $file");
				array_splice($result, count($result), 0, self::find($uri.'/'.$file,$options));
			}
		}
		if (preg_match($options['pattern'], $uri)) {
			array_push($result,self::meta($uri,$options));
		}
		return $result;
	}

	/**
	 * Compute the total size of a file or a folder
	 * @param $uri	a file or dir to compute size for
	 * @return the number of bytes in file or folder
	 */
	static function size($uri, $options = array()){
		$options = Config::get($options);
		if (!is_dir($options['file']['root'].$uri))
			return filesize($options['file']['root'].$uri);
		$size = 0;
		foreach (scandir($options['file']['root'].$uri) as $file){
			if ($file=='.' or $file=='..') continue;
			$size+= self::size($options['file']['root'].$uri.'/'.$file,$options);
		}
		return $size;
	}

	/**
	 * Tests whether a file exists
	 * @param $uri URI of the file to test existence for
	 * @return TRUE if file exists, FALSE otherwise
	 */
	static function exists($uri,$options = array()){
		$options = Config::get($options);
		//Log::put('file_exists('.$options['file']['root'].$uri.') = '.(file_exists($options['file']['root'].$uri)?'true':'false'));
		return file_exists($options['file']['root'].$uri);
	}
	
	/**
	 * Move a file
	 * @option $target	Target file path (from file root)
	 * @return TRUE if file is moved, FALSE otherwise
	 */
	static function move($uri,$options = array()){
		$options = Config::get($options);
		return @rename($uri,$options['file']['root'].$options['target']);
	}

	/**
	 * Copy a file
	 * @option $target	Target file path (from file root)
	 * @return TRUE if file is copied, FALSE otherwise
	 */
	static function copy($uri,$options = array()){
		$options = Config::get($options);
		return @copy($uri,$options['file']['root'].$options['target']);
	}

	/**
	 * Restore a file
	 * @option $version to restore (from 0 to backup_rotation)
	 * @return TRUE if file is restored, FALSE otherwise
	 */
	static function restore($uri,$options = array()){
		$options = Config::get($options);
		return File::backup($uri,$options) && @copy($options['file']['root'].$uri."~".$options['version'],$uri);
	}
}
