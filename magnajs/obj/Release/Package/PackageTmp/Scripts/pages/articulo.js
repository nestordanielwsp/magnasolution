(function () {
    app.controller('articulo', ['$scope', '$http', 'util', "$timeout",
        function ($scope, $http, util, $timeout) {
            $Ex.Http = $http;

            $scope.forma = {};
            $scope.filtro = {};
            $scope.articulo = { Proveedores: []};
            $scope.articulos = [];
            $scope.esDetalle = false;
            $scope.proveedores = ProveedoresInfo;

            var quitarProveedorDeLista = function (proveedor) {
                for (var i = 0; i < $scope.articulo.ListaPrecios.length; i++) {
                    var lista = $scope.articulo.ListaPrecios[i];
                    var indexProveedor = _.findIndex(lista.Proveedores, { id: proveedor.id });
                    lista.Proveedores.splice(indexProveedor, 1);
                }
            };

            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();
            $scope.opcionesProveedores = util.getOptionsMultiselect("ProveedorId", "Nombre");    
            $scope.multiselectEventos = {
                onItemSelect: function (item) {
                    var proveedor = _.findWhere($scope.proveedores, { ProveedorId: item.id });
                    item.Nombre = proveedor.Nombre;

                    for (var i = 0; i < $scope.articulo.ListaPrecios.length; i++) {
                        var lista = $scope.articulo.ListaPrecios[i];
                        var indexProveedor = _.findIndex(lista.Proveedores, { id: proveedor.id });

                        if (indexProveedor === -1) {
                            lista.Proveedores.push(angular.copy(item));
                        }
                    }
                },
                onItemDeselect: function (item) {
                    quitarProveedorDeLista(item);
                },
                onDeselectAll: function () {
                    for (var i = 0; i < $scope.articulo.Proveedores.length; i++) {
                        var proveedor = $scope.articulo.Proveedores[i];
                        quitarProveedorDeLista(proveedor);
                    }
                }
            };

            $scope.agregar = function () {
                $scope.submitted = false;
                $scope.esDetalle = true;
                $scope.articulo = { Proveedores: [], ListaPrecios: [], ArticuloId: 0,Active: true};
            };

            $scope.getArticulo = function (articulo) {
                $Ex.Execute("GetArticulo", articulo, function (response) {
                    $scope.articulo = response.d;
                    $scope.esDetalle = true;
                });
            };

            $scope.getArticulos = function () {
                $Ex.Execute("GetArticulos", $scope.filtro, function (response) {
                    $scope.articulos = response.d;
                });
            };

            $scope.guardar = function () {
                $scope.submitted = true;
                $Ex.Execute("Guardar", $scope.articulo, function (response, isInvalid) {
                    if (!isInvalid) {
                        $scope.getArticulos();
                        $scope.esDetalle = false;
                    }
                }, $scope.forma);
            };

            $scope.agregarLista = function () {
                var proveedores = angular.copy($scope.articulo.Proveedores);
                $scope.articulo.ListaPrecios.push({ Proveedores: proveedores});
            };

            $scope.getArticulos();
        }]);
})();