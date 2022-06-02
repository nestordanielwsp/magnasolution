(function () {
    app.controller('dashboardController', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            var service = $Ex;
            service.Http = $http;

            $scope.filtro = { Marcas: [], Fecha: { StartDate: "", EndDate: "" } };

            $scope.chartPptoRubro = {};
            $scope.chartPptoCanal = {};
            $scope.chartPptoMarca = {};
            $scope.chartPptoMarcaDetalle = {};
            $scope.opcionesFechaDashboard = { autoclose: true };
            $scope.marcas = MarcaInfo;

            $scope.filtro.Fecha.StartDate = FechaInicialInfo.StartDate;
            $scope.filtro.Fecha.EndDate = FechaInicialInfo.EndDate;

            $scope.titulo = Ex.GetResourceValue("Titulo") || '';

            $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

            $scope.chartPieOptions = {
                innerSize: "50%",
                connectorShape: 'crookedLine',
                distance: 10,
                pointFormat: '<b>{point.name}</b>: ${point.Monto:,.2f}'
            };

            $scope.chartPptoCanalOptions = {
                legend: {
                    align: 'right',
                    verticalAlign: 'top',
                    y: -18,
                    floating: true
                },
                headerFormat: '<b>{point.x}</b><br/>',
                pointFormat: '{series.name}: ${point.y:,.0f}',
                categories: [],
                yMin: 0,
                yAllowDecimals: true
            };

            $scope.chartPptoMarcaDetalleOptions = {
                legend: {
                    align: 'right',
                    verticalAlign: 'top',
                    y: -18,
                    floating: true
                },
                headerFormat: '<b>{point.x}</b><br/>',
                pointFormat: '{series.name}: ${point.y:,.0f}',
                categories: [],
                yMin: 0,
                yAllowDecimals: true
            };

            $scope.actualizar = function (startDate, endDate) {
	            $scope.filtro.MarcaIds = _.pluck($scope.filtro.Marcas, 'id').join(",");
                $scope.filtro.FechaInicio = $scope.filtro.Fecha.StartDate;
                $scope.filtro.FechaFin = $scope.filtro.Fecha.EndDate;

                $Ex.Execute("ObtenerDashboard", $scope.filtro, function (response) {

                    $scope.Dashboard = response.d.Dashboard[0];
                    var dataGraficaPtoPorRubro = response.d.PresupuestoPorRubro;
                    var dataPtoPorCanal = response.d.PresupuestoPorCanal;
                    var dataGraficaPtoPorMarca = response.d.PresupuestoPorMarca;
                    var dataPtoPorMarcaDetalle = response.d.PresupuestoPorMarcaDetalle;

                    //Pto por canal
                    var seriesComprometido = { name: Ex.GetResourceValue("lblComprometido"), data: [] };
                    var seriesEjecutado = { name: Ex.GetResourceValue("lblEjecutado"), data: [], color: "#0ba457" };
                    var dataGraficaPtoCanal = [];
                    $scope.chartPptoCanalOptions.categories = [];

                    for (var i = 0; i < dataPtoPorCanal.length; i++) {
                        seriesComprometido.data.push(dataPtoPorCanal[i].Comprometido);
                        seriesEjecutado.data.push(dataPtoPorCanal[i].Ejecutado);
                        $scope.chartPptoCanalOptions.categories.push(dataPtoPorCanal[i].Canal);
                    }

                    dataGraficaPtoCanal.push(seriesComprometido);
                    dataGraficaPtoCanal.push(seriesEjecutado);
                    $scope.chartPptoCanal.open(dataGraficaPtoCanal);

                    //Pto Marca Detalle (Comprometido vs Ejecuta)
                    seriesComprometido = { name: Ex.GetResourceValue("lblComprometido"), data: [] };
                    seriesEjecutado = { name: Ex.GetResourceValue("lblEjecutado"), data: [], color: "#0ba457" };
                    var dataGraficaPtoMarcaDetalle = [];
                    $scope.chartPptoMarcaDetalleOptions.categories = [];

                    for (i = 0; i < dataPtoPorMarcaDetalle.length; i++) {
                        seriesComprometido.data.push(dataPtoPorMarcaDetalle[i].Comprometido);
                        seriesEjecutado.data.push(dataPtoPorMarcaDetalle[i].Ejecutado);
                        $scope.chartPptoMarcaDetalleOptions.categories.push(dataPtoPorMarcaDetalle[i].Marca);
                    }

                    dataGraficaPtoMarcaDetalle.push(seriesComprometido);
                    dataGraficaPtoMarcaDetalle.push(seriesEjecutado);
                    $scope.chartPptoMarcaDetalle.open(dataGraficaPtoMarcaDetalle);

                    $scope.chartPptoRubro.open(dataGraficaPtoPorRubro);
                    $scope.chartPptoMarca.open(dataGraficaPtoPorMarca);

                });
            };

            $scope.actualizar();
        }]);
})();