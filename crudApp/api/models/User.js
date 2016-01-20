/**
 * User.js
 *
 * @description :: TODO: You might write a short summary of how this model works and what it represents here.
 * @docs        :: http://sailsjs.org/#!documentation/models
 */

module.exports = {
    attributes: {
        user: {
            type: "string",
            unique: true
        },
        name: "string",
        lastName: "string",
        pass: "string",
        image: "string",
        email: "string",
        birthdate: "date"
    },
    beforeCreate: function (values, next) {
        console.log(values);
        require('bcrypt').hash(values.pass, 10, function passwordEncrypted(err, password) {
            if (err)
                return next(err);
            values.pass = password;
            next();
        });
    },
    beforeUpdate: function (values, next) {
        console.log(values);
        if (typeof values.password !== "undefined") {
            require('bcrypt').hash(values.pass, 10, function passwordEncrypted(err, password) {
                if (err)
                    return next(err);
                values.pass = password;
                next();
            });
        } else {
            next();
        }
    }
};

