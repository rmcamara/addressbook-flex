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


class Person {
    const TABLE_NAME = "people";

    const ID = "id";
    const TITLE = "title";
    const FIRSTNAME = "firstname";
    const LASTNAME = "lastname";
    const BIRTHDATE = "birth";
    const EMAIL = "email";
    const CELLPHONE = "cell";
    const LAST_UPDATE = "last-update";
    const DETAILS = "details";
}

class Place{
    const TABLE_NAME = "places";

    const ID = "id";
    const NAME = "name";
    const ADDRESS = "address";
    const ADDRESS2 = "address2";
    const CITY = "city";
    const STATE = "state";
    const ZIPCODE = "zipcode";
    const PHONE = "phone";
    const LAST_UPDATE = "last-update";
    const DETAILS = "details";
}


?>