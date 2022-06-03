(function () {
    app.controller('usuarioQad', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;
            $scope.filtro = {};
            $scope.esDetalle = false;

            $scope.agregar = function () {
                $scope.submitted = false;
                $scope.esDetalle = true;
                $scope.usuarioQad = {
                    Active: true
                };
            }

            $scope.ObtenerUsuariosQad = function () {
                $Ex.Execute("GetUsuariosQad", $scope.filtro, function (response) {
                    $scope.usuariosQad = response.d;
                });
            }

            $scope.ObtenerUsuarioQad = function (Item) {
                $Ex.Execute("GetUsuarioQad", Item, function (response) {
                    $scope.submitted = false;
                    $scope.esDetalle = true;
                    $scope.usuarioQad = response.d;
                });
            }

            $scope.guardar = function () {
                $scope.submitted = true;
                var valida = _.where($scope.usuariosQad, { Usuario: $scope.usuarioQad.Usuario });
                if (valida.length === 0 || (valida.length === 1 && valida[0].UsuarioQadId === $scope.usuarioQad.UsuarioQadId)) {
                    $Ex.Execute("Guardar", $scope.usuarioQad, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.ObtenerUsuariosQad();
                            $scope.esDetalle = false;
                        }
                    }, $scope.forma);
                } else {
                    Ex.mensajes("El Usuario capturado ya existe.");
                }
            }

            $scope.ObtenerUsuariosQad();

        }]);
}
)();