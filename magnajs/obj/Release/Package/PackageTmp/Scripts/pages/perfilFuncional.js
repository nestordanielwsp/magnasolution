(function () {
    app.controller('perfilFuncional', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.forma = {};
            $scope.perfiles = [];
            $scope.perfil = {};
          
            $scope.agregar = function () {
                $scope.perfil = { Active: true, Tipo: 0, EsVendedor: 0 };
                $scope.submitted = false;
                $scope.esDetalle = true;
            }

            $scope.getPerfil = function (item) {
                try {
                    Ex.load(true);
                    $Ex.Execute("GetPerfil", item, function (response) {
                        $scope.perfil = response.d;
                        $timeout(function () {
                            $scope.esDetalle = true;
                        }, 50);
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.getPerfiles = function () {
                try {
                    Ex.load(true);
                    $Ex.Execute("GetPerfiles", $scope.filtro, function (response) {
                        $scope.perfiles = response.d;
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.guardar = function () {
                try {
                    Ex.load(true);
                    $scope.submitted = true;

                    $Ex.Execute("GuardarPerfil", $scope.perfil, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.getPerfiles();
                            $scope.esDetalle = false;
                        }
                    }, $scope.forma);
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }          

            $scope.getPerfiles();
        }]);
})();