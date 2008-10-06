<?php
require_once("dbconnect.php");
include("dbscheme.php");


if (!$_GET['user'] || !$_GET['password'])
{
	throw new Exception('Malformed login request.');
}

$xml = new XMLWriter();
$xml->openMemory();
$xml->setIndent(true);
$xml->startDocument('1.0','UTF-8');
$xml->startElement('response');
$xml->startElement('data');

$query = "SELECT uid FROM users WHERE username='". $_GET['user']. "' AND password='".$_GET['password']."'";
$uid = $DB->GetOne($query);

if ($uid == null){
    $xml->text("Authentication Failed");
}
else {
    $xml->text('true');
    $ip = getenv('REMOTE_ADDR');
    $query = "UPDATE users SET last_ip='$ip' WHERE uid='$uid'";
    $results = $DB->Execute($query);
}

$xml->endElement(); // end data
$xml->endElement(); // end response
$xml->endDocument();
header("Content-type: text/xml");
print $xml->outputMemory(true);


?>