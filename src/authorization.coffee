
class Role
  constructor: (@name, @scope) -> @actions = {}
  permit: (actions, condition) =>  @actions[a] = condition for a in actions
  check: (action, user, context) -> @actions[action]?(user, context)

class Authorization
  constructor: (@scope) -> @roles = {}
  role: (name, callback) => callback @roles[name] ?= new Role(name, @scope)
  check: (user, action, context) =>
    for r in user.roles
      return true if @roles[r]?.check action, user, context

module.exports = Authorization
