app = angular.module "uTunes"

app.controller("UserRegistrationController", ["$scope", "$auth", ($scope, $auth) ->
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
