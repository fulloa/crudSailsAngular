class User
    constructor: ($scope,Upload) ->
        $scope.users=[]
        $scope.file
        $scope.newUser=
            name:"",
            lastName:"",
            email:"",
            birthdate: new Date(),
            user:"",
            pass:"",
            image:"/images/user.png"
        $scope.createUser = (user) ->
            if $scope.userForm.$valid
                io.socket.get "/user/create/", 
                  user, 
                  (data) ->
                      console.log "Agregando datos"
                      console.log data
                      $scope.users.push data
                      $scope.newUser=
                        name:"",
                        lastName:"",
                        email:"",
                        birthdate: new Date(),
                        user:"",
                        pass:""
                      $scope.$apply()
        $scope.updateUser = (user) ->
            console.log "Actualizando"
            userUpdate = angular.extend({}, user);
            #delete userUpdate.$$hashKey
            #delete userUpdate.createdAt
            #delete userUpdate.updatedAt
            io.socket.get "/user/update/#{user.id}", 
                user, 
                (data) ->
                    console.log "Datos modificados correctamente"
                    console.log data
        $scope.deleteUser= (user) ->
            console.log "eliminando"
            io.socket.get "/user/destroy/#{user.id}", 
                user, 
                (data) ->
                    index = $scope.users.indexOf user
                    $scope.users.splice index , 1
                    $scope.$apply()
                    console.log "Eliminando datos"
                    console.log data
        $scope.upload = (file,invalidFiles) ->
            console.log file
            console.log invalidFiles
            console.log $scope.curUser.id
            if file
                Upload
                .upload {
                    url: '/user/upload',
                    data: {
                        file: file,
                        id:$scope.curUser.id
                    },
                } 
                .then (response) ->
                    $scope.curUser.image = response.data.img;
                    $scope.file=undefined
                    $("#loadImageModal").modal("hide")
                    true
                ,
                    (response) ->
                        console.log response
                        if response.status > 0 
                            $scope.errorMsg = "#{response.status} : #{response.data}"
                ,            
                    (evt) ->
                        console.log evt
                        $scope.progress = parseInt(100.0 * evt.loaded / evt.total);

        $scope.showLoadImage = (user) ->
            $scope.curUser=user
            $("#loadImageModal").modal("show")
            true
        io.socket.get '/user/', 
            {}, 
            (data) ->
                $scope.users = data
                $scope.$apply()
                console.log data

app = angular.module 'Users', ['ui.bootstrap','ui.bootstrap.showErrors','ngFileUpload']
app.controller 'userController', ['$scope','Upload', User]