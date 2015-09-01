angular.module "uTunes"
  .directive 'sidebar', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/sidebar/sidebar.html'
      link: (scope, element) ->
        scope.$on "trackplaying", (e, track) ->
          scope.track = track

        scrollBoxes = element.find(".scroll-box")

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
