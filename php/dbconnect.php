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

	define('ADODB_DIR', dirname(realpath(__FILE__)) . '/adodb5/');

	define('DATABASE', 'dev_address');
	define('HOSTNAME', 'localhost');
	define('USERNAME', 'addressbot');
	define('PASSWORD', 'camara');
	define('NEWLINE', "\n");

	include_once(ADODB_DIR.'adodb-exceptions.inc.php');
	include_once(ADODB_DIR.'adodb.inc.php');

	$DB = ADONewConnection('mysql');
    $DB->PConnect(HOSTNAME, USERNAME, PASSWORD, DATABASE);
    $ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;


function generateWhere($fields){
    $results = ' WHERE';
    if (!is_array($fields)){
        throw new Exception("Not an array of fields");
    }

    unset($seen);
    foreach ($fields as $key => $value){
        if(!$value){
            continue;
        }
        if (isset($seen)){
            $results .= " AND ";
        }

        $results .= " ".$key."=";
        if (!is_numeric($value)){
            $results .= "'";
        }
        $results .= $value;
        if (!is_numeric($value)){
            $results .= "'";
        }
        $seen = true;
    }

    return $results;
}
?>