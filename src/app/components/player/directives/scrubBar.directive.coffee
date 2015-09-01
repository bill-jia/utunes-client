angular.module "uTunes"
  .directive "scrubBar", ["$document", ($document) ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/scrub-bar.html'
      link: (scope, element, attrs, playerController) ->
        currentTimeline = element.find(".timeline-current")
        totalTime = element.find(".timeline")
        playhead = element.find("#playhead")
        halfPlayheadSize =  parseInt(playhead.css("font-size"), 10)/2

        setPosition = (position) ->
          scope.$apply(playerController.setPosition(position))

        totalTime.bind "click", (e) ->
          currentTimeline.css({
            width: e.pageX - currentTimeline.offset().left
          })
          playhead.css({
            left: e.pageX - currentTimeline.offset().left - halfPlayheadSize
          })
          setPosition(currentTimeline.width()/totalTime.width())


        playhead.bind "mousedown", (e) ->
          playhead.addClass "active"
          $document.on 'mousemove', mousemove
          $document.on 'mouseup', mouseup

        $document.bind "mouseup", (e) ->
          playhead.removeClass "active"

        mouseup = () ->
          $document.off "mousemove", mousemove
          $document.off "mouseup", mouseup

        mousemove = (e) ->
          currentTimeline.css({
            width: Math.min(e.pageX - currentTimeline.offset().left, totalTime.width())
          })
          playhead.css({
            left: Math.max(
              Math.min(e.pageX - currentTimeline.offset().left - halfPlayheadSize, totalTime.width() - halfPlayheadSize), -halfPlayheadSize
            )
          })
          setPosition(currentTimeline.width()/totalTime.width())

        scope.$watch(
          (scope) -> scope.currentTime,
          (newValue) ->
            # console.log newValue
            currentTimeline.css({
              width: (newValue/scope.audio.duration)*totalTime.width()
            })
            playhead.css({
              left: (newValue/scope.audio.duration)*totalTime.width() - halfPlayheadSize
            })
        )
  ]
