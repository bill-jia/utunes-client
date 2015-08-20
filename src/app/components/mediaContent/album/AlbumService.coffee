angular.module "uTunes"
  .factory("AlbumService", ["Restangular",
    (Restangular) ->
      model = "albums"
      service = Restangular.service(model)

      # Restangular.extendModel(model, (obj) ->
      #   angular.extend(obj, Album)
      # )

      service.listAlbums = () -> Restangular.all(model).getList()
      service.getAlbum = (albumId) -> Restangular.one(model, albumId).get()

      service
  ])