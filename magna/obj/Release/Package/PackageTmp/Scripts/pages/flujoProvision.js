(function () {
    app.controller('flujoProvision', ['$scope', '$http', '$timeout',
        function ($scope, $http, $timeout) {
            $Ex.Http = $http;

            $scope.forma = {};
            $scope.rubros = RubroInfo;
            $scope.flujo = {};
            $scope.opcionesUsuario = { idProp: "UsuarioId", displayProp: "NombreUsuario", methodName: "BuescarUsuario" };

            $scope.sortableOptions = {
                update: function (e, ui) {
                    $timeout(function () {
                        _.each($scope.flujo.Lista, function (item, index) {
                            item.Orden = index + 1;
                        });
                    }, 0);
                },
                handle: '.drag'
            };

            $scope.agregar = function () {
                $scope.flujo.Lista.push({ Orden: $scope.flujo.Lista.length + 1 });
            };

            $scope.eliminar = function (index) {
                $scope.flujo.Lista.splice(index, 1);
                _.each($scope.flujo.Lista, function (item, i) {
                    item.Orden = i + 1;
                });
            };

            $scope.getFlujos = function () {
                //var datos = { RubroId: $scope.flujo.RubroId };
                $Ex.Execute("GetFlujos", {}, function (response) {
                    $scope.flujo.Lista = response.d;
                });
            };

            $scope.guardar = function () {
                $scope.submitted = true;
                var success = true;               

                angular.forEach($scope.flujo.Lista, function (item) {

                    var total = 0;

                    for (var index = 0; index < $scope.flujo.Lista.length; index++) {

                        var infoUsuario = $scope.flujo.Lista[index];
                        if (infoUsuario.UsuarioId === item.UsuarioId)
                             total = total + 1;
                    }

                    if (total > 1)
                        success = false;
                });
                if (success) {
                    $Ex.Execute("Guardar", $scope.flujo, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.submitted = false;
                            $scope.getFlujos();
                        }
                    }, $scope.forma);
                }
                else {
                    Ex.mensajes(Ex.GetResourceValue("msgErrorGuardar"), 1, null, null, null, function (r) {
                    }, null);
                }
                
            };

            $scope.getFlujos();
        }]);
})();