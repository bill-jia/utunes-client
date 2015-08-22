angular.module "uTunes"
  .factory("TrackService", ["Restangular",
    (Restangular) ->
      model = "tracks"
      TrackRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              # console.log "Put/Post"
              track: elem
            else
              # console.log "Other stuff"
              elem
          )
      )
      service = TrackRestangular.service(model)

      service.listTracks = () -> TrackRestangular.all(model).getList()
      service.getTrack = (trackId) -> TrackRestangular.one(model, trackId).get()

      service
  ])
