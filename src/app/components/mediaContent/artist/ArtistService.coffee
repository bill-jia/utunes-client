angular.module "uTunes"
  .factory("ArtistService", ["Restangular",
    (Restangular) ->
      ArtistRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              artist: elem
            else
              elem
          )
      )
      model = "artists"
      service = ArtistRestangular.service(model)

      service.listArtists = () -> ArtistRestangular.all(model).getList()
      service.getArtist = (artistId) -> ArtistRestangular.one(model, artistId).get()
      service.getTracks = (artistId) -> ArtistRestangular.one(model, artistId).getList("tracks")
      service.getAlbums = (artistId) -> ArtistRestangular.one(model, artistId).getList("albums")

      service
  ])
