CollectionView = require 'views/base/collection-view'
EntryView = require './entry-view'
Collection = require 'models/base/collection'
Entry = require 'models/entry'

module.exports = class EntryListView extends CollectionView
  autoRender: true
  template: require './templates/entry-list'
  className: 'entry-list'
  itemView: EntryView
  listSelector: '.item-container'

  query: ''
  newEntry: null
  
  listen:
    'search:search mediator': 'updateSearch'
  
  events:
    'submit #search-form': 'submitSearch'
    'click .js-add-entry:not(.toggled)': 'createNewEntry'
    'click .js-add-entry.toggled': 'cancelNewEntry'

  initialize: ->
    super
    @handleKeyboardShortcuts()
  
  getTemplateData: ->
    data = super
    data.query = @query
    return data
    
  disableAllEdits: ->
    item.disableEdit() for own k, item of @getItemViews()
    @cancelNewEntry()

  toggleAddButton: (state) ->
    $btn = @$ '.js-add-entry'
    $txt = $btn.find 'span'
    $ico = $btn.find 'i'
    $btn[(if state is on then 'add' else 'remove') + 'Class'] 'toggled'
    $txt.text $txt.data (if state is on then 'toggle' else 'default') + '-text'
    $ico[(if state is on then 'add' else 'remove') + 'Class'] 'fa-toggle-up'
    $ico[(if state is on then 'remove' else 'add') + 'Class'] 'fa-link'

  createNewEntry: (e) ->
    e?.preventDefault()
    @disableAllEdits()
    @newEntry = new Entry null, path:'entries'
    @toggleAddButton on
    @subview 'new-entry', new EntryView
      container: @$ '.new-entry-container'
      model: @newEntry
      editing: true
    @newEntry.once 'sync', =>
      @toggleAddButton off
      @removeSubview 'new-entry'
      @collection.unshift @newEntry
      @newEntry = null

  initItemView: ->
    view = super
    @listenTo view, 'edit:on', @disableAllEdits
    return view

  cancelNewEntry: ->
    @newEntry?.dispose()
    @newEntry = null
    @toggleAddButton off

  focusSearch: (e) ->
    e?.preventDefault()
    @$('#search').focus()

  submitSearch: (e) ->
    e.preventDefault()
    query = $.trim $(e.target).find('#search').val()
    @publishEvent '!search:search', query

  updateSearch: (data) ->
    @query = data.processed
    @$('#search').val @query

  # Shortcut code overview: http://www.catswhocode.com/blog/using-keyboard-shortcuts-in-javascript
  handleKeyboardShortcuts: ->
    $bar = @$('#search')
    # 27 = ESC
    # 191 = /
    $(document).keydown (e) =>
      @disableAllEdits() if e.which is 27
      @focusSearch(e) if e.which is 191 and $(document).has(':focus').length is 0
      $bar.blur() if ($bar.is ':focus') and e.which is 27
