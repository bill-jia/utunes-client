angular.module "uTunes"
  .directive 'producerFields', ["$timeout", ($timeout)->
    directive =
      restrict: 'E'
      scope: {
        registerFormScope: "="
        producer: "="
        edit: "="
      }
      templateUrl: 'app/components/mediaContent/forms/views/producer-fields.html'
      link: (scope) ->
        scope.disabled = false

        $timeout(() ->
          scope.form.fields = ["name", "class_year"]
          scope.registerFormScope(scope.form, scope.$id)
        )
  ]
