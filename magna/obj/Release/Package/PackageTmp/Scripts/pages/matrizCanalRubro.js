(function () {
    app.controller('matrizCanalRubro', ['$scope', '$http',
        function ($scope, $http) {
            $Ex.Http = $http;

            $scope.canales = CanalInfo;
            $scope.rubros = RubroInfo;

            $scope.getMatrizCanalRubro = function () {
                $Ex.Execute("GetRubroCanal", {}, function (response) {
                    var matrizCanalRubro = response.d;
                    $scope.rubrosCanal = [];

                    for (var i = 0; i < $scope.rubros.length; i++) {
                        var rubroCanal = angular.copy($scope.rubros[i]);
                        rubroCanal.canales = [];

                        for (var j = 0; j < $scope.canales.length; j++) {
                            var canal = angular.copy($scope.canales[j]);
                            canal.Seleccionado = _.some(matrizCanalRubro, { RubroId: rubroCanal.RubroId, CanalId: canal.CanalId});

                            rubroCanal.canales.push(canal);
                        }

                        $scope.rubrosCanal.push(rubroCanal);
                    }
                });
            };

            $scope.guardar = function () {
                var datos = { RubrosCanal: $scope.rubrosCanal };
                $Ex.Execute("Guardar", datos, function () {
	                Ex.mensajes(Ex.GetGlobalResourceValue("msgSuccess"));
                });
            };

            $scope.getMatrizCanalRubro();
        }]);
})();