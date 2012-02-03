Authorization = require './authorization'

# controller
class Glossary

  @ADMIN: 'admin'
  @USER: 'user'
  @GUEST: 'guest'

  constructor: (@user, @terms) ->

    @authorize = new Authorization 'glossary'

    # GUEST
    @authorize.role Glossary.GUEST, (role) ->
      role.permit ['list'], (user) -> true # no condition

    # USER (multiple permit definitions)
    @authorize.role Glossary.USER, (role) ->
      role.permit ['create', 'list'], -> true
      role.permit ['edit'], (user, term) ->
        true if term.owner == user.login # check ownership

    # ADMIN (multiple role definitions)
    @authorize.role Glossary.ADMIN, (role) ->
      role.permit ['list', 'create', 'edit'], -> true
    @authorize.role Glossary.ADMIN, (role) ->
      role.permit ['delete'], -> true


  list: -> @terms if @authorize.check @user, 'list'

  create: (term) ->
    if @authorize.check @user, 'create'
      term.owner = @user.login
      @terms.push term

  edit: (i, term) ->
    if @authorize.check @user, 'edit', @terms[i]
      term.owner = @user.login # fix owner
      @terms[i] = term

  delete: (i) ->
    term = @terms[i]
    if @authorize.check @user, 'delete', term
      @terms.splice i, 1


module.exports = Glossary
