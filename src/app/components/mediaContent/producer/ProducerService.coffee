angular.module "uTunes"
  .factory("ProducerService", ["Restangular",
    (Restangular) ->
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
      service = ProducerRestangular.service(model)

      service.listProducers = () -> ProducerRestangular.all(model).getList()
      service.getProducer = (producerId) -> ProducerRestangular.one(model, producerId).get()
      service.getAlbums = (producerId) -> ProducerRestangular.one(model, producerId).getList("albums")

      service
  ])
