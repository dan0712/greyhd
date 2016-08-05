app = angular.module('stubsApp', ['ngAnimate', 'ui.bootstrap', 'ngSanitize',
                                  'ui.select', 'color.picker'])


app.run [
  '$templateCache'
  ($templateCache) ->
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
]

app.filter 'propsFilter', ->
  (items, props) ->
    out = []
    if angular.isArray(items)
      keys = Object.keys(props)
      items.forEach (item) ->
        itemMatches = false
        i = 0
        while i < keys.length
          prop = keys[i]
          text = props[prop].toLowerCase()
          if item[prop].toString().toLowerCase().indexOf(text) != -1
            itemMatches = true
            break
          i++
        if itemMatches
          out.push item
        return
    else
      out = items
    out

app.controller 'SelectCtrl', ($scope, $http, $timeout, $interval) ->
  vm = this
  vm.disabled = undefined
  vm.searchEnabled = undefined

  vm.setInputFocus = ->
    $scope.$broadcast 'UiSelectDemo1'
    return

  vm.enable = ->
    vm.disabled = false
    return

  vm.disable = ->
    vm.disabled = true
    return

  vm.enableSearch = ->
    vm.searchEnabled = true
    return

  vm.disableSearch = ->
    vm.searchEnabled = false
    return

  vm.clear = ->
    vm.person.selected = undefined
    vm.address.selected = undefined
    vm.country.selected = undefined
    return

  vm.someGroupFn = (item) ->
    if item.name[0] >= 'A' and item.name[0] <= 'M'
      return 'From A - M'
    if item.name[0] >= 'N' and item.name[0] <= 'Z'
      return 'From N - Z'
    return

  vm.firstLetterGroupFn = (item) ->
    item.name[0]

  vm.reverseOrderFilterFn = (groups) ->
    groups.reverse()

  vm.onSelectCallback = (item, model) ->
    vm.counter++
    vm.eventResult =
      item: item
      model: model
    return

  vm.removed = (item, model) ->
    vm.lastRemoved =
      item: item
      model: model
    return

  vm.tagTransform = (newTag) ->
    item =
      name: newTag
      email: newTag.toLowerCase() + '@email.com'
      age: 'unknown'
      country: 'unknown'
    item

  vm.country = {}
  vm.countries = [
    {
      name: 'Afghanistan'
      code: 'AF'
    }
    {
      name: 'Loooooooooooooonnnnnnnnnnnnnnnnnnnnnnnggggggggg'
      code: 'AX'
    }
    {
      name: 'Albania'
      code: 'AL'
    }
    {
      name: 'Algeria'
      code: 'DZ'
    }
    {
      name: 'American Samoa'
      code: 'AS'
    }
    {
      name: 'Andorra'
      code: 'AD'
    }
  ]
  $scope.itemArray = [
    {
      id: 1
      name: 'first'
    }
    {
      id: 2
      name: 'second'
    }
    {
      id: 3
      name: 'third'
    }
    {
      id: 4
      name: 'fourth'
    }
    {
      id: 5
      name: 'fifth'
    }
  ]
  $scope.selectedItem = $scope.itemArray[0]
  return


app.controller 'dateCtrl', ($scope) ->
  disabled = (data) ->
    date = data.date
    mode = data.mode
    mode == 'day' and (date.getDay() == 0 or date.getDay() == 6)

  getDayClass = (data) ->
    date = data.date
    mode = data.mode
    if mode == 'day'
      dayToCheck = new Date(date).setHours(0, 0, 0, 0)
      i = 0
      while i < $scope.events.length
        currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0)
        if dayToCheck == currentDay
          return $scope.events[i].status
        i++
    ''

  $scope.today = ->
    $scope.dt = new Date

  $scope.today()

  $scope.clear = ->
    $scope.dt = null

  $scope.inlineOptions =
    customClass: getDayClass
    minDate: new Date
    showWeeks: true
  $scope.dateOptions =
    dateDisabled: disabled
    formatYear: 'yy'
    maxDate: new Date(2020, 5, 22)
    minDate: new Date
    startingDay: 1
    showWeeks: false

  $scope.toggleMin = ->
    $scope.inlineOptions.minDate = if $scope.inlineOptions.minDate then null else new Date
    $scope.dateOptions.minDate = $scope.inlineOptions.minDate

  $scope.toggleMin()

  $scope.open1 = ->
    $scope.popup1.opened = true

  $scope.setDate = (year, month, day) ->
    $scope.dt = new Date(year, month, day)

  $scope.formats = [
    'dd-MMMM-yyyy'
    'yyyy/MM/dd'
    'dd.MM.yyyy'
    'shortDate'
  ]
  $scope.format = $scope.formats[0]
  $scope.altInputFormats = [ 'M!/d!/yyyy' ]
  $scope.popup1 = opened: false
  $scope.popup2 = opened: false
  tomorrow = new Date
  tomorrow.setDate tomorrow.getDate() + 1
  afterTomorrow = new Date
  afterTomorrow.setDate tomorrow.getDate() + 1
  $scope.events = [
    {
      date: tomorrow
      status: 'full'
    }
    {
      date: afterTomorrow
      status: 'partially'
    }
  ]

app.controller 'TabsCtrl', ($scope, $window) ->
  $scope.model = name: 'Tabs'
  return

app.controller 'AccordionCtrl', ($scope) ->
  $scope.oneAtATime = true
  $scope.groups = [
    {
      title: 'Dynamic Group Header - 1'
      content: 'Dynamic Group Body - 1'
    }
    {
      title: 'Dynamic Group Header - 2'
      content: 'Dynamic Group Body - 2'
    }
  ]
  $scope.items = [
    'Item 1'
    'Item 2'
    'Item 3'
  ]

  $scope.addItem = ->
    newItemNo = $scope.items.length + 1
    $scope.items.push 'Item ' + newItemNo
    return

  $scope.status =
    isCustomHeaderOpen: false
    isFirstOpen: true
    isFirstDisabled: false
  return

app.controller 'ModalCtrl', ($scope, $uibModal, $log) ->
  $scope.items = [
    'item1'
    'item2'
    'item3'
  ]
  $scope.animationsEnabled = true

  $scope.open = (size) ->
    modalInstance = $uibModal.open(
      animation: $scope.animationsEnabled
      templateUrl: 'myModalContent.html'
      controller: 'ModalInstanceCtrl'
      size: size
      resolve: items: ->
        $scope.items
    )
    modalInstance.result.then ((selectedItem) ->
      $scope.selected = selectedItem
      return
    ), ->
      $log.info 'Modal dismissed at: ' + new Date
      return
    return

  $scope.toggleAnimation = ->
    $scope.animationsEnabled = !$scope.animationsEnabled
    return

  return

app.controller 'ModalInstanceCtrl', ($scope, $uibModalInstance, items) ->
  $scope.items = items
  $scope.selected = item: $scope.items[0]

  $scope.ok = ->
    $uibModalInstance.close $scope.selected.item
    return

  $scope.cancel = ->
    $uibModalInstance.dismiss 'cancel'
    return

  return
