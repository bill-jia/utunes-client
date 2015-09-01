angular.module "uTunes"
  .directive 'gridList', () ->
    directive =
      restrict: 'E'
      templateUrl: 'app/components/mediaContent/gridList/grid-list.html'
      controller: ($scope, $element) ->

        #
        # console.dir $scope.items[0]
        buildGridModel = (items) ->
          tiles = []
          for item in items
            # console.dir item
            tile = angular.extend({}, {title: "", year: "", image: "", type: "", id: ""})
            tile.id = item.id
            if item.name
              tile.title = item.name
              tile.type = "artist"
            else
              tile.title = item.title
              tile.type = "album"
            if item.class_year
              tile.year = item.class_year
            else
              tile.year = item.year
            if item.profile_picture
              tile.image = item.profile_picture
            else
              tile.image = item.cover_image

            tiles.push tile

          return tiles
        $scope.$on "elementsloaded", () ->
          console.log "Elements received"
          $scope.items = if $scope.albums then $scope.albums else $scope.artists
          console.dir $scope.items
          $scope.tiles = buildGridModel($scope.items)
          console.dir $scope.tiles
