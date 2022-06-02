(function () {
    app.controller('descExtracontractual', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.tiposActividad = TipoActividadInfo;
            $scope.canales = CanalInfo;
            $scope.marcas = MarcaInfo;
            $scope.estatusLista = EstatusInfo;
            $scope.filtro = { Marcas: [], Fecha: { StartDate: "", EndDate: "" } };
            $scope.forma = {};
            $scope.descuentos = [];
            $scope.descuento = { Marcas: [], Canales: [] };
            $scope.esAutorizador = false;
            var centroCostos = [];
            var subcuentas = [];

            $scope.setCentroCosto = function () {
                var canal = _.find($scope.canales, { CanalId: $scope.descuento.CanalId });
                $scope.descuento.CentroCostos = canal.CentroCostos;
            }

            var setCentroCostos = function (item) {
                var canal = _.findWhere($scope.canales, { CanalId: item.id });
                centroCostos.push(canal.CentroCostos);
                $scope.descuento.CentroCostos = centroCostos.join(",");
            }

            var removeCentroCostos = function (item) {
                var canal = _.findWhere($scope.canales, { CanalId: item.id });
                var index = _.indexOf(centroCostos, canal.CentroCostos);
                centroCostos.splice(index, 1);
                $scope.descuento.CentroCostos = centroCostos.join(",");
            }

            var setSubcuenta = function (item) {
                var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                subcuentas.push(marca.SubcuentaContable);
                $scope.descuento.Subcuenta = subcuentas.join(",");
            }

            var removeSubcuenta = function (item) {
                var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                var index = _.indexOf(subcuentas, marca.SubcuentaContable);
                subcuentas.splice(index, 1);
                $scope.descuento.Subcuenta = subcuentas.join(",");
            }

            $scope.canalesOptions = util.getOptionsMultiselect("CanalId", "NombreCanal");
            $scope.multiselectCanalEventos = {
                onItemSelect: setCentroCostos,
                onItemDeselect: removeCentroCostos,
                onDeselectAll: function () { $scope.descuento.CentroCostos = ""; centroCostos = []; }
            }

            $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
            $scope.multiselectEventos = {
                onItemSelect: setSubcuenta,
                onItemDeselect: removeSubcuenta,
                onDeselectAll: function () { $scope.descuento.Subcuenta = ""; subcuentas = []; }
            }
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

            $scope.cuentaOptions = {
                idProp: "CuentaContableId",
                displayProp: "NombreCuentaContable",
                methodName: "BuescarCuentas"
            };

            $scope.fileOptions = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true,
                maxFilesize: Ex.GetResourceValue('maxFileSize'),
                validExtensions: Ex.GetResourceValue('validExtensions'),
                disabled: false
            };
            $scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };

            $scope.setParametrosArchivo = function (response) {
                $scope.descuento = _.defaults(response, $scope.descuento);
            }

            $scope.disabledOptions = {
                disabled: false
            }

            $scope.agregar = function () {
                $scope.descuento = { Marcas: [], Canales:[], Active:true, Fecha: null };
                $scope.submitted = false;
                $scope.esDetalle = true;
                $scope.activityId = 0;
                $scope.disabledOptions.disabled = false;
                subcuentas = [];
                centroCostos = [];
            }

            $scope.getDescuento = function (item) {
                try {
                    Ex.load(true);
                    $Ex.Execute("GetDescuento", item, function (response) {
                        $scope.descuento = response.d;
                        $scope.descuento.deshabilitarForma = true;
                        $scope.activityId = response.d.ActivityId;
                        $scope.descuento.Fecha = { StartDate: response.d.VigenciaInicio, EndDate: response.d.VigenciaFin }
                        subcuentas = $scope.descuento.Subcuenta.split(",");
                        centroCostos = $scope.descuento.CentroCostos.split(",");

                        $scope.fileOptions.disabled = $scope.descuento.NoEditable || $scope.esAutorizador;
                        $scope.disabledOptions.disabled = $scope.descuento.NoEditable || $scope.esAutorizador;

                        $timeout(function () {
                            $scope.esDetalle = true;                            
                        }, 50);
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.getDescuentos = function () {
                try {
                    Ex.load(true);
                    $scope.filtro.MarcaIds = _.pluck($scope.filtro.Marcas, 'id').join(",");
                    $scope.filtro.VigenciaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                    $scope.filtro.VigenciaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";
                    $Ex.Execute("GetDescuentos", $scope.filtro, function (response) {
                        $scope.descuentos = response.d;
                        $scope._descuentos = response.d;
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.calcularBalance = function() {
                if ($scope.descuento.MontoEnAutorizacion) {
                    $scope.descuento.Balance = $scope.descuento.MontoAutorizado - $scope.descuento.MontoEnAutorizacion
                        - $scope.descuento.MontoQad;
                    $scope.descuento.Balance = +($scope.descuento.Balance.toFixed(2));
                }
            }

            $scope.guardar = function () {
                try {
                    Ex.load(true);
                    $scope.submitted = true;

                    if (!$scope.descuento.EsSellIn && !$scope.descuento.EsSellOut) {
                        Ex.mensajes(Ex.GetResourceValue("msgImpractoRequerido"));
                    } else {
                        $scope.descuento.VigenciaInicio = $scope.descuento.Fecha ? $scope.descuento.Fecha.StartDate : "";
                        $scope.descuento.VigenciaFin = $scope.descuento.Fecha ? $scope.descuento.Fecha.EndDate : "";
                        $scope.descuento.Active = !$scope.descuento.Inactivo;
                        $Ex.Execute("GuardarDescuento", $scope.descuento, function (response, isInvalid) {
                            if (!isInvalid) {
                                $scope.getDescuentos();
                                $scope.esDetalle = false;
                                Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"));
                            }
                        }, $scope.forma);
                    }                    
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }
          
            $scope.openDocumento = function () {
                try {
                    Ex.load(true);
                    $Ex.Execute("OpenDocumento", $scope.descuento, function (response, isInvalid) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                        else {
                            Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            };

            $scope.exportar = function (esDetalle) {
                try {
                    Ex.load(true);
                    var data = esDetalle ? $scope.descuento : $scope.filtro;
                    data.ExportarDetalle = esDetalle;

                    $Ex.Execute("Exportar", data, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            };

            try {
                $Ex.Execute("ValidarTipoUsuario", {}, function (response) {
                    $scope.esAutorizador = response.d;
                    $scope.getDescuentos();
                });

            } catch (ex) {
                Ex.mensajes(ex.message, 4);
            }
        }]);
})();