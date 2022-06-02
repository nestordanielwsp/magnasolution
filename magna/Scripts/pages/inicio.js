(function () {
    app.controller('inicio', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.filtro = { Anio: new Date().getFullYear(), MesId: new Date().getMonth() + 1 };
            $scope.anios = util.getYearArray(4);
            $scope.meses = util.getMonthArray();
            $scope.chartVentaNeta = {};
            $scope.chartVentasMarca = {};
            $scope.chartVentasCanal = {};
            $scope.canales = [
                { Grupo: Ex.GetResourceValue("lblCanalModerno"), Subcanales: [] },
                { Grupo: Ex.GetResourceValue("lblCanalTradicional"), Subcanales: [] }
            ];

            $scope.ventaNetaOptions = {
                pointFormat: '<span">{point.name}</span>: <b>${point.y:,.2f}</b>',
                legend: { enabled: false },
                chart: { marginTop: 15 }
            };

            $scope.chartOptions = {
                size: "100%",
                innerSize: "50%",
                labelEnabled: false
            }
           
            $scope.actualizar = function () {
                try {
                    Ex.load(true);
                    $Ex.Execute("GetInfromacion", $scope.filtro, function (response) {
                        if (response.d.VentasMarca.length > 0) {
                            $scope.resumen = response.d.Resumen;

                            var venta = _.find($scope.resumen, { name: "Total Ventas"});
                            var rechazo = _.find($scope.resumen, { name: "Rechazos" });
                            var descuento = _.find($scope.resumen, { name: "Descuentos" });

                            if (rechazo == null)
                                $scope.resumen.splice(1, 0, { name: "Rechazos", y: 0 });

                            var totalVentas = venta == null? 0: venta.y;
                            var rechazos = rechazo == null ? 0 : rechazo.y;
                            var descuentos = descuento == null ? 0 : descuento.y;

                            if (!isNaN(totalVentas) && totalVentas > 0) {
                                $scope.porcentajeRechazo = rechazos * 100 / totalVentas;
                                $scope.porcentajeDescuentos = descuentos * 100 / totalVentas;
                            }
                            
                            $scope.chartVentaNeta.open($scope.resumen);
                            $scope.chartVentasMarca.open(response.d.VentasMarca);
                            $scope.chartVentasCanal.open(response.d.VentasCanal);
                            $scope.canales[0].Subcanales = response.d.CanalModerno;
                            $scope.canales[1].Subcanales = response.d.CanalTradicional;
                            $scope.sinInformacion = false;
                        } else {
                            $scope.sinInformacion = true;
                        }                        
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.actualizar();
        }]);
})();