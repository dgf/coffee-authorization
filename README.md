# CoffeeScript Authorization Implementation Example

    git clone ...
    npm install
    npm test



                        _______________
                       |  << scope >>  |
                       | Authorization |
                       |_______________|
                              |
                              |
                        ______|________
                       |               |
                       |     Role      |
                       |_______________|
                              |
                              |
                        ______|________
                       |<< composite >>|
                       |   Permission  |
                       |_______________|
                         |           |
                         |           |
            _____________|_         _|_____________
           |  << list >>   |       |               |
           |    Action     |_______|   Condition   |
           |_______________|       |_______________|

    e.g. ['list', 'create']   (term) -> user.login == term.owner
