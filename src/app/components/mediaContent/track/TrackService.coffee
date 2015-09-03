angular.module "uTunes"
  .factory("TrackService", ["Restangular", "Upload",
    (Restangular, Upload) ->
      model = "tracks"
      TrackRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              console.log "Put/Post"
              console.dir elem
              track: elem
            else
              # console.log "Other stuff"
              elem
          )
      )

      sendPayload = (formData, method, url) ->
        options =
          url: url
          method: method
          file: formData.file
          fields:
            track:
              title: formData.title
              length_in_seconds: formData.length_in_seconds
        console.log "Uploader"
        console.dir formData
        console.dir options.file

        Upload.upload(options)
          .success((data, status, headers, config) ->
            console.log("files " + config.file.name + "uploaded. Response: " + data)
          )
          .error((data, status, headers, config) ->
            console.log("error status: " + status)
          )

      listTracks: () -> TrackRestangular.all(model).getList()
      getTrack: (trackId) -> TrackRestangular.one(model, trackId).get()
      getArtists: (trackId) -> TrackRestangular.one(model, trackId).getList("artists")
      updateTrack: (track, trackId) ->
        if track.file
          sendPayload(track, "PUT", "/api/tracks/#{trackId}")
        else
          track.put()

  ])
