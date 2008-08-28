-- phpMyAdmin SQL Dump
-- version 2.11.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 27, 2008 at 02:14 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `dev-address`
--

-- --------------------------------------------------------

--
-- Table structure for table `addressgroup`
--

DROP TABLE IF EXISTS `addressgroup`;
CREATE TABLE IF NOT EXISTS `addressgroup` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `city` varchar(100) default NULL,
  `state` varchar(2) default NULL,
  `zipcode` varchar(10) default NULL,
  `details` text,
  `last-update` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `addressgroup`
--


-- --------------------------------------------------------

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
CREATE TABLE IF NOT EXISTS `people` (
  `id` int(10) unsigned NOT NULL,
  `gid` int(10) unsigned NOT NULL,
  `firstname` varchar(100) default NULL,
  `lastname` varchar(100) default NULL,
  `title` varchar(20) default NULL,
  `birth` date default NULL,
  `email` varchar(255) default NULL,
  `phone` varchar(30) default NULL,
  `cell` varchar(30) default NULL,
  `details` text,
  `last-update` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `people`
--


-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `uid` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `last-login` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `last-ip` varchar(15) default '0.0.0.0',
  PRIMARY KEY  (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

