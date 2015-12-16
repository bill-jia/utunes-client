angular.module "uTunes"
  .directive 'navbar', ->

    directive =
      restrict: 'E'
      templateUrl: 'app/components/navbar/navbar.html'
      controller:["$scope", "$element", "$timeout", "$mdSidenav", "$mdUtil", "$state",
        ($scope, $element, $timeout, $mdSidenav, $mdUtil, $state) ->
          buildToggler = (navId) ->
            $mdUtil.debounce((-> $mdSidenav(navId).toggle().then()), 200)


          $scope.toggleLeft = buildToggler('left')
          $scope.toggleRight = buildToggler('right')

          $scope.submit = () ->
            console.log "Submitted"
            $state.go("root.search", {"searchParams": $scope.searchParams})
      ]
