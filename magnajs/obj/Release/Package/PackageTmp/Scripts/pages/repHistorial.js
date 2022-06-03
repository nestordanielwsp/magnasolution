(function () {
    app.controller('repHistorial', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            $scope.filtro = {
                Catalogo: [], Fecha: { StartDate: "", EndDate: "" }
            };
            
            $scope.catalogo = CatalogoInfo;
            $scope.actividades = ActividadInfo;

            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();
            $scope.catalogoOptions = util.getOptionsMultiselect("CatalogoId", "NombreCatalogo");
            

            $scope.obtenerHistorial = function () {
                try {

                    $scope.filtro.CatalogosIds = _.pluck($scope.filtro.Catalogo, 'id').join(",");

                    $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                    $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";

                    $Ex.Execute("ObtenerHistorial", $scope.filtro, function (response) {
                        $scope.historial = response.d;
                        $scope._historial = response.d;
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }
       
            $scope.exportar = function () {
                try {

                    $scope.filtro.CatalogosIds = _.pluck($scope.filtro.Catalogo, 'id').join(",");

                    $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                    $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";

                    $Ex.Execute("Exportar", $scope.filtro, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };
          


            $scope.obtenerHistorial();
        }]);
})();