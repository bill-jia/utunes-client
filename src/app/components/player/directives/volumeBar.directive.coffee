angular.module "uTunes"
  .directive 'volumeBar', ["$document", ($document) ->
    directive =
      require: "^audioPlayer"
      restrict: 'E'
      templateUrl: 'app/components/player/views/volume-bar.html'
      link: (scope, element, attrs, playerController) ->
        icon = element.find("#volume-controls")
        volumeBar = element.find("#volume-bar")
        currentVolumeBar = element.find(".volume-current")
        volumeHead = element.find("#volumehead")
        halfVolumeheadSize = parseInt(volumeHead.css("font-size"), 10)/2

        icon.on "mouseover", (e) ->
          icon.addClass "active"
        icon.on "mouseleave", (e) ->
          icon.removeClass "active"

        icon.on "click", (e) ->
          scope.$apply(playerController.changeMuteState())

        setVolume = (volume) ->
          scope.$apply(playerController.setVolume(volume))
          # console.log "Control volume" + scope.volume

        volumeBar.on "click", (e) ->
          currentVolumeBar.css({
            width: e.pageX - currentVolumeBar.offset().left
          })
          volumeHead.css({
            left: e.pageX - currentVolumeBar.offset().left - halfVolumeheadSize
          })
          setVolume(currentVolumeBar.width()/volumeBar.width())

        volumeHead.on "mousedown", (e) ->
          volumeHead.addClass "active"
          $document.on 'mousemove', mousemove
          $document.on 'mouseup', mouseup

        $document.on "mouseup", (e) ->
          volumeHead.removeClass "active"

        mouseup = () ->
          $document.off "mousemove", mousemove
          $document.off "mouseup", mouseup

        mousemove = (e) ->
          currentVolumeBar.css({
            width: Math.min(e.pageX - currentVolumeBar.offset().left, volumeBar.width())
          })
          volumeHead.css({
            left: Math.max(
              Math.min(e.pageX - currentVolumeBar.offset().left - halfVolumeheadSize, volumeBar.width() - halfVolumeheadSize), -halfVolumeheadSize
            )
          })
          setVolume(currentVolumeBar.width()/volumeBar.width())
  ]
