(function () {
    app.controller('repCarteraCierreMes', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.vista = {};
            $scope.canales = CanalInfo;
            $scope.regiones = RegionInfo;
            $scope.analistas = AnalistaInfo;
            $scope.jacs = JacInfo;
            $scope.anios = util.getYearArray(4);
            $scope.meses = util.getMonthArray(false, true);
            $scope.chartEvolucion = {};
            $scope.chartCalidadDias = {};
            $scope.chartCanal = {};
            $scope.chartCanalMobile = {};
            $scope.chartComportaientoAnual = {};
            $scope.chartCanalDiasCalidad = {};
            $scope.chartRegionDiasCalidad = {};
            $scope.chartCobrabilidad = {};
            $scope.tablaCanales = [];
            $scope.tablaAnalistas = [];
            $scope.tablaRegiones = [];
            $scope.calidadDiasCanal = [];
            $scope.calidadDiasCliente = [];
            $scope.calidadDiasRegion = [];
            $scope.vistaPadreId = 0;
            $scope.esVistaPrincipal = true;
            $scope.titulo = "";
            $scope.lblDias = Ex.GetResourceValue("lblDias");
            $scope.lblCalidad = Ex.GetResourceValue("lblCalidad");

            var vistaPadre = {};
            var vistaIdPrevia = 1;

            $scope.filtro.Anio = new Date().getFullYear();
            $scope.filtro.MesId = new Date().getMonth() + 1;

            if ($scope.canales.length === 1) {
                $scope.filtro.CanalId = $scope.canales[0].CanalId;
            }

            var pointFormat = '<span">{point.name}</span>: <b>${point.y:,.2f}</b>';
            $scope.columnaOptions = {
                legend: { enabled: false },
                pointFormat: pointFormat
            };

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

            $scope.chartCalidadDiasOptions = { categories: [] };
            $scope.canalDiasCalidadOptions = { categories: [] };
            $scope.regionDiasCalidadOptions = { categories: [] };
            $scope.chartCobrabilidadOptions = { categories: [] };

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

            $scope.titulosCalidadDias = [
                Ex.GetResourceValue("lblDias"),
                Ex.GetResourceValue("lblCalidad")
            ];

            var abrirChart = function (datos, chart, chartOptions) {
                chartOptions.categories = _.pluck(datos, "name");

                var calidad = _.pluck(datos, "Calidad");
                var dias = _.pluck(datos, "Dias");

                var series = [
                    { type: "column", name: "Días de cartera", yAxis: 1, data: dias },
                    { type: "spline", name: "Calidad de cartera", data: calidad }
                ];

                chart.openCombinationChart(series);
            }
           
            var obtenerResumen = function () {
                $scope.filtro.vistaId = $scope.vista.vistaId;
                $Ex.Execute("ObtenerResumen", $scope.filtro, function (response) {
                    if (response.d.Evolucion.length > 0) {         
                        $scope.chartEvolucion.open(response.d.Evolucion);

                        abrirChart(response.d.CalidadDias, $scope.chartCalidadDias, $scope.chartCalidadDiasOptions);
                        abrirChart(response.d.CanalDiasCalidad, $scope.chartCanalDiasCalidad, $scope.canalDiasCalidadOptions);
                        abrirChart(response.d.RegionDiasCalidad, $scope.chartRegionDiasCalidad, $scope.regionDiasCalidadOptions);

                        $scope.tablaCalidadDias = response.d.Tabla;
                        $scope._tablaCalidadDias = response.d.Tabla;
                        //$scope.calidadDiasCanal = response.d.TablaCanal;
                        //$scope.calidadDiasCliente = response.d.TablaCliente;
                        //$scope._calidadDiasCliente = response.d.TablaCliente;
                        //$scope.calidadDiasRegion = response.d.TablaRegion;

                        $scope.sinInformacion = false;
                    } else {
                        $scope.sinInformacion = true;
                    }
                });
            }

            var obtenerAntiguedad = function() {
                $Ex.Execute("ObtenerAntiguedad",
                    $scope.filtro,
                    function(response) {
                        if (response.d.DistribucionCanal.length > 0) {
                            $scope.chartCanal.open(response.d.DistribucionCanal);
                            $scope.chartCanalMobile.open(response.d.DistribucionCanal);

                            $scope.monto = response.d.ComportamientoAnual;

                            if ($scope.monto.length > 0) {
                                var datosComportamientoAual = [
                                    {
                                        name: Ex.GetResourceValue("lblVencida"),
                                        data: _.pluck($scope.monto, "MontoVencido")
                                    },
                                    {
                                        name: Ex.GetResourceValue("lblCorriente"),
                                        data: _.pluck($scope.monto, "MontoCorriente")
                                    }
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
            };

            var openChartCobrabilidad = function() {
                $scope.chartCobrabilidadOptions.categories = _.pluck($scope.cobrabilidad, "Nombre");

                var series = [
                    { id: 1, type:"column", name:"Contractual", data:[]},
                    { id: 2, type:"column", name:"Extracontractual", data:[]},
                    { id: 3, type:"column", name:"Apv", data:[]},
                    { id: 999, type:"column", name:"Otros", data:[]},
                    { id: 4, type:"column", name:"Cobrabilidad", data:[]},
                    { id: 5, type:"line", name:"Objetivo", data:[]}
                ];
                var totalClientes = $scope.cobrabilidad.length;

                for (var i = 0; i < totalClientes; i++) {
                    var cliente = $scope.cobrabilidad[i];
                    var facturacion = cliente.Descuento + cliente.Cobrabilidad;

                    series[4].data.push(+(cliente.Cobrabilidad * 100 / facturacion).toFixed(2));
                    series[5].data.push(cliente.ObjetivoCobrabilidad);

                    for (var j = 0; j <= 3; j++) {
                        var serie = series[j];

                        var tipoNotaCredito = _.findWhere(cliente.TiposNotaCredito, { Id: serie.id });
                        var valor = tipoNotaCredito != null
                            ? +(tipoNotaCredito.Descuento * 100 / facturacion).toFixed(2)
                            : 0;
                        serie.data.push(valor);
                    }
                }

                $scope.chartCobrabilidad.open(series, false);
            };
                
            var obtenerCobrabilidad = function () {
                $Ex.Execute("ObtenerCobrabilidad", $scope.filtro, function (response) {
                    $scope.cobrabilidad = response.d;
                    openChartCobrabilidad();
                });
            };

            $scope.actualizar = function() {
                try {
                    if ($scope.esVistaPrincipal) {
                        obtenerResumen();
                    } else {
                        vistaPadre.metodo();
                    }
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.vistasPadre = [
                { vistaId: 1, name: Ex.GetResourceValue("btnAntiguedad"), metodo: obtenerAntiguedad },
                { vistaId: 2, name: Ex.GetResourceValue("btnCalidadDias"), metodo: obtenerResumen },
                { vistaId: 3, name: Ex.GetResourceValue("btnCobrabilidad"), metodo: obtenerCobrabilidad, graficaTabla: true }
            ];

            $scope.vistas = [
                { vistaId: 1, name: Ex.GetResourceValue("btnResumen"), vistaPadreId: 1 },
                { vistaId: 2, name: Ex.GetResourceValue("btnCanal"), vistaPadreId: 1 },
                { vistaId: 3, name: Ex.GetResourceValue("btnCliente"), vistaPadreId: 1 },
                { vistaId: 4, name: Ex.GetResourceValue("btnAnalista"), vistaPadreId: 1 },
                { vistaId: 5, name: Ex.GetResourceValue("btnVendedor"), vistaPadreId: 1 },
                { vistaId: 6, name: Ex.GetResourceValue("btnRegion"), vistaPadreId: 1 },
                { vistaId: 7, name: Ex.GetResourceValue("btnCanal"), vistaPadreId: 2, graficaTabla: true },
                { vistaId: 8, name: Ex.GetResourceValue("btnCliente"), vistaPadreId: 2 },
                { vistaId: 9, name: Ex.GetResourceValue("btnRegion"), vistaPadreId: 2, graficaTabla: true }
            ];

            $scope.cambiarVistaPrincipal = function (esVistaPrincipal, vista) {
                $scope.esVistaPrincipal = esVistaPrincipal;
                $scope.vistaPadreId = 0;
                $scope.filtro = {};
                $scope.filtro.Anio = new Date().getFullYear();
                $scope.filtro.MesId = new Date().getMonth() + 1;
                vistaPadre = {};
                $scope.vista = {};
                vistaIdPrevia = 0;
                $scope.titulo = "";
                $scope.sinInformacion = false;
                $scope.esVerFiltros = false;
                
                if (!esVistaPrincipal) {
                    $scope.vistaPadreId = vista.vistaId;
                    $scope.vista = vista.vistaId === 1 ? $scope.vistas[0] : $scope.vistas[6];
                    vistaIdPrevia = vista.vistaId === 1 ? 1 : 7;

                    if (vistaIdPrevia !== 7 || $scope.vistaPadreId === 3) {
                        vista.metodo();
                    }

                    vistaPadre = vista;
                    $scope.esGrafica = true;
                    $scope.titulo = " - " + vista.name;
                }
            }

            $scope.cambiarVista = function (vista) {
                //Evita que busque datos cuando se le da click en la pestaña activa
                if (vistaIdPrevia !== vista.vistaId) {
                    $scope.esGrafica = true;

                    $scope.vista = vista;
                    vistaIdPrevia = vista.vistaId;

                    if (vista.vistaId >= 7 && vista.vistaId <= 9) {
                        obtenerResumen();
                    }
                }
            }

            $scope.exportar = function () {
                try {
                    Ex.load(true);
                    var datos = angular.copy($scope.filtro);
                    datos.VistaId = $scope.vista.vistaId;
                    datos.VistaPadreId = $scope.vistaPadreId;
                    datos.EsExportar = true;
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