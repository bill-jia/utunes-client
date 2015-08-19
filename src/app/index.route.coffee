angular.module "uTunes"
  .config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "root",
        abstract: true,
        name: "root"
        url: "/"
        templateUrl: "app/main/index.html"
      .state "root.home",
        name: "home"
        url: ""
        templateUrl: "app/main/home.html"
# Root children
      .state "root.faq",
        name: "faq"
        url: "faq"
        templateUrl: "app/main/faq.html"
      .state "root.albums",
        name: "albums"
        url: "albums"
        templateUrl: "app/components/mediaContent/album/albums.html"
        controller: "AlbumsController"
      .state "root.artists",
        name: "artists"
        url: "artists"
        templateUrl: "app/components/mediaContent/artist/artists.html"
      .state "root.playlists",
        name: "playlists"
        url: "playlists"
        templateUrl: "app/components/mediaContent/playlist/playlists.html"
      .state "root.tracks",
        name: "tracks"
        templateUrl: "app/components/mediaContent/track/tracks.html"

      .state "yeoman",
        url: "/yo"
        templateUrl: "app/yeoman/yeoman.html"
        controller: "YeomanController"
        controllerAs: "yeoman"

    $urlRouterProvider.otherwise '/'
