app = angular.module "uTunes"

app.controller("PostIndexController", ["$scope", "PostService", "UserService", "$state",
  ($scope, PostService, UserService, $state) ->
    PostService.listPosts().then((posts) ->
      $scope.posts = posts
      for post in $scope.posts
        post.user = UserService.getUser(post.user_id).$object
    )
    $scope.delete = (post) ->
      post.remove().then(() ->
        $state.go("root.posts.index", {}, {reload: true})
      )
])

app.controller("PostShowController", ["$scope", "PostService", "UserService"
  ($scope, PostService) ->

])

app.controller("PostNewController", ["$scope", "PostService", "$state",
  ($scope, PostService, $state) ->
    $scope.post = {title: "", content: "", user_id: $scope.user.id}
    $scope.save = () ->
      # console.dir $scope.album
      PostService.createPost($scope.post).then(() ->
        $state.go("root.posts.index", {}, {reload: true})
      )
])

app.controller("PostEditController", ["$scope", "PostService", "$stateParams", "$state",
  ($scope, PostService, $stateParams, $state) ->
    PostService.getPost($stateParams.postId).then((post) ->
      $scope.post = post
    )

    $scope.save = () ->
      console.dir $scope.post
      PostService.updatePost($scope.post, $stateParams.postId).then(() ->
        $state.go("root.posts.index", {}, {reload: true})
        # $state.go("root.posts.show", {"postId": $stateParams.postId})
      )

    $scope.delete = () ->
      $scope.post.remove().then(() ->
        $state.go("root.posts.index", {}, {reload: true})
      )
])

app.config(["$stateProvider", ($stateProvider) ->
  $stateProvider
    .state "root.posts",
      name: "posts"
      abstract: true
      url: "posts"
      template: "<ui-view/>",
    .state "root.posts.index",
      name: "posts.index"
      url: "/"
      templateUrl: "app/components/posts/views/index.html"
      controller: "PostIndexController"
    .state "root.posts.show",
      name: "posts.show"
      url: "/{postId}/show"
      templateUrl: "app/components/posts/views/show.html"
      controller: "PostShowController"
    .state "root.posts.new",
      name: "posts.new"
      url: "/new"
      templateUrl: "app/components/posts/views/new.html"
      controller: "PostNewController"
    .state "root.posts.edit",
      name: "posts.edit"
      url: "/{postId}/edit"
      templateUrl: "app/components/posts/views/edit.html"
      controller: "PostEditController"
])
