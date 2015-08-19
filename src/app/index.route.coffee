angular.module "uTunes"
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        url: "/"
        templateUrl: "app/main/index.html"
      .state "yeoman",
        url: "/yo"
        templateUrl: "app/yeoman/yeoman.html"
        controller: "YeomanController"
        controllerAs: "yeoman"

      .state "albums",
        url: "/albums"
        templateUrl: "app/views/albums.html",
        controller: "AlbumsController"

    $urlRouterProvider.otherwise '/'
