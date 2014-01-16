CollectionView = require 'views/base/collection-view'
TagView = require './tag-view'
SyncCollection = require 'models/base/sync-collection'
Tag = require 'models/tag'

module.exports = class TagListView extends CollectionView
  className: 'tag-list'
  autoRender: true
  itemView: TagView
  
  comparator = (a, b) ->
    return -1 if a.attributes.color and not b.attributes.color
    return  1 if b.attributes.color and not a.attributes.color
    return -1 if a.attributes.num > b.attributes.num
    return  1 if b.attributes.num > a.attributes.num
    return  0
  
  initialize: ->
    @collection = new SyncCollection null, model:Tag
    @collection.comparator = comparator
    @subscribeEvent 'entry:sync', => @collection.fetch()
    @collection.fetch()
    super
  
  search: (query) ->
    @collection.urlParams.search = query
    @collection.fetch()