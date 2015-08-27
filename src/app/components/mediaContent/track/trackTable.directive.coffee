app = angular.module "uTunes"

app.directive 'trackTable', () ->
  directive =
    restrict: 'E'
    templateUrl: "app/components/mediaContent/tracks/track-table.html"
