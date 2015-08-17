angular.module "uTunes"
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        url: "/"
        templateUrl: "app/main/main.html"
        controller: "MainController"
        controllerAs: "main"

      .state "albums",
        url: "/albums"
        templateUrl: "app/views/albums.html",
        controller: "AlbumsController"

    $urlRouterProvider.otherwise '/'
