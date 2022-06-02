(function () {
    app.controller('comprador', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;
            $scope.filtro = {};
            $scope.esDetalle = false;

            $scope.agregar = function () {
                $scope.submitted = false;
                $scope.esDetalle = true;
                $scope.comprador = {
                    Active: true
                };
            }

            $scope.ObtenerCompradores = function () {
                $Ex.Execute("GetCompradores", $scope.filtro, function (response) {
                    $scope.compradores = response.d;
                });
            }

            $scope.ObtenerComprador = function (Item) {
                $Ex.Execute("GetComprador",Item , function (response) {
                    $scope.submitted = false;
                    $scope.esDetalle = true;
                    $scope.comprador = response.d;
                });
            }

            $scope.guardar = function () {
                $scope.submitted = true;
                var valida = _.where($scope.compradores, { UsuarioComprador: $scope.comprador.UsuarioComprador });
               
                if (valida.length === 0 || (valida.length === 1 && valida[0].CompradorId === $scope.comprador.CompradorId)) {
                    $Ex.Execute("Guardar", $scope.comprador, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.ObtenerCompradores();
                            $scope.esDetalle = false;
                        }
                    }, $scope.forma);
                } else {
                    Ex.mensajes("El UsuarioComprador capturado ya existe.");
                }
            }

            $scope.ObtenerCompradores();

        }]);
}
)();