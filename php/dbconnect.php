<?php

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