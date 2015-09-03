app = angular.module "uTunes"

app.controller("UserRegistrationController", ["$scope", "$auth", ($scope, $auth) ->
  $scope.handleRegBtnClick = () ->
    console.log "Registration"
    $auth.submitRegistration $scope.registrationForm
])
