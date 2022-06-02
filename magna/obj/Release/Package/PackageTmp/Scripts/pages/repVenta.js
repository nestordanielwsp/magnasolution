(function () {
    app.controller('repVenta', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            $scope.filtro = { TiposDescuento: [] };
            $scope.vista = {};
            $scope.esGrafica = true;
            $scope.canales = CanalInfo;
            $scope.regiones = RegionInfo;
            $scope.jacs = JacInfo;
            $scope.marcas = MarcaInfo;
            $scope.anios = util.getYearArray(4);
            $scope.meses = util.getMonthArray();
            $scope.chartVenta = {};
            $scope.chartVentaRegion = {};
            $scope.chartTopCliente = {};
            $scope.chartVentasMarca = {};
            $scope.chartVentasCanal = {};
            $scope.chartCanal = {};
            $scope.chartMarca = {};
            $scope.chartRegion = {};

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

            $scope.productoOptions = {
                idProp: "ProductoId",
                displayProp: "Description",
                methodName: "BuscarProducto"
            };

            $scope.tiposDecuentoOptions = util.getOptionsMultiselect("TipoDescuentoId", "NombreTipoDescuento");
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

            var pointFormat = '<span">{point.name}</span>: <b>${point.y:,.2f}</b>';
            $scope.ventaOptions = {
                pointFormat: pointFormat,
                legend: { enabled: false },
                chart: { marginTop: 15 }
            };

            $scope.regionOptions = {
                legend: { enabled: false },
                pointFormat: pointFormat
            };

            $scope.clienteOptions = {
                legend: { enabled: false },
                pointFormat: pointFormat,
                chart: { marginRight: 0, marginBottom: 10 }
            };

            $scope.chartOptions = {
                size: "100%",
                innerSize: "50%",
                labelEnabled: false
            }

            $scope.chartCanalOptions = { categories: [] };
            $scope.chartMarcaOptions = { categories: [] };
            $scope.chartRegionOptions = { categories: [] };

            var abrirChart = function (datos, chart, chartOptions) {                
                chartOptions.categories = _.pluck(datos, "name");

                var anioActual = _.pluck(datos, "AnioActual");
                var anioAnterior = _.pluck(datos, "AnioAnterior");
                var variacion = _.pluck(datos, "Variacion");

                var maxAnioActual = _.max(anioActual);
                var maxAnioAnterior = _.max(anioAnterior);
                var minAnioActual = _.min(anioActual);
                var minAnioAnterior = _.min(anioAnterior);

                var max = maxAnioActual > maxAnioAnterior ? maxAnioActual : maxAnioAnterior;
                var min = minAnioActual < minAnioAnterior ? minAnioActual : minAnioAnterior;

                var series = [
                    { type: "column", name: "Año Actual", yAxis: 1, data: anioActual },
                    { type: "column", name: "Año Anterior", yAxis: 1, data: anioAnterior },
                    { type: "spline", name: "Variación", data: variacion }
                ];

                var setTickAmount = chartOptions.categories.length > 2;
                chart.openCombinationChart(series, setTickAmount);
            }

            $scope.actualizar = function () {
                try {
                    $scope.filtro.TiposDecuentoIds = _.pluck($scope.filtro.TiposDescuento, 'id').join(",");
                    $Ex.Execute("ObtenerResumen", $scope.filtro, function (response) {
                        if (response.d.Resumen.length > 0) {
                            $scope.resumen = response.d.Resumen;

                            $scope.ventasModerno = 0;
                            $scope.ventasTradicional = 0;

                            for (var i = 0; i < $scope.resumen.length; i++) {
                                $scope["ventas" + $scope.resumen[i].name] = $scope.resumen[i].y;
                            }

                            $scope.totalVentas = $scope.ventasModerno + $scope.ventasTradicional;

                            if ($scope.totalVentas > 0) {
                                $scope.porcentajeModerno = $scope.ventasModerno * 100 / $scope.totalVentas;
                                $scope.porcentajeTradicional = $scope.ventasTradicional * 100 / $scope.totalVentas;
                            }

                            $scope.chartVenta.open($scope.resumen);
                            $scope.chartVentaRegion.open(response.d.VentasRegion);
                            $scope.chartTopCliente.open(response.d.VentasCliente);
                            $scope.chartVentasMarca.open(response.d.VentasMarca);
                            $scope.chartVentasCanal.open(response.d.VentasCanal);

                            $scope.tablaCanales = response.d.ComparativoCanal;
                            $scope.tablaClientes = response.d.ComparativoCliente;
                            $scope._tablaClientes = response.d.ComparativoCliente;
                            $scope.tablaMarcas = response.d.ComparativoMarca;
                            $scope.tablaVendedores = response.d.ComparativoVendedor;
                            $scope._tablaVendedores = response.d.ComparativoVendedor;
                            $scope.tablaRegiones = response.d.ComparativoRegion;

                            abrirChart($scope.tablaCanales, $scope.chartCanal, $scope.chartCanalOptions);
                            abrirChart($scope.tablaMarcas, $scope.chartMarca, $scope.chartMarcaOptions);
                            abrirChart($scope.tablaRegiones, $scope.chartRegion, $scope.chartRegionOptions);

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
                { vistaId: 1, name: Ex.GetResourceValue("btnResumen"), graficaTabla: false },
                { vistaId: 2, name: Ex.GetResourceValue("btnCanal"), graficaTabla: true },
                { vistaId: 3, name: Ex.GetResourceValue("btnCliente"), graficaTabla: false },
                { vistaId: 4, name: Ex.GetResourceValue("btnMarca"), graficaTabla: true },
                { vistaId: 5, name: Ex.GetResourceValue("btnVendedor"), graficaTabla: false },
                { vistaId: 6, name: Ex.GetResourceValue("btnRegion"), graficaTabla: true }
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