angular.module "uTunes"
  .directive 'sidebar', ->

    SidebarController = (moment) ->
      vm = this
      # "vm.creation" is avaible by directive option "bindToController: true"
      return

    directive =
      restrict: 'E'
      templateUrl: 'app/components/sidebar/sidebar.html'
      controller: SidebarController
      controllerAs: 'vm'
      bindToController: true
