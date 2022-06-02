(function () {
    app.controller('RequisicionController', ['$scope', '$http', '$location', '$anchorScroll', '$timeout', 'util', function ($scope, $http, $location, $anchorScroll, $timeout, util) {
        debugger;
        $Ex.Http = $http;
        var req = this;
        req.form = {};
        req.distribuir = {};
        req.ListaReqProducto = [];
        req.filter = {};
        req.isValid = true;
        req.esConsulta = true;
        req.esDisabled = false;
        req.esDisabledAlta = false;
        req.esDisabledProducto = false;
        req.esDisabledProveedor = false;
        req.esRequiredProveedor = false;
        req.esRequiredAutorizacion = false;
        req.esOC = false;
        req.porCotizarMark = false;
        req.porConvertirOCMark = false;
        req.porAutorizarMark = false;
        req.porCotizar = 0;
        req.porConvertirOC = 0;
        req.porAutorizar = 0;
        req.ListaRequisicion = [];
        req.ListaClasificacion = [];
        req.ListaTiposCompra = [];
        req.ListaEmpresa = [];
        req.ListaMoneda = [];
        req.ListaAlmacen = [];
        req.ListaSucursal = [];
        req.ListaEstatusRequisicion = [];
        req.ListaDepartamento = [];
        req.ListaProducto = [];
        req.ListaProveedor = [];
        req.ListaParametro = [];
        req.ListaUnidadMedida = [];
        req.UsuarioInfo = {};
        req.ListaAutorizaciones = [];
        req.ListaReqProveedor = [];
        req.ListaDistribuir = [];

        req.Carga = function () {
            try {
                Ex.load(true);
                var callback = function (response) {
                    var data =  response.d;
                    req.ListaClasificacion = data.ListaClasificacion;
                    req.ListaTiposCompra = data.ListaTipoCompra;
                    req.ListaEmpresa = data.ListaEmpresa;
                    req.ListaMoneda = data.ListaMoneda;
                    req.ListaAlmacen = data.ListaAlmacen;
                    req.ListaSucursal = data.ListaSucursal;
                    req.ListaEstatusRequisicion = data.ListaEstatusRequisicion;
                    req.ListaDepartamento = data.ListaDepartamento;
                    req.ListaProducto = data.ListaProducto;
                    req.ListaProveedor = data.ListaProveedor;
                    req.ListaParametro = data.ListaParametro;
                    req.ListaUnidadMedida = data.ListaUnidadMedida;
                    req.UsuarioInfo     = data.UsuarioInfo[0];
                    req.BuscarReq();
                }
                $Ex.Execute("Carga", req.filter, callback);
            } catch (ex) {
                Ex.load(false);
                Ex.mensajes(ex.message);
            }
        };
        
        req.AgregarRequisicion = function () {
            req.esConsulta = false;
            req.form = {};
            req.ListaReqProducto = [];
            req.ListaAutorizaciones = [];
            req.ListaReqProveedor = [];
            var callback = function (response) {
                var data = response.d;
                req.UsuarioInfo = data.UsuarioInfo[0];
                req.form = data.UsuarioInfo[0];
                req.form.RequisicionID = 0;
                req.form.EstatusRequisicionID = 0;
                req.isValid = true;
                req.esDisabled = false;
                req.esDisabledAlta = false;
                req.esDisabledProducto = false;
                req.esDisabledProveedor = false;
                req.esCompras = true;
            }
            $Ex.Execute("NuevaReq", {}, callback);
        };

        req.EditarReq = function (item) {
            req.esConsulta = false;
            req.form = {};
            req.ListaReqProducto = [];
            req.ListaAutorizaciones = [];
            req.ListaReqProveedor = [];
            Ex.load(true);
            var callback = function (response) {
                var data = response.d;
                if (!response.d.Requisicion)
                    return;
                req.form = data.Requisicion[0];
                if (req.form.EstatusRequisicionID != 1 && req.form.EstatusRequisicionID != 0) {
                    req.esDisabled = true;
                    req.esDisabledProducto = true;
                    req.esDisabledProveedor = true;
                    req.esDisabledAlta = true;
                }
                if (req.form.EstatusRequisicionID == 3 && req.UsuarioInfo.PerfilAutorizadorCompras) {
                    req.esDisabledProducto = true;
                    req.esDisabledProveedor = false;
                    req.esDisabledAlta = false;
                }
                if (req.form.EstatusRequisicionID >= 3 && req.UsuarioInfo.PerfilAutorizadorCompras) {
                    req.esRequiredProveedor = true;
                   
                }
                req.esRequiredAutorizacion = false;
                req.ListaReqProducto = data.RequisicionProductos;
                req.ListaAutorizaciones = data.Autorizaciones;
                req.ListaReqProveedor = data.RequisicionProveedores;
                req.esConsulta = false;
                Ex.load(false);
            }
            $Ex.Execute("EditarReq", item, callback);
        };

        req.AgregarProveedor = function () {
            var defaultValues = {
            }
            defaultValues.RequisicionProveedorID = 0;
            defaultValues.Active = true;
            defaultValues.IsEditMode = true;
            defaultValues.IsDirty = true;
            defaultValues.file = "";
            defaultValues.path = "";
            defaultValues.EsProveedor = 1;
            defaultValues.NombreAnexo = '';
            defaultValues.Ganador = 0;
            req.ListaReqProveedor.push(defaultValues); 
        }

        req.AgregarProducto = function () {
            if (req.form.TipoCompraID == undefined || req.form.TipoCompraID == "") {
                Ex.load(false);
                Ex.mensajes(Ex.GetResourceValue("msgErrorTipoCompra"));
                return;
            }
            var defaultValues = {
            }
            defaultValues.RequisicionProductoID = 0;
            defaultValues.Cantidad = 0;
            defaultValues.Active = true;
            defaultValues.IsEditMode = true;
            defaultValues.IsDirty = true;
            defaultValues.file = "";
            defaultValues.path = "";
            req.ListaReqProducto.push(defaultValues);
        }

        req.BuscarAdjunto = function (InputId) {
            $('#' + InputId)[0].click();
        }

        req.CambiaProducto = function (item) {
            item.ProductoID = item.Producto.ProductoID;
            req.form.ObligarNumEconomico = item.Producto.ObligarNumEconomico;
        }

        req.CambiaProveedor = function (item) {
            item.ProveedorID = item.Proveedor.ProveedorID;
        }

        req.ConProveedor = function (item) {
            item.EsProveedor = 0;
            item.NombreProveedor = '';
        }

        req.SinProveedor = function (item) {
            if(item.Proveedor != undefined){
                item.Proveedor = null;
            }
            item.EsProveedor = 1;
            item.ProveedorID = 0;
            item.NombreProveedor = '';
        }

        req.CambiaGanador = function (item) {
            item.Ganador = 1;
            req.form.ProveedorGanadorID = item.ProveedorID;
        }

        req.EliminarProducto = function (item, index) {
            try {
                var filter = {};
                var item = index;
                var callback = function (response) {
                    req.ListaReqProducto.remove(item);
                }
                $Ex.Execute("EliminarProducto", filter, callback, {}, false);
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.RegresarListado = function () {
            req.esConsulta = true;
            req.esOC = false;

        };

        req.AbrirAnexo = function (info, Tipo) {
            try {
                Ex.load(true);
                info.Tipo = Tipo;
                $Ex.Execute("AbrirAnexo", info, function (response, isInvalid) {
                    window.location = "DownLoadPage.aspx?d=" + getRandom();
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        req.BuscarReq = function () {
            try {
                Ex.load(true);
                if (req.filter.FechaFinal != undefined && req.filter.FechaFinal != '' && (req.filter.FechaInicial == undefined || req.filter.FechaInicial == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaInicial"));
                    return;
                }
                if (req.filter.FechaInicial != undefined && req.filter.FechaInicial != '' && (req.filter.FechaFinal == undefined || req.filter.FechaFinal == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaFinal"));
                    return;
                }
                $Ex.Execute("BuscarRequisicion", req.filter, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    var data = response.d;
                    req.ListaRequisicion = data.Requisicion;
                    req.ListaRequisicionAux = data.Requisicion;
                    req.porCotizar = data.RequisicionPorCotizar[0].Cantidad;
                    req.porAutorizar = data.RequisicionPorAutorizar[0].Cantidad;
                    req.porConvertirOC = data.RequisicionPorConvertirOC[0].Cantidad;
                    req.porCotizarMark = (req.porCotizar > 0 ? true : false);
                    req.porConvertirOCMark = (req.porConvertirOC > 0 ? true : false);
                    req.porAutorizarMark = (req.porAutorizar > 0 ? true : false);
                    req.esConsulta = true;
                    Ex.load(false);
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        req.MisReqPorCotizar = function () {
            try {
                req.ListaRequisicion = [];
                if (req.filter.FechaFinal != undefined && req.filter.FechaFinal != '' && (req.filter.FechaInicial == undefined || req.filter.FechaInicial == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaInicial"));
                    return;
                }
                if (req.filter.FechaInicial != undefined && req.filter.FechaInicial != '' && (req.filter.FechaFinal == undefined || req.filter.FechaFinal == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaFinal"));
                    return;
                }
                Ex.load(true);
                $Ex.Execute("BuscarRequisicionPorCotizar", req.filter, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    req.ListaRequisicion = response.d.Requisicion;
                    req.ListaRequisicionAux = response.d.Requisicion;
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        req.MisReqPorConvertir = function () {
            try {
                req.ListaRequisicion = [];
                if (req.filter.FechaFinal != undefined && req.filter.FechaFinal != '' && (req.filter.FechaInicial == undefined || req.filter.FechaInicial == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaInicial"));
                    return;
                }
                if (req.filter.FechaInicial != undefined && req.filter.FechaInicial != '' && (req.filter.FechaFinal == undefined || req.filter.FechaFinal == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaFinal"));
                    return;
                }
                Ex.load(true);
                $Ex.Execute("BuscarRequisicionPorConvertir", req.filter, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    req.ListaRequisicion = response.d.Requisicion;
                    req.ListaRequisicionAux = response.d.Requisicion;
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        req.MisReqPorAutorizar = function () {
            try {
                req.ListaRequisicion = [];
                if (req.filter.FechaFinal != undefined && req.filter.FechaFinal != '' && (req.filter.FechaInicial == undefined || req.filter.FechaInicial == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaInicial"));
                    return;
                }
                if (req.filter.FechaInicial != undefined && req.filter.FechaInicial != '' && (req.filter.FechaFinal == undefined || req.filter.FechaFinal == '')) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgFiltroFechaFinal"));
                    return;
                }
                Ex.load(true);
                $Ex.Execute("BuscarRequisicionPorAutorizar", req.filter, function (response, isInvalid) {
                    if (isInvalid) {
                        req.form.isValid = false;
                        return;
                    }
                    req.ListaRequisicion = response.d.Requisicion;
                    req.ListaRequisicionAux = response.d.Requisicion;
                });
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };
        
        req.GuardarReq = function () {
            try {
                if (!$Ex.IsValidateRequiredFieldForm(req.Form)) {
                    req.isValid = false;
                    return;
                }
                Ex.load(true);
                var callback = function (response) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, req.BuscarReq, null);
                }
                var lista = angular.copy(req.ListaReqProducto);
                var productos = [];
                angular.forEach(lista, function (item) {
                    delete item.Producto;
                    productos.push(item);
                });

                var listaProv = angular.copy(req.ListaReqProveedor);
                var proveedores = [];
                angular.forEach(listaProv, function (item) {
                    delete item.Proveedor;
                    proveedores.push(item);
                });
                req.form.ListaReqProducto = JSON.stringify(productos);
                req.form.ListaReqProveedor = JSON.stringify(proveedores);

                $Ex.Execute("GuardarRequisicion", req.form, callback);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.confirmaCancelar = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmcancelada"), 2, null, null, null, req.CancelarReq, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.SolicitarReq = function () {
            try {
                req.esRequiredAutorizacion = false;
                if (!$Ex.IsValidateRequiredFieldForm(req.Form)) {
                    req.isValid = false;
                    return;
                }
                Ex.load(true);
                var callback = function (response) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgAlertSolicitar"), 1, null, null, null, req.BuscarReq, null);
                }
                var lista = req.ListaReqProducto;
                var productos = [];
                angular.forEach(lista, function (item) {
                    delete item.Producto;
                    productos.push(item);
                });
                var listaProv = req.ListaReqProveedor;
                var proveedores = [];
                angular.forEach(listaProv, function (item) {
                    delete item.Proveedor;
                    proveedores.push(item);
                });
                req.form.ListaReqProducto = JSON.stringify(productos);
                req.form.ListaReqProveedor = JSON.stringify(proveedores);
                $Ex.Execute("SolicitarRequisicion", req.form, callback);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.GuardarPorCotizar = function () {
            try {
                req.esRequiredAutorizacion = false;
                if (!$Ex.IsValidateRequiredFieldForm(req.Form)) {
                    req.isValid = false;
                    return;
                }
                Ex.load(true);
                var callback = function (response) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1, null, null, null, req.BuscarReq, null);
                }
                var lista = angular.copy(req.ListaReqProducto);
                var productos = [];
                angular.forEach(lista, function (item) {
                    delete item.Producto;
                    productos.push(item);
                });

                var listaProv = angular.copy(req.ListaReqProveedor);
                var proveedores = [];
                angular.forEach(listaProv, function (item) {
                    delete item.Proveedor;
                    proveedores.push(item);
                });
                req.form.ListaReqProducto = JSON.stringify(productos);
                req.form.ListaReqProveedor = JSON.stringify(proveedores);

                $Ex.Execute("GuardarPorCotizar", req.form, callback);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.ConvertirReqOC = function () {
            Ex.load(true);
            var callback = function (response) {
                setTimeout(req.Redirect, 1500);
            }
            $Ex.Execute("ConvertirRequisicionOC", req.form, callback,undefined,null,null,false);
        }

        req.Redirect = function () {
            window.location = domainURL + 'OrdenCompra.aspx';
        }

        req.CancelarConvertirOC = function () {
            req.esOC = false;
        }
    
        req.BuscarProducto = function (descripcion) {
            try {
                req.form.busqueda = descripcion;
                $Ex.Execute("GetProductoCmb", req.form, function (response, isInvalid) {
                    req.ListaProducto = response.d.Producto;
                }, {},false);
            } catch (ex) {
                Ex.mensajes(ex.message, 4);
                Ex.load(false);
            }
        };

        req.AutorizarPorCotizarReq = function () {
            try {
                
               if (!$Ex.IsValidateRequiredFieldForm(req.Form)) {
                   req.isValid = false;
                  return;
                }
                var lista = angular.copy(req.ListaReqProducto);
                var productos = [];
                angular.forEach(lista, function (item) {
                    delete item.Producto;
                    productos.push(item);
                });

                var listaProv = angular.copy(req.ListaReqProveedor);
                var proveedores = [];
                var esGanador = false;
                angular.forEach(listaProv, function (item) {
                    delete item.Proveedor;
                    if (item.Ganador) {
                        esGanador = true;
                    }
                    proveedores.push(item);
                });
                if (!esGanador) {
                    Ex.mensajes(Ex.GetResourceValue("msgErrorGanador"));
                    return;
                }
                req.form.ListaReqProducto = JSON.stringify(productos);
                req.form.ListaReqProveedor = JSON.stringify(proveedores);
                var callback = function (response) {
                    Ex.load(false);
                    Ex.mensajes(Ex.GetResourceValue("msgAlertAutorizacionMonto"), 1, null, null, null, req.BuscarReq, null);
                }
                Ex.load(true);

                $Ex.Execute("EnviaParaAutorizacion", req.form, callback, undefined, null, null, null, req);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.confirmaConvertirOC = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmCOnvertirOC"), 2, null, null, null, req.ConvertirReqOC, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.confirmaConvertirOC = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmCOnvertirOC"), 2, null, null, null, req.ConvertirReqOC, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };
         
        req.confirmaEnviaAutorizar = function () {
            try {
                req.esRequiredAutorizacion = true;
                Ex.mensajes(Ex.GetResourceValue("msgConfirmEnviarAutorizar"), 2, null, null, null, req.AutorizarPorCotizarReq, function () {
                    req.esRequiredAutorizacion = false;
                });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.confirmaAutorizar = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmAutorizar"), 2, null, null, null, req.AutorizarReq, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        }; 
      
        req.confirmaRechazar = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmRechazar"), 2, null, null, null, req.RechazarReq, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.confirmaAutorizarOC = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmAutorizar"), 2, null, null, null, req.AutorizarReq, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.confirmaRechazarOC = function () {
            try {
                Ex.mensajes(Ex.GetResourceValue("msgConfirmRechazar"), 2, null, null, null, req.RechazarReq, function () { });
            } catch (ex) {
                Ex.mensajes(ex.message);
                Ex.load(false);
            }
        };

        req.AutorizarReq = function () {
            try {
                Ex.load(true);
                var callback = function (response) {
                    Ex.mensajes(Ex.GetResourceValue("msgAlertAutorizada"), 1, null, null, null, req.BuscarReq, null);
                }
                $Ex.Execute("AutorizarRequisicion", req.form, callback);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.RechazarReq = function () {
            try {
                Ex.load(true);
                var callback = function (response) {
                    Ex.mensajes(Ex.GetResourceValue("msgAlertRechazada"), 1, null, null, null, req.BuscarReq, null);
                }
                $Ex.Execute("RechazarRequisicion", req.form, callback);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.CancelarReq = function () {
            try {
                Ex.load(true);
                var callback = function (response) {
                    Ex.mensajes(Ex.GetResourceValue("msgAlertCancelada"), 1, null, null, null, req.BuscarReq, null);
                }
                $Ex.Execute("CancelarRequisicion", req.form, callback);
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        };

        req.Distribuir = function (item,index) {
            var info = {};
            if (req.ListaReqProducto[index].Producto == undefined) {
                Ex.mensajes(Ex.GetResourceValue("msjDistribuirSinProducto"));
                return;
            }
            if (req.ListaReqProducto[index].Cantidad == 0) {
                Ex.mensajes(Ex.GetResourceValue("msjDistribuirSinCantidad"));
                return;
            }
            info.Cantidad = req.ListaReqProducto[index].Cantidad;
            req.distribuir.ProductoID = req.ListaReqProducto[index].ProductoID;
            var callback = function (response) {
                var data = response.d;
                req.distribuir = data.Producto[0];
                req.distribuir.Cantidad = info.Cantidad;
                req.ListaDistribuir = data.Distribucion;
                req.ListaDistribuirAux = data.Distribucion;
                Ex.modalShow("modalDistribuir");
                Ex.load(false);
            }
            $Ex.Execute("DistribuirReq", req.distribuir, callback);
        }

        req.CambiarDistribucion = function (item) {
            var info = {};
            info.Cantidad = req.distribuir.Cantidad;
            req.distribuir.CantidadOrdenar = 0;
            angular.forEach(req.ListaDistribuir, function (item, key) {
                if (!isNaN(parseFloat(item.CantidadOrdenar))) {
                    req.distribuir.CantidadOrdenar += parseFloat(item.CantidadOrdenar);
                }
            });
            req.distribuir.PorDistribuir = (req.distribuir.Cantidad - req.distribuir.CantidadOrdenar);
        }

        req.GuardarDistribucion = function () {
            var info = {};
            if (req.distribuir.PorDistribuir != 0) {
                Ex.mensajes(Ex.GetResourceValue("msjDistribuirEnCero"));
                return;
            }
            var listaDistribuir = angular.copy(req.ListaDistribuir);
            req.distribuir.ListaDistribuir = JSON.stringify(listaDistribuir);
            var callback = function (response) {
                var data = response.d;
                Ex.modalHide("modalDistribuir");
                Ex.load(false);
            }
            $Ex.Execute("GuardarDistribuir", req.distribuir, callback);
        }

        req.DistribuidorCerrar = function () {
            Ex.modalHide("modalDistribuir");
        }
      
        req.Carga();

    }]);
})();
setTimeout("$('.selectPicker').selectpicker()", 1000);



