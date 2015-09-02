angular.module "uTunes"
  .directive 'artistFields', ["$timeout", ($timeout)->
    directive =
      restrict: 'E'
      scope: {
        registerFormScope: "="
        artist: "="
        edit: "="
      }
      templateUrl: 'app/components/mediaContent/forms/views/artist-fields.html'
      link: (scope) ->
        scope.disabled = false

        $timeout(() ->
          scope.form.fields = ["name", "class_year"]
          scope.registerFormScope(scope.form, scope.$id)
        )
  ]
