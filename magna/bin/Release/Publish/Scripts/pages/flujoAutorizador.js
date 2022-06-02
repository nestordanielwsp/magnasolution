(function () {
    app.controller('flujoAutorizador', ['$scope', '$http', 'util', '$timeout',
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.forma = {};
            $scope.areas = AreaInfo;
            $scope.canales = {};
            $scope.canales = CanalInfo;
            $scope.canales.push({ 'CanalId': 0, 'NombreCanal': '[ Sin Canal ]', 'CentroCostos': '0000' });

            $scope.marcas = MarcaInicialInfo;
            $scope.cargos = PerfilFuncionalInfo;
            $scope.modificacionInfo = FlujoAutorizacionModificacionInfo;
            $scope.flujo = {
                AreaId: $scope.areas[0].AreaId, CanalId: $scope.canales[0].CanalId, Marcas: []
            };

            //$scope.flujo.Marcas = [];
            $scope.sortableOptions = {
                update: function (e, ui) {
                    $timeout(function () {
                        _.each($scope.flujo.Lista, function (item, index) {
                            item.Orden = index + 1;
                        });
                    }, 0);
                },
                handle: '.drag'
            };

            $scope.agregar = function () {
                $scope.flujo.Lista.push({ Orden: $scope.flujo.Lista.length + 1 });
            };

            $scope.eliminar = function (index) {
                $scope.flujo.Lista.splice(index, 1);

                _.each($scope.flujo.Lista, function (item, index) {
                    item.Orden = index + 1;
                });
            };

            $scope.cambiaflujoModificacion = function (item) {
                if (item.EsModificacion) {
                    item.Monto = 0;
                }
            };

            $scope.getFlujos = function () {
                var canal = $scope.flujo.CanalId;
                var marca = "";
                if ($scope.flujo.Marcas.length > 0) {
                    marca = $scope.flujo.Marcas[0].id;
                    var datos = { AreaId: $scope.flujo.AreaId, CanalId: canal, LineaCodigo: marca };
                    $Ex.Execute("GetFlujos", datos, function (response) {
                        $scope.flujo.Lista = response.d;
                    });
                }
            };

            $scope.guardar = function () {
                $scope.submitted = true;
                $Ex.Execute("Guardar", $scope.flujo, function (response, isInvalid) {
                    if (!isInvalid) {
                        $scope.submitted = false;
                        $scope.getFlujos();
                    }
                }, $scope.forma);
            };


            $scope.llenaMarca = function (canalId) {
                // Cuando Elija Sin Canal, debe traer todos las Marcas
                $scope.marcas = MarcaInicialInfo;
                if (canalId != 0) {
                    var Marcas = _.filter(MarcaInfo, { 'CanalId': canalId });
                    $scope.marcas = Marcas;
                }
                var seleccionado = { 'LineaCodigo': 0, 'NombreMarca': '[ Sin Marca ]', 'CanalId': 0 };
                Marcas.push(seleccionado);
                $scope.flujo.LineaCodigo = 0;
                $scope.getFlujos();
            }

            var setMarca = function (item) {
                //var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });             
                $scope.getFlujos();
            }
            $scope.multiselectEventos = {
                onItemSelect: setMarca,
                onItemDeselect: setMarca,
                onDeselectAll: setMarca
            };


            $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();


            var marcasSellIn = [];
            var getMarcas = function () {
                try {
                    $Ex.Execute("GetMarcas", $scope.flujo, function (response) {
                        $scope.flujo.Marcas = response.d;
                        marcasSellIn = response.d;
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.getFlujos();
        }]);
})();