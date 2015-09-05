app = angular.module "uTunes"

app.controller("UserIndexController", ["$scope", "UserService", ($scope, UserService) ->
    UserService.listUsers().then((users) ->
      $scope.users = users
    )

    $scope.headers = [
      {
        name: "Name"
        field: "name"
      }
      {
        name: "Email"
        field: "email"
      }
      {
        name: "Role"
        field: "role"
      }
      {
        name: "Edit"
        field: "edit"
      }
    ]
    $scope.count = 25
])

app.controller("UserNewController", ["$scope", "$auth", ($scope, $auth) ->
  $scope.handleRegBtnClick = () ->
    console.log "Registration"
    $auth.submitRegistration($scope.registrationForm).then(()->
      $auth.submitLogin({
        email: $scope.registrationForm.email,
        password: $scope.registrationForm.password
      })
    )

  $scope.$on("auth:registration-email-error", (ev, reason) ->
    $scope.errors = reason.errors
  )
])

app.controller("UserEditController", ["$scope", "$auth", ($scope, $auth) ->
  $scope.$on("auth:account-update-error", (ev, reason) ->
    $scope.errors = reason.errors
  )
])

app.controller("UserAdminEditController", ["$scope", "$state", "$stateParams", "UserService",
  ($scope, $state, $stateParams, UserService) ->
    UserService.getUser($stateParams.userId).then((user) ->
      console.dir user
      $scope.otheruser = user
    )

    $scope.save = () ->
      UserService.updateUser($scope.otheruser).then(() ->
        $state.go("root.users.index", {}, {reload: true})
      )

    $scope.delete = () ->
      $scope.otheruser.remove().then(() ->
        $state.go("root.users.index", {}, {reload: true})
      )

])

app.config(["$stateProvider", ($stateProvider) ->
  $stateProvider
    .state "root.users",
      name: "users"
      abstract: true
      url: "users"
      template: "<ui-view/>",
    .state "root.users.index",
      name: "users.index"
      url: "/"
      templateUrl: "app/components/users/views/index.html"
      controller: "UserIndexController"
    .state "root.users.new",
      name: "users.new"
      url: "/new"
      templateUrl: "app/components/users/views/new.html"
      controller: "UserNewController"
    .state "root.users.edit",
      name: "users.edit"
      url: "/{userId}/edit"
      templateUrl: "app/components/users/views/edit.html"
      controller: "UserEditController"
    .state "root.users.adminEdit",
      name: "users.adminEdit"
      url: "/admin/{userId}/edit"
      templateUrl: "app/components/users/views/admin-edit.html"
      controller: "UserAdminEditController"
])
