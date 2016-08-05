'use strict'

angular
  .module('greyhd', [
    'ngResource',
    'templates',
    'ui.router',
    'ui-notification',
    'ng-token-auth',
    'ui.bootstrap',
    'ngProgress',
    'ui.select',
    'color.picker',
    'ngSanitize',
    'ngFileUpload',
    'as.sortable'
  ])
  .config(['$stateProvider', ($stateProvider) ->
    $stateProvider
      .state('auth',
        abstract: true
        template: '<ui-view />'
        resolve:
          user: ['$auth', '$state', '$q', ($auth, $state, $q) ->
            deferred = $q.defer()

            $auth
              .validateUser()
              .then (user) ->
                if user.state == 'invited' then $state.go('onboard.welcome') else $state.go('home')
              .catch () ->
                deferred.resolve()

            deferred.promise
          ]
          company: ['CompanyResource', (CompanyResource) ->
            CompanyResource.current().$promise
          ]
      )
      .state('login',
        url: '/login'
        parent: 'auth'
        controller: 'LoginController'
        controllerAs: 'login_ctrl'
        templateUrl: 'templates/auth/login.html'
      )
      .state('logout',
        url: '/logout'
        controller: ['$auth', ($auth) ->
          $auth.signOut()
        ]
      )
      .state('root',
        url: '/'
        controller: ['$rootScope', '$state', ($rootScope, $state) ->
          if Object.keys($rootScope.user).length == 0
            $state.go('login')
          else if $rootScope.user.state == 'invited'
            $state.go('onboard.welcome')
          else
            $state.go('home')
        ]
      )
      .state('onboard',
        abstract: true
        templateUrl: 'templates/layouts/onboard.html'
        controller: 'OnboardController'
        controllerAs: 'onboard_ctrl'
        resolve:
          user: ['$auth', '$state', '$q', ($auth, $state, $q) ->
            deferred = $q.defer()

            $auth
              .validateUser()
              .then (user) ->
                deferred.resolve(user)
              .catch () ->
                $state.go('login')

            deferred.promise
          ]
          company: ['CompanyResource', (CompanyResource) ->
            CompanyResource.current().$promise
          ]
      )
      .state('onboard.welcome',
        url: '/welcome'
        templateUrl: 'templates/onboard/welcome.html'
        parent: 'onboard'
      )
      .state('onboard.our_story',
        url: '/ourstory'
        templateUrl: 'templates/onboard/our_story.html'
        parent: 'onboard'
      )
      .state('board',
        abstract: true
        templateUrl: 'templates/layouts/board.html'
        controller: 'BoardController'
        controllerAs: 'board_ctrl'
        resolve:
          user: ['$auth', '$state', '$q', ($auth, $state, $q) ->
            deferred = $q.defer()

            $auth
              .validateUser()
              .then (user) ->
                if user.state == 'invited'
                  $state.go('onboard.welcome')
                deferred.resolve(user)
              .catch () ->
                $state.go('login')

            deferred.promise
          ]
          company: ['CompanyResource', (CompanyResource) ->
            CompanyResource.current().$promise
          ]
      )
      .state('home',
        url: '/home'
        parent: 'board'
        templateUrl: 'templates/board/home.html'
      )
      .state('invite',
        url: '/invite/:token'
        controller: ['InvitesResource', '$state', '$stateParams', '$rootScope', '$auth', (InvitesResource, $state, $stateParams, $rootScope, $auth) ->
          InvitesResource.accept({token: $stateParams.token},
            (user, headers) ->
              newHeaders = {}
              for key, val of $auth.getConfig().tokenFormat
                if headers(key)
                  newHeaders[key] = headers(key)
              $auth.deleteData('auth_headers')
              $auth.setAuthHeaders(newHeaders)
              $state.go('onboard.welcome')
            ,
            () ->
              $auth.deleteData('auth_headers')
              $state.go('login')
          )
          @
        ]
      )
      .state('admin',
        abstract: true
        url: '/admin'
        parent: 'board'
        templateUrl: 'templates/layouts/admin.html'
      )
      .state('admin.dashboard',
        url: '/dashboard'
        templateUrl: 'templates/admin/dashboard.html'
      )
      .state('admin.people',
        url: '/people'
        abstract: true
        template: '<ui-view />'
      )
      .state('admin.people.manage',
        url: '/manage'
        templateUrl: 'templates/admin/people/manage.html'
        controller: 'AdminPeopleManageController'
        controllerAs: 'manage_ctrl'
        resolve:
          users: ['AdminUserResource', (AdminUserResource) ->
            AdminUserResource.query().$promise
          ]
          teams: ['AdminTeamResource', (AdminTeamResource) ->
            AdminTeamResource.query().$promise
          ]
          locations: ['AdminLocationResource', (AdminLocationResource) ->
            AdminLocationResource.query().$promise
          ]
      )
      .state('admin.people.onboardNew',
        url: '/onboard'
        templateUrl: 'templates/admin/onboard/base.html'
        controller: 'AdminOnboardController'
        controllerAs: 'onboard_ctrl'
        resolve:
          user: ['AdminUserResource', '$q', (AdminUserResource, $q) ->
            $q.when(new AdminUserResource)
          ]
          teams: ['AdminTeamResource', (AdminTeamResource) ->
            AdminTeamResource.query().$promise
          ]
          locations: ['AdminLocationResource', (AdminLocationResource) ->
            AdminLocationResource.query().$promise
          ]
          managers: ['AdminUserResource', (AdminUserResource) ->
            AdminUserResource.query(registered: true).$promise
          ]
      )
      .state('admin.people.onboardEdit',
        url: '/onboard/:id'
        templateUrl: 'templates/admin/onboard/base.html'
        controller: 'AdminOnboardController'
        controllerAs: 'onboard_ctrl'
        resolve:
          user: ['AdminUserResource', '$stateParams', (AdminUserResource, $stateParams) ->
            AdminUserResource.get(id: $stateParams.id).$promise
          ]
          teams: ['AdminTeamResource', (AdminTeamResource) ->
            AdminTeamResource.query().$promise
          ]
          locations: ['AdminLocationResource', (AdminLocationResource) ->
            AdminLocationResource.query().$promise
          ]
          managers: ['AdminUserResource', (AdminUserResource) ->
            AdminUserResource.query(registered: true).$promise
          ]
      )
      .state('admin.company',
        url: '/company'
        abstract: true
        template: '<ui-view />'
      )
      .state('admin.company.general',
        url: '/general'
        templateUrl: 'templates/admin/company/general.html'
        controller: 'AdminCompanyController'
        controllerAs: 'company_ctrl'
        resolve:
          company: ['AdminCompanyResource', (AdminCompanyResource) ->
            AdminCompanyResource.current().$promise
          ]
      )
      .state('admin.company.teams',
        url: '/teams'
        templateUrl: 'templates/admin/company/teams.html'
        controller: 'AdminCompanyTeamsController'
        controllerAs: 'teams_ctrl'
        resolve:
          teams: ['AdminTeamResource', (AdminTeamResource) ->
            AdminTeamResource.query().$promise
          ]
      )
      .state('admin.company.locations',
        url: '/locations'
        templateUrl: 'templates/admin/company/locations.html'
        controller: 'AdminCompanyLocationsController'
        controllerAs: 'locations_ctrl'
        resolve:
          locations: ['AdminLocationResource', (AdminLocationResource) ->
            AdminLocationResource.query().$promise
          ]
      )
      .state('admin.company.tasks',
        url: '/tasks'
        templateUrl: 'templates/admin/company/tasks.html'
        controller: 'AdminCompanyTasksController'
        controllerAs: 'tasks_ctrl'
        resolve:
          workstreams: ['AdminWorkstreamResource', (AdminWorkstreamResource) ->
            AdminWorkstreamResource.query().$promise
          ]
      )
  ])
  .config(['$urlRouterProvider', ($urlRouterProvider) ->
    $urlRouterProvider.otherwise('/')
  ])
  .config(['NotificationProvider', (NotificationProvider) ->
    NotificationProvider.setOptions(
      delay: 5000
    )
  ])
  .config(['$authProvider', ($authProvider) ->
    $authProvider.configure(
      apiUrl: '/api/v1'
      handleLoginResponse: (response) -> response
      handleTokenValidationResponse: (response) -> response
    )
  ])
  .config(['$httpProvider', ($httpProvider) ->
    $httpProvider.interceptors.push('ProgressBarInterceptor', 'ErrorHandlerInterceptor')
  ])
  .config(['$resourceProvider', ($resourceProvider) ->
    $resourceProvider.defaults.actions =
      get:
        method: 'GET'
      update:
        method: 'PUT'
      save:
        method: 'POST'
      query:
        method: 'GET'
        isArray: true
      remove:
        method: 'DELETE'
      delete:
        method: 'DELETE'
  ])
  .run(['$templateCache', ($templateCache) ->
    $templateCache.put 'template/color-picker/directive.html',
    '<div class="color-picker-wrapper" ng-class="{\'color-picker-swatch-only\': config.swatchOnly}">\n' +
    '   <div class="color-picker-panel" ng-show="visible" ng-class="{\n' +
    '       \'color-picker-panel-top color-picker-panel-right\': config.pos === \'top right\',\n' +
    '       \'color-picker-panel-top color-picker-panel-left\': config.pos === \'top left\',\n' +
    '       \'color-picker-panel-bottom color-picker-panel-right\': config.pos === \'bottom right\',\n' +
    '       \'color-picker-panel-bottom color-picker-panel-left\': config.pos === \'bottom left\',\n' +
    '       \'color-picker-show-alpha\': config.alpha && config.format !== \'hex\',\n' +
    '       \'color-picker-show-inline\': config.inline,\n' + '   }">\n' +
    '       <div class="color-picker-row">\n' +
    '           <div class="color-picker-grid color-picker-sprite">\n' +
    '               <div class="color-picker-grid-inner"></div>\n' +
    '               <div class="color-picker-picker">\n' +
    '                   <div></div>\n' +
    '               </div>\n' +
    '           </div>\n' +
    '           <div class="color-picker-hue color-picker-sprite">\n' +
    '               <div class="color-picker-slider"></div>\n' +
    '           </div>\n' +
    '           <div class="color-picker-opacity color-picker-sprite" ng-show="config.alpha && config.format !== \'hex\'">\n' +
    '               <div class="color-picker-slider"></div>\n' +
    '           </div>\n' +
    '       </div>\n' +
    '   </div>\n' +
    '   <div class="color-picker-input-wrapper" ng-class="{\'input-group\': config.swatchBootstrap && config.swatch}">\n' +
    '       <input class="color-picker-input admin-input__input form-control min-10" type="text" ng-model="ngModel" ng-readonly="config.swatchOnly" ng-disabled="config.disabled" ng-blur="onBlur()" ng-change="onChange($event)" size="7" ng-focus="show()" ng-class="{\'color-picker-input-swatch\': config.swatch && !config.swatchOnly && config.swatchPos === \'left\'}">\n' +
    '       <span ng-if="config.swatchPos === \'left\'" class="color-picker-swatch admin-input__picker-color" ng-click="focus()" ng-show="config.swatch" ng-class="{\'color-picker-swatch-left\': config.swatchPos !== \'right\', \'color-picker-swatch-right\': config.swatchPos === \'right\', \'input-group-addon\': config.swatchBootstrap}"></span>\n' +
    '   </div>\n' +
    '</div>'
    return
  ])
