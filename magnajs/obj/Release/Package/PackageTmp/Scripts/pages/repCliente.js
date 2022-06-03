(function () {
    app.controller('repCliente', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.canales = CanalInfo;
            $scope.regiones = RegionInfo;
            $scope.analistas = AnalistaInfo;
            $scope.jacs = JacInfo;

            $scope.vendedorOptions = {
                idProp: "VendedorId",
                displayProp: "NombreVendedor",
                methodName: "BuscarVendedor"
            };

            $scope.jefeOptions = {
                idProp: "JefeId",
                displayProp: "NombreJefe",
                methodName: "BuscarJefe"
            };
                           
            $scope.actualizar = function () {
                try {
                    $Ex.Execute("ObtenerClientes", $scope.filtro, function (response) {
                        $scope.clientes = response.d;
                        $scope._clientes = response.d;
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }
       
            $scope.exportar = function () {
                try {
                    $Ex.Execute("Exportar", $scope.filtro, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.actualizar();
        }]);
})();