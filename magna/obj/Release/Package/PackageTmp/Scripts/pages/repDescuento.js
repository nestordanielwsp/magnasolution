(function () {
    app.controller('repDescuento', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.filtro = { vistaId: 1, Cuentas: [], TiposDescuento: [] };
            $scope.vista = { inicio: true, canalTipo: false, canalCuenta: false, cuentaCanal: false };
            $scope.esGrafica = true;
            $scope.canales = CanalInfo;
            $scope.regiones = RegionInfo;
            $scope.tiposDescuento = TipoDescuentoInfo;
            $scope.tiposNota = TipoNotaInfo;
            $scope.cuentas = CuentaContableInfo;
            $scope.chartTotalCanal = {};
            $scope.chartCanalMobile = {};
            $scope.chartTotalTipo = {};
            $scope.chartTipoMobile = {};
            $scope.chartTopClientes = {};
            $scope.chartClientesTablet = {};
            $scope.chartClientesMobile = {};
            $scope.chartTipoData = {};
            $scope.chartTipoDataMobile = {};
            $scope.chartCuentaCanal = {};
            $scope.anios = util.getYearArray(4);
            
            if ($scope.canales.length === 1) {
                $scope.filtro.CanalId = $scope.canales[0].CanalId;
            }

            var anioActual = new Date().getFullYear();
            $scope.mesActualId = new Date().getMonth() + 1;

            $scope.filtro.Anio = anioActual;
            $scope.filtro.MesId = $scope.mesActualId;

            $scope.meses = util.getMonthArray();

            $scope.cuentasOptions = util.getOptionsMultiselect("CuentaContableId", "NombreCuentaContable");
            $scope.tiposDecuentoOptions = util.getOptionsMultiselect("TipoDescuentoId", "NombreTipoDescuento");
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

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

            $scope.chartOptions = {
                size: "90%",
                innerSize: "45%",
                legend: {
                    align: 'center',
                    verticalAlign: 'bottom',
                    layout: 'horizontal'
                }
            }

            $scope.tipoChartOptions = $scope.chartOptions;
            $scope.topClientesOptions = {
                size: "90%", innerSize: "50%"
            };
            $scope.canalTipoOptions = { is3d: true, xFontSize: "16px", categories: [] };
            $scope.cuentaCanalOptions = {categories: [] };

            $scope.chartOptionsMobile = {
                size: "100%",
                innerSize: "50%",
                labelEnabled: false,
                legend: {
                    align: 'center',
                    verticalAlign: 'bottom',
                    layout: 'horizontal'
                }
            }

            $scope.chartOptionsTipoMobile = {
                legend: {
                    align: 'center',
                    verticalAlign: 'bottom',
                    layout: 'horizontal'
                }
            }

            var obtenerResumen = function () {
                try {
                    $Ex.Execute("ObtenerResumen", $scope.filtro, function (response) {
                        if (response.d.TopClientes.length > 0) {
                            $scope.chartTotalCanal.open(response.d.TotalCanal);
                            $scope.chartCanalMobile.open(response.d.TotalCanal);
                            $scope.chartTotalTipo.open(response.d.TotalTipo);
                            $scope.chartTipoMobile.open(response.d.TotalTipo);
                            $scope.chartTopClientes.open(response.d.TopClientes);
                            $scope.chartClientesTablet.open(response.d.TopClientes);
                            $scope.chartClientesMobile.open(response.d.TopClientes);
                            $scope.sinInformacion = false;
                        } else {
                            $scope.sinInformacion = true;
                        }                        
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            var obtenerCanalTipo = function () {
                try {
                    $Ex.Execute("ObtenerCanalTipo", $scope.filtro, function (response) {
                        if (response.d.TablaCanalTipo.length > 0) {
                            $scope.tablaCanalTipo = response.d.TablaCanalTipo;

                            $scope.canalesTipo = response.d.CanalTipo;

                            var canalesTipo = response.d.CanalTipo;
                            var totalDatos = canalesTipo.length;
                            if (totalDatos > 0) {
                                var canalTipoKeys = _.keys(canalesTipo[0]);
                                $scope.canalTipoOptions.categories = [];
                                $scope.chartOptionsTipoMobile.categories = [];

                                if (canalTipoKeys.length > 1) {
                                    for (var i = 0; i < totalDatos; i++) {
                                        var canalTipo = canalesTipo[i];
                                        canalTipo.data = [];

                                        for (var key in canalTipo) {
                                            if (canalTipo.hasOwnProperty(key) && key !== "name" && key !== "data") {
                                                //Se agregan las categorias para la grafica de barras, solo la primera vez
                                                //para no repetir los nombres
                                                if (i === 0) {
                                                    $scope.canalTipoOptions.categories.push(key);
                                                    $scope.chartOptionsTipoMobile.categories.push(key);
                                                }

                                                var cantidad = parseInt(canalTipo[key]);
                                                canalTipo.data.push(isNaN(cantidad) ? 0 : cantidad);
                                            }
                                        }
                                    }
                                }
                            }

                            $scope.chartTipoData.open(canalesTipo);
                            $scope.chartTipoDataMobile.open(canalesTipo);
                            $scope.sinInformacion = false;
                        } else {
                            $scope.sinInformacion = true;
                        }                        
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            var obtenerClienteCuenta = function () {
                try {
                    $Ex.Execute("ObtenerClienteCuenta", $scope.filtro, function (response) {
                        if (response.d.length > 0) {
                            $scope.mesActualId = $scope.filtro.Anio === anioActual ? $scope.mesActualId : 12;
                            $scope.tablaClienteCuenta = response.d;
                            $scope._tablaClienteCuenta = response.d;
                            $scope.sinInformacion = false;
                        } else {
                            $scope.sinInformacion = true;
                        }
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            var vistaIdPrevia = 1;
            var obtenerCanalCuenta = function () {
                try {
                    $Ex.Execute("ObtenerCanalCuenta", $scope.filtro, function (response) {
                        if (response.d.TablaCuentaCanal.length > 1) {
                            $scope.tablaCuentaCanal = response.d.TablaCuentaCanal;

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
                { vistaId: 1, name: Ex.GetResourceValue("btnResumen"), metodo: obtenerResumen },
                { vistaId: 2, name: Ex.GetResourceValue("btnCanalTipo"), metodo: obtenerCanalTipo },
                { vistaId: 3, name: Ex.GetResourceValue("btnClienteCuenta"), metodo: obtenerClienteCuenta },
                { vistaId: 4, name: Ex.GetResourceValue("btnCuentaCanal"), metodo: obtenerCanalCuenta }
            ];

            var vistaSeleccionada = $scope.vistas[0];
            $scope.cambiarVista = function (vista) {
                //Evita que busque datos cuando se le da click en la pestaña activa
                if (vistaIdPrevia !== vista.vistaId) {
                    //$scope.filtro = {
                    //    Anio: anioActual,
                    //    MesId: $scope.mesActualId,
                    //    vistaId: vista.vistaId
                    //}
                    $scope.filtro.vistaId = vista.vistaId;

                    $scope.esGrafica = true;

                    vista.metodo();
                    vistaSeleccionada = vista;
                    vistaIdPrevia = vista.vistaId;
                }                
            }

            $scope.expandirCanal = function (item, vista) {
                item.esColapsado = !item.esColapsado;

                var data = vista === "canalTipo" ? $scope.tablaCanalTipo : $scope.tablaCanalCuenta;

                var datos = _.where(data, { CanalId: item.CanalId });

                var totaldatos = datos.length;

                for (var i = 0; i < totaldatos; i++) {
                    var dato = datos[i];
                    if (!dato.hasOwnProperty("EsCanal")) {
                        dato.esOculto = item.esColapsado;
                    }
                }
            }

            $scope.expandirFila = function (item, esPorCliente) {
                item.esColapsado = !item.esColapsado;
                var datos = esPorCliente ? _.where($scope.tablaClienteCuenta, { ClienteId: item.ClienteId }) :
                    _.where($scope.tablaCuentaCanal, { TipoNotaId: item.TipoNotaId });

                var totaldatos = datos.length;

                for (var i = 0; i < totaldatos; i++) {
                    var dato = datos[i];
                    if (!dato.hasOwnProperty("EsPrimerNivel")) {
                        dato.esOculto = item.esColapsado;
                    }
                }
            }

            $scope.actualizar = function () {
                $scope.filtro.CuentasIds = _.pluck($scope.filtro.Cuentas, 'id').join(",");
                $scope.filtro.TiposDecuentoIds = _.pluck($scope.filtro.TiposDescuento, 'id').join(",");
                vistaSeleccionada.metodo();
            }

            $scope.exportar = function () {
                try {
                    Ex.load(true);
                    $Ex.Execute("Exportar", $scope.filtro, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }                      
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            };

            obtenerResumen();
        }]);
})();