angular.module "uTunes"
  .factory("PostService", ["Restangular", "Upload",
    (Restangular, Upload) ->
      PostRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              post: elem
            else
              elem
          )
      )
      model = "posts"

      sendPayload = (formData, method, url) ->
        options =
          url: url
          method: method
          file: formData.file
          fields:
            post:
              title: formData.title
              content: formData.content
              user_id: formData.user_id
              author: formData.author
        console.log "Uploader"
        console.dir options.file
        console.dir formData

        Upload.upload(options)
          .success((data, status, headers, config) ->
            console.log("files " + config.file.name + "uploaded. Response: " + data)
          )
          .error((data, status, headers, config) ->
            console.log("error status: " + status)
          )

      listPosts: () -> PostRestangular.all(model).getList()
      getPost: (postId) -> PostRestangular.one(model, postId).get()
      createPost: (post) ->
        if post.file
          sendPayload(post, "POST", "/api/posts")
        else
          PostRestangular.service(model).post(post)
      updatePost: (post, postId) ->
        if post.file
          sendPayload(post, "PUT", "/api/posts/#{postId}")
        else
          post.put()

  ])
