angular.module "uTunes"
  .directive 'sidebarRight', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/sidebarRight/sidebar-right.html'
      controller: [ "$scope", "$element", "$timeout", "$mdSidenav", "$auth", "$state",
        ($scope, $element, $timeout, $mdSidenav, $auth, $state) ->
          $scope.user = $scope.$root.user
          $scope.login = "app/components/userSessions/views/new.html"
          $scope.signup = "app/components/users/views/new.html"
          $scope.template = $scope.login
          $scope.close = () ->
            $mdSidenav("right").close()

          $scope.goTo = (e, state, params) ->
            $state.go(state, params, {reload: true})
            $scope.close()

          $scope.switchLogin = () ->
            $scope.template = if ($scope.template == $scope.login) then $scope.signup else $scope.login

          $scope.submitLogin = (loginForm)->
            $auth.submitLogin(loginForm).then((resp)->$scope.close()).catch((resp)->)

          $scope.signOut = () ->
            $auth.signOut().then((resp)->
              $state.go("root.posts.index", {}, {reload: true})
            ).catch((resp)->)

          $scope.handleRegBtnClick = (registrationForm) ->
            console.log "Registration"
            $auth.submitRegistration(registrationForm).then(()->
              $state.go("root.emailnotif", {}, {reload: false})
              $scope.close()
            ).catch((resp)->
              console.log "Registration failed"
            )

            
          $scope.$on("auth:registration-email-error", (ev, reason) ->
            $scope.errors = reason.errors
          )

          $scope.$on("auth:login-error", (ev, reason) ->
            $scope.errors = reason.errors
          )
      ]
