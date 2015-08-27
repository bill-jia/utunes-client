angular.module "uTunes"
  .factory("ProducerService", ["Restangular", "Upload",
    (Restangular, Upload) ->
      ProducerRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              producer: elem
            else
              elem
          )
      )
      model = "producers"

      sendPayload = (formData, method, url) ->
        options =
          url: url
          method: method
          file: formData.file
          fields:
            producer:
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

      listProducers: () -> ProducerRestangular.all(model).getList()
      getProducer: (producerId) -> ProducerRestangular.one(model, producerId).get()
      getAlbums: (producerId) -> ProducerRestangular.one(model, producerId).getList("albums")
      updateProducer: (producer, producerId) ->
        if producer.file
          sendPayload(producer, "PUT", "/api/producers/#{producerId}")
        else
          producer.put()


  ])
