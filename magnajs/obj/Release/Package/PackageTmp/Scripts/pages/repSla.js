(function () {
	app.controller('repSla', ['$scope', '$http', 'util',
		function ($scope, $http, util) {
			$Ex.Http = $http;

			$scope.filtro = { Marcas: [], Canales: [] };
			$scope.marcas = MarcaInfo;
			$scope.canales = CanalInfo;
			$scope.anios = util.getYearArray(4);
			$scope.chartPromedioMarca = {};
			$scope.chartExtemporaneoMarca = {};
			$scope.chartPieExtemporaneo = {};

			$scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
			$scope.canalesOptions = util.getOptionsMultiselect("CanalId", "NombreCanal");
			$scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

			var fechaActual = new Date();
			$scope.filtro.Anio = fechaActual.getFullYear();

			$scope.promedioMarcaOptions = {
				pointFormat: '<span">{point.name}</span>: <b>{point.y:,.2f}</b>',
				legend: { enabled: false },
				tooltip: { enabled: false },
				chart: { marginTop: 15 },
				stacking: "",
				plotOptions: {
					column: {
						dataLabels: {
							enabled: true,
							format: '{point.y:.1f}',
							verticalAlign: "top",
							y: -20
						}
					}
				}
			};

			$scope.extemporaneoMarcaOptions = {
				legend: {
					floating: true,
					align: 'right',
					verticalAlign: 'top'
				},
				plotOptions: {
					column: {
						stacking: 'normal',
						dataLabels: {
							enabled: true,
							format: '{point.y:.0f}'
						}
					}
				},
				yAxis: { height: "175px", top: 67.5}
			};

			var abrirChartPromedioMarca = function (datos) {
				var categorias = _.pluck(datos, "NombreMarca");
				var totalCategorias = categorias.length;
				var dias = _.pluck(datos, "DiasPromedioFlujo");
				var promedioDiasMarca = [];

				for (var i = 0; i < totalCategorias; i++) {
					promedioDiasMarca.push($scope.promedioActivities.DiasFlujo);
				}

				var series = [
					{ type: "column", data: dias },
					{ type: "spline", data: promedioDiasMarca, color: "#ff9900" }
				];

				$scope.promedioMarcaOptions.categories = categorias;
				$scope.chartPromedioMarca.openCombinationChart(series);
			};

			var abrirChartExtemporaneoMarca = function (datos) {
				var series = [
					{
						name: Ex.GetResourceValue("lblExtemporaneos"),
						type: 'column',
						color: "#cc0000",
						data: _.pluck(datos, "Extemporaneo")
					},

					{
						name: Ex.GetResourceValue("lblEnTiempo"),
						type: 'column',
						data: _.pluck(datos, "EnTiempo")
					},
					{
						type: "pie",
						center: [50, 10],
						size: 80,
						showInLegend: false,
						tooltip: {
							pointFormat: '<b>{point.y}</b>'
						},
						dataLabels: {
							format: '{point.percentage:.0f}%',
							distance: -20
						},
						data: [
							{ name: Ex.GetResourceValue("lblExtemporaneos"), y: $scope.activitiesExtemporaneos.Extemporaneo, color: "#cc0000"},
							{ name: Ex.GetResourceValue("lblEnTiempo"), y: $scope.activitiesExtemporaneos.EnTiempo }
						]
					}
				];

				$scope.extemporaneoMarcaOptions.categories = _.pluck(datos, "NombreMarca");
				$scope.chartExtemporaneoMarca.openCombinationChart(series);
			};

			$scope.actualizar = function () {
				$scope.filtro.MarcaIds = _.pluck($scope.filtro.Marcas, 'id').join(",");
				$scope.filtro.CanalIds = _.pluck($scope.filtro.Canales, 'id').join(",");

				$Ex.Execute("GetReporte", $scope.filtro, function (response) {
					$scope.promedioActivities =
						response.d.PromedioDiasTotal.length > 0 ? response.d.PromedioDiasTotal[0] : {};

					$scope.activitiesExtemporaneos =
						response.d.ActivitiesExtemporaneos.length > 0 ? response.d.ActivitiesExtemporaneos[0] : {};

					abrirChartPromedioMarca(response.d.PromedioDiasMarca);
					abrirChartExtemporaneoMarca(response.d.ActivitiesExtemporaneosMarca);
				});
			};

			$scope.actualizar();
		}]);
})();