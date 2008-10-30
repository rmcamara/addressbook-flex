<?php
///////////////////////////////////////////////////////////////////////////////
//    
//    Copyright 2008 Ross Camara
//
//    This file is part of Addressbook.
//
//    Foobar is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    AddressBook is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////////////

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