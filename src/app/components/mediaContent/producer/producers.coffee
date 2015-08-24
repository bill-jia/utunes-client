app = angular.module "uTunes"

app.controller("ProducerIndexController", ["$scope", "ProducerService",
  ($scope, ProducerService) ->
    ProducerService.listProducers().then((producers) ->
      $scope.producers = producers
      )
])

app.controller("ProducerShowController", ["$scope", "$stateParams", "ProducerService", "TrackService",
  ($scope, $stateParams, ProducerService) ->

    ProducerService.getProducer($stateParams.producerId).then((producer) ->
      $scope.producer = producer
    )
    ProducerService.getAlbums($stateParams.producerId).then((albums) ->
      $scope.albums = albums
    )
])

app.controller("ProducerEditController", ["$scope", "$state", "$stateParams", "ProducerService",
  ($scope, $state, $stateParams, ProducerService) ->
    ProducerService.getProducer($stateParams.producerId).then((producer) ->
      $scope.producer = producer
    )

    $scope.save = () ->
      $scope.producer.put().then(() ->
        $state.go("root.producers.show", {"producerId": $stateParams.producerId})
      )

    $scope.delete = () ->
      $scope.producer.remove().then(() ->
        $state.go("root.producers.index", {}, {reload: true})
      )
])

app.config(["$stateProvider",
  ($stateProvider) ->
    $stateProvider
      .state "root.producers",
        name: "producers"
        abstract: true
        url: "producers"
        template: "<ui-view/>"
      .state "root.producers.index",
        name: "producers.index"
        url: "/"
        templateUrl: "app/components/mediaContent/producer/views/index.html"
        controller: "ProducerIndexController"
      .state "root.producers.show",
        name: "producers.show"
        url: "/{producerId}/show"
        templateUrl: "app/components/mediaContent/producer/views/show.html"
        controller: "ProducerShowController"
      .state "root.producers.edit",
        name: "producers.edit"
        url: "/{producerId}/edit"
        templateUrl: "app/components/mediaContent/producer/views/edit.html"
        controller: "ProducerEditController"
])