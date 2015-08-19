angular.module "uTunes"
  .directive 'audioPlayer', ->

    PlayerController = (moment) ->
      vm = this
      # "vm.creation" is avaible by directive option "bindToController: true"
      return

    directive =
      restrict: 'E'
      templateUrl: 'app/components/player/player.html'
      controller: PlayerController
      controllerAs: 'vm'
      bindToController: true
