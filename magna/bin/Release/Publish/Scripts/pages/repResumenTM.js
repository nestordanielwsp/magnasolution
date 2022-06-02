(function () {
    app.controller('repResumenTM', ['$scope', '$http', 'enums', 'util', '$timeout',
        function ($scope, $http, enums, util, $timeout) {
            $Ex.Http = $http;

            var fechaActual = new Date();
            $scope.filtro = { vistaId: 1, vistaSegId: 1, Marcas: [], Estatus: [], Canales: [] };
            $scope.filtroRE = { Marcas: [], Cuentas: [], Anio: fechaActual.getFullYear() };

            $scope.Year = util.getYearArray(4);
            $scope.Meses = util.getMonthArray(12, false);

            $scope.filtro.Anio = fechaActual.getFullYear();
            $scope.marcas = MarcaInfo;
            $scope.canales = [];
            $scope.canalesVisual = [];
            $scope.estatus = EstatusInfo;
            $scope.cuentas = CuentasInfo;

            $scope.SuperFiltro = {};

            $scope.esVentas = esVentasInfo;

            $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
            $scope.canalesOptions = util.getOptionsMultiselect("CanalId", "NombreCanal");
            $scope.estatusOptions = util.getOptionsMultiselect("EstatusId", "Nombre");
            $scope.cuentasOptions = util.getOptionsMultiselect("CuentaContableId", "CuentaContable");

            var getCanales = function (item) {
                //var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                //$scope.marcasSeleccionadas.push(marca);
                $scope.SuperFiltro.Marcas = _.pluck($scope.filtro.Marcas, 'id').join(",");

                $scope.marcasJoin = $scope.SuperFiltro.Marcas;

                obtenerCanales($scope.marcasJoin);
            }

            var removeCanales = function (item) {
                //var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                //var index = $scope.marcasSeleccionadas.indexOf(marca);

                //$scope.marcasSeleccionadas.splice(index, 1);
                $scope.SuperFiltro.Marcas = _.pluck($scope.filtro.Marcas, 'id').join(",");

                obtenerCanales($scope.SuperFiltro.Marcas);
            };

            var obtenerCanales = function (marcas) {

                try {
                    var marcasSel = {};
                    marcasSel.Marcas = marcas;

                    $Ex.Execute("ObtenerCanalesPorMarca", marcasSel, function (response) {

                        $scope.filtro.Canales = [];

                        var canales = response.d.Canales;
                        var canalesVisual = response.d.CanalesVisual;

                        $scope.canales = canales;
                        $scope.canalesVisual = canalesVisual;

                        Ex.load(false);

                    });


                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }

            }

            $scope.multiselectEventos = {
                onItemSelect: getCanales,
                onItemDeselect: removeCanales,
                onDeselectAll: function () {
                    $scope.canales = [];
                    $scope.canalesVisual = [];

                    $scope.filtro.Canales = [];

                },
                onSelectAll: function () {

                    $timeout(function () {
                        obtenerCanales($scope.marcasJoin);
                    }, 3000);
                },
            };

            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

            $scope.ObtenerResumenTM = function () {
                $Ex.Execute("GetRepResumenTM", $scope.filtro, function (response) {
                    $scope.resumenTm = response.d;
                });
            }

            $scope.Buscar = function () {
                $scope.filtro.MarcaIds = _.pluck($scope.filtro.Marcas, 'id').join(",");
                $scope.filtro.CanalIds = _.pluck($scope.filtro.Canales, 'id').join(",");
                $scope.filtro.EstatusIds = _.pluck($scope.filtro.Estatus, 'id').join(",");

                if ($scope.filtro.vistaId === 1) {
                    getResumenTM();
                } else if ($scope.filtro.vistaId === 2) {
                    obtenerSeguimientoActivity();
                } else if ($scope.filtro.vistaId === 3) {
                    getActivityProNCan();
                }
            };

            var getResumenTM = function () {
                $scope.ObtenerResumenTM();
            };

            $scope.GetSeguimientoActivity = function () {
                $Ex.Execute("ObtenerActivityGeneral",
                    $scope.filtro,
                    function (response) {
                        $scope.Reg = response.d;
                    });
            };

            var obtenerSeguimientoActivity = function () {
                //$Ex.Execute("ObtenerActivityGeneral",
                //    $scope.filtro,
                //    function (response) {
                //        $scope.Reg = response.d;
                //    });
                $scope.GetSeguimientoActivity();
            };

            var getActivityProNCan = function () {

                $Ex.Execute("obtenerActivityProNCan", $scope.filtro, function (response) {
                    $scope.ProcesoCancelado = response.d;
                });
            }

            $scope.vistas = [
                { vistaId: 1, name: Ex.GetResourceValue("btnControlTM"), metodo: getResumenTM },
                { vistaId: 2, name: Ex.GetResourceValue("btnSeguimientoAct"), metodo: obtenerSeguimientoActivity },
                { vistaId: 3, name: Ex.GetResourceValue("btnActProNCancel"), metodo: getActivityProNCan },
                //{ vistaId: 4, name: Ex.GetResourceValue("btnDetalleRealEjecutado"), metodo: getActivityProNCan }
            ];


            $scope.Detalle1Collapse = function (item) {
                item.Collapsed = !item.Collapsed
                item.Detalle1 = _.where($scope.Principal.Detalle1, { Marca: item.Marca });
            }


            $scope.Detalle2Collapse = function (item) {
                item.Collapsed = !item.Collapsed
                item.Detalle2 = _.where($scope.Principal.Detalle2, { Marca: item.Marca, CuentaConcepto: item.CuentaConcepto });
            }

            $scope.ObtenerDetalle1 = function () {
                $Ex.Execute("GetDetalle", $scope.filtro, function (response) {
                    $scope.Detalle = response.d;
                });
            }

            var vistaIdPrevia = 1;
            $scope.cambiarVista = function (vista, opcion) {
                $scope.filtro.Activity = "";
                $scope.filtro.Canales = [];
                $scope.filtro.Estatus = [];

                if (opcion === "Seguimiento") {
                    $scope.filtro.vistaSegId = vista.vistaId;
                } else if (vistaIdPrevia !== vista.vistaId) {
                    $scope.filtro.vistaId = vista.vistaId;
                    vistaSeleccionada = vista;
                    vistaIdPrevia = vista.vistaId;
                    vista.metodo();
                }

                if (vista.vistaId !== 1) {
                    $scope.estatus = _.filter(EstatusInfo, function (estatus) {
                        return vista.vistaId === 2 && estatus.EstatusId > enums.estatusActivity.enAutorizacion ||
                            estatus.EstatusId === enums.estatusActivity.enAutorizacion ||
                            estatus.EstatusId === enums.estatusActivity.pendientePublicar ||
                            estatus.EstatusId === enums.estatusActivity.rechazado;
                    });
                }
            };

            $scope.Detalle1ByMonth = function (item) {
                item.Collapsed = !item.Collapsed;
                item.DtlByMonth = _.where($scope.Principal.Detalle2ByMonth, { Marca: item.Marca, CuentaConcepto: item.CuentaConcepto });
            }

            $scope.btnGastoRealEjecutado = function () {
                $scope.gReal = !$scope.gReal;
            }

            $scope.exportar = function () {
                $Ex.Execute("Exportar", $scope.filtro, function (response) {
                    if (response.d) {
                        window.location = "DownLoadPage.aspx?d=" + getRandom();
                    }
                });
            };

            $scope.ObtenerReporteRealEjecutado = function () {
                $Ex.Execute("GetRepRealEjecutado", $scope.filtro, function (response) {
                    $scope.DetalleRealEjecutado = response.d;
                    $scope.HabilitarExportarRE = $scope.DetalleRealEjecutado.length > 0 ? true : false;
                });
            }

            $scope.MostrarColumnaMes = function (mesId) {

                if ($scope.filtro.Mes === undefined)
                    return true;
                else if ($scope.filtro.Mes === mesId)
                    return true;
                else
                    return false;
            }

            $scope.ExportarRepRealEjecutado = function () {
                $Ex.Execute("ExportarDetalleRealEjecutado", $scope.filtro, function (response) {
                    if (response.d) {
                        window.location = "DownLoadPage.aspx?d=" + getRandom();
                    }
                });
            };

            if ($scope.esVentas) {
                $scope.vistas.splice(0, 1);
                $scope.filtro.vistaId = 2;
                $scope.GetSeguimientoActivity();
            }
            else {
                $scope.ObtenerResumenTM();
            }
            
        }]);
}
)();