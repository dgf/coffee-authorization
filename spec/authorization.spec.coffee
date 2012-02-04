Glossary = require '../src/glossary'

class User
  constructor: (@login, @roles) ->

admin = new User 'Administrator', [Glossary.ADMIN, Glossary.USER]
user = new User 'Editor', [Glossary.USER]
guest = new User 'Guest', [Glossary.GUEST]

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
    expect(createAccess actual, term).toBeTruthy 'guest can create'
    expect(editAccess actual, 0, term).toBeFalsy 'guest can edit'
    expect(deleteAccess actual, 0).toBeFalsy 'guest can delete'


  it 'permits user a globally list view', ->

    actual = getGlossary user
    expect(listAccess actual).toBeTruthy 'user can list'
    # term 0 own by other
    expect(editAccess actual, 0, term).toBeFalsy 'user can edit'
    expect(deleteAccess actual, 0).toBeFalsy 'user can delete'


  it 'permits user a change of own terms', ->

    actual = getGlossary user
    expect(createAccess actual, term).toBeTruthy 'user can create'

    lastTerm = actual.terms.length - 1
    newTerm = title: 'new title', desc: 'new description'
    expect(editAccess actual, lastTerm, newTerm).toBeTruthy 'user can edit'
    expect(deleteAccess actual, lastTerm).toBeFalsy 'user can delete'


  it 'permits admin user all operations', ->

    actual = getGlossary admin
    expect(listAccess actual).toBeTruthy 'admin can list'
    expect(actual.list().length).toBe 3, 'three terms'
    expect(createAccess actual, term).toBeTruthy 'admin can create'
    expect(actual.list().length).toBe 4, 'term added'
    expect(deleteAccess actual, 2).toBeTruthy 'admin can delete'
    expect(editAccess actual, 1, term).toBeTruthy 'admin can edit'
