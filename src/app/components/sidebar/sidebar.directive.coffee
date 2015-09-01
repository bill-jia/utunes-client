angular.module "uTunes"
  .directive 'sidebar', ->

    directive =
      restrict: 'E'
      templateUrl: 'app/components/sidebar/sidebar.html'
      controller: ($scope, $element) ->
