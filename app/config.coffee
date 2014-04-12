# Environment
production = false

# App configuration.
module.exports =
  production: production
  api:
    urlRoot: if production then 'http://api.webistor.net/rest/' else 'http://localhost/WebistorAPI/rest/'
