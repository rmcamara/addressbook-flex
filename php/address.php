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
    case "Place":
        GetLocation();
        break;
    case "SavePlace":
        CommitLocation();
        break;
    case "LinkLocation":
        LinkLocation();
        break;
    case "UpdatePeopleLink":
        UpdateLinks(false);
        break;
    case "DeletePerson":
        DeleteModel(false);
        break;
    case "ListPeople":
        ListPeople();
        break;
    case "Person":
        GetPerson();
        break;
    case "SavePerson":
        CommitPerson();
        break;
    case "LinkPeople":
        LinkPeople();
        break;
    case "UpdateLocationLink":
        UpdateLinks(true);
        break;
    case "DeleteLocation":
        DeleteModel(true);
        break;
    default:
        throw new Exception("Unrecognized Request:" . $_REQUEST["method"]);
        break;
}

die();

function GetValueString($key, $value, $results){
    if($value == null){
        return $value;
    }

    if ($key == 'birth' || $key == "last-update"){
        return $results->UserTimeStamp($value, "Y/m/d H:i:s");
    }
    else{
        return stripslashes($value);
    }
}

function ListAllAddress() {
    global $DB;

    // validate the id is correct

    $query = "SELECT * FROM places Order by " . Place::NAME;
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

function ListPeople() {
    global $DB;

    // validate the id is correct

    $query = "SELECT * FROM " . Person::TABLE_NAME . " Order By " . Person::LASTNAME.", ". Person::FIRSTNAME;
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

        $pquery = "Select ". Place::ID . ", " . Place::NAME .
                  " FROM ". Place::TABLE_NAME .
                  " LEFT JOIN links ON ".Place::TABLE_NAME.".".Place::ID."=links.places ".
                  "WHERE links.people=" . $person[Person::ID];
        $places = $DB->Execute($pquery);

        $xml->startElement('Places');
        while ($location = $places->FetchRow()) {
            $xml->startElement('Place');
            foreach ($location as $key => $value){
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

function LinkPeople() {
    global $DB;

    // validate the id is correct

    $query = "SELECT " .Person::ID.", ".Person::FIRSTNAME.", " .Person::LASTNAME.
             " FROM " . Person::TABLE_NAME;
    $results = $DB->Execute($query);

    $placeQuery = "SELECT * FROM links WHERE places=" . $_REQUEST[Person::ID];
    $places = $DB->Execute($placeQuery);

    $placeIds = Array();

    while ($place = $places->FetchRow()) {
        array_push($placeIds, $place['people']);
    }

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
        if (in_array($person[Place::ID], $placeIds)){
            $xml->writeAttribute('selected', 'true');
        }
        $xml->endElement();
    }

    $xml->endElement(); // end data
    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}

function LinkLocation() {
    global $DB;

    // validate the id is correct

    $query = "SELECT ".Place::ID.", ".Place::NAME.", " .Place::STATE.", " .Place::CITY.
             " FROM " . Place::TABLE_NAME;
    $results = $DB->Execute($query);

    $placeQuery = "SELECT * FROM links WHERE people=" . $_REQUEST[Person::ID];
    $people = $DB->Execute($placeQuery);

    $peopleIds = Array();

    while ($person = $people->FetchRow()) {
        array_push($peopleIds, $person['places']);
    }

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');
    $xml->startElement('data');

    while ($person = $results->FetchRow()) {
        $xml->startElement('Places');
        foreach ($person as $key => $value){
            $xml->writeAttribute($key, GetValueString($key, $value, $results));
        }
        if (in_array($person[Place::ID], $peopleIds)){
            $xml->writeAttribute('selected', 'true');
        }
        $xml->endElement();
    }

    $xml->endElement(); // end data
    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}

function UpdateLinks($mode) {
    global $DB;

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');

    // Remove links no longer used.
    $xml->startElement('delete');
    $query = "DELETE FROM links WHERE ";
    $query .= $mode ? "places=" : "people=";
    $query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
    $query .= " AND ";
    $query .= $mode ? "people" : "places";
    $query .= " NOT IN (";

    $linkCount = $_REQUEST['count'];
    for ($x = 0; $x < $linkCount; $x++){
        if ($x > 0){
            $query .= ", ";
        }
        $query .= $_REQUEST['lid'.$x];
    }
    $query .= ")";

    $DB->Execute($query);
    $xml->text($query);
    $xml->endElement();

    for ($x = 0; $x < $linkCount; $x++){
        $query = "Select * FROM links WHERE ";
        $query .= $mode ? "places=" : "people=";
        $query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
        $query .= " AND ";
        $query .= $mode ? "people=" : "places=";
        $query .= $_REQUEST['lid'.$x];
        $xml->startElement('select');
        $results = $DB->Execute($query);
        $xml->text($query);
        if ($results->FetchRow() == null){
            $query = "INSERT INTO links (";
            $query .= $mode ? "places" : "people";
            $query .= ", ";
            $query .= $mode ? "people" : "places";
            $query .= ") VALUES (";
            $query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
            $query .= ", ";
            $query .= $_REQUEST['lid'.$x];
            $query .= ")";

            $xml->startElement('insert');
            $xml->text($query);
            $xml->endElement();
            $DB->Execute($query);
        }
        $xml->endElement();
    }


    $xml->text("complete");
    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}

function GetPerson() {
    global $DB;

    $fields = array( Person::ID => $_REQUEST[Person::ID]);

    $query = "SELECT * FROM ".Person::TABLE_NAME.generateWhere($fields);
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

    if($_REQUEST[Person::ID] < 1){
        $record[Person::ID] = $_REQUEST[Person::ID];
    }
    $record[Person::TITLE] = $_REQUEST[Person::TITLE];
    $record[Person::FIRSTNAME] = $_REQUEST[Person::FIRSTNAME];
    $record[Person::LASTNAME] = $_REQUEST[Person::LASTNAME];
    $record[Person::BIRTHDATE] = $_REQUEST[Person::BIRTHDATE];
    $record[Person::EMAIL] = $_REQUEST[Person::EMAIL];
    $record[Person::CELLPHONE] = $_REQUEST[Person::CELLPHONE];
    $record[Person::DETAILS] = $_REQUEST[Person::DETAILS];

    if($_REQUEST[Person::ID] < 1){
        $DB->AutoExecute(Person::TABLE_NAME,$record, 'INSERT');

        // update the new id attribute
        $sql = "select " . Person::ID . " from " . Person::TABLE_NAME . generateWhere($record) .
               "Order by " . Person::LAST_UPDATE . " DESC";
        $_REQUEST[Place::ID] = $DB->GetOne($sql);
    }
    else{
        $DB->AutoExecute(Person::TABLE_NAME,$record, 'UPDATE', Person::ID."=".$_REQUEST[Person::ID], false);
    }

    // return the updated person
    GetPerson();
}

function GetLocation() {
    global $DB;

    $fields = array( Place::ID => $_REQUEST[Place::ID]);
    $query = "SELECT * FROM ".Place::TABLE_NAME. generateWhere($fields);
    $results = $DB->Execute($query);

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');
    $xml->startElement('data');

    while ($place = $results->FetchRow()) {
        $xml->startElement('Place');
        foreach ($place as $key => $value){
            $xml->writeAttribute($key, GetValueString($key, $value, $results));
        }

        $pquery = "Select * ".
                  "FROM ".Person::TABLE_NAME.
                  " LEFT JOIN links ON ".Person::TABLE_NAME.'.'.Person::ID."=links.people ".
                  "WHERE links.places=" . $place[Place::ID];
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

function CommitLocation(){
    global $DB;

    if($_REQUEST[Place::ID] > 0){
        $record[Place::ID] = $_REQUEST[Place::ID];
    }
    $record[Place::NAME] = $_REQUEST[Place::NAME];
    $record[Place::ADDRESS] = $_REQUEST[Place::ADDRESS];
    $record[Place::ADDRESS2] = $_REQUEST[Place::ADDRESS2];
    $record[Place::CITY] = $_REQUEST[Place::CITY];
    $record[Place::STATE] = $_REQUEST[Place::STATE];
    $record[Place::ZIPCODE] = $_REQUEST[Place::ZIPCODE];
    $record[Place::PHONE] = $_REQUEST[Place::PHONE];
    $record[Place::DETAILS] = $_REQUEST[Place::DETAILS];

    if($_REQUEST[Place::ID] < 1){
        $DB->AutoExecute(Place::TABLE_NAME,$record, 'INSERT');

        // update the id.
        $sql = "select " . Place::ID . " from " . Place::TABLE_NAME . generateWhere($record) .
               " Order by `" . Place::LAST_UPDATE . "` DESC";
        $_REQUEST[Place::ID] = $DB->GetOne($sql);
    }
    else{
        $DB->AutoExecute(Place::TABLE_NAME,$record, 'UPDATE', Place::ID."=".$_REQUEST[Place::ID], false);
    }

    // return the updated person
    GetLocation();
}

function DeleteModel($mode){
    global $DB;

    $xml = new XMLWriter();
    $xml->openMemory();
    $xml->setIndent(true);
    $xml->startDocument('1.0','UTF-8');
    $xml->startElement('response');

    $query = "DELETE FROM links WHERE ";
    $query .= $mode ? "places" : "people";
    $query .= "=";
    $query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
    $DB->Execute($query);
    $xml->startElement('links');
    $xml->text($query);
    $xml->endElement();

    $query = "DELETE FROM ";
    $query .= $mode ? Place::TABLE_NAME : Person::TABLE_NAME;
    $query .= " WHERE ";
    $query .= $mode ? Place::ID : Person::ID;
    $query .= "=";
    $query .= $mode ? $_REQUEST[Place::ID] : $_REQUEST[Person::ID];
    $DB->Execute($query);
    $xml->startElement('item');
    $xml->text($query);
    $xml->endElement();

    $xml->endElement(); // end response
    $xml->endDocument();
    header("Content-type: text/xml");
    print $xml->outputMemory(true);
}

?>