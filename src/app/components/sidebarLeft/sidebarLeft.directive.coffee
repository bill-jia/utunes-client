angular.module "uTunes"
  .directive 'sidebarLeft', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/sidebarLeft/sidebar-left.html'
      controller: ($scope, $element, $timeout, $mdSidenav, $state) ->
        $scope.state = $state.current.name
        $scope.$on "trackplaying", (e, track) ->
          $scope.track = track

        $scope.close = () ->
          $mdSidenav("left").close()

        $scope.goTo = (e, state) ->
          $state.go(state, {}, {reload: false})
          $scope.close()

        scrollBoxes = $element.find(".scroll-box")

        scrollBoxes.mouseenter(->
          $(this).stop()
          boxWidth = $(this).width()
          textWidth = $('.scroll-text', $(this)).width()
          if textWidth > boxWidth
            animSpeed = textWidth * 10
            $(this).animate { scrollLeft: textWidth - boxWidth }, animSpeed, ->
              $(this).animate { scrollLeft: 0 }, animSpeed, ->
                $(this).trigger 'mouseenter'
                return
              return
          return
        ).mouseleave ->
          animSpeed = $(this).scrollLeft() * 10
          $(this).stop().animate { scrollLeft: 0 }, animSpeed
          return
