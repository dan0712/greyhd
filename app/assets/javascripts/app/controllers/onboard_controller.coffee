'use strict'

class OnboardController
  constructor: ($rootScope, $scope, $state, company, $filter, $anchorScroll, $sce) ->
    @steps = [
      'onboard.welcome'
      'onboard.our_story'
      'onboard.our_team'
      'onboard.about_you'
      'onboard.road_map'
      'onboard.wrap_up'
    ]
    @current_user = $rootScope.user
    @company = company
    @current_step = localStorage['onboarding_step'] || 0
    @current_last_step = localStorage['onboarding_last_step'] || 0
    @onboarding_started = @steps.indexOf($state.current.name) != 0 && @current_last_step != 0
    @animations = {}
    @company_video = $sce.trustAsHtml(@company.company_video)

    @welcome_page_template_url = () =>
      if @onboarding_started
        'templates/onboard/agenda.html'
      else
        'templates/onboard/landing.html'

    @formatDate = (date) ->
      $filter('date')(date, 'MMMM yyyy')

    @animatePulseButton = (index) =>
      @animations[index] = true

    ensureCompleteStep = (state) =>
      @current_step = @steps.indexOf(state.name)
      if @steps.indexOf(state.name) > @current_last_step
        $state.go(@steps[@current_last_step])

    ensureCompleteStep($state.current)

    $scope.$on '$stateChangeStart', (event, state) =>
      ensureCompleteStep(state)

    setCurrentStep = (index) =>
      @current_step = index
      @onboarding_started = true
      localStorage['onboarding_step'] = @current_step
      $anchorScroll()

    setCurrentLastStep = (index) =>
      @current_last_step = index
      localStorage['onboarding_last_step'] = index

    @nextStep = (index) =>
      setCurrentLastStep(index) if index > @current_step
      setCurrentStep(index)
      $state.go(@steps[index])

    @isStepDisabled = (index) =>
      @current_step < index

    @isStepComplete = (index) =>
      if $state.current.name == @steps[@current_last_step]
        @current_last_step > index
      else
        @current_last_step >= index

    @isStepActive = (index) =>
      @current_step == index

angular
  .module('greyhd')
  .controller('OnboardController', ['$rootScope', '$scope', '$state', 'company', '$filter', '$anchorScroll', '$sce', OnboardController])
