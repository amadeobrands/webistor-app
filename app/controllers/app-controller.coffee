utils = require 'lib/utils'

PageController = require 'controllers/base/page-controller'
HistoryPageView = require 'views/history/history-page-view'
RequireLogin = require 'lib/require-login'
AppView = require 'views/app-view'
MenuView = require 'views/menu-view'

module.exports = class AppController extends PageController
  
  beforeAction: ->
    super
    @reuse 'login', RequireLogin
    @reuse 'app', AppView
    @reuse 'menu', MenuView
  
  history: (params, route) ->
    @view = new HistoryPageView
  
  search: (params, route) ->
    query = decodeURIComponent params.query
    document.title = '/q/'+query#TODO: Reset document title after search field is cleared again.
    @view = new HistoryPageView search: query
    @publishEvent 'q', query
  
  add: (params, route) ->
    Entry = require 'models/entry'
    MessageView = require 'views/message-view'
    EntryView = require 'views/history/entry-view'
    
    @view?.dispose()
    entry = new Entry Chaplin.utils.queryParams.parse route.query
    @view = new EntryView {model: entry, editing:true, focus: 'tags', region: 'main'}
    
    @view.once 'editOff', =>
      entry.dispose()
      @view = new MessageView {region: 'main', message: 'Added a new entry. :)'}
