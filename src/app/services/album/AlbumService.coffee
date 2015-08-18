angular.module "uTunes"
  .factory("AlbumService", ["Restangular", "Album",
    (Restangular, Album) ->

      model = "albums"

      Restangular.extendModel(model, (obj) ->
        angular.extend(obj, Album)
      )

      list: () -> Restangular.all(model).getList()
  ])