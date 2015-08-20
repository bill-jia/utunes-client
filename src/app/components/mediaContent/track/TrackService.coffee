angular.module "uTunes"
  .factory("TrackService", ["Restangular",
    (Restangular) ->
      model = "tracks"
      service = Restangular.service(model)

      service.listTracks = () -> Restangular.all(model).getList()
      service.getTrack = (trackId) -> Restangular.one(model, trackId).get()

      service
  ])