app = angular.module "uTunes"

app.controller("PostIndexController", ["$scope", "PostService",
  ($scope, PostService) ->
    PostService.listPosts().then((posts) ->
      $scope.posts = posts.plain()
    )
])

app.controller("PostIndexController", ["$scope", "PostService",
  ($scope, PostService) ->

])

app.controller("PostIndexController", ["$scope", "PostService",
  ($scope, PostService) ->

])

app.controller("PostIndexController", ["$scope", "PostService",
  ($scope, PostService) ->

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
