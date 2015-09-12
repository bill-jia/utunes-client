angular.module "uTunes"
  .directive 'sidebarRight', ->
    directive =
      restrict: 'E'
      scope: {}
      templateUrl: 'app/components/sidebarRight/sidebar-right.html'
      controller: ($scope, $element, $timeout, $mdSidenav, $auth) ->
        $scope.user = $scope.$root.user
        $scope.login = "app/components/userSessions/views/new.html"
        $scope.signup = "app/components/users/views/new.html"
        $scope.template = $scope.login
        $scope.close = () ->
          $mdSidenav("right").close()

        $scope.switchLogin = () ->
          $scope.template = if ($scope.template == $scope.login) then $scope.signup else $scope.login

        $scope.submitLogin = (loginForm)->
          $auth.submitLogin(loginForm).then((resp)->).catch((resp)->)

        $scope.signOut = () ->
          $auth.signOut().then((resp)->).catch((resp)->)

        $scope.handleRegBtnClick = () ->
          console.log "Registration"
          $auth.submitRegistration($scope.registrationForm).then(()->
            $auth.submitLogin({
              email: $scope.registrationForm.email,
              password: $scope.registrationForm.password
            })
          )

        $scope.$on("auth:login-error", (ev, reason) ->
          $scope.errors = reason.errors
        )
