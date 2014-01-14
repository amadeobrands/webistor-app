module.exports = (match) ->
  match '', 'app#history'
  match 'add', 'app#history'
  match 'search/:query', 'app#history'
  match 'logout', 'session#logout'
  match 'login', 'start#login'
  match 'invite', 'start#invite'
  match 'register/:user_id/:claim_key', 'start#register'
