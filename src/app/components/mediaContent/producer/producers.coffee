app = angular.module "uTunes"

app.controller("ProducerIndexController", ["$scope", "ProducerService",
  ($scope, ProducerService) ->
    ProducerService.listProducers().then((producers) ->
      $scope.producers = producers
      )
    $scope.count = 24
])

app.controller("ProducerShowController", ["$scope", "$stateParams", "ProducerService", "TrackService",
  ($scope, $stateParams, ProducerService) ->

    ProducerService.getProducer($stateParams.producerId).then((producer) ->
      $scope.producer = producer
      console.dir $scope.producer
    )
    ProducerService.getAlbums($stateParams.producerId).then((albums) ->
      $scope.albums = albums
    )

    $scope.albumCount = 6
])

app.controller("ProducerEditController", ["$scope", "$state", "$stateParams", "ProducerService", "$mdDialog",
  ($scope, $state, $stateParams, ProducerService, $mdDialog) ->
    ProducerService.getProducer($stateParams.producerId).then((producer) ->
      $scope.producer = producer
    )

    $scope.formsValid = false
    $scope.albumEdit = false
    $scope.artistEdit = false
    $scope.producerEdit = true
    $scope.trackEdit = false

    $scope.registerFormScope = (form, id) ->
      $scope.parentForm["childForm" + id] = form
      console.dir $scope.parentForm

    $scope.save = () ->
      $scope.formSending = true
      ProducerService.updateProducer($scope.producer, $stateParams.producerId).then(() ->
        $state.go("root.producers.show", {"producerId": $stateParams.producerId})
      )

    $scope.delete = () ->
      $scope.formSending = true
      $scope.producer.remove().then(() ->
        $state.go("root.producers.index", {}, {reload: true})
      )

    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: ProducerDeleteDialogController
          templateUrl: "app/components/mediaContent/producer/views/delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.delete()
        () ->
    )
])

ProducerDeleteDialogController = ($scope, $mdDialog) ->
  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    $mdDialog.cancel()

  $scope.answer = (answer) ->
    $mdDialog.hide(answer)

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
        resolve: {
          auth: ["$auth", ($auth) ->
            return $auth.validateUser()
          ]
          producer: ["trackRoles", (trackRoles) ->
            return trackRoles.producer()
          ]
        }
])
