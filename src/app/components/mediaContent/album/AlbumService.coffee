angular.module "uTunes"
  .factory("AlbumService", ["Restangular", "Album",
    (Restangular, Album) ->

      model = "albums"

      Restangular.extendModel(model, (obj) ->
        angular.extend(obj, Album)
      )

      listAlbums: () -> Restangular.all(model).getList()
      getAlbum: (albumId) -> Restangular.one(model, albumId).get()
  ])