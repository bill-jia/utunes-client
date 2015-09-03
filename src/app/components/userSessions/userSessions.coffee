app = angular.module "uTunes"

app.controller("UserSessionsController", ["$scope", ($scope)->
  $scope.$on("auth:login-error", (ev, reason) ->
    $scope.errors = reason.errors
  )
])
