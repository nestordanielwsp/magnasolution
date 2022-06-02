(function () {
    app.controller('capturaRequisicion', ['$scope', '$http', 'enums', 'util',
        function ($scope, $http, enums, util) {
            $Ex.Http = $http;
            $scope.filtro = {
                Fecha: { StartDate: "", EndDate: "" }
            };
            $scope.pantallas =
            {
                principal: 1
                , nuevaRequisicion: 2
                , verRequisicion: 3
            };
            $scope.pantallaId = $scope.pantallas.principal;
            $scope.Monedas = Monedas;
            $scope.proveedores = Proveedores;
            $scope.aprobador = AprobadorInfo;
            $scope.comprador = CompradorInfo;
            $scope.usuarioQad = UsuarioQadInfo;
            $scope.proveedorOptions = util.getOptionsMultiselect("ProveedorId", "Nombre");
            $scope.activityOptions = { idProp: "ActivityId", displayProp: "Nombre", methodName: "GetActivity" };
            $scope.activities = Activity;
            $scope.proveedorOptions = { idProp: "ProveedorId", displayProp: "Nombre", methodName: "GetProveedor" };
            $scope.requisicion = { Articulos: [] };

            $scope.ObtenerRequisiciones = function () {

                $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";

                $Ex.Execute("GetRequisiciones", $scope.filtro, function (response) {
                    $scope.requisiciones = response.d;
                });
            }

            $scope.ObtenerRequisicion = function (requisicion) {

                $Ex.Execute("GetRequisicion", requisicion, function (response) {
                    $scope.pantallaId = $scope.pantallas.verRequisicion;
                    $scope.requisicion = response.d.requisicion;
                });
            }

            $scope.guardarComentario = function (item) {
                $scope.ArticuloSolo = item;
                var backOfferButton = document.getElementById(item.RequisicionArticuloId);
                backOfferButton.dataset.target = "#myModal";
            };

            $scope.ObtenerRequisiciones();

        }]);
}
)();