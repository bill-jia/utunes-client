angular.module "uTunes"
  .directive 'trackFields', ["$timeout", "TrackService", ($timeout, TrackService)->
    directive =
      restrict: 'E'
      scope: {
        registerFormScope: "="
        track: "="
        tracks: "="
        edit: "="
        artistEdit: "="
        trackNumbers: "="
      }
      templateUrl: 'app/components/mediaContent/forms/views/track-fields.html'
      link: (scope, element) ->
        scope.disabled = false
        
        scope.addArtist = (track) ->
          unless track.artists
            track.artists = []
          track.artists.push({name: "", class_year: ""})

        scope.removeArtist = (index, track) ->
          artist = track.artists[index]
          unless artist.id
            track.artists.splice(index,1)

        scope.removeArtistAssociation = (artist) ->
          artist._remove = true
          unless scope.track.artists
            scope.track.artists = []
          scope.track.artists.push artist

        scope.uniqueTrackNumber = (value) ->
          trackNumbers = scope.trackNumbers.slice(0)
          for track in scope.tracks
            trackNumbers.push track.track_number
          if trackNumbers.indexOf(value) == -1
            true
          else
            false

        $timeout(() ->
          scope.form.fields = ["track_number", "title", "audio"]
          scope.registerFormScope(scope.form, scope.$id)
        )

        scope.$watch('track', (newValue)->
          if newValue
            if scope.edit && !scope.artists
              TrackService.getArtists(scope.track.id).then((artists) ->
                scope.artists = artists
                # console.dir scope.artists
              )
        , true)
        scope.$watch('track.file', (newValue) ->
          audio = element.find("#new-track-audio")[0]
          audio.onloadedmetadata = (e) ->
            scope.track.length_in_seconds = audio.duration
        )
  ]
