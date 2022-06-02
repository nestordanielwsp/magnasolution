(function () {
    app.controller('proveedor', ['$scope', '$http',
        function ($scope, $http) {
            $Ex.Http = $http;

            $scope.forma = {};
            $scope.filtro = {};
            $scope.proveedor = {};
            $scope.proveedores = [];
            $scope.esDetalle = false;

            $scope.agregar = function () {
                $scope.submitted = false;
                $scope.esDetalle = true;
                $scope.proveedor = { ProveedorId: 0,Active: true};
            };

            $scope.getProveedor = function (proveedor) {
                $Ex.Execute("GetProveedor", proveedor, function (response) {
                    $scope.proveedor = response.d;
                    $scope.esDetalle = true;
                });
            };

            $scope.getProveedores = function () {
                $Ex.Execute("GetProveedores", $scope.filtro, function (response) {
                    $scope.proveedores = response.d;
                });
            };

            $scope.guardar = function () {
                $scope.submitted = true;
                $Ex.Execute("Guardar", $scope.proveedor, function (response, isInvalid) {
                    if (!isInvalid) {
                        $scope.getProveedores();
                        $scope.esDetalle = false;
                    }
                }, $scope.forma);
            };

            $scope.getProveedores();
        }]);
})();