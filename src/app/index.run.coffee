angular.module "uTunes"
  .run(["$log", "$rootScope", "$state", ($log, $rootScope, $state) ->
    $log.debug 'runBlock end'
    $rootScope.$on "auth:login-success", () ->
      $state.go "root.home"
  ])
