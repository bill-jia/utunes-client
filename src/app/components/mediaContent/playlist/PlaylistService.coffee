angular.module "uTunes"
  .factory("PlaylistService", ["Restangular",
    (Restangular) ->
      PlaylistRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              console.dir elem
              playlist: elem
            else
              elem
          )
      )
      model = "playlists"

      listPlaylists: () -> PlaylistRestangular.all(model).getList()
      searchPlaylists: (searchParams) -> PlaylistRestangular.all(model).getList({"search": searchParams})
      getPlaylist: (playlistId) -> PlaylistRestangular.one(model, playlistId).get()
      getUserPlaylists: (userId) -> PlaylistRestangular.one("users", userId).getList(model)
      getTracks: (playlistId) -> PlaylistRestangular.one(model, playlistId).getList("tracks")
      createPlaylist: (playlist) ->
          PlaylistRestangular.service(model).post(playlist)
      updatePlaylist: (playlist) ->
          playlist.put()
      addTrackToPlaylist: (playlist, track) ->
        unless playlist.tracks
          playlist.tracks = []
        playlist.tracks.push track
        playlist.put()

  ])
