<?php
/**
 * This service is used to handle openid authentification
 * using Simple OpenID PHP class (see .core/openid.php)
 * TODO Implement services as class instead of programs (inherit service core class)
 */

// Get the input parameters
$openid_url = $_REQUEST["openid_url"];
$openid_mode = $_REQUEST["openid_mode"];
$openid_identity = $_REQUEST["openid_identity"];
$openid_approved_url = $_REQUEST["openid_approved_url"];

// Initialize response parameters
$success = 0;
$message = "";

// Include Simple OpenID PHP class
include("../../.core/openid.php");
// Get identity from user and redirect browser to OpenID Server
if ($openid_mode == "login"){
	if (!isset($openid_url)){
		$message = "Sorry, no user is related to this OpenId account";
	}else{
		$openid = new SimpleOpenID;
		$openid->SetIdentity($openid_url);
		$openid->SetTrustRoot('http://' . $_SERVER["HTTP_HOST"]);
		$openid->SetRequiredFields(array('email','fullname'));
		$openid->SetOptionalFields(array('dob','gender','postcode','country','language','timezone'));
		if ($openid->GetOpenIDServer()){
			$success = 1;			
			// Send Response from OpenID server to this script
			$openid->SetApprovedURL("http://" . $_SERVER["HTTP_HOST"] . $openid_approved_url );
			// This will redirect user to OpenID Server
			$openid->Redirect();
		}else{
			$error = $openid->GetError();
			$message = $error["description"]." (".$error["error"].") ";
		}
	}
}
// Perform HTTP Request to OpenID server to validate key
else if($openid_mode == 'id_res'){
	$openid = new SimpleOpenID;
	$openid->SetIdentity($openid_identity);
	if ($openid->ValidateWithServer()){
		$success = 1;
	}else if($openid->IsError()){
		$error = $openid->GetError();
		$message = $error["description"]." (".$error["error"].") ";
	}else{
		$message = "Authorization failed";
	}
// User Canceled your Request
}else if ($openid_mode == 'cancel'){
	$message = "User canceled request";
}
// Memorize the result of the authentification for further pages
$_SESSION["openid_state"] = ($success==1);
// Print the XML output
echo "<?xml version=\"1.0\"?".">";
echo "<openid>";
echo "<success>".$success."</success>";
echo "<message>".$message."</message>";
echo "</openid>";
?>
