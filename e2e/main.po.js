/**
 * This file uses the Page Object pattern to define the main page for tests
 * https://docs.google.com/presentation/d/1B6manhG0zEXkC-H-tPo2vwU06JhL8w9-XCF9oehXzAQ
 */

'use strict';

var MainPage = function() {
  this.navbar = element(by.css("md-toolbar"));
  this.sections = this.navbar.all(by.css("a"));
  this.home = element(by.linkText("Home"));
  this.news = element(by.linkText("News"));
  this.faq = element(by.linkText("FAQ"));
  this.about = element(by.linkText("About"));

  this.sidebar = element(by.css(".md-sidenav-left"));
  this.mediaLinks = this.sidebar.all(by.css(".md-button"));
  this.albums = element(by.cssContainingText(".md-button", "Albums"));
  this.artists = element(by.cssContainingText(".md-button", "Artists"));
  this.playlists = element(by.cssContainingText(".md-button", "Playlists"));
  this.producers = element(by.cssContainingText(".md-button", "Producers"));
  this.tracks = element(by.cssContainingText(".md-button", "Tracks"));

};

module.exports = new MainPage();
