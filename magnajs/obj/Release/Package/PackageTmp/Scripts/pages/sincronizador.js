(function () {
    app.controller('sincronizador', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.sincronizadores = [];
            $scope.logErrores = [];
            $scope.modal = {};
            $scope.modaltipocambio = {};

            const CarteraCierreMesId = 11;

            $scope.getSincronizadores = function () {
                try {
                    $Ex.Execute("GetSincronizadores", $scope.filtro, function (response) {
                        $scope.sincronizadores = response.d;
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }
           
            $scope.abrirLog = function (item) {
                try {
                    $Ex.Execute("GetErroresSincronizador", item, function (response) {
                        $scope.logErrores = response.d;
                        $scope.modal.open();
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            $scope.ejecutar = function (item) {
                try {

                    item.TipoCambio = '';
                    if (item.SincronizadorId === CarteraCierreMesId) {
                        $scope.modaltipocambio.open();
                        $scope.itemsincronizar = item;
                    }
                    else {
                        $Ex.Execute("Ejecutar", item, function (response) {
                            if (response.d.hasOwnProperty("Error")) {
                                Ex.mensajes(response.d.Error);
                            } else {
                                Ex.mensajes(Ex.GetGlobalResourceValue("msgSuccess"));
                            }
                            $scope.getSincronizadores();
                        });
                    }

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            $scope.ejecutarmodal = function () {
                try {

                    if ($scope.itemsincronizar.TipoCambio === '') {
                        $scope.isValid = false;
                        return;
                    }

                    $scope.modaltipocambio.close();

                    $Ex.Execute("Ejecutar", $scope.itemsincronizar, function (response) {                  
                        if (response.d.hasOwnProperty("Error")) {
                            Ex.mensajes(response.d.Error);
                        } else {            
                            Ex.mensajes(Ex.GetGlobalResourceValue("msgSuccess"));
                        }
                        $scope.getSincronizadores();
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            $scope.getSincronizadores();
        }]);
})();