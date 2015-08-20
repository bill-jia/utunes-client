'use strict';

describe('The main view', function () {
  var page;

  beforeEach(function () {
    browser.get("/");
  });

  it("should get the album list", function(){
    element(by.cssContainingText(".btn", "Albums")).click();
  	expect(element(by.repeater("album in albums").row(0)).isPresent()).toBe(true);
  });

  it("should view the first album", function(){
    element(by.cssContainingText(".btn", "Albums")).click();
		element(by.repeater("album in albums").row(0)).element(by.tagName("a")).click();
		expect(element(by.id("album-show")).isPresent()).toBe(true);
		expect(element.all(by.css(".btn")).last().getText()).toEqual("Edit this album");
  });
});
