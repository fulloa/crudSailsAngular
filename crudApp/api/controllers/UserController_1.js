module.exports = {
    upload: function (req, res) {
        sails.log(req.body);
        if (req.body.id) {
            return req.file('file').upload({
                dirname: '../public/uploads/'
//                saveAs: 'avatar_' + req.body.id
            }, function (err, files) {
                sails.log(files);
                if (err) {
                    return res.serverError(err);
                }

                User.findOne({id: req.body.id}).exec(function (err, user) {
                    var pathComponents = files[0].fd.split('/');
                    pathComponents.pop();
                    pathComponents.pop();
                    path = pathComponents.join("/");
                    console.log(user);
                    if (user.image !== "/images/user.png") {
                        try {
                            require('fs').unlinkSync(path + user.image);
                        } catch (e) {
                            console.log("problemas al borrar imagen antigua");
                        }
                    }
                });

                var img = "/uploads/" + files[0].fd.split('/').reverse()[0];

                User.update({id: req.body.id}, {image: img}, function (err, user) {
                    if (err) {
                        console.log("error");
                        console.log(err);
                    } else {
                        console.log("modificado correctamente");
                        console.log(user);
                    }
                });
                return res.json({
                    message: files.length + " Archivo(s) subidos correctamente",
                    img: img
                });
            });
        } else {
            return res.json({
                message: "usuario invalido",
            });
        }
    }
};