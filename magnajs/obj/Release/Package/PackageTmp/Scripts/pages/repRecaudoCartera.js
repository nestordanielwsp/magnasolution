(function () {
    app.controller('repRecaudoCartera', ['$scope', '$http', 'util',
        function ($scope, $http, util) {
            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.anios = util.getYearArray(4);
            $scope.meses = util.getMonthArray();
            $scope.chartEvolucion = {};
            $scope.chartCanal = {};
            $scope.chartCanalMobile = {};
            $scope.esGrafica = true;

            $scope.filtro.Anio = new Date().getFullYear();
            $scope.filtro.MesId = new Date().getMonth() + 1;
                    
            $scope.chartOptions = {
                size: "90%",
                innerSize: "45%",
                legend: {
                    align: 'center',
                    verticalAlign: 'bottom',
                    layout: 'horizontal'
                }
            }

            $scope.chartOptionsMobile = {
                size: "100%",
                innerSize: "50%",
                labelEnabled: false
            }

            var meses = util.getMonthArray(false, true);
           
            $scope.chartEvolucionOptions = {
                categories: _.pluck(meses, "Name"),
                pointFormat: '<span">{series.name}</span>: <b>${point.y:,.2f}</b>',
                legend: {
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            };

            $scope.actualizar = function () {
                try {
                    var mes = _.findWhere(meses, { Id: $scope.filtro.MesId });
                    $scope.mes = mes.Name;
                    $Ex.Execute("ObtenerRecaudo", $scope.filtro, function (response) {                                            
                        var recaudoEvolucion = [];
                        var totalAnios = response.d.Evolucion.length;

                        for (var i = 0; i < totalAnios; i++) {
                            var evolucion = response.d.Evolucion[i];
                            var series = { name: evolucion.Anio };
                            var data = [];

                            for (var key in evolucion) {
                                if (evolucion.hasOwnProperty(key) && key !== "Anio") {
                                    data.push(evolucion[key]);
                                }
                            }
                            series.data = data;
                            recaudoEvolucion.push(series);
                        }

                        $scope.chartEvolucion.open(recaudoEvolucion);
                        $scope.chartCanal.open(response.d.Canal);
                        $scope.chartCanalMobile.open(response.d.Canal);
                        $scope.tablaCanales = response.d.TablaCanal;
                    });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }
         
            $scope.exportar = function () {
                try {
                    $Ex.Execute("Exportar", $scope.filtro, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.actualizar();
        }]);
})();