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
  .config ($mdThemingProvider) ->
    $mdThemingProvider.theme('default')
      .primaryPalette("indigo", {"default":"600", "hue-1":"300", "hue-2":"900"})
      .backgroundPalette("grey")
      .accentPalette("blue", {"default":"A700", "hue-1":"A400"})
      .warnPalette("pink")
