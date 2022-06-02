(function () {
    app.controller('tareasPendientes', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;

            $scope.filtro = {
                Estatus: [], Tareas: [], Responsables: [], Fecha: { StartDate: "", EndDate: "" }, EstatusId: 1
            };
            $scope.pantallas = {
                principal: 1,
                altaProyecto: 2,
                creacionCodigo: 3,
                altaProvision: 4,
                cerrarProyecto: 5,
                actualizarFechaCierre: 6,
                cierreCodigo: 7,
                tarea: 8
            };
            $scope.pantallaId = $scope.pantallas.principal;
            $scope.tareas = [];
            $scope.codigosPromocionales = [];
            $scope.Actvity = "";
            $scope.estatus = EstatusTareasPendientes;
            $scope.filtroTareas = [];
            $scope.responsables = [/*{ id: 1, nombre: "Responsable 1" }*/];
            $scope.altaProyecto = {};
            $scope.cerrarProyecto = {};
            $scope.altaCodigo = {};
            $scope.cierreCodigo = {};
            $scope.estatusOptions = util.getOptionsMultiselect("EstatusId", "Nombre");
            $scope.tareasOptions = util.getOptionsMultiselect("TareaPendienteId", "Nombre");
            $scope.responsableOptions = util.getOptionsMultiselect("id", "nombre");
            $scope.filtroTareas = TareasPendientes;
            //$scope.proveedores = ProveedorInfo;
            $scope.articuloOptions = { idProp: "ArticuloId", displayProp: "Articulo", methodName: "GetArticulos" };
            $scope.proveedoresOptions = { idProp: "ProveedorId", displayProp: "Proveedor", methodName: "GetProveedores" };
            $scope.proveedoresMatrizOptions = { idProp: "ProveedorId", displayProp: "Proveedor", methodName: "GetProveedoresMatriz" };
            $scope.materialMatrizOptions = { idProp: "MaterialId", displayProp: "Material", methodName: "GetMaterialMatriz" };
            $scope.FilterProveedor = { ArticuloId: 0 };
            $scope.FilterArticulo = { ProveedorId: 0 };
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();
            $scope.forma = {};
            //$scope.tarea.TienePoP = false;

            $scope.ObtenerTareas = function () {
                $scope.filtro.TareaIds = _.pluck($scope.filtro.Tareas, 'id').join(",");

                $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";
                $Ex.Execute("ObtenerTareas", $scope.filtro, function (response) {
                    $scope.tareas = response.d;
                });
            }

            $scope.ObtenerTarea = function (tarea) {
                $scope.pantallaId = $scope.pantallas.tarea;
                $Ex.Execute("ObtenerTarea", tarea, function (response) {
                    $scope.tarea = response.d;
                    $scope.sourceOtros = _.where(response.d.Otros, { RubroId: 4 });
                    $scope.sourceConcurso = _.where(response.d.Otros, { RubroId: 3 });
                    $scope.verTabla = response.d.Promociones.length > 0;
                    $scope.filtro.Realizado = $scope.tarea.Realizado ? true : false;
                    $scope.tarea.Activity = tarea.Codigo;
                    $scope.tarea.EsTienePoP = $scope.tarea.TienePoP;
                    $scope.tarea.TienePoP = response.d.PoP.length > 0 ;
                    $scope.tarea.tieneOtros = $scope.sourceOtros.length > 0 ;
                    $scope.tarea.tieneConcurso = $scope.sourceConcurso.length > 0;
                    $scope.tarea.TienePromociones = $scope.tarea.TienePromocion;
                    $scope.habilitado = $scope.tarea.Realizado;
                    if ($scope.verTabla) {
                        $scope.promociones = $scope.tarea.Promociones;
                    }
                });
            }

            $scope.hasRealizado = function (value) {
                return (value === false);
            }

            $scope.ChangeStatus = function (key, promocion, tarea) {
                if (tarea == 4) {
                    var value = promocion == 0 ? false : true;
                }
                if (tarea == 5) {
                    var value = promocion == 1 ? false : true;
                }
                $scope.promociones[key].Estatus = value;
            }

            $scope.ActualizarTarea = function () {
                try {
                    Ex.load(true);
                    var success = true;
                    var datos = $scope.filtro || {};
                    $scope.submitted = true;

                    if ($scope.tarea.TareaPendienteId === 4 || $scope.tarea.TareaPendienteId === 5) {
                        //$scope.filtro.Promociones = _.where($scope.promociones, { Realizado: true });
                        var promociones = _.where($scope.promociones, { Estatus: false });

                        if (promociones.length == 0) {
                            $scope.tarea.Realizado = true;
                        }
                    }
                    else {
                        $scope.tarea.Realizado = $scope.tarea.Realizado;
                    }

                    /*if ($scope.tarea.TienePoP) {
                        angular.forEach($scope.tarea.PoP, function (pop) {
                            if (pop.CodigoArticulo == "") {
                                success = false;
                                Ex.mensajes("Ingresar código a todos los artículos", 4);
                            }
                        });
                    }*/

                    if (success) {
                        /*$Ex.Execute("ActualizarTarea", $scope.tarea, function () {
                            Ex.load(false);
                            $scope.pantallaId = $scope.pantallas.principal;
                            $scope.ObtenerTareas();

                        });*/
                        $Ex.Execute("ActualizarTarea", $scope.tarea, function (response, isInvalid) {

                            if (!isInvalid) {
                                $scope.submitted = false;
                                Ex.load(false);
                                $scope.pantallaId = $scope.pantallas.principal;
                                $scope.ObtenerTareas();
                            }
                        }, $scope.forma);
                    }
                    
                }
                catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.setMaterialCodigo = function (articuloSeleccionado, item) {
                $scope.FilterProveedor = { MaterialId: articuloSeleccionado.MaterialId };
            };

            $scope.setPropiedadProveedor = function (proveedorSeleccionado, item) {
                $scope.FilterArticulo = { ProveedorId: proveedorSeleccionado.ProveedorId };
            };

            $scope.DescargarExcel = function (promocionId,key) {
                try {
                    Ex.load(true);
                    var Promocion = $scope.tarea.Promociones[key];  //{ PromocionId: promocionId }
                    $Ex.Execute("DescargarExcel", Promocion, function () {
                        window.location = "DownLoadPage.aspx";
                        setTimeout(function () {
                            Ex.load(false);
                        }, 100);
                    });
                }
                catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.ObtenerTareas();

        }]);
})();