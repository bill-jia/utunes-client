angular.module "uTunes"
  .factory("AlbumService", ["Restangular",
    (Restangular) ->
      AlbumRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              console.log "Put/Post"
              album: elem
            else
              console.log "Other stuff"
              elem
      )
      )
      model = "albums"
      service = AlbumRestangular.service(model)

      service.listAlbums = () -> AlbumRestangular.all(model).getList()
      service.getAlbum = (albumId) -> AlbumRestangular.one(model, albumId).get()
      service.getTracks = (albumId) -> AlbumRestangular.one(model, albumId).getList("tracks")

      service
  ])