# CoffeeScript Authorization Example

simple authorization template and specification

    git clone ...
    npm install
    npm test

## example declaration of a glossary

                                                    _______________
                                                   |  << scope >>  |
    authorize = new Authorization 'glossary'       | Authorization |
                                                   |_______________|
                                                          |
                                                    ______|________
                                                   |               |
    authorize.role 'user', (role) ->               |     Role      |
                                                   |_______________|
                                                          |
                                                    ______|________
                                                   | << builder >> |
    role.permit ['edit','delete'], (user, term) -> |   Permission  |
                                                   |_______________|
      true if term.owner == user.login                    |
                              _______________       ______|________
                             |               |     |  << list >>   |
                             |   Condition   |_____|    Action     |
                             |_______________|     |_______________|



