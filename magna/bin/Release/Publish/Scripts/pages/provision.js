(function () {
    app.controller('provision', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;

            $scope.filtro = {
                Estatus: []
            };
            $scope.activities = [];         
            $scope.estatusProvisiones = EstatusProvisiones;
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();
            $scope.estatusOptions = util.getOptionsMultiselect("EstatusProvisionesId", "Nombre");
            $scope.Meses = [
                {
                    id: 1, nombre: "Enero"
                },
                {
                    id: 2, nombre: "Febrero"
                },
                {
                    id: 3, nombre: "Marzo"
                },
                {
                    id: 4, nombre: "Abril"
                },
                {
                    id: 5, nombre: "Mayo"
                },
                {
                    id: 6, nombre: "Junio"
                },
                {
                    id: 7, nombre: "Julio"
                },
                {
                    id: 8, nombre: "Agosto"
                },
                {
                    id: 9, nombre: "Septiembre"
                },
                {
                    id: 10, nombre: "Octubre"
                },
                {
                    id: 11, nombre: "Noviembre"
                },
                {
                    id: 12, nombre: "Diciembre"
                }
            ];

            //Permite ocultar o cambiar de pantalla, de inicio se muestra la pantalla principal.
            $scope.pantallas = {
                principal: 1,
                detalle: 2,
            };
            $scope.pantallaId = $scope.pantallas.principal;

            $scope.vistas = [];

            $scope.cambiarVista = function (vista) {
                $scope.vista = vista;
            };
        
            $scope.ObtenerDetalle = function (provisionId) {
                $scope.flujoProvisiones = [];
                $scope.filtro.ProvisionId = provisionId;

                $Ex.Execute("ObtenerProvisionDetalle", $scope.filtro, function (response) {
                    $scope.provisionesDetalle = response.d;
                    $scope.pantallaId = $scope.pantallas.detalle;

                    $scope.habilitarAciones = false;

                    if ($scope.provisionesDetalle.lenght > 0)
                        $scope.habilitarAciones = $scope.provisionesDetalle[0].Aprobador;
                });                
            };

            $scope.Obtenerprovisiones = function () {
                $scope.filtro.EstatusIds = _.pluck($scope.filtro.Estatus, 'id').join(",");

                $Ex.Execute("ObtenerProvisiones", $scope.filtro, function (response) {
                    $scope.provisiones = response.d;
                });

                $Ex.Execute("ObtenerActivities", $scope.filtro, function (response) {
                    $scope.activities = response.d;
                });
            };

            $scope.Obtenerprovisiones();

            $scope.DescargarExcel = function () {
                try {
                    Ex.load(true);
                    var datos = $scope.filtro || {};
                    $Ex.Execute("DescargarExcel", $scope.filtro, function (response, isInvalid) {
                        if (isInvalid) {
                            return;
                        }
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

            $scope.aprobar = function () {
                try {
                    Ex.load(true);
                    var datos = $scope.filtro || {};
                    $Ex.Execute("Aprobar", $scope.filtro, function (response, isInvalid) { 
                        if (isInvalid) {
                            return;
                        }
                        window.location = "Provision.aspx";
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
           
            $scope.rechazar = function () {
                try {
                    Ex.load(true);
                    var datos = $scope.filtro || {};
                    $Ex.Execute("Rechazar", $scope.filtro, function (response, isInvalid) {
                    if (isInvalid) {
                            return;
                        }
                        window.location = "Provision.aspx";
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
           
        }]);
})();