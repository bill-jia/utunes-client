angular.module "uTunes"
  .directive 'sidebarRight', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/sidebarRight/sidebar-right.html'
      controller: ($scope, $element, $timeout, $mdSidenav, $auth, $state) ->
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
          $auth.signOut().then((resp)->).catch((resp)->)

        $scope.handleRegBtnClick = (registrationForm) ->
          console.log "Registration"
          $auth.submitRegistration(registrationForm).then(()->
            $auth.submitLogin({
              email: registrationForm.email,
              password: registrationForm.password
            })
          )

        $scope.$on("auth:login-error", (ev, reason) ->
          $scope.errors = reason.errors
        )
