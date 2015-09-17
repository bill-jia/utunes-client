angular.module "uTunes"
  .directive 'albumFields', ["$timeout", ($timeout)->
    directive =
      restrict: 'E'
      scope: {
        registerFormScope: "="
        album: "="
        edit: "="
      }
      templateUrl: 'app/components/mediaContent/forms/views/album-fields.html'
      link: (scope) ->
        scope.disabled = false
        scope.tracksLength = scope.album.tracks.length

        $timeout(() ->
          scope.form.fields = ["title", "year", "cover_image"]
          scope.registerFormScope(scope.form, scope.$id)
        )
  ]
