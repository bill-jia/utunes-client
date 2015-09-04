app = angular.module "uTunes"

app.controller("NewUserController", ["$scope", "$auth", ($scope, $auth) ->
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

app.config(["$stateProvider", ($stateProvider) ->
  $stateProvider
    .state "root.users",
      name: "users"
      abstract: true
      url: "users"
      template: "<ui-view/>"
    .state "root.users.new",
      name: "users.new"
      url: "/new"
      templateUrl: "app/components/users/views/new.html"
      controller: "NewUserController"
])
