angular.module "uTunes"
  .run(["$log", "$rootScope", "$state", "$document", ($log, $rootScope, $state, $document) ->
    $log.debug 'runBlock end'
    $rootScope.$on "auth:login-success", () ->
    $rootScope.$on "auth:account-update-success", () ->
      $state.go "root.home"
    $rootScope.$on "auth:logout-success", () ->
      $state.go "root.home"
  ])
