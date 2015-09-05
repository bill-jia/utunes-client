angular.module "uTunes"
  .factory("PostService", ["Restangular",
    (Restangular) ->
      PostRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              artist: elem
            else
              elem
          )
      )
      model = "posts"

      listPosts: () -> PostRestangular.all(model).getList()
      getPost: (postId) -> PostRestangular.one(model, postId).get()
      updatePost: (post) -> post.put()

  ])
