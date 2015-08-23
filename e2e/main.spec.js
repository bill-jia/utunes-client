'use strict';

describe('The main view', function () {
  var page;

  beforeEach(function () {
    browser.get('/');
    page = require('./main.po');
  });

  it('has the correct title', function() {
    expect(browser.getTitle()).toEqual("uTunes");
  });

  it('should include navbar with correct data', function() {
    expect(page.sections.count()).toEqual(4);
    expect(page.home.getAttribute('ui-sref')).toBe(".home");
    expect(page.news.getAttribute('ui-sref')).toBe(".news");
    expect(page.faq.getAttribute('ui-sref')).toBe(".faq");
    expect(page.about.getAttribute('ui-sref')).toBe(".about");
  });

  it('should include sidebar with correct data', function() {
    expect(page.mediaLinks.count()).toEqual(5);
    expect(page.albums.getAttribute("ui-sref")).toBe(".albums.index");
    expect(page.artists.getAttribute("ui-sref")).toBe(".artists.index");
    // TODO: Implement playlists
    // expect(page.playlists.getAttribute("ui-sref")).toBe(".playlists.index");
    expect(page.producers.getAttribute("ui-sref")).toBe(".producers.index");
    expect(page.tracks.getAttribute("ui-sref")).toBe(".tracks.index");
  });

  it ('should have a homepage', function() {
    page.home.click();
    var content = element(by.css("md-content h2"));
    expect(content.getText()).toEqual("This is the home page.");
  });

  // it ('should have a newspage', function() {
  //   page.news.click();
  //   var content = element(by.css("md-content h2"));
  //   expect(content.getText()).toContain("This is the news page");
  // });

  it ('should have an FAQ page', function() {
    page.faq.click();
    var content = element(by.css("md-content h2"));
    expect(content.getText()).toEqual("This is the FAQ page.");
  });

  it ('should have an About page', function() {
    page.about.click();
    var content = element(by.css("md-content h2"));
    expect(content.getText()).toEqual("This is the About page.");
  });

  // it ('should have an Albums page', function() {
  //   page.albums.click();
  //   var content = element(by.css("h2"));
  //   expect(content.isPresent()).toBe(true);
  // });
});
