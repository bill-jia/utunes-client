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
    $auth.submitRegistration($scope.registrationForm).then(
      ()->
        console.log "Registration successful"
        $auth.submitLogin({
          email: $scope.registrationForm.email,
          password: $scope.registrationForm.password
        })
      (ev, reason) ->
        console.log "Registration failed"
        $scope.errors = reason.errors
    )
])

app.controller("UserEditController", ["$scope", "$auth","$mdDialog", "$state"
  ($scope, $auth, $mdDialog, $state) ->
    $scope.$on("auth:account-update-error", (ev, reason) ->
      $scope.errors = reason.errors
    )

    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: UserDeleteDialogController
          templateUrl: "app/components/users/views/delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.delete()
        () ->
      )

    $scope.save = () ->
      $scope.formSending = true
      $auth.updateAccount($scope.updateAccountForm).then(()->
        $state.go("root.posts.index")
      ).catch(()->)

    $scope.delete = () ->
      $scope.formSending = true
      $auth.destroyAccount().then(()->
        $state.go("root.posts.index")
      ).catch(()->)
])

app.controller("UserAdminEditController", ["$scope", "$state", "$stateParams", "UserService", "$mdDialog",
  ($scope, $state, $stateParams, UserService, $mdDialog) ->
    $scope.formSending = false
    UserService.getUser($stateParams.userId).then((user) ->
      console.dir user
      $scope.otheruser = user
    )

    $scope.save = () ->
      $scope.formSending = true
      UserService.updateUser($scope.otheruser).then(() ->
        $state.go("root.users.index", {}, {reload: true})
      ).catch((errors) ->
        $scope.errors = errors.data
        $scope.formSending = false
      )

    $scope.openDeleteDialog = (e) ->
      $mdDialog.show({
          controller: UserDeleteDialogController
          templateUrl: "app/components/users/views/admin-delete-dialog.html"
          parent: angular.element(document.body)
          targetEvent: e
          clickOutsideToClose: true
      }).then(
        (answer) ->
          $scope.delete()
        () ->
      )

    $scope.delete = () ->
      $scope.formSending = true
      $scope.otheruser.remove({admin_password: $scope.otheruser.admin_password}).then(() ->
        $state.go("root.users.index", {}, {reload: true})
      ).catch((errors) ->
        $scope.errors = errors.data
        $scope.formSending = false
      )
])

UserDeleteDialogController = ["$scope", "$mdDialog", ($scope, $mdDialog) ->
  $scope.hide = () ->
    $mdDialog.hide()

  $scope.cancel = () ->
    $mdDialog.cancel()

  $scope.answer = (answer) ->
    $mdDialog.hide(answer)
]
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
      resolve: {
        auth: ["$auth", ($auth) ->
          return $auth.validateUser()
        ]
        admin: ["trackRoles", (trackRoles) ->
          return trackRoles.admin()
        ]
      }
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
      resolve: {
        auth: ["$auth", ($auth) ->
          return $auth.validateUser()
        ]
      }
    .state "root.users.adminEdit",
      name: "users.adminEdit"
      url: "/admin/{userId}/edit"
      templateUrl: "app/components/users/views/admin-edit.html"
      controller: "UserAdminEditController"
      resolve: {
        auth: ["$auth", ($auth) ->
          return $auth.validateUser()
        ]
        admin: ["trackRoles", (trackRoles) ->
          return trackRoles.admin()
        ]
      }
])
