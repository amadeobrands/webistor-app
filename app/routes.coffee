module.exports = (match) ->
  match '', 'history#show'
  match 'entries/:id', 'history#show'
  