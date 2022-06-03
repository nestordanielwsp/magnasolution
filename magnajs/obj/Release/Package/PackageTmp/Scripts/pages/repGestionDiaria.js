(function () {
    app.controller('repGestionDiaria', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.vista = {};
            $scope.canales = CanalInfo;
            $scope.regiones = RegionInfo;
            $scope.analistas = AnalistaInfo;
            $scope.jacs = JacInfo;
            $scope.anios = util.getYearArray(4);
            $scope.meses = util.getMonthArray();
            $scope.chartCanal = {};
            $scope.chartCanalMobile = {};
            $scope.chartComportaientoAnual = {};
            $scope.tablaCanales = [];
            $scope.tablaAnalistas = [];
            $scope.tablaRegiones = [];

            $scope.filtro.Anio = new Date().getFullYear();
            $scope.filtro.MesId = new Date().getMonth() + 1;

            if ($scope.canales.length === 1) {
                $scope.filtro.CanalId = $scope.canales[0].CanalId;
            }

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

            $scope.tiposDecuentoOptions = util.getOptionsMultiselect("TipoDescuentoId", "NombreTipoDescuento");
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

            $scope.chartOptions = {
                size: "50%", innerSize: "45%",
                chart: { marginLeft: 5, marginBottom: 5, marginTop: 5 }
            }

            $scope.chartOptionsMobile = {
                size: "100%",
                innerSize: "50%",
                labelEnabled: false
            }

            var meses = util.getMonthArray(false, true);
            $scope.nombreMeses = meses;
            $scope.chartComportamientoOptions = {
                categories: [],
                legend: {
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            };

            $scope.columasCartera = [
                Ex.GetResourceValue("gvReporte-0Dias"),
                Ex.GetResourceValue("gvReporte-30Dias"),
                Ex.GetResourceValue("gvReporte-60Dias"),
                Ex.GetResourceValue("gvReporte-90Dias"),
                Ex.GetResourceValue("gvReporte-120Dias"),
                Ex.GetResourceValue("gvReporte-Total")
            ];

            $scope.actualizar = function () {
                try {
                    $Ex.Execute("ObtenerResumen", $scope.filtro, function (response) {
                        if (response.d.DistribucionCanal.length > 0) {
                            $scope.chartCanal.open(response.d.DistribucionCanal);
                            $scope.chartCanalMobile.open(response.d.DistribucionCanal);

                            $scope.monto = response.d.ComportamientoAnual;

                            if ($scope.monto.length > 0) {
                                var datosComportamientoAual = [
                                { name: Ex.GetResourceValue("lblVencida"), data: _.pluck($scope.monto, "MontoVencido") },
                                { name: Ex.GetResourceValue("lblCorriente"), data: _.pluck($scope.monto, "MontoCorriente") }
                                ];

                                $scope.nombreMeses = meses.slice($scope.monto[0].MesId - 1);
                                $scope.chartComportamientoOptions.categories = _.pluck($scope.nombreMeses, "Name");

                                $scope.chartComportaientoAnual.open(datosComportamientoAual);
                            }

                            $scope.tablaCanales = response.d.TablaCanal;
                            $scope.tablaClientes = response.d.TablaCliente;
                            $scope._tablaClientes = response.d.TablaCliente;
                            $scope.tablaAnalistas = response.d.TablaAnalista;
                            $scope.tablaVendedores = response.d.TablaVendedor;
                            $scope._tablaVendedores = response.d.TablaVendedor;
                            $scope.tablaRegiones = response.d.TablaRegion;

                            $scope.sinInformacion = false;
                        } else {
                            $scope.sinInformacion = true;
                        }
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            $scope.vistas = [
                { vistaId: 1, name: Ex.GetResourceValue("btnResumen") },
                { vistaId: 2, name: Ex.GetResourceValue("btnCanal") },
                { vistaId: 3, name: Ex.GetResourceValue("btnCliente") },
                { vistaId: 4, name: Ex.GetResourceValue("btnAnalista") },
                { vistaId: 5, name: Ex.GetResourceValue("btnVendedor") },
                { vistaId: 6, name: Ex.GetResourceValue("btnRegion") }
            ];

            var vistaIdPrevia = 1;
            $scope.vista = $scope.vistas[0];
            $scope.cambiarVista = function (vista) {
                //Evita que busque datos cuando se le da click en la pestaña activa
                if (vistaIdPrevia !== vista.vistaId) {
                    $scope.esGrafica = true;

                    $scope.vista = vista;
                    vistaIdPrevia = vista.vistaId;
                }
            }

            $scope.exportar = function () {
                try {
                    Ex.load(true);
                    var datos = angular.copy($scope.filtro);
                    datos.VistaId = $scope.vista.vistaId;
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