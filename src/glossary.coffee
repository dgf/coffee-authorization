Authorization = require './authorization'

ROLE = ADMIN: 'admin', USER: 'user', GUEST: 'guest'

authorize = new Authorization 'glossary'

# GUEST
authorize.role ROLE.GUEST, (role) ->
  role.permit ['list'], (user) -> true # no condition

# USER (multiple permit definitions)
authorize.role ROLE.USER, (role) ->
  role.permit ['create', 'list'], -> true
  role.permit ['edit', 'delete'], (user, term) ->
    true if term.owner == user.login # check ownership

# ADMIN (multiple role definitions)
authorize.role ROLE.ADMIN, (role) ->
  role.permit ['list', 'delete'], -> true
authorize.role ROLE.ADMIN, (role) ->
  role.permit ['create', 'edit'], -> true

# controller
class Glossary
  constructor: (@user, @terms) ->
  list: -> @terms if authorize.check @user, 'list'
  create: (term) ->
    if authorize.check @user, 'create'
      term.owner = @user.login
      @terms.push term
  edit: (i, term) ->
    if authorize.check @user, 'edit', @terms[i]
      term.owner = @user.login # fix owner
      @terms[i] = term
  delete: (i) ->
    term = @terms[i]
    if authorize.check @user, 'delete', term
      @terms.splice i, 1

module.exports = Glossary
