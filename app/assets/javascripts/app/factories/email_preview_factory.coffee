'use strict'

EmailPreviewFactory = ($uibModal) ->
  EmailPreview = {}

  urls =
    invite: '/api/v1/admin/email_preview/user_mailer/:user_id/invite.html'

  controller = ($sce, template) ->
    @template = $sce.trustAsHtml(template)
    @

  EmailPreview.invite = (user, welcome_note, additional_information) ->
    params = {}
    params.welcome_note = welcome_note if welcome_note
    params.additional_information = additional_information if additional_information

    $uibModal.open(
      templateUrl: 'templates/modals/admin/email_preview.html'
      controllerAs: 'modal_ctrl'
      controller: ['$sce', 'template', controller]
      resolve:
        template: ['$http', '$q', ($http, $q) ->
          deferred = $q.defer()

          $http
            .get(urls.invite.replace(':user_id', user.id), { params: params })
            .then (response) ->
              deferred.resolve(response.data)

          deferred.promise
        ]
    )

  EmailPreview

angular
  .module('greyhd')
  .factory('EmailPreview', ['$uibModal', EmailPreviewFactory])
