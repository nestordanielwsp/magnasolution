(function () {
    app.controller('preNotaCreditoController', ['$scope', '$http', 'util', "$timeout", "$filter",
        function ($scope, $http, util, $timeout, $filter) {
            $Ex.Http = $http;

            $scope.filtro = { Fecha: { StartDate: "", EndDate: "" } }
            $scope.justificacion = { Numero: 500 }
            $scope.notasCredito = [];
            $scope.tipoNotasCredito = TipoNotaCreditoInfo;
            $scope.tipoNotas = TipoNotaInfo;
            $scope.cuenasContables = CuentaContableInfo;
            $scope.estatusNotasCredito = EstatusInfo;
            $scope.marcas = MarcaInfo;
            $scope.canales = CanalInfo;
            $scope.tipoDescuentos = [];
            $scope.CuentasIva = [];
            $scope.LibrosDiario = [];
            $scope.notaCredito = {};
            $scope.forma = {};
            $scope.form = {};
            $scope.loading = false;
            $scope.esContractual = false;
            $scope.esBloqueadoIVA = true;
            $scope.esTipoDescuentoProntoPago = false;

            $scope.clienteOptions = { idProp: "ClienteId", displayProp: "Cliente", methodName: "GetClientes" };
            $scope.productoOptions = { idProp: "ProductoId", displayProp: "Producto", methodName: "GetProductos" };
            $scope.cuentaOptions = { idProp: "CuentaContableId", displayProp: "NombreCuentaContable", methodName: "GetCuentas" };
            $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();

            $scope.filtro.Fecha.StartDate = FechaInicialInfo.StartDate;
            $scope.filtro.Fecha.EndDate = FechaInicialInfo.EndDate;
            $scope.justificacion.Numero = FechaInicialInfo.Numero;
            $scope.justificacion.esUsuarioAnalista = FechaInicialInfo.PerfilF === "9" ? true : false;



            $scope.fileOptionsDetalle = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true,
                validExtensions: Ex.GetResourceValue('validExtensions'),
                maxFilesize: Ex.GetResourceValue('maxFileSize'),
                puedeEliminar: true
            };



            var objFecha = new Date();
            var dia = objFecha.getDate().toString();
            if (dia.length != 2)
                dia = '0' + dia;
            var mes = (objFecha.getMonth() + 1).toString();
            if (mes.length != 2)
                mes = '0' + mes;
            var anio = objFecha.getFullYear().toString();

            var fechaNueva = dia + "/" + mes + "/" + anio;

            var setSubcuenta = function (item) {
                var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                var index = _.findIndex($scope.notaCredito.Marcas, { id: item.id });
                $scope.notaCredito.Marcas[index].LineaCodigo = marca.LineaCodigo;
                $scope.notaCredito.Marcas[index].SubcuentaId = marca.SubcuentaId;
                $scope.notaCredito.Marcas[index].NombreMarca = marca.NombreMarca;
                $scope.notaCredito.Marcas[index].Tasa = marca.Tasa;
                $scope.notaCredito.Marcas[index].AplicaIVA = marca.AplicaIVA;

                $scope.clearAjuste();
            }

            //Opciones de Archivo
            $scope.fileOptions = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true
            };
            $scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };

            //Get Info from ConfiguracionGeneral
            var configuracionGeneral = ConfiguracionInfo[0];

            if ($scope.tipoNotas.length === 0) {
                $scope.agregarOculto = true;
            }

            $scope.esVendedor = $scope.tipoNotas.length > 1;

            $scope.agregar = function () {
                $scope.notaCredito = {};
                $scope.submitted = false;
                $scope.valoresABuscar = "";
                $timeout(function () {
                    $scope.esDetalle = true;
                }, 400);

                //$scope.form.disableForm(false);
            }

            $scope.mostrarForma = function (nota) {
                $scope.notaCredito = nota ? nota :
                    {
                        TipoNotaCreditoId: $scope.notaCredito.TipoNotaCreditoId,
                        Archivos: [],
                        Facturas: [],
                        Marcas: [],
                        ProductosDevolucion: [],
                        TipoApoyoEvidencia: [],
                        EsIvaGeneral: false,
                        EsSolicitante: true,
                        FechaConciliacion: fechaNueva
                    };
                $scope.notaCredito.esContractual = $scope.notaCredito.TipoNotaCreditoId === 1;
                $scope.notaCredito.esExtraContractual = $scope.notaCredito.TipoNotaCreditoId === 2;
                $scope.notaCredito.esApv = $scope.notaCredito.TipoNotaCreditoId === 3;
                $scope.notaCredito.esDevolucion = $scope.notaCredito.TipoNotaCreditoId === 4;
                $scope.tipoDescuentos = [];
                $scope.tipoApoyoEvidencia = $scope.notaCredito.TipoApoyoEvidencia;
                $scope.tipoApoyoEvidencia_ = $scope.notaCredito.TipoApoyoEvidencia;
                $scope.notaCredito.esAplicaProntoPago = nota == undefined ? false : nota.esAplicaProntoPago;
                $scope.notaCredito.esAplicaProntoPagoExcepcion = nota == undefined ? false : nota.esAplicaProntoPagoExcepcion;
               // $scope.notaCredito.esTipoDescuentoProntoPago = (nota.TipoDescuentoId === 2 || nota.TipoDescuentoId === 1) ? true : false;
            }

            //Se manda a llamar cuando se selecciona un cliente
            $scope.setValorCampos = function (item) {
                $scope.notaCredito.MontoInicial = null;
                $scope.notaCredito.MultiplicarPor = null;
                $scope.notaCredito.NombreVendedor = $scope.esVendedor ? item.Vendedor : Usuario;
                $scope.notaCredito.NombreCobrarA = item.NombreCobrarA;
                $scope.notaCredito.VendedorId = item.VendedorId;
                $scope.notaCredito.Direccion = item.Direccion;
                $scope.notaCredito.Facturas = [];
                $scope.notaCredito.AutocalculadoPorFacturas = false;

                if ($scope.notaCredito.esContractual) {
                    if (item.ClienteId) {
                        try {
                            $scope.notaCredito.TipoDescuentoId = null;
                            $Ex.Execute("GetTipoDescuentos", item, function (response) {
                                $scope.notaCredito.TipoDescuentos = response.d;

                                if (response.d.length === 1) {
                                    $scope.notaCredito.esTipoDescuentoProntoPago = false;
                                    var tipoDescuento = response.d[0];
                                    $scope.notaCredito.esTipoDescuentoProntoPago = (tipoDescuento.TipoDescuentoId === 2 || tipoDescuento.TipoDescuentoId === 1) ? true : false;
                                    $scope.notaCredito.AplicaAjusteCentavos = tipoDescuento.EsPorcentaje;

                                    $scope.notaCredito.TipoDescuentoId = tipoDescuento.TipoDescuentoId;
                                    $scope.notaCredito.EsPorcentaje = tipoDescuento.AutocalculadoPorFacturas || tipoDescuento.ReferenciaFactura;
                                    $scope.notaCredito.AutocalculadoPorFacturas = tipoDescuento.AutocalculadoPorFacturas;
                                    $scope.notaCredito.MontoPorcentaje = tipoDescuento.Monto;
                                    $scope.notaCredito.ActivityId = tipoDescuento.ActivityId;
                                    $scope.notaCredito.Monto = tipoDescuento.EsPorcentaje ? null : tipoDescuento.Monto;
                                    $scope.notaCredito.EsCambiarMonto = !tipoDescuento.EsMontoFijo;

                                    if (!tipoDescuento.EsPorcentaje && !tipoDescuento.EsMontoFijo) {
                                        $scope.notaCredito.MontoInicial = tipoDescuento.Monto;
                                        $scope.notaCredito.MultiplicarPor = 1;
                                    }
                                }
                            });

                        } catch (ex) {
                            Ex.mensajes(ex.message, 4);
                        }
                    }
                }

                if ($scope.notaCredito.esExtraContractual) {
                    try {
                        $scope.notaCredito.DescuentoId = null;
                        $Ex.Execute("GetExtracontractuales", $scope.notaCredito, function (response) {
                            $scope.extracontractuales = response.d;
                        });

                    } catch (ex) {
                        Ex.mensajes(ex.message, 4);
                    }
                }
            };

            $scope.setValorProducto = function (opcionSeleccionada, item) {
                item.NombreProducto = opcionSeleccionada.Description;
            };

            $scope.verTipoDescuento = function () {
                var tipoDescuento = _.find($scope.notaCredito.TipoDescuentos, { TipoDescuentoId: $scope.notaCredito.TipoDescuentoId });



                $scope.notaCredito.esTipoDescuentoProntoPago = false;
                if (tipoDescuento) {
                    $scope.notaCredito.esTipoDescuentoProntoPago = (tipoDescuento.TipoDescuentoId === 2 || tipoDescuento.TipoDescuentoId === 1) ? true : false;

                    $scope.notaCredito.AplicaAjusteCentavos = tipoDescuento.EsPorcentaje;
                    $scope.notaCredito.MontoInicial = null;
                    $scope.notaCredito.MultiplicarPor = null;
                    $scope.notaCredito.Monto = null;
                    $scope.notaCredito.EsPorcentaje = tipoDescuento.AutocalculadoPorFacturas || tipoDescuento.ReferenciaFactura;
                    $scope.notaCredito.EsProrrateo = tipoDescuento.EsPorcentaje;
                    $scope.notaCredito.AutocalculadoPorFacturas = tipoDescuento.AutocalculadoPorFacturas;
                    $scope.notaCredito.MontoPorcentaje = tipoDescuento.Monto;
                    $scope.notaCredito.ActivityId = tipoDescuento.ActivityId;
                    $scope.notaCredito.EsIvaGeneral = tipoDescuento.EsIvaGeneral;
                    $scope.notaCredito.Monto = tipoDescuento.EsPorcentaje ? null : tipoDescuento.Monto;
                    $scope.notaCredito.EsCambiarMonto = !tipoDescuento.EsMontoFijo;
                    $scope.notaCredito.AutocalculadoPorFacturas = tipoDescuento.AutocalculadoPorFacturas;
                    $scope.notaCredito.ReferenciaFactura = tipoDescuento.ReferenciaFactura;
                    $scope.notaCredito.Facturas = [];
                    $scope.notaCredito.Marcas = [];

                    if (!tipoDescuento.EsPorcentaje && !tipoDescuento.EsMontoFijo) {
                        $scope.notaCredito.MontoInicial = tipoDescuento.Monto;
                        $scope.notaCredito.MultiplicarPor = 1;
                    }
                }
            };

            //$scope.verBusquedaFacturas = function (notaCredito) {
            //    var notaCredito_1 = $scope.notaCredito;

            //    if (notaCredito_1.AutocalculadoPorFacturas || notaCredito_1.ReferenciaFactura || notaCredito_1.EsPorcentaje) {
            //        return true;
            //    }


            //};

            var marcasSellIn = [];
            var getMarcas = function () {
                try {
                    $Ex.Execute("GetMarcas", $scope.notaCredito, function (response) {
                        $scope.notaCredito.Marcas = response.d;
                        marcasSellIn = response.d;
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.tipoapoyo = [];
            var getTipoApoyo = function () {
                try {
                    var datos = { CanalId: $scope.notaCredito.CanalId, TipoNotaCreditoId: $scope.notaCredito.TipoNotaCreditoId };
                    $Ex.Execute("GetTipoApoyoEvidencia", datos, function (response) {
                        $scope.tipoapoyo = response.d;
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }

            }

            
            $scope.getTipoApoyoEvidencia = function (item) {                
                try {
                    var datos = { TipoApoyoId: item };
                    $Ex.Execute("GetTipoApoyoEvidencia", datos, function (response) {
                        $scope.tipoApoyoEvidencia = response.d;
                        $scope.tipoApoyoEvidencia_ = angular.copy($scope.tipoApoyoEvidencia);
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }

            }
            


            var montoEnAutorizacion = 0;
            $scope.verTipoActividad = function () {
                var descuento = _.find($scope.extracontractuales,
                    { DescuentoId: $scope.notaCredito.DescuentoExtracontractualId });

                $scope.notaCredito.Facturas = [];
                $scope.notaCredito.Marcas = [];
                $scope.notaCredito.EsSeleccionarImpacto = false;
                $scope.notaCredito.EsSellIn = false;
                $scope.notaCredito.EsSellOut = false;
                $scope.EsSeleccionarImpacto = false;
                $scope.notaCredito.EsPorcentaje = false;
                $scope.notaCredito.Monto = 0;
                marcasSellIn = [];

                if (descuento) {
                    $scope.notaCredito.DescuentoId = descuento.DescuentoId;
                    $scope.notaCredito.ActivityId = descuento.ActivityId;
                    $scope.notaCredito.Estrategia = descuento.Estrategia;
                    $scope.notaCredito.NombreCanal = descuento.NombreCanal;
                    $scope.notaCredito.CanalId = descuento.CanalId;
                    $scope.notaCredito.MontoAutorizado = descuento.MontoAutorizado;
                    $scope.notaCredito.MontoEnAutorizacion = descuento.MontoEnAutorizacion;
                    $scope.notaCredito.VigenciaInicio = descuento.VigenciaInicio;
                    $scope.notaCredito.VigenciaFin = descuento.VigenciaFin;
                    $scope.notaCredito.Balance = descuento.Balance;
                    montoEnAutorizacion = descuento.MontoEnAutorizacion;

                    if (descuento.EsSellIn && descuento.EsSellOut) {
                        $scope.EsSeleccionarImpacto = true;
                        $scope.notaCredito.EsSellIn = false;
                        $scope.notaCredito.EsSellOut = false;
                    } else {
                        $scope.notaCredito.EsSellIn = descuento.EsSellIn;
                        $scope.notaCredito.EsSellOut = descuento.EsSellOut;
                        $scope.notaCredito.EsPorcentaje = descuento.EsSellIn;
                    }
                    getMarcas();
                    getTipoApoyo();
                }
            };

            $scope.setTipoImpacto = function (esSellIn) {
                $scope.notaCredito.Facturas = [];
                $scope.notaCredito.Marcas = [];

                $scope.notaCredito.EsSellIn = esSellIn;
                $scope.notaCredito.EsSellOut = !esSellIn;
                $scope.notaCredito.EsPorcentaje = esSellIn;

                if ($scope.notaCredito.esExtraContractual && $scope.notaCredito.EsSellIn && $scope.notaCredito.NombreCanal == 'MAYOREO')
                {

                }

                getMarcas();
            };


            

            $scope.calcularMonto = function () {
                $scope.notaCredito.MultiplicarPor = $scope.notaCredito.MultiplicarPor ? $scope.notaCredito.MultiplicarPor : 1;
                //$scope.notaCredito.Monto = $scope.notaCredito.MontoInicial * $scope.notaCredito.MultiplicarPor;
            };

            var getMontoTotal = function () {
                $scope.notaCredito.TotalMontoFacturas = _.reduce($scope.notaCredito.Facturas, function (value, item) {
                    return item.Total + value;
                }, 0);
            };

            $scope.buscarFacturas = function () {
                if ($scope.valoresABuscar) {
                    $scope.notaCredito.TextoFacturas = $scope.valoresABuscar.split(/[ ,;]+/).join();
                    try {
                        $Ex.Execute("BuscarFacturas", $scope.notaCredito, function (response) {
                            $scope.notaCredito.Facturas = response.d;

                            if ($scope.notaCredito.esContractual && $scope.notaCredito.AutocalculadoPorFacturas)
                                $scope.notaCredito.Marcas = [];
                            getMontoTotal();
                        });

                    } catch (ex) {
                        Ex.mensajes(ex.message, 4);
                    }
                }
            };

            var getLineaTotalesMarca = function (validar) {

                $scope.clearAjuste();

                if (!validar || $scope.notaCredito.Marcas.length > 0) {
                    $scope.notaCredito.Subtotal = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                        var subtotal = isNaN(e.Subtotal) ? 0 : e.Subtotal;
                        return subtotal + value;
                    }, 0);

                    $scope.notaCredito.Iva = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                        var iva = isNaN(e.Iva) ? 0 : e.Iva;
                        return iva + value;
                    }, 0);



                    //Si validar trae la propiedad id significa que viene de los eventos del multiselect
                    if (validar != null && validar.hasOwnProperty("id")) {
                        $scope.notaCredito.Monto = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                            var total = isNaN(e.Total) ? 0 : e.Total;
                            return total + value;
                        }, 0);
                    }
                }

                $scope.notaCredito.Monto = $scope.notaCredito.Iva + $scope.notaCredito.Subtotal;


                if ($scope.notaCredito.esContractual && $scope.notaCredito.EsAplicaIVARetencion) {
                    $scope.notaCredito.RetencionIVA = $scope.notaCredito.Subtotal * (configuracionGeneral.ClaveIvaRetencion / 100);

                    $scope.notaCredito.TotalConRetencionIVA = $scope.notaCredito.Monto - $scope.notaCredito.RetencionIVA;
                }

            };

            var calcularIVA = function (item) {
                var cantidad = isNaN(item.Cantidad) ? 0 : item.Cantidad;
                var monto = isNaN(item.Monto) ? 0 : item.Monto;

                //Check if TipoIVA Frontera is selected
                var tasaIVA = $scope.notaCredito.EsAplicaIVAFrontera ? configuracionGeneral.ClaveIvaFrontera : item.Tasa;

                var iva = item.AplicaIVA || $scope.notaCredito.EsIvaGeneral ? cantidad * monto * (tasaIVA / 100) : 0;

                //var ivaFloat = parseFloat(iva.toFixed(2));

                item.Iva = iva > 0 ? iva : null;
                item.Subtotal = cantidad * monto;

                var total = item.Iva ? item.Subtotal + iva : item.Subtotal;

                item.Total = total;
                //item.Total = parseFloat(total.toFixed(2));
            };

            var getTotalesMarca = function (item) {
                calcularIVA(item);

                $scope.notaCredito.Monto = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                    var total = isNaN(e.Total) ? 0 : e.Total;
                    return total + value;
                }, 0);

                $scope.notaCredito.Monto = +$scope.notaCredito.Monto.toFixed(2);
                getLineaTotalesMarca(false);

                if ($scope.notaCredito.esExtraContractual) {
                    $scope.notaCredito.MontoEnAutorizacion = $scope.notaCredito.MontoEnAutorizacion ?
                        $scope.notaCredito.MontoEnAutorizacion : 0;

                    $scope.notaCredito.Balance = $scope.notaCredito.Balance ? $scope.notaCredito.Balance : 0;

                    $scope.notaCredito.MontoEnAutorizacion = montoEnAutorizacion + $scope.notaCredito.Subtotal;

                    $scope.notaCredito.Balance = +$scope.notaCredito.MontoAutorizado.toFixed(2) -
                        +$scope.notaCredito.MontoEnAutorizacion.toFixed(2);
                }
            };

            $scope.seleccionarFactura = function () {
                var facturas = _.where($scope.notaCredito.Facturas, { Seleccionada: true });

                if ($scope.notaCredito.esContractual && $scope.notaCredito.AutocalculadoPorFacturas) {
                    var datos = {
                        Facturas: _.pluck(facturas, "FacturaId").toString(),
                        Porcentaje: $scope.notaCredito.MontoPorcentaje,
                        EsIvaGeneral: $scope.notaCredito.EsIvaGeneral,
                        EsExtracontractual: $scope.notaCredito.esExtraContractual,
                        ReferenciaFactura: $scope.notaCredito.ReferenciaFactura,
                        Marcas: _.pluck($scope.notaCredito.Marcas, "LineaCodigo").toString()
                    };

                    $Ex.Execute("BuscarMarcas", datos, function (response) {
                        $scope.notaCredito.Marcas = response.d;
                        _.forEach($scope.notaCredito.Marcas, function (e) {
                            calcularIVA(e);
                        });

                        getLineaTotalesMarca(true);


                        if ($scope.notaCredito.AutocalculadoPorFacturas === false) {
                            return;
                        }
                        $scope.notaCredito.Monto = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                            var total = isNaN(e.Total) ? 0 : e.Total;
                            return total + value;
                        }, 0);

                        if ($scope.notaCredito.esExtraContractual)
                            $scope.aplicarIvaMarcas();

                        if ($scope.notaCredito.EsAplicaIVARetencion)
                            $scope.aplicarIvaRetencion();
                    });
                }

                if (facturas.length > 0) {
                    $scope.notaCredito.esAplicaProntoPago = facturas[0].AplicaProntoPago_sn == 1 ? true : false;
                    $scope.notaCredito.esAplicaProntoPagoExcepcion = facturas[0].AplicaProntoPago_sn == 0 ? true : false;
                }
                else {
                    $scope.notaCredito.esAplicaProntoPago = false;
                    $scope.notaCredito.esAplicaProntoPagoExcepcion = false;
                }

                console.log('Aplica Ajuste: ' + $scope.notaCredito.AplicaAjusteCentavos)
                console.log('esAplicaProntoPago ' + $scope.notaCredito.esAplicaProntoPago);
                console.log('esAplicaProntoPagoExcepcion ' + $scope.notaCredito.esAplicaProntoPagoExcepcion);
                console.log('Marcas ' + $scope.notaCredito.Marcas.length);
                console.log('Es Contractual ' + $scope.notaCredito.esContractual);
                console.log('Es esTipoDescuentoProntoPago ' + $scope.notaCredito.esTipoDescuentoProntoPago);


            };

            $scope.AplicaProntoPagoExcepcion = function () {
                $scope.notaCredito.esAplicaProntoPago = true;


                console.log('Aplica Ajuste: ' + $scope.notaCredito.AplicaAjusteCentavos)
                console.log('esAplicaProntoPago ' + $scope.notaCredito.esAplicaProntoPago);
                console.log('esAplicaProntoPagoExcepcion ' + $scope.notaCredito.esAplicaProntoPagoExcepcion);
                console.log('Marcas ' + $scope.notaCredito.Marcas.length);
                console.log('Es Contractual ' + $scope.notaCredito.esContractual);
                console.log('Es esTipoDescuentoProntoPago ' + $scope.notaCredito.esTipoDescuentoProntoPago);
            }

            //$scope.aplicarIvaMarcas = function () {
            //    $timeout(function () {
            //        var totalMarcas = $scope.notaCredito.Marcas.length;
            //        for (var i = 0; i < totalMarcas; i++) {
            //            getTotalesMarca($scope.notaCredito.Marcas[i]);
            //        }
            //    }, 0);
            //};

            $scope.aplicarIvaMarcas = function () {
                $timeout(calculateTotalesMarca, 0);
            };

            $scope.cambiarTipoIVA = function () {
                $timeout(calculateTotalesMarca, 0);
            };

            $scope.aplicarIvaRetencion = function () {
                $timeout(getLineaTotalesMarca, 0);
            };

            var calculateTotalesMarca = function () {
                var totalMarcas = $scope.notaCredito.Marcas.length;
                for (var i = 0; i < totalMarcas; i++) {
                    getTotalesMarca($scope.notaCredito.Marcas[i]);
                }
            };

            $scope.multiselectEventos = {
                onItemSelect: setSubcuenta,
                onItemDeselect: getLineaTotalesMarca,
                onDeselectAll: getLineaTotalesMarca
            };

            $scope.getTotalCantidad = function (item) {
                $scope.notaCredito.TotalCantidad = _.reduce($scope.notaCredito.Marcas,
                    function (value, e) {
                        var cantidad = isNaN(e.Cantidad) ? 0 : e.Cantidad;
                        return cantidad + value;
                    },
                    0);

                getTotalesMarca(item);
            };

            $scope.getTotalMonto = function (item) {
                $scope.notaCredito.TotalMontoMarca = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                    var monto = isNaN(e.Monto) ? 0 : e.Monto;
                    return monto + value;
                }, 0);

                getTotalesMarca(item);
            };

            $scope.getAjusteCentavos = function (esConsulta, monto_CONSULTA) {

                // obtiene montos del grid
                var _Monto_AJUSTE = $scope.notaCredito.Total_AJUSTE || 0;

                var _Monto_ACTUAL = $scope.notaCredito.Monto = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                    var total = isNaN(e.Total) ? 0 : e.Total;
                    return total + value;
                }, 0);
                var _iva_ACTUAL = $scope.notaCredito.Monto = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                    var iva = isNaN(e.Iva) ? 0 : e.Iva;
                    return iva + value;
                }, 0);
                var _subtotal_ACTUAL = $scope.notaCredito.Monto = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                    var subtotal = isNaN(e.Subtotal) ? 0 : e.Subtotal;
                    return subtotal + value;
                }, 0);

                // si hay diferencia (ajuste) temporal
                var diferenciaCERO = $scope.notaCredito.Monto_AJUSTE == '' ? 0 : parseFloat($scope.notaCredito.Monto_AJUSTE);

                _Monto_ACTUAL = _Monto_ACTUAL - diferenciaCERO;

                // valida previo
                var _Monto_FINAL = _Monto_AJUSTE - _Monto_ACTUAL;
                var _EsNegativo = _Monto_AJUSTE > _Monto_ACTUAL ? false : true;
                var _diferencia = _Monto_AJUSTE <= 0 ? 0 : parseFloat(_Monto_FINAL.toFixed(4));
                var _diferenciaTEMPORAL = Math.abs(parseFloat(_Monto_FINAL).toFixed(4));

                // validamos tope del sistema +
                if (!_EsNegativo && _diferenciaTEMPORAL > configuracionGeneral.TopeDiasProntoPago) {
                    _diferencia = 0;
                    $scope.notaCredito.Total_AJUSTE = 0;
                    Ex.mensajes(Ex.GetResourceValue("msgTopeDiasProntoPago") + ' $ ' + configuracionGeneral.TopeDiasProntoPago);
                }
                if (_EsNegativo) {
                    _diferenciaTEMPORAL = diferenciaCERO == 0 ? 0 : _Monto_ACTUAL - _Monto_AJUSTE;
                }
                // validamos tope del sistema - menos
                if (_EsNegativo && _Monto_AJUSTE > 0 && $scope.notaCredito.EsProrrateo) {
                    //_diferencia = 0;
                    $scope.notaCredito.Total_AJUSTE = _Monto_AJUSTE;
                    //Ex.mensajes(Ex.GetResourceValue("msgTopeDiasProntoPago") + ' $ ' + configuracionGeneral.TopeDiasProntoPago);

                }

                if (_Monto_AJUSTE == 0) {
                    // base row
                    var data = $scope.notaCredito.Marcas[0];
                    var marca = _.findWhere($scope.marcas, { LineaCodigo: data.id == undefined ? data.LineaCodigo : data.id });
                    var descAJUSTE = "***ajuste centavos***";   // fijo
                    var tasaIVA = $scope.notaCredito.EsAplicaIVAFrontera ? configuracionGeneral.ClaveIvaFrontera : marca.Tasa;
                    var aplicaIVA = marca.AplicaIVA;

                    $scope.notaCredito.Marcas[0].Monto = (($scope.notaCredito.Marcas[0].Monto) - parseFloat(diferenciaCERO));
                    $scope.notaCredito.Marcas[0].Subtotal = ((($scope.notaCredito.Marcas[0].Monto)) * $scope.notaCredito.Marcas[0].Cantidad);
                    $scope.notaCredito.Marcas[0].Iva = aplicaIVA ? (($scope.notaCredito.Marcas[0].Subtotal) * (tasaIVA / 100)) : null;
                    $scope.notaCredito.Marcas[0].Total = (($scope.notaCredito.Marcas[0].Subtotal) + ($scope.notaCredito.Marcas[0].Iva))

                    _Monto_ACTUAL = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                        var total = isNaN(e.Total) ? 0 : e.Total;
                        return total + value;
                    }, 0);
                    _iva_ACTUAL = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                        var iva = isNaN(e.Iva) ? 0 : e.Iva;
                        return iva + value;
                    }, 0);
                    _subtotal_ACTUAL = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                        var subtotal = isNaN(e.Subtotal) ? 0 : e.Subtotal;
                        return subtotal + value;
                    }, 0);

                    $scope.notaCredito.Subtotal = (_subtotal_ACTUAL);
                    $scope.notaCredito.Iva = (_iva_ACTUAL);
                    $scope.notaCredito.Monto = (parseFloat(_Monto_ACTUAL));

                    // clear row    
                    $scope.notaCredito.Cantidad_AJUSTE = '';     // fijo

                    // clear calculadas
                    $scope.notaCredito.Monto_AJUSTE = 0;
                    $scope.notaCredito.Subtotal_AJUSTE = 0;
                    $scope.notaCredito.Iva_AJUSTE = 0;
                    $scope.notaCredito.SubcuentaId_AJUSTE = '';
                    $scope.notaCredito.NombreMarca_AJUSTE = '';
                    $scope.notaCredito.Total_AJUSTE = 0;

                    // gran total
                    $scope.notaCredito.Subtotal = (_subtotal_ACTUAL);
                    $scope.notaCredito.Iva = (_iva_ACTUAL);
                    $scope.notaCredito.Monto = (parseFloat(_subtotal_ACTUAL + _iva_ACTUAL));
                }
                else {


                    // base row
                    var data = $scope.notaCredito.Marcas[0];
                    var marca = _.findWhere($scope.marcas, { LineaCodigo: data.id == undefined ? data.LineaCodigo : data.id });
                    var descAJUSTE = "***ajuste centavos***";   // fijo
                    var tasaIVA = $scope.notaCredito.EsAplicaIVAFrontera ? configuracionGeneral.ClaveIvaFrontera : marca.Tasa;
                    var aplicaIVA = marca.AplicaIVA;
                    // aditional row    
                    $scope.notaCredito.Cantidad_AJUSTE = 1;     // fijo

                    // calculadas
                    if (esConsulta) {
                        _diferencia = monto_CONSULTA;
                    }

                    if (!_EsNegativo) {

                        $scope.notaCredito.Monto_AJUSTE = ((aplicaIVA ? (_diferencia / (1 + (tasaIVA / 100))) : _diferencia)).toFixed(4);
                        $scope.notaCredito.Subtotal_AJUSTE = ((aplicaIVA ? (_diferencia / (1 + (tasaIVA / 100))) : _diferencia)).toFixed(4);
                        $scope.notaCredito.Iva_AJUSTE = aplicaIVA ? (($scope.notaCredito.Monto_AJUSTE) * (tasaIVA / 100)).toFixed(4) : null;


                        $scope.notaCredito.SubcuentaId_AJUSTE = marca.SubcuentaId;
                        $scope.notaCredito.NombreMarca_AJUSTE = marca.NombreMarca + ' ' + descAJUSTE;

                        // gran total
                        //$scope.notaCredito.Subtotal = (_subtotal_ACTUAL + parseFloat($scope.notaCredito.Subtotal_AJUSTE)).toFixed(2);
                        //$scope.notaCredito.Iva = (_iva_ACTUAL + parseFloat($scope.notaCredito.Iva_AJUSTE)).toFixed(2);
                        //$scope.notaCredito.Monto = (parseFloat(_Monto_ACTUAL) + _diferencia).toFixed(2);


                        if (!esConsulta) {
                            $scope.notaCredito.Marcas[0].Monto = (($scope.notaCredito.Marcas[0].Monto) + parseFloat($scope.notaCredito.Monto_AJUSTE) - parseFloat(diferenciaCERO));
                            $scope.notaCredito.Marcas[0].Subtotal = ((($scope.notaCredito.Marcas[0].Monto)) * $scope.notaCredito.Marcas[0].Cantidad);
                            $scope.notaCredito.Marcas[0].Iva = aplicaIVA ? (($scope.notaCredito.Marcas[0].Subtotal) * (tasaIVA / 100)) : null;
                            $scope.notaCredito.Marcas[0].Total = (($scope.notaCredito.Marcas[0].Subtotal) + ($scope.notaCredito.Marcas[0].Iva))
                        }

                        _Monto_ACTUAL = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                            var total = isNaN(e.Total) ? 0 : e.Total;
                            return total + value;
                        }, 0);
                        _iva_ACTUAL = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                            var iva = isNaN(e.Iva) ? 0 : e.Iva;
                            return iva + value;
                        }, 0);
                        _subtotal_ACTUAL = _.reduce($scope.notaCredito.Marcas, function (value, e) {
                            var subtotal = isNaN(e.Subtotal) ? 0 : e.Subtotal;
                            return subtotal + value;
                        }, 0);

                        $scope.notaCredito.Subtotal = (_subtotal_ACTUAL);
                        $scope.notaCredito.Iva = (_iva_ACTUAL);
                        $scope.notaCredito.Monto = (parseFloat(_subtotal_ACTUAL + _iva_ACTUAL));


                    } else {

                        $scope.notaCredito.SubcuentaId_AJUSTE = '';
                        $scope.notaCredito.NombreMarca_AJUSTE = '% ' + descAJUSTE;



                        $scope.notaCredito.Monto = (parseFloat(_subtotal_ACTUAL + _iva_ACTUAL));
                        $scope.notaCredito.Cantidad_AJUSTE = '';
                        $scope.notaCredito.Monto_AJUSTE = '';


                        if ($scope.notaCredito.Marcas.length > 0) {
                            var subt = 0.0;
                            var ivat = 0.0;
                            for (i = 0; i < $scope.notaCredito.Marcas.length; i++) {
                                $scope.notaCredito.Marcas[i].Monto = (($scope.notaCredito.Marcas[i].Monto / _Monto_ACTUAL) * _Monto_AJUSTE);
                                $scope.notaCredito.Marcas[i].Subtotal = (($scope.notaCredito.Marcas[i].Subtotal / _Monto_ACTUAL) * _Monto_AJUSTE);
                                $scope.notaCredito.Marcas[i].Iva = $scope.notaCredito.Marcas[i].Iva != '' && $scope.notaCredito.Marcas[i].Iva != null ? (($scope.notaCredito.Marcas[i].Subtotal) * (tasaIVA / 100)) : null;
                                $scope.notaCredito.Marcas[i].Total = (($scope.notaCredito.Marcas[i].Subtotal) + ($scope.notaCredito.Marcas[i].Iva));

                                subt = subt + parseFloat($scope.notaCredito.Marcas[i].Subtotal);
                                ivat = ivat + parseFloat($scope.notaCredito.Marcas[i].Iva != '' && $scope.notaCredito.Marcas[i].Iva != null ? $scope.notaCredito.Marcas[i].Iva : 0);

                            }

                            $scope.notaCredito.Subtotal_AJUSTE = subt;
                            $scope.notaCredito.Iva_AJUSTE = ivat;





                        }

                    }

                }
            };

            $scope.calcularBalance = function () {
                var marca = marcasSellIn[0];
                var monto = isNaN($scope.notaCredito.Monto) ? 0 : $scope.notaCredito.Monto;

                if (monto > 0 && marca.AplicaIVA) {
                    monto = +(monto / (1 + (marca.Tasa / 100))).toFixed(2);
                }

                $scope.notaCredito.MontoEnAutorizacion =
                    $scope.notaCredito.MontoEnAutorizacion ? $scope.notaCredito.MontoEnAutorizacion : 0;

                $scope.notaCredito.Balance = $scope.notaCredito.Balance ? $scope.notaCredito.Balance : 0;

                $scope.notaCredito.MontoEnAutorizacion = montoEnAutorizacion + monto;
                $scope.notaCredito.Balance =
                    $scope.notaCredito.MontoAutorizado - $scope.notaCredito.MontoEnAutorizacion;
            };

            var caulcarTotalDevolucion = function () {
                if ($scope.notaCredito.ProductosDevolucion != null &&
                    $scope.notaCredito.ProductosDevolucion.length > 0) {
                    $scope.notaCredito.Monto = _.reduce($scope.notaCredito.ProductosDevolucion, function (value, e) {
                        var total = isNaN(e.MontoDevolucion) ? 0 : e.MontoDevolucion;
                        return total + value;
                    }, 0);
                }
            };

            $scope.clearAjuste = function () {

                $scope.notaCredito.Total_AJUSTE = '';
                // aditional row    
                $scope.notaCredito.Cantidad_AJUSTE = '';     // fijo

                // calculadas
                $scope.notaCredito.Monto_AJUSTE = '';
                $scope.notaCredito.Subtotal_AJUSTE = '';
                $scope.notaCredito.Iva_AJUSTE = '';
                $scope.notaCredito.SubcuentaId_AJUSTE = '';
                $scope.notaCredito.NombreMarca_AJUSTE = '';
            }

            $scope.calcularDevolucion = function (item) {
                var costo = isNaN(parseFloat(item.CostoConInva)) ? 0 : parseFloat(item.CostoConInva);
                var piezaPorCaja = isNaN(parseInt(item.PiezasCaja)) ? 0 : parseInt(item.PiezasCaja);
                var cajas = isNaN(parseInt(item.TotalCajas)) ? 0 : parseInt(item.TotalCajas);
                var unidades = isNaN(parseInt(item.TotalUnidades)) ? 0 : parseInt(item.TotalUnidades);
                var precioUnitario = piezaPorCaja > 0 ? costo / piezaPorCaja : 0;

                if (unidades >= piezaPorCaja && piezaPorCaja > 0) {
                    item.TotalCajas += parseInt(unidades / piezaPorCaja);
                    item.TotalUnidades = unidades % piezaPorCaja;

                    cajas = item.TotalCajas;
                    unidades = item.TotalUnidades;
                }

                item.MontoCajas = costo * cajas;
                item.MontoUnidades = unidades * precioUnitario;
                item.MontoDevolucion = item.MontoCajas + item.MontoUnidades;

                caulcarTotalDevolucion();
            };

            $scope.agregarArchivo = function () {
                $scope.notaCredito.Archivos.push({ EsNuevo: true });
            };

            $scope.quitarArchivo = function (item) {
                item.EsEliminar = true;
            };

            $scope.agregarProducto = function () {
                $scope.notaCredito.ProductosDevolucion.push({});
            };

            $scope.quitarProducto = function (index) {
                $scope.notaCredito.ProductosDevolucion.splice(index, 1);
                caulcarTotalDevolucion();
            };

            $scope.getCausales = function (item) {
                try {
                    item.EsAveriado = item.EsDisponible === "0";
                    $Ex.Execute("GetCausales",
                        item,
                        function (response) {
                            item.causalesDevolucion = response.d;
                        });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.verNota = function (item) {
                try {
                    $scope.submitted = true;
                    $scope.comentarioRequerido = false;
                    $Ex.Execute("GetNotaCredito",
                        item,
                        function (response) {
                            $scope.notaCredito = response.d;
                            $scope.esDetalle = true;
                            $scope.evidenciaAbierta = false;
                            $scope.valoresABuscar = "";
                            $scope.notaCredito.EsCambiarMonto = $scope.notaCredito.MontoInicial;
                            var _monto = $scope.notaCredito.Monto;
                            $scope.mostrarForma($scope.notaCredito);

                            if ($scope.notaCredito.EsPorcentaje) {
                                getMontoTotal();
                            }

                            getLineaTotalesMarca(true);
                            caulcarTotalDevolucion();

                            if ($scope.notaCredito.TieneAjuste) {
                                $scope.notaCredito.AplicaAjusteCentavos = true;
                                $scope.notaCredito.Total_AJUSTE = parseFloat(_monto);
                                $scope.getAjusteCentavos(true, (parseFloat(item.Monto_AJUSTE) + (item.Iva_AJUSTE == null ? 0 : parseFloat(item.Iva_AJUSTE))));
                            }
                            else {
                                $scope.notaCredito.AplicaAjusteCentavos = false;
                                $scope.clearAjuste();
                            }

                            if ($scope.notaCredito.esExtraContractual) {
                                try {
                                    $scope.notaCredito.DescuentoId = null;
                                    $Ex.Execute("GetExtracontractuales", $scope.notaCredito, function (response) {
                                        $scope.extracontractuales = response.d;

                                        $scope.actualizarPermisosActividad();
                                    });

                                } catch (ex) {
                                    Ex.mensajes(ex.message, 4);
                                }
                            }


                            //$scope.form.disableForm(true);
                        });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };


            $scope.actualizarPermisosActividad = function () {
                var descuento = _.find($scope.extracontractuales,
                    { DescuentoId: $scope.notaCredito.DescuentoExtracontractualId });

                $scope.EsSeleccionarImpacto = false;

                if (descuento) {

                    if (descuento.EsSellIn && descuento.EsSellOut && $scope.notaCredito.EstatusNotaCreditoId == 7 &&
                        UsuarioId == $scope.notaCredito.SolicitanteId) {
                        $scope.EsSeleccionarImpacto = true;
                    }
                }
            };

            $scope.getNotasCredito = function (respuestaAprobacion, esCimConsulta) {
                try {
                    $scope.submitted = true;
                    $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                    $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";
                    $Ex.Execute("GetNotasCredito",
                        $scope.filtro,
                        function (response) {
                            $scope.notasdeCredito = response.d;
                            $scope.notasdeCredito_ = response.d;

                            $scope.esAprobadorMasivo = _.some(response.d, { MostrarAprobar: true });
                            $scope.esUsuarioAprobador = _.some(response.d, { EsUsuarioAprobador: true });

                            if (respuestaAprobacion != null) {
                                if (respuestaAprobacion.hasOwnProperty("ErrorParaUsuario")) {
                                    Ex.mensajes(respuestaAprobacion.ErrorParaUsuario);
                                    console.log(respuestaAprobacion.ErrorParaTi);
                                } else {
                                    if (!esCimConsulta) {
                                        Ex.mensajes(Ex.GetGlobalResourceValue("msgSuccess"));
                                    }
                                }
                            }

                        });

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            var guardarNota = function () {
                if (typeof ($scope.notaCredito.NotaCreditoId) === "boolean") {
                    delete $scope.notaCredito.NotaCreditoId;
                }
                $Ex.Execute("Guardar",
                    $scope.notaCredito,
                    function (response, isInvalid) {
                        if (!isInvalid) {

                            // dejamos en la misma pantalla
                            $scope.notaCredito = response.d;
                            $scope.esDetalle = true;
                            $scope.evidenciaAbierta = false;
                            $scope.valoresABuscar = "";
                            $scope.notaCredito.EsCambiarMonto = $scope.notaCredito.MontoInicial;
                            var _monto = $scope.notaCredito.Monto;
                            $scope.mostrarForma($scope.notaCredito);

                            if ($scope.notaCredito.EsPorcentaje) {
                                getMontoTotal();
                            }

                            getLineaTotalesMarca(true);
                            caulcarTotalDevolucion();

                            $scope.getNotasCredito();
                            //////$scope.esDetalle = false;
                            if (response.d.hasOwnProperty("ErrorParaUsuario")) {
                                Ex.mensajes(response.d.ErrorParaUsuario);
                                console.log(response.d.ErrorParaTi);
                            } else {
                                //Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"));
                                $scope.agregar();
                            }
                        }
                    },
                    $scope.forma);
            };


            $scope.guardaryenviarNota = function () {
                if (typeof ($scope.notaCredito.NotaCreditoId) === "boolean") {
                    delete $scope.notaCredito.NotaCreditoId;
                }
                $Ex.Execute("GuardaryEnviar",
                    $scope.notaCredito,
                    function (response, isInvalid) {
                        if (!isInvalid) {

                            // dejamos en la misma pantalla
                            $scope.notaCredito = response.d;
                            $scope.esDetalle = true;
                            $scope.evidenciaAbierta = false;
                            $scope.valoresABuscar = "";
                            $scope.notaCredito.EsCambiarMonto = $scope.notaCredito.MontoInicial;
                            var _monto = $scope.notaCredito.Monto;
                            $scope.mostrarForma($scope.notaCredito);

                            if ($scope.notaCredito.EsPorcentaje) {
                                getMontoTotal();
                            }

                            getLineaTotalesMarca(true);
                            caulcarTotalDevolucion();

                            $scope.getNotasCredito();
                            //////$scope.esDetalle = false;
                            if (response.d.hasOwnProperty("ErrorParaUsuario")) {
                                Ex.mensajes(response.d.ErrorParaUsuario);
                                console.log(response.d.ErrorParaTi);
                            } else {
                                //Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"));
                                $scope.agregar();
                            }
                        }
                    },
                    $scope.forma);
            };

            $scope.guardarNota = function () {
                try {
                    $scope.submitted = true;
                    var archivos = _.filter($scope.notaCredito.Archivos, function (item) {
                        return !item.hasOwnProperty("EsEliminar");
                    });

                    let today = new Date();
                    var date = today.getDate();
                    var month = today.getMonth() + 1;
                    var year = today.getFullYear();
                    var current_date = date + '/' + month + '/' + year;
                    var Fecha = current_date;
                    //var FechaConciliacion = current_date; 

                    //var _tipoNotasCredito = _.findWhere($scope.tipoNotasCredito, { LineaCodigo: item.id });

                    if ($scope.notaCredito.esExtraContractual &&
                        $scope.EsSeleccionarImpacto &&
                        !$scope.notaCredito.EsSellIn &&
                        !$scope.notaCredito.EsSellOut) {
                        Ex.mensajes(Ex.GetResourceValue("msgSeleccionarTipoActivity"));
                        return;
                    }

                    if ($scope.notaCredito.esExtraContractual && $scope.notaCredito.Balance < 0) {
                        Ex.mensajes(Ex.GetResourceValue("msgMontoMayorMontoAutoriado"));
                        return;
                    }

                    // control cambios marzo 2021
                    var TipoNotaCredito = _.filter($scope.tipoNotas, { 'TipoNotaCreditoId': $scope.notaCredito.TipoNotaCreditoId });
                    $scope.notaCredito.Tipo = TipoNotaCredito[0].NombreTipoNotaCredito;
                    $scope.notaCredito.Fecha = Fecha;
                    //$scope.notaCredito.FechaConciliacion = FechaConciliacion;
                    $scope.notaCredito.EstatusId = 0;
                    $scope.notaCredito.ConciliacionId = 0;
                    $scope.notaCredito.DescripcionGeneral = $scope.notaCredito.Justificacion;
                    $scope.notaCredito.NcPorAplicar = $scope.notaCredito.Monto;
                    $scope.notaCredito.FaltanteNc = -$scope.notaCredito.Monto;
                    $scope.notaCredito.Comentarios = $scope.notaCredito.ComentariosLibro;
                    $scope.notaCredito.Archivos = $scope.tipoApoyoEvidencia;

                    if (!$scope.notaCredito.EsCorregir && ($scope.notaCredito.AutocalculadoPorFacturas || $scope.notaCredito.ReferenciaFactura) &&
                        ($scope.notaCredito.Facturas.length === 0 ||
                            !_.some($scope.notaCredito.Facturas, { Seleccionada: true })
                        )
                    ) {
                        Ex.mensajes(Ex.GetResourceValue("msgSeleccioanarFactura"));
                        return;
                    }

                    //if ($scope.esVendedor &&
                    //    ($scope.notaCredito.esApv ||
                    //        $scope.notaCredito.esExtraContractual ||
                    //        !$scope.notaCredito.EsPorcentaje) &&
                    //    archivos.length === 0) {
                    //    Ex.mensajes(Ex.GetResourceValue("msgAgregarSoporte"));
                    //    return;
                    //}

                    if ($scope.notaCredito.esAplicaProntoPagoExcepcion && archivos.length === 0 && $scope.notaCredito.esTipoDescuentoProntoPago) {
                        Ex.mensajes(Ex.GetResourceValue("msgAgregarSoporte"));
                        return;
                    }

                    if ($scope.notaCredito.esAplicaProntoPagoExcepcion) {
                        if (($scope.notaCredito.JustificacionProntoPago == undefined || $scope.notaCredito.JustificacionProntoPago == '') && $scope.notaCredito.esTipoDescuentoProntoPago) {
                            Ex.mensajes(Ex.GetResourceValue("msgAgregarSoporteProntoPago"));
                            return;
                        }
                    }

                    if (($scope.notaCredito.esApv || $scope.notaCredito.esContractual) &&
                        $scope.notaCredito.Marcas.length === 0) {
                        Ex.mensajes(Ex.GetResourceValue("msgAgregarMarcas"));
                        return;
                    }

                    if ($scope.notaCredito.EsSellIn) {
                        var mensaje = Ex.GetResourceValue("msgSellIn")
                            .replace("{0}", $filter('currency')($scope.notaCredito.Monto));
                        Ex.mensajes(mensaje, 2, null, null, null, guardarNota, function () { }, null);
                    } else {
                        guardarNota();
                    }

                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.aprobarRechazarNota = function (accionAprobador) {
                try {
                    var esRechazar = accionAprobador !== "Aprobar";

                    if ($scope.evidenciaAbierta || $scope.notaCredito.EsPorcentaje) {
                        var mensaje = Ex.GetResourceValue('msgConfirmar' + accionAprobador);

                        if ((esRechazar || $scope.notaCredito.EsLogistica === 1) && !$scope.notaCredito.Comentario) {
                            $scope.comentarioRequerido = true;
                            Ex.mensajes(Ex.GetResourceValue(esRechazar ? "msgComentarioRequerdio" : "msgMotivoNotaRequerdio"));
                        } else {
                            Ex.mensajes(mensaje, 2, null, null, null, function () {
                                $scope.notaCredito.AccionAprobador = accionAprobador;
                                $Ex.Execute("AprobarNota", $scope.notaCredito, function (response, isInvalid) {
                                    $scope.getNotasCredito();
                                    $scope.esDetalle = false;
                                    if (response.d.hasOwnProperty("ErrorParaUsuario")) {
                                        Ex.mensajes(response.d.ErrorParaUsuario);
                                        console.log(response.d.ErrorParaTi);
                                    }
                                });
                            }, function () { }, null);
                        }
                    }
                    else {
                        Ex.mensajes(Ex.GetResourceValue("msgAbrirEvidencia"));
                    }
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            $scope.aprobarTodos = function () {
                _.forEach($scope.notasdeCredito, function (item) {
                    if (item.MostrarAprobar) {
                        item.PorAprobar = $scope.esAprobarTodos;
                    }
                });
            }

            $scope.checkSiEsAprobarTodo = function () {
                var notasPorAprobar = _.filter($scope.notasdeCredito, { 'MostrarAprobar': true });
                $scope.esAprobarTodos = _.every(notasPorAprobar, { PorAprobar: true });
            }

            $scope.aprobarNotas = function () {
                var notasPorAprobar = _.filter($scope.notasdeCredito, { 'PorAprobar': true });

                if (notasPorAprobar.length > 0) {
                    var mensaje = Ex.GetResourceValue("msgAprobarNotas").
                        replace("{0}", notasPorAprobar.length);
                    Ex.mensajes(mensaje, 2, null, null, null, function () {
                        var datos = { notasPorAprobar: notasPorAprobar };
                        $Ex.Execute("AprobarNotas", datos, function (response, isInvalid) {
                            $scope.getNotasCredito(response.d);
                        }, undefined, true, null, false);
                    }, function () { }, null);
                }
            }

            $scope.cancelarNota = function () {
                try {
                    Ex.mensajes(Ex.GetResourceValue("msgConfirmarCancelar"), 2, null, null, null, function () {
                        $Ex.Execute("CancelarNota", $scope.notaCredito, function (response, isInvalid) {
                            $scope.getNotasCredito();
                            $scope.esDetalle = false;
                        });
                    }, function () { }, null);
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            }

            $scope.openDocumento = function (info) {
                try {
                    $scope.evidenciaAbierta = true;
                    $Ex.Execute("OpenDocumento", info, function (response, isInvalid) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                        else {
                            Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };


            $scope.setParametrosArchivo = function (response, item) {
                item.UID = response.UID;
                item.RutaArchivo = response.RutaArchivo;
                item.EsArchivoNuevo = response.EsNuevo;
            };

            $scope.abrirDocumento = function (item) {
                $Ex.Execute("AbrirDocumento", item, function (response, isInvalid) {
                    if (response.d) {
                        window.location = "DownLoadPage.aspx?d=" + getRandom();
                    }
                    else {
                        Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                    }
                });
            };

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

            $scope.habilitarMarca = function () {
                var habilitada = ($scope.notaCredito.esApv || $scope.notaCredito.esContractual && !$scope.notaCredito.AutocalculadoPorFacturas) &&
                    (!$scope.notaCredito.NotaCreditoId || $scope.notaCredito.EsCorregir);
                return habilitada;
            };

            $scope.deshabilitarDetalle = function () {

                var result = $scope.notaCredito.AutocalculadoPorFacturas && !$scope.notaCredito.EsSellIn ||
                    $scope.notaCredito.NotaCreditoId && !$scope.notaCredito.EsCorregir;

                if ($scope.notaCredito.esContractual && $scope.notaCredito.AplicaAjusteCentavos) {
                    result = false; // si aplica, enviamos false para habilitar
                }

                return result;
            };

            $scope.noEditable = function () {
                return $scope.notaCredito.NotaCreditoId && !$scope.notaCredito.EsCorregir;
            };

            $scope.esContractualOesExtraContractual = function () {
                return $scope.notaCredito.esContractual || $scope.notaCredito.esExtraContractual;
            };

            $scope.esContractualYesAplicaIVARetencion = function () {
                return $scope.notaCredito.esContractual && $scope.notaCredito.EsAplicaIVARetencion;
            };

            $scope.getNotasCredito();

            $scope.selectCIMTodos = function () {
                _.forEach($scope.notasdeCredito, function (item) {
                    if (item.MostrarSeleccionarCIM) {
                        item.PorSeleccionarCIM = $scope.esSeleccionarCIMTodos;
                    }
                });
            }

            $scope.checkselectCIMTodos = function () {
                var notasPorAprobar = _.filter($scope.notasdeCredito, { 'MostrarSeleccionarCIM': true });
                $scope.esSeleccionarCIMTodos = _.every(notasPorAprobar, { PorSeleccionarCIM: true });
            }

            $scope.generarCimNcNotas = function (esGlobal, parametros) {
                var notasPorAprobar = _.filter($scope.notasdeCredito, { 'PorSeleccionarCIM': true });

                if (notasPorAprobar.length > 0) {
                    var datos = {};
                    datos = parametros;
                    datos.notasPorAprobar = notasPorAprobar
                    datos.esGlobal = esGlobal;
                    $Ex.Execute("GenerarCIMNotas", datos, function (response, isInvalid) {
                        if (response.d) {
                            $scope.getNotasCredito(response.d, true);
                            window.location = "DownLoadPage.aspx?d=" + getRandom();
                        }
                    });
                }
                else {
                    var mensaje = Ex.GetResourceValue("msgGenerarCIMNotasNONE");
                    Ex.mensajes(mensaje, 4);
                }
            }

            $Ex.Execute("GetListas", {}, function (response) {
                $scope.CuentasIva = response.d.CuentasIva;
                $scope.LibrosDiario = response.d.LibrosDiario;
            });

            $scope.changeLibroDiario = function () {
                var libroSeleccionado = $scope.notaCredito.LibroDiario;
                var ClaveNotasCreditoFiscal = 'MXF-NCCL';
                var ClaveNotasCreditoNoFiscal = 'MXF-NCCZ';

                if (libroSeleccionado == ClaveNotasCreditoFiscal) {
                    var libroRow = _.find($scope.LibrosDiario, { Id: libroSeleccionado });
                    $scope.notaCredito.Cuenta = libroRow.Cuenta;
                }
                else if (libroSeleccionado == ClaveNotasCreditoNoFiscal) {
                    var libroRow = _.find($scope.LibrosDiario, { Id: libroSeleccionado });
                    $scope.notaCredito.Cuenta = libroRow.Cuenta;
                }
                else {
                    $scope.notaCredito.LibroDiario = '';
                    $scope.notaCredito.Cuenta = '';
                }

            };

            $scope.openModalNotas = function () {
                var notasPorAprobar = _.filter($scope.notasdeCredito, { 'PorSeleccionarCIM': true });

                if (notasPorAprobar.length > 0) {
                    $scope.submitted = false;
                    $scope.esBloqueadoIVA = false;

                    $scope.notaCredito.DescripcionGeneral = '';
                    $scope.notaCredito.OrdenCompra = '';
                    $scope.notaCredito.DescripcionDetallada = '';
                    $scope.notaCredito.Cuenta = '';
                    $scope.notaCredito.LibroDiario = '';
                    $scope.notaCredito.Comentarios = '';
                    $scope.notaCredito.FechaConciliacion = fechaNueva;
                    $scope.tituloModal = Ex.GetResourceValue("lblGeneralesNc");
                    $scope.modalNotas.open();
                }
                else {
                    var mensaje = Ex.GetResourceValue("msgGenerarCIMNotasNONE");
                    Ex.mensajes(mensaje, 4);
                }
            };

            $scope.guardarNotaAdicional = function (forma) {
                $scope.submitted = true;
                $scope.esBloqueadoIVA = false;
                if (forma.$invalid)
                    Ex.mensajes(Ex.GetGlobalResourceValue("msgRequiredFields"));
                else {
                    var notaSeleccionada = {};
                    notaSeleccionada.DescripcionGeneral = $scope.notaCredito.DescripcionGeneral == undefined ? '' : $scope.notaCredito.DescripcionGeneral;
                    notaSeleccionada.OrdenCompra = $scope.notaCredito.OrdenCompra == undefined ? '' : $scope.notaCredito.OrdenCompra;
                    notaSeleccionada.DescripcionDetallada = $scope.notaCredito.DescripcionDetallada == undefined ? '' : $scope.notaCredito.DescripcionDetallada;
                    notaSeleccionada.Cuenta = $scope.notaCredito.Cuenta;
                    notaSeleccionada.LibroDiario = $scope.notaCredito.LibroDiario;
                    notaSeleccionada.Comentarios = $scope.notaCredito.Comentarios == undefined ? '' : $scope.notaCredito.Comentarios;
                    notaSeleccionada.FechaConciliacion = $scope.notaCredito.FechaConciliacion == undefined ? '' : $scope.notaCredito.FechaConciliacion;
                    notaSeleccionada.CapturoFC = true;
                    $scope.generarCimNcNotas(false, notaSeleccionada);

                    $scope.modalNotas.close();
                }
            };

            $scope.definePath = function (esGlobal) {
                var notasPorAprobar = _.filter($scope.notasdeCredito, { 'PorSeleccionarCIM': true });
                if (notasPorAprobar.length > 0) {
                    var TIPO = notasPorAprobar[0].TipoNotaCreditoId;
                    var MismoUsuario = notasPorAprobar[0].MismoUsuario;
                    if (TIPO === 1) {
                        if (esGlobal) {
                            var iguales = true;
                            var currentClientId = notasPorAprobar[0].ClienteId;
                            _.forEach(notasPorAprobar, function (item) {
                                if (currentClientId != item.ClienteId) {
                                    iguales = false;
                                }
                            });

                            if (!iguales) {
                                var mensaje = Ex.GetResourceValue("msgGenerarCIMNotasClientes");
                                Ex.mensajes(mensaje, 4);
                                return;
                            }
                        }
                        var datos = {};
                        if (MismoUsuario == 1) {
                            $scope.generarCimNcNotas(esGlobal, datos); // esContractual
                        }
                        else {
                            $scope.openModalNotas();
                        }
                    }
                    else if ((TIPO === 2 || TIPO === 3) && esGlobal == false) {
                        if (MismoUsuario == 1) {
                            $scope.generarCimNcNotas(esGlobal, datos); // esContractual
                        }
                        else {
                            $scope.openModalNotas();
                        }
                    }

                }
                else {
                    var mensaje = Ex.GetResourceValue("msgGenerarCIMNotasNONE");
                    Ex.mensajes(mensaje, 4);
                }
            }

            //$scope.PRUEBAS_CIM = function () {
            //    var datos = {};
            //    $Ex.Execute("GenerarCIMNotas", datos, function (response, isInvalid) {
            //        if (response.d) {
            //            $scope.getNotasCredito(response.d);
            //            window.location = "DownLoadPage.aspx?d=" + getRandom();
            //        } 
            //    })
            //}

        }]);
})();