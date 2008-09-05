<?php
require_once("dbconnect.php");

include("dbscheme.php");

//

$ip = getenv('REMOTE_ADDR');
$msg = print_r($_REQUEST, true);
$query = "INSERT INTO requestLog (source, request) VALUES ('$ip', '$msg')";
$DB->Execute($query);

// perform login check

switch (@$_REQUEST["method"]) {
    case "ListPlaces":
        ListAllAddress();
        break;
    case "Person":
        GetPerson();
        break;
    case "SavePerson":
        CommitPerson();
        break;
//    case "InsertAddressee":
//        $ret = InsertAddress();
//        break;
    default:
        ListAllAddress();
        break;
}

die();

function GetSQLValueString($theValue, $theType, $theDefinedValue = "", $theNotDefinedValue = ""){
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

function GetValueString($key, $value, $results){
    if($value == null){
        return $value;
    }

    if ($key == 'birth' || $key == "last-update"){
        return $results->UserTimeStamp($value, "Y/m/d H:i:s");
    }
    else{
        return $value;
    }
}

function ListAllAddress() {
    global $DB;

    // validate the id is correct

    $query = "SELECT * FROM places";
    $results = $DB->Execute($query);

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');
    $xml->startElement('data');

    while ($AddressGroup = $results->FetchRow()) {
        $xml->startElement('Place');
        foreach ($AddressGroup as $key => $value){
            $xml->writeAttribute($key, GetValueString($key, $value, $results));
        }

        $pquery = "Select id, firstname, lastname, title ".
                  "FROM people LEFT JOIN links ON people.id=links.people ".
                  "WHERE links.places=" . $AddressGroup['id'];
        $people = $DB->Execute($pquery);

        $xml->startElement('People');
        while ($person = $people->FetchRow()) {
            $xml->startElement('Person');
            foreach ($person as $key => $value){
                $xml->writeAttribute($key, GetValueString($key, $value, $results));
            }
            $xml->endElement(); // end person
        }
        $xml->endElement();
        $xml->endElement();
    }

    $xml->endElement(); // end data
    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}

function GetPerson() {
    global $DB;

    $query = "SELECT * FROM ".Person::TABLE_NAME.
             " WHERE id=".$_REQUEST[Person::ID];
    $results = $DB->Execute($query);

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');
    $xml->startElement('data');

    while ($person = $results->FetchRow()) {
        $xml->startElement('Person');
        foreach ($person as $key => $value){
            $xml->writeAttribute($key, GetValueString($key, $value, $results));
        }

        $pquery = "Select * ".
                  "FROM ".Place::TABLE_NAME.
                  " LEFT JOIN links ON ".Place::TABLE_NAME.'.'.Place::ID."=links.places ".
                  "WHERE links.people=" . $person['id'];
        $places = $DB->Execute($pquery);

        $xml->startElement('Places');
        while ($place = $places->FetchRow()) {
            $xml->startElement('Place');
            foreach ($place as $key => $value){
                $xml->writeAttribute($key, GetValueString($key, $value, $results));
            }
            $xml->endElement(); // end person
        }
        $xml->endElement();
        $xml->endElement();
    }

    $xml->endElement(); // end data
    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}

function CommitPerson(){
    global $DB;

    $record[Person::ID] = $_REQUEST[Person::ID];
    $record[Person::TITLE] = $_REQUEST[Person::TITLE];
    $record[Person::FIRSTNAME] = $_REQUEST[Person::FIRSTNAME];
    $record[Person::LASTNAME] = $_REQUEST[Person::LASTNAME];
    $record[Person::BIRTHDATE] = $_REQUEST[Person::BIRTHDATE];
    $record[Person::EMAIL] = $_REQUEST[Person::EMAIL];
    $record[Person::CELLPHONE] = $_REQUEST[Person::CELLPHONE];
    $record[Person::DETAILS] = $_REQUEST[Person::DETAILS];

    if($_REQUEST[Person::ID] < 1){
        $DB->AutoExecute(Person::TABLE_NAME,$record, 'INSERT');
    }
    else{
        $DB->AutoExecute(Person::TABLE_NAME,$record, 'UPDATE', Person::ID."=".$_REQUEST[Person::ID], false);
    }

    // return the updated person
    GetPerson();
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