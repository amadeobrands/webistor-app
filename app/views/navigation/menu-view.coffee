PanelView = require './base/panel-view'

module.exports = class MenuView extends PanelView
  
  className: 'menu'
  template: require './templates/menu'
  
  listSelector: '.hob-nav'
  
  listen:
    'panel:open:menu mediator': 'show'
  
  showPermanent: ->
    @hide()
    @region = 'permanentPanel'
    @unsubscribeEvent 'panel:open:menu', @show
    @unsubscribeEvent 'panel:close', @hide
    @show()