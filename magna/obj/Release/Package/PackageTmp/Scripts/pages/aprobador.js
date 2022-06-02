(function () {
    app.controller('aprobador', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;
            $scope.filtro = {};
            $scope.esDetalle = false;

            $scope.agregar = function () {
                $scope.submitted = false;
                $scope.esDetalle = true;
                $scope.aprobador = {
                    Active:true
                };
            }

            $scope.ObtenerAprobadores = function () {
                $Ex.Execute("GetAprobadores", $scope.filtro, function (response) {
                    $scope.aprobadores = response.d;
                });
            }

            $scope.ObtenerAprobador = function (Item) {
                $Ex.Execute("GetAprobador", Item, function (response) {
                    $scope.submitted = false;
                    $scope.esDetalle = true;
                    $scope.aprobador = response.d;
                });
            }

            $scope.guardar = function () {
                $scope.submitted = true;
                var valida = _.where($scope.aprobadores, { UsuarioAprobador: $scope.aprobador.UsuarioAprobador });
                if (valida.length === 0 || (valida.length === 1 && valida[0].AprobadorId === $scope.aprobador.AprobadorId)) {

                    $Ex.Execute("Guardar", $scope.aprobador, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.ObtenerAprobadores();
                            $scope.esDetalle = false;
                        }
                    }, $scope.forma);
                } else {
                    Ex.mensajes("El Usuario capturado ya existe.");
                }
            }

            $scope.ObtenerAprobadores();

        }]);
}
)();