(function (){
    app.controller('repDevoluciones', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;
            $scope.filtro = {};
            $scope.concentrado = [];
            $scope_concentrado = [];
            $scope.anios = util.getYearArray(4);
            $scope.meses = util.getMonthArray();
            $scope.canales = CanalInfo;
            $scope.marcas = MarcaInfo;
            $scope.causales = CausalInfo;
            $scope.estatus = EstatusInfo;

            $scope.filtro.Anio = new Date().getFullYear();
            $scope.filtro.MesId = new Date().getMonth() + 1;
            $scope.sinInformacion = false;

            $scope.clienteOptions = {
                idProp: "ClienteId",
                displayProp: "NombreCliente",
                methodName: "BuscarVendedor"
            };

            $scope.actualizar = function () {
                try {
                    $scope.filtro.TiposDecuentoIds = _.pluck($scope.filtro.TiposDescuento, 'id').join(",");
                    $Ex.Execute("ObtenerConcentrado", $scope.filtro, function (response) {
                        if (response.d.Concentrado.length > 0) {
                            $scope.concentrado = response.d.Concentrado;
                            $scope._concentrado = response.d.concentrado;

                            $scope.sinInformacion = false;
                        } else {
                            $scope.sinInformacion = true;
                        }
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.exportar = function () {
                try {
                    Ex.load(true);
                    var datos = angular.copy($scope.filtro);
                    $Ex.Execute("Exportar", datos, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            };

            $scope.actualizar();

        }]);
})();