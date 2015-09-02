angular.module "uTunes"
  .directive 'trackFields', ["$timeout", ($timeout)->
    directive =
      restrict: 'E'
      scope: {
        registerFormScope: "="
        track: "="
        edit: "="
        artistEdit: "="
      }
      templateUrl: 'app/components/mediaContent/forms/views/track-fields.html'
      link: (scope) ->
        scope.disabled = false

        scope.addArtist = (track) ->
          unless track.artists
            track.artists = []
          track.artists.push({name: "", class_year: ""})

        scope.removeArtist = (index, track) ->
          artist = track.artists[index]
          if artist.id
            artist._destroy = true
          else
            track.artists.splice(index,1)

        $timeout(() ->
          scope.form.fields = ["track_number", "title", "audio"]
          scope.registerFormScope(scope.form, scope.$id)
        )
  ]
