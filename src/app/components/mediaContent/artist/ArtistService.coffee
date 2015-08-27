angular.module "uTunes"
  .factory("ArtistService", ["Restangular", "Upload",
    (Restangular, Upload) ->
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

      sendPayload = (formData, method, url) ->
        options =
          url: url
          method: method
          file: formData.file
          fields:
            artist:
              name: formData.name
              class_year: formData.class_year
              bio: formData.bio
        console.log "Uploader"
        console.dir options.file

        Upload.upload(options)
          .success((data, status, headers, config) ->
            console.log("files " + config.file.name + "uploaded. Response: " + data)
          )
          .error((data, status, headers, config) ->
            console.log("error status: " + status)
          )

      listArtists: () -> ArtistRestangular.all(model).getList()
      getArtist: (artistId) -> ArtistRestangular.one(model, artistId).get()
      getTracks: (artistId) -> ArtistRestangular.one(model, artistId).getList("tracks")
      getAlbums: (artistId) -> ArtistRestangular.one(model, artistId).getList("albums")
      updateArtist: (artist, artistId) ->
        if artist.file
          sendPayload(artist, "PUT", "/api/artists/#{artistId}")
        else
          artist.put()

  ])
