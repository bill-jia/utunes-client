angular.module "uTunes"
  .config ($logProvider, toastr) ->
    # Enable log
    $logProvider.debugEnabled true
    # Set options third-party lib
    toastr.options.timeOut = 3000
    toastr.options.positionClass = 'toast-top-right'
    toastr.options.preventDuplicates = true
    toastr.options.progressBar = true
  .config (RestangularProvider) ->
    RestangularProvider.setBaseUrl("/api")
    RestangularProvider.addRequestInterceptor((elem, operation, what, url) ->
        console.log "Request intercepted"
        if (operation == "put" || operation == "POST")
          console.log "Put/Post"
          album: elem
        else
          console.log "Other stuff"
          elem
      )
