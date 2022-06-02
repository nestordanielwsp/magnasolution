(function () {
    app.controller('repActivity', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;
            $scope.filtro = { vistaId: 1}
            $scope.vista = { inicio: true, detalle: false};
            $scope.esGrafica = true;
            $scope.anios = util.getYearArray(4);
            var anioActual = new Date().getFullYear();
            $scope.mesActualId = new Date().getMonth() + 1;
            $scope.Reg = [];
            $scope.filtro.Anio = anioActual;
            $scope.filtro.MesId = ""; 

            $scope.meses = util.getMonthArray();

            var obtenerActivityDetalle = function () {
                $Ex.Execute("ObtenerActivityGeneral", $scope.filtro, function (response) { 
                    if(response.d.length > 0) {
                        $scope.Reg = response.d;
                        $scope.sinInformacion = false;
                    } else {
                        $scope.sinInformacion = true;
                    }
                    });         
            }
            var obtenerResumen = function () {
                $Ex.Execute("ObtenerActivityResumen", $scope.filtro, function (response) {
                    if (response.d.length > 0) {
                        $scope.Res = response.d;
                        $scope.sinInformacion = false;
                    } else {
                        $scope.sinInformacion = true;
                    }
                });   
            }

            $scope.vistas = [
                { vistaId: 1, name: Ex.GetResourceValue("btnResumen"), metodo: obtenerResumen },
                { vistaId: 2, name: Ex.GetResourceValue("btnDetalle"), metodo: obtenerActivityDetalle },
            ];

            $scope.actualizar = function () {
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

            var vistaIdPrevia = 1;
            var vistaSeleccionada = $scope.vistas[0];
            $scope.cambiarVista = function (vista) {
                //Evita que busque datos cuando se le da click en la pestaña activa
                if (vistaIdPrevia !== vista.vistaId) {
                    $scope.filtro = {
                        Anio: anioActual,
                        MesId: $scope.mesActualId,
                        vistaId: vista.vistaId
                    }
                    $scope.filtro.vistaId = vista.vistaId;

                    $scope.esGrafica = true;
                    vista.metodo();
                    vistaSeleccionada = vista;
                    vistaIdPrevia = vista.vistaId;
                }
            }
        }]);
})();