app = angular.module "uTunes"

app.directive 'searchbar', () ->
  directive =
    restrict: 'E'
    scope: ""
    templateUrl: "app/components/search/searchbar.html"
    controller: ($scope, $element, $state) ->
      $scope.submit = () ->
        console.log "Submitted"
        $state.go("root.search", {"searchParams": $scope.searchParams})
