<?php
/**
 * This is a basic PHP send form service
 */

// Get the input parameters
$from = @$_REQUEST["from"];
$to = @$_REQUEST["to"];
$subject = @$_REQUEST["subject"];
$success = 0;

//If all these parameters are defined, then send the form
if (!empty($from) && !empty($to) && !empty($subject)){
	//Put all the request values into the body variable
	$body = "";
	foreach ($_REQUEST as $name=>$value){
		$body.= $name." = ".$value."\n";
	}
	// Create the header and send the mail
	$header = "From: ".$from."\n";
	$header.= "Content-Type: text/plain; charset=iso-8859-1";
	$success = @mail($to,$subject,$body,$header)?1:0;
}

// Print the XML output
echo "<?xml version=\"1.0\"?>";
echo "<sendForm>";
echo "<success>".$success."</success>";
echo "</sendForm>";
?>