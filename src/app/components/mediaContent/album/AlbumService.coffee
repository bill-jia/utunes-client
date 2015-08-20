angular.module "uTunes"
  .factory("AlbumService", ["Restangular", "Album",
    (Restangular, Album) ->
      service = Restangular.service("albums")
      model = "albums"

      Restangular.extendModel(model, (obj) ->
        angular.extend(obj, Album)
      )

      service.listAlbums = () -> Restangular.all(model).getList()
      service.getAlbum = (albumId) -> Restangular.one(model, albumId).get()

      service
  ])