<?php
require_once(dirname(__FILE__) . "/XmlSerializer.class.php");

$ret ='false';
if ($_GET['user'] == "rcamara")
{
	$ret = 'true';
}

// the XmlSerializer uses a PEAR xml parser to generate an xml response.
$serializer = new XmlSerializer();
echo $serializer->serialize($ret);
die();
	
?>