angular.module "uTunes"
  .factory "AlbumUploader", ["Upload", (Upload) ->

    sendPayload = (formData, method, url) ->
      cover_image = formData.cover_image ?[]
      options =
        url: url
        method: method
        file: cover_image
        file_form_data_name: cover_image.name? ""
        fields:
          album:
            title: formData.title
            year: formData.year
            producers: formData.producers
            tracks: formData.tracks
      console.log "Uploader"
      console.dir formData
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
