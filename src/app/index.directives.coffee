app = angular.module 'uTunes'

app.directive 'stopEvent', () ->
  directive =
    restrict: 'A'
    link: (scope, element, attr) ->
      if attr and attr.stopEvent
        element.bind attr.stopEvent, (e) ->
          e.stopPropagation()

app.directive 'ngRightClick', ($parse) ->
  (scope, element, attrs) ->
    fn = $parse(attrs.ngRightClick)
    element.bind 'contextmenu', (event) ->
      scope.$apply ->
        event.preventDefault()
        fn scope, $event: event
        return
      return
    return

app.directive 'mdContextMenu', [
  '$parse'
  ($parse) ->

    renderContextMenu = ($scope, event, options, model) ->
      if !$
        $ = angular.element
      $(event.currentTarget).addClass 'context'
      $contextMenu = $('<div>')
      $contextMenu.addClass 'dropdown clearfix'
      $ul = $('<ul>')
      $ul.addClass 'md-whiteframe-z3'
      $ul.attr 'role': 'menu'
      $ul.css
        display: 'block'
        position: 'absolute'
        left: event.pageX + 'px'
        top: event.pageY + 'px'
        zIndex: 100
        opacity: 0.99
        backgroundColor : "white"
      angular.forEach options, (item, i) ->
        $li = $('<li>')
        if item == null
          $li.addClass 'divider'
        else
          $a = $('<a>')
          $a.attr
            tabindex: '-1'
            href: '#'
          text = if typeof item[0] == 'string' then item[0] else item[0].call($scope, $scope, event, model)
          $a.text text
          $li.append $a
          enabled = if angular.isDefined(item[2]) then item[2].call($scope, $scope, event, text, model) else true
          if enabled
            $li.on 'click', ($event) ->
              $event.preventDefault()
              $scope.$apply ->
                $(event.currentTarget).removeClass 'context'
                $contextMenu.remove()
                item[1].call $scope, $scope, event, model
                return
              return
          else
            $li.on 'click', ($event) ->
              $event.preventDefault()
              return
            $li.addClass 'disabled'
        $ul.append $li
        return
      $contextMenu.append $ul
      height = Math.max(document.body.scrollHeight,
        document.documentElement.scrollHeight,
        document.body.offsetHeight,
        document.documentElement.offsetHeight,
        document.body.clientHeight,
        document.documentElement.clientHeight)
      $contextMenu.css
        width: '100%'
        height: height + 'px'
        position: 'absolute'
        top: 0
        left: 0
        zIndex: 100
        opacity: 0.99
      $(document).find('body').append $contextMenu
      $contextMenu.on('mousedown', (e) ->
        if $(e.target).hasClass('dropdown')
          $(event.currentTarget).removeClass 'context'
          $contextMenu.remove()
        return
      ).on 'contextmenu', (event) ->
        $(event.currentTarget).removeClass 'context'
        event.preventDefault()
        $contextMenu.remove()
        return
      return

    ($scope, element, attrs) ->
      element.on 'contextmenu', (event) ->
        event.stopPropagation()
        $scope.$apply ->
          event.preventDefault()
          options = $scope.$eval(attrs.mdContextMenu)
          model = $scope.$eval(attrs.model)
          if options instanceof Array
            if options.length == 0
              return
            renderContextMenu $scope, event, options, model
          else
            throw new Error(['"' + attrs.mdContextMenu + '" not an array'])
          return
        return
      return
]

app.directive "integer", () ->
  require: "ngModel"
  restrict: "A"
  link: (scope, element, attrs, ctrl) ->
    console.log "Integer validation"
    INTEGER_REGEXP = /^\-?\d+$/
    ctrl.$validators.integer = (modelValue, viewValue) ->
      if ctrl.$isEmpty(modelValue)
        return true
      if INTEGER_REGEXP.test(viewValue)
        return true
      return false
