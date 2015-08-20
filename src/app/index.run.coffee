angular.module "uTunes"
  .run ($log, Restangular) ->
    console.log 'uTunes running'
    $log.debug 'runBlock end'
