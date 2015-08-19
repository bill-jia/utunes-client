angular.module "uTunes"
  .directive 'searchbar', ->

    SearchController = (moment) ->
      vm = this
      # "vm.creation" is avaible by directive option "bindToController: true"
      return

    directive =
      restrict: 'E'
      templateUrl: 'app/components/searchbar/searchbar.html'
      controller: SearchController
      controllerAs: 'vm'
      bindToController: true
