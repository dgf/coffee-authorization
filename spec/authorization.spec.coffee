Glossary = require '../src/glossary'

class User
  constructor: (@login, @roles) ->

admin = new User 'Administrator', ['admin', 'user']
user = new User 'Editor', ['user']
guest = new User 'Guest', ['guest']

describe 'authorization permission handling', ->

  # assertion helper
  listAccess = (glossary) ->
    actual = glossary.list()
    actual? and actual == glossary.terms
  createAccess = (glossary, term) ->
    glossary.create term
    glossary.terms[glossary.terms.length - 1] == term
  editAccess = (glossary, i, term) ->
    glossary.edit i, term
    glossary.terms[i] == term
  deleteAccess = (glossary, i) ->
    expected = glossary.terms[i]
    actual = glossary.delete i
    actual? and actual[0] == expected

  term = {title: 'title', desc: 'description'}

  getGlossary = (user) -> new Glossary user, [
    {title: 'one term', desc: 'first term', owner: 'Administrator'}
    {title: 'another term', desc: 'second term', owner: 'Editor'}
    {title: 'a third term', desc: 'term term', owner: 'Editor'}
  ]

  it 'permits guest only the list view', ->

    actual = getGlossary guest
    expect(listAccess actual).toBeTruthy 'guest can list'
    expect(createAccess actual, term).toBeFalsy 'guest can create'
    expect(editAccess actual, 0, term).toBeFalsy 'guest can edit'
    expect(deleteAccess actual, 0).toBeFalsy 'guest can delete'

  it 'permits admin user all operations', ->

    actual = getGlossary admin
    expect(createAccess actual, term).toBeTruthy 'admin can create'
    expect(deleteAccess actual, 2).toBeTruthy 'admin can delete'
    expect(editAccess actual, 1, term).toBeTruthy 'admin can edit'
    expect(listAccess actual).toBeTruthy 'admin can list'

  it 'permits user a globally list view', ->

    actual = getGlossary user
    expect(listAccess actual).toBeTruthy 'user can list'
    expect(editAccess actual, 0, term).toBeFalsy 'user can edit'
    expect(deleteAccess actual, 0).toBeFalsy 'user can delete'

  it 'permits user a change of owned terms', ->

    actual = getGlossary user
    expect(createAccess actual, term).toBeTruthy 'user can create'

    lastTerm = actual.terms.length - 1
    newTerm = title: 'new title', desc: 'new description'
    expect(editAccess actual, lastTerm, newTerm).toBeTruthy 'user can edit'
    expect(deleteAccess actual, lastTerm).toBeTruthy 'user can delete'