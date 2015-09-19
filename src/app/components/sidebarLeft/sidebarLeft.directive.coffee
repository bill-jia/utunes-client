angular.module "uTunes"
  .directive 'sidebarLeft', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/sidebarLeft/sidebar-left.html'
      controller: ($scope, $element, $timeout, $mdSidenav, $state) ->
        $scope.$on "trackplaying", (e, track) ->
          $scope.track = track

        $scope.$watch((()-> $state.current.name), (newValue)->
          $scope.state = $state.current.name
        , true)

        $scope.close = () ->
          $mdSidenav("left").close()

        $scope.goTo = (e, state) ->
          $state.go(state, {}, {reload: false})
          $scope.close()
