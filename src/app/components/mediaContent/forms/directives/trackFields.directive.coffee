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
      }
      templateUrl: 'app/components/mediaContent/forms/views/track-fields.html'
      link: (scope) ->
        scope.disabled = false
        # console.dir scope.track


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
          console.log "Comparison"
          trackNumbers = []
          for track in scope.tracks
            trackNumbers.push track.track_number
          console.log trackNumbers
          if trackNumbers.indexOf(value) == -1
            true
          else
            false

        scope.comparetoOne = (value) ->
          console.log "Comparison"
          value >= 1

        scope.getTrackArray = () ->
          trackNumbers = []
          for track in scope.tracks
            trackNumbers.push track.track_number
          console.log trackNumbers

        $timeout(() ->
          scope.form.fields = ["track_number", "title", "audio"]
          scope.registerFormScope(scope.form, scope.$id)
        )

        scope.$watch('track', (newValue)->
          if newValue
            # console.dir scope.track
            if scope.edit && !scope.artists
              TrackService.getArtists(scope.track.id).then((artists) ->
                scope.artists = artists
                console.dir scope.artists
              )
        , true)
        scope.$watch('tracks', (newValue)->
          if newValue
            console.dir scope.tracks
        , true)
  ]
