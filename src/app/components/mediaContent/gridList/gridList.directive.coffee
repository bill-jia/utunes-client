angular.module "uTunes"
  .directive 'gridList', () ->
    directive =
      restrict: 'E'
      scope: {
        items: "="
        type: "="
        count: "="
      }
      templateUrl: 'app/components/mediaContent/gridList/grid-list.html'
      link: (scope, element, attrs) ->
        scope.reverse = 0
        scope.tablePage = 0
        scope.orderProp = "title"
        
        buildGridModel = (items) ->
          tiles = []
          for item in items
            # console.dir item
            tile = angular.extend({}, {title: "", year: "", image: "", id: ""})
            tile.id = item.id
            if scope.type == "album"
              tile.title = item.title
              tile.year = item.year
              tile.image = item.cover_image
            else
              tile.title = item.name
              tile.year = item.class_year
              tile.image = item.profile_picture

            tiles.push tile

          return tiles
        # scope.$on "elementsloaded", (e, items) ->
        #   console.log "Elements received"

        scope.numberOfPages = () ->
          Math.ceil(scope.tiles.length/scope.count)

        scope.getNumber = (number) ->
          new Array(number)

        scope.goToPage = (page) ->
          scope.tablePage = page

        scope.$watch('items', (newValue)->
          if newValue
            scope.props = []
            if scope.type == "album"
              scope.props = [
                {
                  name: "Title"
                  field: "title"
                }
                {
                  name: "Year"
                  field: "year"
                }
              ]
            else
              scope.props = [
                {
                  name: "Name"
                  field: "title"
                }
                {
                  name: "Class Year"
                  field: "year"
                }
              ]
            scope.tiles = buildGridModel(scope.items)
        , true)

          # console.dir $scope.tiles
