(function () {
    'use strict';
    angular.module(appName)
        .controller("masterPageController", masterPageController)

    masterPageController.$inject = ['$scope', '$http', '$location', '$rootScope'];
    function masterPageController($scope, $http, $location, $rootScope) {

        var root = this;
        root = {
            ImagenPErfil: null
        }
        $rootScope.$on("tituloPagina", function (w, h) {
            root.titulo = h.value;
        });

        $rootScope.$on("ImagenPerfil", function (w, h) {
            root.ImagenPErfil = h.value;
        });

        root.ImagenPErfil = ImgPerfil ? ImgPerfil : null;
        $Ex.Http = $http;

        $scope.salir = function () {
            try {
                Ex.load(true);

                $Ex.Http.post('/Pages/Inicio.aspx/Salir', { datos: {} })
                    .success(function (response) {
                        if (response.d.Data)
                            window.location.href = 'Pages/Login.aspx';
                        Ex.load(false);

                    })
                    .error(function (result, result2, result3) {

                        Ex.load(false);
                    });


            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        $scope.ImagenPerfilfn = function () {
            return root.ImagenPErfil;
        }
        $scope.getUsuario = function () {
            return Usuario;
        }
        //$Ex.Http = $http;
        //$scope.menus = [];
        //var esInicio = $location.absUrl().indexOf("Inicio.aspx") >= 0;
        //if (esInicio) {
        //    try {
        //        Ex.load(true);
        //        $Ex.Execute("GetMenu", {}, function (response) {
        //            $scope.menus = response.d;
        //        });
        //    } catch (ex) {
        //        Ex.mensajes(ex.message, 4);
        //        Ex.load(false);
        //    }
        //}
    }

})();