
(function () {
    'use strict';

    angular.module(appName)
        .controller('usuarioController', usuarioController);

    usuarioController.$inject = ['$scope', '$http', '$rootScope', 'fileReader', 'FileUploader', 'util', '$timeout'];

    function usuarioController($scope, $http, $rootScope, fileReader, FileUploader, util, $timeout) {
        var service = $Ex;
        service.Http = $http;
        var vm = this;
        vm.viewDetail = false;
        vm.canal = {};
        vm.titulo = Ex.GetResourceValue("Titulo") || '';
        vm.usuarios = [];
        vm.perfiles = [];
        vm.isValid = true;
        vm.filtro = { NombreUsuario: null };
        vm.loading = true;
        vm.UsuarioId = UsuarioId;
        vm.areas = AreaInfo;
        vm.rubros = RubroInfo;
        vm.tareasPendientes = TareaPendienteInfo;
        vm.usuarioQad = UsuarioQadInfo;
        vm.clearFiltros = function () {
            if (!vm.openFilterAdvance)
                vm.filtro = {}
        }

        vm.vendedorOptions = {
            idProp: "VendedorId",
            displayProp: "NombreVendedor",
            methodName: "BuescarVendedor"
        };

        $scope.usuario = { Marcas: [], Canales: [] };

        $scope.marcasSeleccionadas = [];
        $scope.canalesSeleccionados = [];
        $scope.canalesSeleccionadosArray = [];
        $scope.SuperFiltro = {};

        $scope.marcasJoin = '';

        $scope.marcas = MarcaInfo;
        $scope.canales = [];
        $scope.canalesVisual = [];
        $scope.canalesInfo = CanalInfo;


        //var setCanales = function (item) {
        //    var canal = _.findWhere($scope.canales, { CanalId: item.id });

        //    var a = $scope.usuario.Canales;
        //    $scope.canalesSeleccionados.push(canal);

        //    var canalesArray = $scope.canales.filter(function (channel) { return channel.CanalId == item.id });

        //    canalesArray.forEach(function (canArray) {

        //        $scope.canalesSeleccionadosArray.push(canArray);

        //    });
        //}

        var getCanales = function (item) {

            $timeout(function () {

                var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                $scope.marcasSeleccionadas.push(marca);
                $scope.SuperFiltro.Marcas = _.pluck($scope.usuario.Marcas, 'id').join(",");

                $scope.marcasJoin = $scope.SuperFiltro.Marcas;
                obtenerCanales($scope.marcasJoin);
            }, 300);
        }

        var obtenerCanales = function (marcas) {

            try {
                var marcasSel = {};
                marcasSel.Marcas = marcas;

                service.Execute("ObtenerCanalesPorMarca", marcasSel, function (response) {

                    $scope.usuario.Canales = [];

                    var canales = response.d.Canales;
                    var canalesVisual = response.d.CanalesVisual;

                    $scope.canales = canales;
                    $scope.canalesVisual = canalesVisual;

                    Ex.load(false);

                });


            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }

        }



        var obtenerCanalesEditar = function (marcas, channels) {

            try {
                var marcasSel = {};
                marcasSel.Marcas = marcas;

                service.Execute("ObtenerCanalesPorMarca", marcasSel, function (response) {

                    $scope.usuario.Canales = [];

                    var canales = response.d.Canales;
                    var canalesVisual = response.d.CanalesVisual;

                    $scope.canales = canales;
                    $scope.canalesVisual = canalesVisual;

                    $scope.usuario.Canales = [];

                    channels.forEach(function (canal) {

                        $scope.usuario.Canales.push({ id: canal.CanalId });

                    });

                    Ex.load(false);

                });


            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }

        }

        var removeCanales = function (item) {
            var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
            var index = $scope.marcasSeleccionadas.indexOf(marca);

            $scope.marcasSeleccionadas.splice(index, 1);
            $scope.SuperFiltro.Marcas = _.pluck($scope.usuario.Marcas, 'id').join(",");

            obtenerCanales($scope.SuperFiltro.Marcas);
        };

        $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
        $scope.multiselectEventos = {
            onItemSelect: getCanales,
            onItemDeselect: removeCanales,
            onDeselectAll: function () {

                $scope.canales = [];
                $scope.canalesVisual = [];
                $scope.marcasSeleccionadas = [];
                $scope.canalesSeleccionados = [];
                $scope.canalesSeleccionadosArray = [];
                $scope.usuario.Canales = [];

            }
            //onSelectAll: function () {

            //    $timeout(function () {
            //        obtenerCanales($scope.marcasJoin);

            //    }, 3000);

            //}

        };

        $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

        $scope.canalesOptions = util.getOptionsMultiselect("CanalId", "NombreCanal");

        $scope.multiselectEventosCanal = {
            //onItemSelect: setCanales,
            onDeselectAll: function () {
                $scope.canalesSeleccionados = [];
                $scope.canalesSeleccionadosArray = [];

            }
        };

        var consultar = function (filtros) {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Consultar', datos, function (response) {
                    if (response.d) {
                        vm.usuarios = response.d.Usuario;
                        vm.usuarios_ = angular.copy(vm.usuarios);
                        vm.perfiles = response.d.Perfil;
                        vm.perfilesFuncional = response.d.PerfilFuncional;


                    }
                    Ex.load(false)
                    vm.loading = false;

                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
                vm.loading = false;

            }
        }
        var init = function () {
            consultar();
        }

        vm.VerEsVendedor = function () {
            var vendedor = _.find(vm.perfilesFuncional, { PerfilId: vm.usuario.PerfilFuncionalId });
            vm.usuario.EsVendedor = vendedor.EsVendedor;
            vm.usuario.VendedorId = null;
        }

        vm.descargar = function () {
            try {
                Ex.load(true);
                var datos = vm.filtro || {};
                service.Execute('Exportar', datos, function (response, isInvalid) {
                    if (isInvalid) {
                        return;
                    }
                    window.location = "DownLoadPage.aspx";
                    setTimeout(function () {
                        Ex.load(false);
                    }, 1000);
                })
            }
            catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        vm.Editar = function (item) {
            vm.usuario = angular.copy(item);
            var vendedor = _.find(vm.perfilesFuncional, { PerfilId: vm.usuario.PerfilFuncionalId });
            vm.usuario.EsVendedor = vendedor.EsVendedor;
            //Consultar path de la imagen  
            try {
                var datos = vm.usuario;
                service.Execute("ConsultarRutaArchivo", datos, function (response) {
                    if (response.d) {
                        vm.usuario.PathImg = response.d;
                    }
                    Ex.load(false);
                    vm.viewDetail = true;
                });

                service.Execute("ConsultarTareasPendientes", datos, function (response) {
                    if (response.d) {
                        vm.usuario.TareasPendientes = response.d;
                    }
                });


                service.Execute("ConsultarCanales", datos, function (response) {

                    var marcas = response.d.Marcas;
                    var canales = response.d.Canales;

                    $scope.usuario.Marcas = [];

                    marcas.forEach(function (marca) {

                        $scope.usuario.Marcas.push({ id: marca.LineaCodigo });

                    });

                    $scope.SuperFiltro.Marcas = _.pluck($scope.usuario.Marcas, 'id').join(",");

                    obtenerCanalesEditar($scope.SuperFiltro.Marcas, canales);


                    //canales.forEach(function (canal) {
                    //    $scope.usuario.Canales.push({ id: canal.CanalId });

                    //});



                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        var consultarPathImg = function (datos) {
            try {
                var datos = datos;
                service.Execute("ConsultarRutaArchivo", datos, function (response) {
                    if (response.d) {
                        vm.usuario.PathImg = response.d;
                        $rootScope.$broadcast('ImagenPerfil', { value: vm.usuario.PathImg });
                    } else
                        $rootScope.$broadcast('ImagenPerfil', { value: "" });
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        vm.removePicture = function () {
            vm.usuario.Img = "";
            vm.usuario.PathImg = null;
            vm.usuario.UID = "";
            delete vm.usuario["Blob"];
            try {
                service.Execute("REmoveSessionMassive", {}, function (response) {
                    console.log(response);
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }

        vm.guardar2 = function () {

            $scope.canalesSeleccionadosArray = [];

            $scope.usuario.Canales.forEach(function (canal) {

                var canales = $scope.canales.filter(function (item) { return item.CanalId == canal.id });

                canales.forEach(function (val) {

                    $scope.canalesSeleccionadosArray.push(val);
                });

            });


            if ($scope.canalesSeleccionadosArray.length <= 0) {
                Ex.mensajes(Ex.GetResourceValue("SeleccionarCanales"), 4);
                return;
            }


        }

        vm.guardar = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                    vm.isValid = false;
                    return;
                }
                if ((vm.usuario.NuevoPassword || vm.usuario.NuevoPasswordValidacion) &&
                    (vm.usuario.NuevoPassword != "" || vm.usuario.NuevoPasswordValidacion != "")) {
                    if (vm.usuario.NuevoPassword != vm.usuario.NuevoPasswordValidacion) {
                        Ex.mensajes(Ex.GetResourceValue("ContrasenasNoCoinciden"), 4);
                        return;
                    }
                }

                $scope.canalesSeleccionadosArray = [];

                $scope.usuario.Canales.forEach(function (canal) {

                    var canales = $scope.canales.filter(function (item) { return item.CanalId === canal.id });

                    canales.forEach(function (val) {

                        $scope.canalesSeleccionadosArray.push(val);
                    });

                });


                if ($scope.canalesSeleccionadosArray.length <= 0) {
                    Ex.mensajes(Ex.GetResourceValue("SeleccionarCanales"), 4);
                    return;
                }


                var datos = vm.usuario;
                datos.Canales = $scope.canalesSeleccionadosArray;
                service.Execute("Guardar", datos, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    if (response.d.UsuarioId) {
                        vm.usuario.UsuarioId = response.d.UsuarioId;
                        vm.usuario.Active = response.d.Active;
                        vm.usuario.UID = response.d.UID;
                        if (vm.usuario.UsuarioId == UsuarioId) {
                            consultarPathImg(vm.usuario);
                        }


                    }
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, function (r) {
                        vm.openFilterAdvance = false; vm.clearFiltros(); vm.actualizar(); vm.viewDetail = false;
                    }, null);
                    Ex.load(false);
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        }
        vm.actualizar = function () {
            consultar();
        }

        vm.agregar = function () {
            vm.usuario = { TareasPendientes: vm.tareasPendientes };
            vm.usuario.EsVendedor = false;
            vm.usuario.UsuarioId = 0;
            vm.viewDetail = true;

            $scope.usuario.Marcas = [];
            $scope.usuario.Canales = [];

            $scope.canales = [];
            $scope.canalesVisual = [];
        }

        init();
        vm.uploadPicture = function () {
            var fileInput = document.getElementById('uploadFile');
            fileInput.click();
        }



        $scope.massiveConfirmationFile = {
            Data: [],
            DataError: []
        }
        $scope.massiveConfirmationAdd = function (e, data) {
            if (data.IsInvalidFile) {
                Ex.mensajes(Ex.GetResourceValue("msgInvalidExtensionFile"), 5);
            }
        }

        $scope.massiveConfirmationUploadStart = function () {
            Ex.load(true);
        }

        $scope.massiveConfirmationUploaded = function (e, data) {
            Ex.load(false);
            if (data.result.HasError) {
                Ex.mensajes(data.result.Message, 4);
                $scope.massiveConfirmationFile.path = '';
            }
            else {
                $scope.massiveConfirmationFile.information = data.result;
                if (data.result) {
                    //vistaPRevia
                    vm.usuario.Img = data.files[0].name;
                    vm.usuario.Blob = window.URL.createObjectURL(data.files[0]);
                }

                $scope.massiveConfirmationFile.DataError = data.result.DataError || [];
                $scope.massiveConfirmationFile.DataErrorAux = data.result.DataError || [];
                if ($scope.massiveConfirmationFile.DataError.length > 0) {
                    $scope.massiveConfirmationFile.HasError = true;
                }


            }
        };
    }
})();