angular.module "uTunes"
  .factory("UserService", ["Restangular",
    (Restangular) ->
      UserRestangular = Restangular.withConfig(
        (RestangularConfigurer) ->
          RestangularConfigurer.addRequestInterceptor((elem, operation, what, url) ->
            # console.log "Request intercepted"
            if (operation == "put" || operation == "post")
              user: elem
            else
              elem
          )
      )
      model = "users"

      listUsers: () -> UserRestangular.all(model).getList()
      getUser: (userId) -> UserRestangular.one(model, userId).get()
      updateUser: (user) -> user.put()
  ])
