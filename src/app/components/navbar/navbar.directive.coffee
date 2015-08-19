angular.module "uTunes"
  .directive 'navbar', ->

    NavbarController = (moment) ->
      vm = this
      # "vm.creation" is avaible by directive option "bindToController: true"
      return

    directive =
      restrict: 'E'
      templateUrl: 'app/components/navbar/navbar.html'
      controller: NavbarController
      controllerAs: 'vm'
      bindToController: true
