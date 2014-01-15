PageView = require 'views/base/page-view'
Entry = require 'models/entry'
EntryView = require './entry-view'
EntryListView = require './entry-list-view'
TagListView = require './tag-list-view'

module.exports = class HistoryPageView extends PageView
  autoRender: true
  className: 'history-page'
  template: require './templates/history'
  
  events:
    'submit #search-form': 'doSearch'
    'click .js-add-entry': 'toggleAdd'
  
  render: ->

    super

    addEntry = new EntryView {container: this.el, model:new Entry, editing:true};
    entryList = new EntryListView {container: this.el};
    addEntry.listView = entryList;
    tagList = new TagListView {container: '#right'};#TODO
    
    @subview 'add-entry', addEntry
    @subview 'entry-list', entryList
    @subview 'tag-list', tagList

    # Handle keyboard shortcuts.
    @handleKeyboardShortcuts()

  edit: (id) ->
    entry = new Entry
    @subview('add-entry').model = entry
    entry.set 'id', id
    entry.fetch().then @subview('add-entry').render
    @subview('add-entry').$el.show()
  
  toggleAdd: (e, data) ->
    
    e?.preventDefault()

    @subview('add-entry').$el.toggle()#TODO Append class to .edit-entry-form wrapper div.
    @subview('add-entry').$el.find('input:eq(0)').focus()

    # Toggle button text
    
    btn = $('.js-add-entry')
    txt = btn.find('span');
    ico = btn.find('i');

    if( $(@subview('add-entry').$el).is(':visible') )
      txt.text(txt.data('toggle-text'));
      ico.removeClass('fa-link').addClass('fa-toggle-up');
      btn.addClass('toggled')
    
    else
      txt.text(txt.data('default-text'));
      ico.removeClass('fa-toggle-up').addClass('fa-link');
      btn.removeClass('toggled')

    # Fill form with data from query string.
    if(typeof data == 'object')

      @subview('add-entry').$el.find('#l_title').val(data.title);
      @subview('add-entry').model.set 'title', data.title;
      @subview('add-entry').$el.find('#l_url').val(data.url);
      @subview('add-entry').model.set 'url', data.url;

  focusSearch: (e) ->

    # Find search bar.
    bar = @$el.find('input[name=search]')

    # If bar isn't already focussed.
    if( ! bar.is(':focus') )
      # Interrupt the (keyboard) action.
      e.preventDefault()
      # Then focus the search bar.
      bar.focus()

  doSearch: (e) ->
    e.preventDefault()
    # Get search query.
    bar = $(e.target).find('input[name=search]')
    # Call search method with the search term(s) as argument.
    @subview('entry-list').search( $(e.target).find('input[name=search]').val() )

  # Keyboard shortcuts handler.
  handleKeyboardShortcuts: ->

    self = this
    
    # Find search bar.
    bar = @$el.find('input[name=search]')

    # Shortcut code overview: http://www.catswhocode.com/blog/using-keyboard-shortcuts-in-javascript
    $(document).keydown (e) ->
      
      # Focus the search bar when slash is pressed outside of a focussed element.
      self.focusSearch(e) if e.which is 191 and $(document).has(':focus').length is 0

      # Search bar empty & focussed + Escape?
      if( bar.val() == '' and bar.is(':focus') and e.which == 27)
        # Unfocus.
        bar.blur()
