'use strict';

describe('The main view', function () {
  var page;

  beforeEach(function () {
    browser.get("/");
  });

  it("should have a title", function(){
    expect(browser.getTitle()).toEqual("uTunes");
  });
});
