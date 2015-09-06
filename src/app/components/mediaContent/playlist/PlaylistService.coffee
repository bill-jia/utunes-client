angular.module "uTunes"
  .factory("PlaylistService", ["Restangular",
    (Restangular) ->
      PlaylistRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              playlist: elem
            else
              elem
          )
      )
      model = "playlists"

      listPlaylists: () -> PlaylistRestangular.all(model).getList()
      getPlaylist: (playlistId) -> PlaylistRestangular.one(model, playlistId).get()
      getTracks: (playlistId) -> PlaylistRestangular.one(model, playlistId).getList("tracks")
      createPlaylist: (playlist) ->
          PlaylistRestangular.service(model).post(playlist)
      updatePlaylist: (playlist) ->
          playlist.put()

  ])
