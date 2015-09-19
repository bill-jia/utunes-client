angular.module "uTunes"
  .directive 'playingToast', [() ->
    directive =
      restrict: 'E'
      scope: {}
      template: ""
      controller: ($scope, $element, $timeout, $mdToast, $document) ->
        $scope.$on "trackplaying", (e, track) ->
          console.log "A track is playing"
          $mdToast.show({
            controller: ToastController
            templateUrl: "app/components/playingToast/playing-toast.html"
            parent: $document[0].querySelector("playing-toast")
            hideDelay: 0
            position: "top right"
          })

  ]

ToastController = ($scope, $mdToast) ->
