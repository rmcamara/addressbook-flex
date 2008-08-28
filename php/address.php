<?php
require_once("dbconnect.php");
switch (@$_REQUEST["method"]) {
    case "ListAll":
        ListAllAddress();
        break;
//    case "InsertAddressee":
//        $ret = InsertAddress();
//        break;
    default:
        ListAllAddress();
        break;
}

die();

function GetSQLValueString($theValue, $theType, $theDefinedValue = "", $theNotDefinedValue = "")
{
    $theValue = get_magic_quotes_gpc() ? stripslashes($theValue) : $theValue;

    $theValue = function_exists("mysql_real_escape_string") ? mysql_real_escape_string($theValue) : mysql_escape_string($theValue);

    switch ($theType) {
        case "text":
            $theValue = ($theValue != "") ? '"' . $theValue . '"' : "NULL";
            break;
        case "long":
        case "int":
            $theValue = ($theValue != "") ? intval($theValue) : "NULL";
            break;
        case "double":
            $theValue = ($theValue != "") ? '"' . doubleval($theValue) . '"' : "NULL";
            break;
        case "date":
            $theValue = ($theValue != "") ? '"' . $theValue . '"' : "NULL";
            break;
        case "defined":
            $theValue = ($theValue != "") ? $theDefinedValue : $theNotDefinedValue;
            break;
    }
    return $theValue;
}

function ListAllAddress() {
    global $DB;

    $query = "SELECT * FROM addressgroup";
    $results = $DB->Execute($query);

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');
    $xml->startElement('data');

    while ($AddressGroup = $results->FetchRow()) {
        $xml->startElement('AddressGroup');
        foreach ($AddressGroup as $key => $value){
            $xml->writeAttribute  ($key, $value);
        }

        $pquery = "Select * FROM people where gid=" . $AddressGroup['id'];
        $people = $DB->Execute($pquery);

        while ($person = $people->FetchRow()) {
            $xml->startElement('Person');
            foreach ($person as $key => $value){
                $xml->writeAttribute  ($key, $value);
            }
            $xml->endElement(); // end person
        }
        $xml->endElement();
    }

    $xml->endElement(); // end data
    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}
/*
function InsertEmployee() {
global $conn;

$query_insert = sprintf("INSERT INTO employees (firstName, lastName, officePhone) VALUES (%s, %s, %s)",
GetSQLValueString($_REQUEST["firstName"], "text"),
GetSQLValueString($_REQUEST["lastName"], "text"),
GetSQLValueString($_REQUEST["officePhone"], "text")
);

$ok = mysql_query($query_insert);

if (!$ok) {
exit("Unable to insert to DB: " . mysql_error());
}

}
*/
?>