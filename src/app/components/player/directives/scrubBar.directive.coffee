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

        totalTime.on "click", (e) ->
          currentTimeline.css({
            width: e.pageX - currentTimeline.offset().left
          })
          playhead.css({
            left: e.pageX - currentTimeline.offset().left - halfPlayheadSize
          })

        playhead.on "mousedown", (e) ->
          playhead.addClass "active"
          $document.on 'mousemove', mousemove
          $document.on 'mouseup', mouseup

        $document.on "mouseup", (e) ->
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
  ]
