angular.module "uTunes"
  .directive 'acmeYeomanNavbar', ->

    YeomanNavbarController = (moment) ->
      vm = this
      # "vm.creation" is avaible by directive option "bindToController: true"
      vm.relativeDate = moment(vm.creationDate).fromNow()
      return

    directive =
      restrict: 'E'
      templateUrl: 'app/components/yeomannavbar/yeomannavbar.html'
      scope: creationDate: '='
      controller: YeomanNavbarController
      controllerAs: 'vm'
      bindToController: true
