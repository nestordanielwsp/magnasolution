(function () {
    app.controller('tipoIndicador', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.forma = {};
            $scope.indicadores = [];

            $scope.agregar = function () {
                $scope.indicadores.push({Active: true});
            };

            $scope.eliminar = function (item, index) {
                if (item.hasOwnProperty("TipoIndicadorId"))
                    item.Active = false;
                else
                    $scope.indicadores.splice(index, 1);
            };

            $scope.getIndicadores = function () {
                $Ex.Execute("GetIndicadores", {}, function (response) {
                    $scope.indicadores = response.d;
                });
            };

            $scope.guardar = function () {
                $scope.submitted = true;
                var datos = { Indicadores: $scope.indicadores };

                var valido = true;
                _.forEach(datos.Indicadores, function (item) {
                        var temp = _.where(datos.Indicadores, { Nombre: item.Nombre })
                        if (temp.length > 1) {
                            valido = false;
                        }
                });
                
                if (!valido) {
                    Ex.mensajes("No se puede agregar TipoIndicador Repetido");
                    $scope.getIndicadores();
                }
                else {
                    $Ex.Execute("Guardar", datos, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.submitted = false;
                            Ex.mensajes(Ex.GetGlobalResourceValue("msgSuccess"));
                            $scope.getIndicadores();
                        }
                    }, $scope.forma);
                }
            };
            
                $scope.getIndicadores();
        }]);
})();