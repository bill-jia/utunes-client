angular.module "uTunes"
  .factory "AlbumUploader", ["Upload", (Upload) ->

    sendPayload = (formData, method, url) ->
      files = []
      names = []
      files.push formData.cover_image
      names.push formData.cover_image.name
      for track in formData.tracks
        files.push track.audio
        names.push track.track_number

      options =
        url: url
        method: method
        file: files
        fileFormDataName: names
        fields:
          album:
            title: formData.title
            year: formData.year
            producers: formData.producers
            tracks: formData.tracks
      console.log "Uploader"
      console.dir options.file
      console.dir options.fileFormDataName

      Upload.upload(options)
        .success((data, status, headers, config) ->
          console.log("files " + config.file.name + "uploaded. Response: " + data)
        )
        .error((data, status, headers, config) ->
          console.log("error status: " + status)
        )

    createAlbumWithAttachment: (formData) ->
      sendPayload(formData, "POST", "/api/albums")
    editAlbumWithAttachment: (formData, albumId) ->
      sendPayload(formData, "PUT", "/api/albums/#{albumId}")
  ]
