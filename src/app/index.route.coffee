angular.module "uTunes"
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "root",
        abstract: true,
        name: "root"
        url: "/"
        templateUrl: "app/main/index.html"
        controller: "MainController"
      .state "root.posts",
        name: "posts"
        abstract: true
        url: ""
        template: "<ui-view/>",
      .state "root.posts.index",
        name: "posts.index"
        url: ""
        templateUrl: "app/components/posts/views/index.html"
        controller: "PostIndexController"
# Root children
      .state "root.faq",
        name: "faq"
        url: "faq"
        templateUrl: "app/main/faq.html"
      .state "root.contact",
        name: "contact"
        url: "contact"
        templateUrl: "app/main/contact.html"
      .state "root.login",
        name: "login"
        url: "sign_in"
        templateUrl: "app/components/userSessions/views/new.html"
        controller: "UserSessionsController"

    $urlRouterProvider.otherwise '/'
