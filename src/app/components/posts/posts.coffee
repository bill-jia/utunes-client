app = angular.module "uTunes"

app.controller("PostIndexController", ["$scope", "PostService", "$state", "$filter",
  ($scope, PostService, $state, $filter) ->
    PostService.listPosts().then((posts) ->
      $scope.posts = posts
      for post in $scope.posts
        post.content = $filter("cut")(post.content, true, 1400, "...", $state.href("root.posts.show", {postId: post.id}))
      $scope.posts = $filter("orderBy")($scope.posts, orderByDate, true)
    )
    $scope.delete = (post) ->
      post.remove().then(() ->
        $state.go("root.posts.index", {}, {reload: true})
      )

    orderByDate = (post) ->
      post.updated_at
])

app.controller("PostShowController", ["$scope", "PostService", "$stateParams"
  ($scope, PostService, $stateParams) ->
    PostService.getPost($stateParams.postId).then((post) ->
      $scope.post = post
    )
])

app.controller("PostNewController", ["$scope", "PostService", "$state",
  ($scope, PostService, $state) ->
    $scope.post = {title: "", content: "", user_id: $scope.user.id, author: $scope.user.name}
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
    .state "root.posts.show",
      name: "posts.show"
      url: "/posts/{postId}/show"
      templateUrl: "app/components/posts/views/show.html"
      controller: "PostShowController"
    .state "root.posts.new",
      name: "posts.new"
      url: "/posts/new"
      templateUrl: "app/components/posts/views/new.html"
      controller: "PostNewController"
    .state "root.posts.edit",
      name: "posts.edit"
      url: "/posts/{postId}/edit"
      templateUrl: "app/components/posts/views/edit.html"
      controller: "PostEditController"
])
