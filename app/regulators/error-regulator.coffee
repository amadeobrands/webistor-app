Regulator = require 'regulators/base/regulator'
ErrorView = require 'views/error-view'

module.exports = class ErrorRegulator extends Regulator
  name: 'error'

  listen:
    '!#error mediator': 'handleError'
    'dispatcher:dispatch mediator': 'attachErrorView'

  attachErrorView: ->
    @view = new ErrorView
    @view.attach()

  handleError: (error) ->
    console.error error.message
    @view.showError error
