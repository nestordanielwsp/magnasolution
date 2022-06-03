(function () {
    app.controller('conciliacionPago', ['$scope', '$http', 'util',
        function ($scope, $http, util) {

            var service = $Ex;
            service.Http = $http;

            $Ex.Http = $http;

            $scope.filtro = {};
            $scope.forma = {};
            $scope.pagos = [];
            $scope.pago = {};
            $scope.form = {};
            $scope.modalForm = {};
            $scope.clienteSeleccionado = {};
            $scope.esPaginaPrincipal = true;
            $scope.esDetalleFactura = false;
            $scope.esDetalleNota = false;
            $scope.Facturas = [];
            $scope.Pagos = [];
            $scope.Notas = [];
            $scope.CuentasIva = [];
            $scope.LibrosDiario = [];
            $scope.notaCredito = {};
            $scope.estatus = EstatusInfo;
            $scope.datepickerOptions = { orientation: "top" };

            var esPagos = false;

            var getNumber = function (number) {
                number = isNaN(number) || number == null ? 0 : number;
                return +number.toString().toFixed(4);
            };

            var getTotal = function (lista, propertyName) {
                var result = _.reduce(lista,
                    function (value, item) {
                        var monto = isNaN(parseInt(item[propertyName])) ? 0 : item[propertyName];
                        return monto + value;
                    },
                    0);

                return getNumber(result);
            };

            var validarMontoPorAplicar = function (detalle) {
                var montosValidos = true;
                var datos = $scope.pago[detalle];

                var montosIncorrectos = _.filter(datos,
                    function (item) {
                        return item.MontoPorAplicar > item.MontoAbierto;
                    });

                var totalMontosIncorrectos = montosIncorrectos.length;

                if (totalMontosIncorrectos > 0) {
                    var mensaje = Ex.GetResourceValue("lbl" + detalle) + "\n";
                    mensaje += Ex.GetResourceValue("msgMontoPorAplicarIncorrectos") + "\n";

                    for (var i = 0; i < montosIncorrectos.length; i++) {
                        mensaje += montosIncorrectos[i].DocumentoId + "\n";
                    }
                    Ex.mensajes(mensaje);
                    montosValidos = false;
                }

                return montosValidos;
            };

            var validarLlenadoCruceId = function (detalle) {
                var error = false;
                for (var i = 0; i < $scope.pago.Notas.length; i++) {
                    if (!$scope.pago.Notas[i].CruceId)
                        error = true;
                }

                if (error) {
                    Ex.mensajes(Ex.GetResourceValue("msgErrorCruceId"));
                    return false;
                }

                return true;
            }


            var validarCruceNotas = function () {
                var formaValida = true;
                var tienePagos = $scope.pago.Pagos.length > 0;
                var totalNotas = $scope.pago.Notas.length;
                var totalCruces = $scope.pago.CruceNotas.length;
                var crucesId = [];
                var mensaje =
                    Ex.GetResourceValue(tienePagos ? "msgCruceNotasIncorrecto" : "msgCruceSinPagoIncorrecto") + "\n";

                var totalNotaCruce1 = 0;
                var totalNotaCruce2 = 0;
                var totalNotaCruce3 = 0;

                var totalCruceId1 = 0;
                var totalCruceId2 = 0;
                var totalCruceId3 = 0;

                for (var i = 0; i < totalNotas; i++) {
                    var nota = $scope.pago.Notas[i];
                    totalNotaCruce1 = +(totalNotaCruce1 + (nota.CruceId === 1 ? nota.MontoPorAplicar : 0)).toFixed(2);
                    totalNotaCruce2 = +(totalNotaCruce2 + (nota.CruceId === 2 ? nota.MontoPorAplicar : 0)).toFixed(2);
                    totalNotaCruce3 = +(totalNotaCruce3 + (nota.CruceId === 3 ? nota.MontoPorAplicar : 0)).toFixed(2);

                    crucesId.push(nota.CruceId);
                }

                for (i = 0; i < totalCruces; i++) {
                    var cruce = $scope.pago.CruceNotas[i];

                    cruce.MontoCruceId1 = _.contains(crucesId, 1) ? cruce.MontoCruceId1 : null;
                    cruce.MontoCruceId2 = _.contains(crucesId, 2) ? cruce.MontoCruceId2 : null;
                    cruce.MontoCruceId3 = _.contains(crucesId, 3) ? cruce.MontoCruceId3 : null;

                    totalCruceId1 = +(totalCruceId1 + getNumber(cruce.MontoCruceId1)).toFixed(2);
                    totalCruceId2 = +(totalCruceId2 + getNumber(cruce.MontoCruceId2)).toFixed(2);
                    totalCruceId3 = +(totalCruceId3 + getNumber(cruce.MontoCruceId3)).toFixed(2);

                    var montoTotal = +(getNumber(cruce.MontoCruceId1) +
                        getNumber(cruce.MontoCruceId2) +
                        getNumber(cruce.MontoCruceId3)).toFixed(2);

                    if (montoTotal > cruce.MontoAbierto || !tienePagos && montoTotal !== cruce.MontoAbierto) {
                        var formaValida = false;
                        mensaje += cruce.DocumentoId + "\n";
                    }
                }

                if (!formaValida)
                    Ex.mensajes(mensaje);

                if (formaValida &&
                    (totalCruceId1 !== totalNotaCruce1 ||
                        totalCruceId2 !== totalNotaCruce2 ||
                        totalCruceId3 !== totalNotaCruce3)
                ) {
                    var cruceIncorrecto = totalCruceId1 !== totalNotaCruce1 ? 1 : totalCruceId2 !== totalNotaCruce2 ? 2 : 3;
                    formaValida = false;
                    Ex.mensajes(Ex.GetResourceValue("msgMontoCruceIdIncorrecto") + cruceIncorrecto);
                }

                $scope.pago.MontoTotalCruce1 = getTotal($scope.pago.CruceNotas, "MontoCruceId1");
                $scope.pago.MontoTotalCruce2 = getTotal($scope.pago.CruceNotas, "MontoCruceId2");
                $scope.pago.MontoTotalCruce3 = getTotal($scope.pago.CruceNotas, "MontoCruceId3");

                return formaValida;
            };

            var validarNotasAdicionales = function (formaValida) {
                if (formaValida && $scope.pago.NotasAdicionales != null) {
                    var notasInvalidas = _.filter($scope.pago.NotasAdicionales,
                        function (item) {
                            return (item.AplicaIva && !item.Cuenta) || !item.LibroDiario;
                        });
                    var totalNotasInvalidas = notasInvalidas.length;

                    if (totalNotasInvalidas > 0) {
                        formaValida = false;
                        var mensaje = Ex.GetResourceValue("msgNotasIncompletas") + "\n";
                        for (var i = 0; i < totalNotasInvalidas; i++) {
                            mensaje += notasInvalidas[i].Folio + "\n";
                            Ex.mensajes(mensaje);
                        }
                    }
                }

                return formaValida;
            };

            var calcularMontos = function (detalle) {
                if (detalle === "Facturas" || detalle === "Pagos") {
                    $scope.pago.FaltantePago = getNumber($scope.pago.PagosMontoPorAplicar) -
                        getNumber($scope.pago.FacturasMontoPorAplicar);
                    $scope.pago.SaldoPorGenerarNc = getNumber($scope.pago.FacturasMontoAbierto) -
                        getNumber($scope.pago.PagosMontoPorAplicar);

                    $scope.pago.MontoPagado = $scope.pago.PagosMontoPorAplicar;
                    $scope.pago.PagosPorAplicar = $scope.pago.FacturasMontoPorAplicar;
                } else {
                    $scope.pago.NcPorAplicar = getNumber($scope.pago.NotasMontoPorAplicar) +
                        getNumber($scope.pago.NotasAdicionalesMontoTotal);
                }

                $scope.pago.FaltanteNc = getNumber($scope.pago.FacturasMontoPorAplicar) - getNumber($scope.pago.NotasMontoPorAplicar);
            };

            var calcularTotales = function (detalle) {
                var datosSeleccionados = $scope.pago[detalle];
                var totalDatos = datosSeleccionados.length;

                $scope.pago[detalle + "MontoTotal"] = 0;

                if (!$scope.pago.sonNotasAdicionales) {
                    $scope.pago[detalle + "MontoAbierto"] = 0;
                    $scope.pago[detalle + "MontoPorAplicar"] = 0;
                }

                if (detalle === "Notas") {
                    $scope.pago[detalle + "Balance"] = 0;
                }

                for (var i = 0; i < totalDatos; i++) {
                    var dato = datosSeleccionados[i];

                    $scope.pago[detalle + "MontoTotal"] += dato.Monto;

                    if (!$scope.pago.sonNotasAdicionales) {
                        $scope.pago[detalle + "MontoAbierto"] += dato.MontoAbierto;
                        $scope.pago[detalle + "MontoPorAplicar"] += dato.MontoPorAplicar;

                    }

                    if (detalle === "Notas") {
                        $scope.pago[detalle + "Balance"] += dato.MontoBalance;
                    }

                }

                $scope.pago[detalle + "MontoTotal"] = getNumber($scope.pago[detalle + "MontoTotal"]);
                $scope.pago[detalle + "MontoAbierto"] = getNumber($scope.pago[detalle + "MontoAbierto"]);
                $scope.pago[detalle + "MontoPorAplicar"] = getNumber($scope.pago[detalle + "MontoPorAplicar"]);
                if (detalle === "Notas") {
                    $scope.pago[detalle + "Balance"] = getNumber($scope.pago[detalle + "Balance"]);
                    $scope.pago.NotasMontoPorAplicar = getNumber($scope.pago.NotasMontoPorAplicar);
                }
                $scope.pago.MontoFacturado = $scope.pago.FacturasMontoAbierto;
            };



            var agregarDetalleCruce = function () {
                var totalFacturas = $scope.pago.Facturas.length;
                var totalMonto = 0;
                var tienePago = $scope.pago.Pagos.length > 0;

                $scope.pago.CruceNotas = [];

                for (var i = 0; i < totalFacturas; i++) {
                    var factura = $scope.pago.Facturas[i];
                    var montoAbierto = !tienePago ? factura.MontoPorAplicar : factura.MontoAbierto - factura.MontoPorAplicar;
                    totalMonto += montoAbierto;

                    $scope.pago.CruceNotas.push({
                        DocumentoId: factura.DocumentoId,
                        MontoAbierto: montoAbierto
                    });
                }

                $scope.pago.CruceNotasMontoAbierto = totalMonto;
            };

            $scope.clienteOptions = { idProp: "ClienteId", displayProp: "Cliente", methodName: "GetClientes" };

            $Ex.Execute("GetListas", {}, function (response) {
                $scope.CuentasIva = response.d.CuentasIva;
                $scope.LibrosDiario = response.d.LibrosDiario;
            });

            $scope.getConciliaciones = function () {
                $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";
                $Ex.Execute("GetConciliaciones",
                    $scope.filtro,
                    function (response) {
                        $scope.pagos = response.d;
                        $scope._pagos = response.d;
                    });
            };

            $scope.verConciliacion = function (item) {
                $Ex.Execute("GetConciliacion",
                    item,
                    function (response) {
                        $scope.pago = response.d;
                        $scope.clienteSeleccionado = { ClienteId: $scope.pago.ClienteId, Cliente: $scope.pago.Cliente };

                        var montoFacturado = $scope.pago.MontoFacturado;

                        calcularTotales("Facturas");
                        calcularTotales("Pagos");
                        calcularTotales("Notas");
                        calcularTotales("NotasAdicionales");

                        $scope.obtenerTotalCruce(1);
                        $scope.obtenerTotalCruce(2);
                        $scope.obtenerTotalCruce(3);
                        $scope.pago["CruceNotasMontoAbierto"] = getTotal($scope.pago.CruceNotas, "MontoAbierto");

                        $scope.form.disableForm($scope.pago.Cerrado);
                        $scope.modalForm.disableForm($scope.pago.Cerrado);
                        $scope.esPaginaPrincipal = false;

                        //Se regresa al valor original del Monto Facturado guardado, ya que el CalcularTotales(Factura) puede ponerlo en cero 
                        //y puede que sea un valor nulo, en ese caso no se debe mostrar información
                        $scope.pago.MontoFacturado = montoFacturado;
                    });
            };

            $scope.eliminar = function (item) {
                mensaje = Ex.GetResourceValue("msgEliminar");
                Ex.mensajes(mensaje, 2, null, null, null, function () {
                    $Ex.Execute("EliminarConciliacion",
                        item,
                        function (response) {
                            $scope.getConciliaciones();
                        });
                }, function () { }, null);
            };

            var guardar = function (esCerrar) {
                $scope.pago.EsCerrar = esCerrar;
                $Ex.Execute("Guardar",
                    $scope.pago,
                    function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.getConciliaciones();

                            $scope.pago.ConciliacionId = 0;

                            //if (esCerrar) {
                            $scope.pago.Cerrado = false;
                            //}
                            //else
                            // $scope.esPaginaPrincipal = true;

                        }
                    },
                    $scope.forma);
            };



            $scope.guardar = function (esCerrar) {
                $scope.submittedForm = true;

                if (esCerrar) {
                    var sinPagos = $scope.pago.Pagos.length === 0;
                    var sinFacturas = $scope.pago.Facturas.length === 0;
                    var sinNotas = $scope.pago.Notas.length === 0;
                    var sinNotasAdicionales = $scope.pago.NotasAdicionales.length === 0;
                    var totalFacturas = $scope.pago.Facturas.length;
                    var totalNotas = $scope.pago.Notas.length;
                    var mensaje = "";
                    var i;

                    if (sinPagos && sinFacturas && sinNotasAdicionales) {
                        Ex.mensajes(Ex.GetResourceValue("msgDetalleRequerido"));
                        return;
                    }

                    if (validarMontoPorAplicar("Facturas") &&
                        validarMontoPorAplicar("Pagos") &&
                        validarMontoPorAplicar("Notas") &&
                        validarLlenadoCruceId("Notas")
                    ) {
                        //var formaValida = validarCruceNotas();
                        formaValida = validarNotasAdicionales(true);

                        var faltantePagoValido = (!sinFacturas && !sinNotas && sinPagos) ||
                            (sinFacturas && sinPagos) ||
                            $scope.pago.FaltantePago === 0;
                        var faltanteNcValido = sinNotas;

                        //Si el faltante de NC no es cero, la conciliación se puede guardar siempre y cuando no haya pagos
                        if (formaValida && !faltanteNcValido && $scope.pago.Notas.length > 0 && getNumber($scope.pago.FaltanteNc) != 0) {

                            //Si el mensaje esta vacío significa que todas las facturas estan en ceros con el cruce de notas                            
                            Ex.mensajes(Ex.GetResourceValue("msgFaltanteNcInvalido"));
                        }
                        else if(formaValida && !faltanteNcValido && $scope.pago.Notas.length > 0 && getNumber($scope.pago.FaltanteNc) == 0 && getNumber($scope.pago.NotasBalance) != 0) {
                            mensaje = "El Balance de Notas de Crédito no es cero, ¿Desea Continuar?";
                            if (mensaje !== "") {                                
                                Ex.mensajes(mensaje, 2, null, null, null, function () {
                                    guardar(esCerrar);
                                    $scope.agregar();
                                }, function () { }, null);
                            } else {
                                guardar(esCerrar);
                                $scope.agregar();
                            }
                        }else if
                            (formaValida && !faltantePagoValido && $scope.pago.Pagos.length > 0) {
                            Ex.mensajes(Ex.GetResourceValue("msgFaltantePagoInvalido"));
                        }
                        //Si no hubo notas de crédito revisa que facturas se quedaron con monto abierto
                        else if (formaValida && sinNotas && $scope.pago.FaltanteNc) {
                            for (i = 0; i < totalFacturas; i++) {
                                var factura = $scope.pago.Facturas[i];
                                var montoAbierto = +(factura.MontoAbierto - factura.MontoPorAplicar);

                                if (montoAbierto > 0) {
                                    mensaje += factura.DocumentoId + ": " + montoAbierto + "\n";
                                }
                            }

                            //Si el mensaje esta vacío significa que ninguan factura se queda con monto abierto
                            if (mensaje !== "") {
                                mensaje = Ex.GetResourceValue("msgFaltantePagoInvalidoFinal") + "\n" + mensaje;
                                Ex.mensajes(mensaje, 2, null, null, null, function () {
                                    guardar(esCerrar);
                                    $scope.agregar();
                                }, function () { }, null);
                            } else {
                                guardar(esCerrar);
                                $scope.agregar();
                            }
                        }
                        else if (formaValida) {
                            guardar(esCerrar);
                            $scope.agregar();
                        }
                    }


                }
                else {
                    guardar(esCerrar);
                    $scope.pago.msgGuardado = true;

                }
            };

            $scope.agregar = function () {
                $scope.submittedForm = false;
                $scope.esPaginaPrincipal = false;
                $scope.clienteSeleccionado = {};
                $scope.pago = { ConciliacionId: 0, Facturas: [], Pagos: [], Notas: [], CruceNotas: [], NotasAdicionales: [] };
                $scope.form.disableForm(false);

                
                
                var objFecha = new Date();
                var dia = objFecha.getDate();
                var mes = objFecha.getMonth()+1;
                var anio = objFecha.getFullYear();
                
                var fechaNueva = dia + "/" + mes + "/" + anio;


                $scope.pago.FechaConciliacion = fechaNueva;
                $scope.pago.msgGuardado = false;
                $scope.pago.Cerrado = false;

            };

            $scope.setValorCliente = function (item) {
                $scope.pago.AnalistaId = item.AnalistaId;
                $scope.pago.Analista = item.Analista;
                $scope.pago.Cliente = item.Cliente;
            };

            $scope.abrirDetalleFactura = function (esPago) {
                $scope.valoresABuscar = "";
                $scope.Facturas = [];
                esPagos = esPago;
                $scope.esDetalleFactura = true;
                $scope.pago.sonNotasAdicionales = false;
                $scope.pago.Alerta = "";
                $scope.pago.MontoTotalAbierto = 0;
            };

            $scope.seleccionarDetalle = function (detalle) {
                detalle = detalle != null ? detalle : esPagos === true ? "Pagos" : "Facturas";
                detalle = detalle === "Notas" && $scope.pago.sonNotasAdicionales ? "NotasAdicionales" : detalle;
                //Si el detalle son pagos, el arreglo es el mismo que el de facturas
                var datos = $scope[detalle === "Pagos" ? "Facturas" : detalle];
                var datosSeleccionados = _.where(datos, { Seleccionado: true });

                if (detalle == "Facturas") {
                    var z = 1;
                    for (var i = 0; i < datosSeleccionados.length; i++) {
                        datosSeleccionados[i].CruceId = z.toString();
                        z++;
                    }
                }

                if (esPagos === true && datosSeleccionados.length > 1) {
                    $scope.pago.Alerta = "Solo puede seleccionar un pago, Favor de Verificar!";
                } else {

                    if (detalle == "Notas") {
                        for (var i = 0; i < datosSeleccionados.length; i++) {
                            datosSeleccionados[i].FolioTpm = "";
                            var datoEncontrado = _.where($scope.pago.Notas, { DocumentoId: datosSeleccionados[i].DocumentoId });
                            if (datoEncontrado.length == 0)
                                $scope.pago.Notas.push(datosSeleccionados[i]);
                        }

                    } else {
                        $scope.pago[detalle] = datosSeleccionados;
                    }

                    calcularTotales(detalle);
                    calcularMontos(detalle);

                    $scope.esDetalleFactura = false;
                    $scope.esDetalleNota = false;

                    if ($scope.pago.ClienteId === undefined && datosSeleccionados.length > 0) {

                        var datos = {
                            TextoBusqueda: datosSeleccionados[0].CobrarA
                        }


                        $Ex.Execute("GetClientes",
                            datos,
                            function (responseCliente) {
                                var clienteEncontrado = responseCliente.d;
                                $scope.pago.AnalistaId = clienteEncontrado[0].AnalistaId;
                                $scope.pago.Analista = clienteEncontrado[0].Analista;
                                $scope.pago.Cliente = clienteEncontrado[0].Cliente;
                                $scope.pago.ClienteId = clienteEncontrado[0].ClienteId;
                                $scope.clienteSeleccionado = { ClienteId: $scope.pago.ClienteId, Cliente: $scope.pago.Cliente };
                            }
                        );
                    }


                    // Agregar la busqueda de Notas a traves de cada factura
                    if (detalle === "Facturas") {
                        var result = [];

                        if (datosSeleccionados.length > 0) {
                            // recorrer factura x factura y traerte las notas y meterlo al $scope.Notas
                            var z = 1;

                           // const tempArray = datosSeleccionados.sort((a, b) => (parseInt(a.CruceId) > parseInt(b.CruceId)) ? 1 : -1);

                            //var documentos = "";
                            for (var i = 0; i < datosSeleccionados.length; i++) {
                               // documentos = documentos + "," + datosSeleccionados[i].DocumentoId;


                                var datos = {
                                    TextoFacturas: datosSeleccionados[i].DocumentoId
                                }

                                if ($scope.pago.Pagos.length === 0) {
                                    $Ex.Execute("BuscarNotasFacturas",
                                        datos,
                                        function (responseDetalleNota) {

                                            result = responseDetalleNota.d;


                                            for (var i = 0; i < result.length; i++) {
                                                $scope.pago.Notas.push(result[i])
                                            }


                                            for (var i = 0; i < $scope.pago.Notas.length; i++) {
                                                var CruceSeleccionado = _.where($scope.pago.Facturas, { DocumentoId: $scope.pago.Notas[i].DocumentoId });
                                                $scope.pago.Notas[i].CruceId = CruceSeleccionado[0].CruceId;
                                            }
                                           
                                            calcularTotales('Notas');
                                            calcularMontos('Notas');
                                            

                                            var saldos = [];
                                            $scope.pago.Notas.reduce(function (res, value) {
                                                if (!res[value.CruceId]) {
                                                    res[value.CruceId] = { CruceId: value.CruceId, MontoPorAplicar: 0 };
                                                    saldos.push(res[value.CruceId])
                                                }
                                                res[value.CruceId].MontoPorAplicar += value.MontoPorAplicar;
                                                return res;
                                            }, {});

                                            var CruceInicial = 0;
                                            for (var i = 0; i < $scope.pago.Notas.length; i++) {
                                                var CruceSeleccionado = _.where(saldos, { CruceId: $scope.pago.Notas[i].CruceId });
                                                
                                                if (CruceSeleccionado.length > 0 && $scope.pago.Notas[i].CruceId != CruceInicial) {
                                                    $scope.pago.Notas[i].SaldoFactura = $scope.pago.Notas[i].MontoAbierto - CruceSeleccionado[0].MontoPorAplicar;
                                                    CruceInicial = $scope.pago.Notas[i].CruceId;
                                                } else {
                                                    $scope.pago.Notas[i].SaldoFactura = 0;
                                                }
                                            }
                                        }
                                    );
                                }
                            }
                        }
                    } 

                    if ((detalle === "Facturas" || detalle === "Notas" || detalle === "Pagos") && $scope.pago.Notas.length > 0)
                        agregarDetalleCruce();
                }
            };



            $scope.buscarNotas = function (sonNotasAdicionales) {
                $scope.pago.sonNotasAdicionales = sonNotasAdicionales;
                $scope.pago.AlertaNC = '';
                var datos = {
                    TextoFacturas: $scope.valoresABuscarNotas.replace(/\r/g, "").split(/[ ,;\n]+/).join(),
                    ClienteId: $scope.pago.ClienteId,
                    sonNotasAdicionales: false
                };

                const documentos = datos.TextoFacturas.split(",");
                let duplicados = [];


                const tempArray =  documentos.sort(function (a, b) {
                    if (a > b) return 1;
                    if (a < b) return -1;
                    return 0;
                });

                //const tempArray = [...documentos].sort();

                for (let i = 0; i < tempArray.length; i++) {
                    if (tempArray[i + 1] === tempArray[i]) {
                        duplicados.push(tempArray[i]);
                    }
                }

                if (duplicados.length > 0)
                    $scope.pago.AlertaNC = 'Elementos duplicados';


                $Ex.Execute("BuscarNotas",
                    datos,
                    function (response) {
                        var detalle = sonNotasAdicionales ? "NotasAdicionales" : "Notas";

                        var datosSeleccionados = response.d;
                        var totalDatos = datosSeleccionados.length;
                        $scope.esDetalleNota = true;

                        $scope.pago.MontoTotalAbiertoNC = 0;



                        if (totalDatos > 0) {
                            for (var i = 0; i < totalDatos; i++) {
                                var dato = datosSeleccionados[i];
                                $scope.pago.MontoTotalAbiertoNC += dato.MontoAbierto;
                            }

                            if (datosSeleccionados[0].CuantosClientes != 1) {
                                if ($scope.pago.AlertaNC.length > 0) {
                                    $scope.pago.AlertaNC += ', y se encontró más de 1 cliente diferente'
                                } else {
                                    $scope.pago.AlertaNC += 'Se encontró más de 1 cliente diferente'
                                }
                            }

                            if ($scope.pago.AlertaNC.length > 0) {
                                $scope.pago.AlertaNC += ' en la búsqueda, favor de verificar!'
                            }

                            $scope[detalle] = response.d;
                        }


                    });
            }

            $scope.buscarFacturas = function () {
                $scope.pago.Alerta = '';
                $scope.pago.MontoTotalAbierto = 0;
                if ($scope.valoresABuscar) {
                    var datos = {
                        TextoFacturas: $scope.valoresABuscar.replace(/\r/g, "").split(/[ ,;\n]+/).join(),
                        ClienteId: $scope.pago.ClienteId,
                        // ConciliacionId: $scope.pago.ConciliacionId,
                        BuscarPagos: esPagos
                    };


                    const documentos = datos.TextoFacturas.split(",");
                    let duplicados = [];


                    const tempArray = documentos.sort(function (a, b) {
                        if (a > b) return 1;
                        if (a < b) return -1;
                        return 0;
                    });

                    //const tempArray = [...documentos].sort();

                    for (let i = 0; i < tempArray.length; i++) {
                        if (tempArray[i + 1] === tempArray[i]) {
                            duplicados.push(tempArray[i]);
                        }
                    }

                    if (duplicados.length > 0)
                        $scope.pago.Alerta = 'Elementos duplicados';


                    $Ex.Execute("BuscarFacturas",
                        datos,
                        function (response) {
                            var datosSeleccionados = response.d;
                            var totalDatos = 0;
                            if (datosSeleccionados.length > 0)
                                var totalDatos = datosSeleccionados.length;

                            $scope.pago.MontoTotalAbierto = 0;

                            if (totalDatos > 0) {
                                for (var i = 0; i < totalDatos; i++) {
                                    var dato = datosSeleccionados[i];
                                    $scope.pago.MontoTotalAbierto += dato.MontoAbierto;
                                }

                                if (datosSeleccionados[0].CuantosClientes != 1) {
                                    if ($scope.pago.Alerta.length > 0) {
                                        $scope.pago.Alerta += ', y se encontró más de 1 cliente diferente'
                                    } else {
                                        $scope.pago.Alerta += 'Se encontró más de 1 cliente diferente'
                                    }
                                }

                                if ($scope.pago.Alerta.length > 0) {
                                    $scope.pago.Alerta += ' en la búsqueda, favor de verificar!'
                                }

                                $scope.Facturas = datosSeleccionados;
                            }
                        }
                    );

                }
            };

            $scope.getMontoPorAplicar = function (detalle) {
                var datos = $scope.pago[detalle];

                if (detalle === "NotasAdicionales")
                    $scope.pago[detalle + "MontoTotal"] = getTotal(datos, "Monto");
                else
                    $scope.pago[detalle + "MontoPorAplicar"] = getTotal(datos, "MontoPorAplicar");


                calcularMontos(detalle);

                //if (detalle === "Facturas") {
                //    var tienePago = $scope.pago.Pagos.length > 0;
                //    var cruceNota = _.find($scope.pago.CruceNotas, { DocumentoId: factura.DocumentoId });
                //    cruceNota.MontoAbierto = !tienePago ? factura.MontoPorAplicar : factura.MontoAbierto - factura.MontoPorAplicar;
                //    $scope.pago["CruceNotasMontoAbierto"] = getTotal($scope.pago.CruceNotas, "MontoAbierto");
                //}

                if (detalle === "Notas") {

                    for (var i = 0; i < $scope.pago.Notas.length; i++) {
                        $scope.pago.Notas[i].SaldoFactura = 0;
                        $scope.pago.Notas[i].MontoBalance = 0;

                        //factura.CruceId = $scope.pago.Notas[i].CruceId;

                        if ($scope.pago.Notas[i].CruceId) {
                            var FacturaSeleccionado = _.where($scope.pago.Facturas, { CruceId: $scope.pago.Notas[i].CruceId });
                            if (FacturaSeleccionado.length > 0) {
                                var FacturaMontoAbierto = 0.0;
                                for (var j = 0; j < FacturaSeleccionado.length; j++) {
                                    FacturaMontoAbierto = FacturaMontoAbierto + FacturaSeleccionado[j].MontoAbierto;
                                }
                                $scope.pago.Notas[i].MontoAbierto = FacturaMontoAbierto;
                            }

                            
                            if (!$scope.pago.Notas[i].Eliminar) {
                                $scope.pago.Notas[i].MontoBalance = $scope.pago.Notas[i].Monto - $scope.pago.Notas[i].MontoPorAplicar;
                            } else {
                                $scope.pago.Notas[i].MontoBalance = $scope.pago.Notas[i].MontoAbierto - $scope.pago.Notas[i].MontoPorAplicar;
                            }
                        }
                    }

                    var saldos = [];
                    $scope.pago.Notas.reduce(function (res, value) {
                        if (!res[value.CruceId]) {
                            res[value.CruceId] = { CruceId: value.CruceId, MontoPorAplicar: 0 };
                            saldos.push(res[value.CruceId])
                        }
                        res[value.CruceId].MontoPorAplicar += value.MontoPorAplicar;
                        return res;
                    }, {});

                    for (var j = 0; j < saldos.length; j++) {
                        var CruceSeleccionado = _.where($scope.pago.Notas, { CruceId: saldos[j].CruceId });
                        if (CruceSeleccionado.length > 0) 
                            CruceSeleccionado[0].SaldoFactura = CruceSeleccionado[0].MontoAbierto - saldos[j].MontoPorAplicar;    
                    }

                    calcularTotales(detalle);
                }
            };

            $scope.quitarDetalle = function (index, detalle, cruceId) {
                $scope.pago[detalle].splice(index, 1);
                $scope.pago.NotasBalance = 0;
                calcularTotales(detalle);
                calcularMontos(detalle);

                //if (detalle === "Facturas") {
                //    $scope.pago.CruceNotas.splice(index, 1);
                //    $scope.pago["CruceNotasMontoAbierto"] = getTotal($scope.pago.CruceNotas, "MontoAbierto");
                //    $scope.pago.MontoTotalCruce1 = getTotal($scope.pago.CruceNotas, "MontoCruceId1");
                //    $scope.pago.MontoTotalCruce2 = getTotal($scope.pago.CruceNotas, "MontoCruceId2");
                //    $scope.pago.MontoTotalCruce3 = getTotal($scope.pago.CruceNotas, "MontoCruceId3");
                //}

                //if (detalle === "Notas" && $scope.pago.Notas.length === 0)

                if (detalle === "Facturas") {


                    var longNotas = $scope.pago.Notas.length;
                    for (var i = 0; i < longNotas; i++) {
                        // let indice = $scope.pago.Notas.findIndex(x => x.CruceId === cruceId);
                        var FacturaSeleccionado = _.where($scope.pago.Notas, { CruceId: cruceId });
                        if (FacturaSeleccionado.length > 0) {
                            let indice = ObtenerIndice($scope.pago.Notas, cruceId);
                            if (indice > -1) {
                                $scope.pago.Notas.splice(indice, 1);                               
                            }
                        }
                    }


                    if ($scope.pago.Notas.length > 0) {
                        calcularTotales("Notas");
                        calcularMontos("Facturas");                       
                    }

                }

                $scope.pago.CruceNotas = [];

                if (detalle === "Pagos" && $scope.pago.Pagos.length === 0)
                    agregarDetalleCruce();
            };

            var ObtenerIndice = function (list, cruceId) {
                var index = 0
                for (var i = 0; i < list.length; ++i) {
                    if (list[i].CruceId == cruceId) {
                        index = i;
                        break;
                    }
                }
                return index;
            }




            $scope.abrirDetalleNota = function (sonNotasAdicionales) {
                $scope.valoresABuscarNotas = "";
                $scope.Notas = [];
                $scope.pago.sonNotasAdicionales = sonNotasAdicionales;
                var detalle = sonNotasAdicionales ? "NotasAdicionales" : "Notas";
                $scope.esDetalleNota = true;
                //$Ex.Execute("BuscarNotas",
                //    $scope.pago,
                //    function (response) {
                //        var detalle = sonNotasAdicionales ? "NotasAdicionales" : "Notas";
                //        $scope[detalle] = response.d;
                //        $scope.esDetalleNota = true;
                //    });
            };

            var financial = function (valor) {
                return Number.financial(valor);
            }

            var notaSeleccionada = {};
            $scope.openModalNotas = function (nota) {
                notaSeleccionada = nota;

                $scope.notaCredito = {
                    DescripcionGeneral: nota.DescripcionGeneral,
                    OrdenCompra: nota.OrdenCompra,
                    DescripcionDetallada: nota.DescripcionDetallada,
                    Cuenta: nota.Cuenta,
                    LibroDiario: nota.LibroDiario,
                    Comentarios: nota.Comentarios,
                    AplicaIva: nota.AplicaIva
                };

                $scope.submitted = false;
                $scope.tituloModal = Ex.GetResourceValue("lblGeneralesNc") + " " + nota.Folio;
                $scope.modalNotas.open();
            };

            $scope.guardarNotaAdicional = function (forma) {
                $scope.submitted = true;

                if (forma.$invalid)
                    Ex.mensajes(Ex.GetGlobalResourceValue("msgRequiredFields"));
                else {
                    notaSeleccionada.DescripcionGeneral = $scope.notaCredito.DescripcionGeneral;
                    notaSeleccionada.OrdenCompra = $scope.notaCredito.OrdenCompra;
                    notaSeleccionada.DescripcionDetallada = $scope.notaCredito.DescripcionDetallada;
                    notaSeleccionada.Cuenta = $scope.notaCredito.Cuenta;
                    notaSeleccionada.LibroDiario = $scope.notaCredito.LibroDiario;
                    notaSeleccionada.Comentarios = $scope.notaCredito.Comentarios;

                    $scope.modalNotas.close();
                }
            };

            $scope.validarCruceId = function (item) {
                var cruceId = parseInt(item.CruceId);
                item.CruceId = cruceId > 3 ? null : cruceId;
            };

            $scope.obtenerTotalCruce = function (cruceId) {
                $scope.pago["MontoTotalCruce" + cruceId] = getTotal($scope.pago.CruceNotas, "MontoCruceId" + cruceId);
            };

            $scope.generarCimNc = function () {
                if ($scope.pago.FechaConciliacion) {
                    var data = {
                        FoliosNc: _.pluck($scope.pago.NotasAdicionales, "Folio").toString(),
                        ConciliacionId: $scope.pago.ConciliacionId,
                        ClienteId: $scope.pago.ClienteId,
                        FechaConciliacion: $scope.pago.FechaConciliacion
                    };
                    $Ex.Execute("GenerarCimNc", data, function (response) {
                        if (response.d >= 0) {
                            Ex.mensajes(Ex.GetResourceValue("msgCargaExitosa"));
                            $scope.pago.CimNota = true;
                            $scope.pago.TieneFecha = true;

                            if (response.d === 3)
                                $scope.getConciliaciones();
                        } else {
                            var mensaje = Ex.GetResourceValue(response.d === -1 ? "msgFechaInvalida" : "msgErrorCarga");
                            Ex.mensajes(mensaje);
                        }
                    });
                } else
                    Ex.mensajes(Ex.GetResourceValue("msgFechaConciliacionRequerida"));
            };

            $scope.generatCimPago = function () {
                if ($scope.pago.FechaConciliacion) {
                    $Ex.Execute("GenerarCimPago", $scope.pago, function (response) {
                        if (response.d >= 0) {
                            Ex.mensajes(Ex.GetResourceValue("msgCargaExitosa"));
                            $scope.pago.CimPago = true;
                            $scope.pago.TieneFecha = true;

                            if (response.d === 3)
                                $scope.getConciliaciones();
                        } else {
                            var mensaje = Ex.GetResourceValue(response.d === -1 ? "msgFechaInvalida" : "msgErrorCarga");
                            Ex.mensajes(mensaje);
                        }
                    });
                } else
                    Ex.mensajes(Ex.GetResourceValue("msgFechaConciliacionRequerida"));
            };

            $scope.descargar = function () {
                try {
                    Ex.load(true);
                    $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                    $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";
                    service.Execute('Descargar', $scope.filtro, function (response, isInvalid) {
                        if (isInvalid) {
                            return;
                        }
                        window.location = "DownLoadPage.aspx";
                        setTimeout(function () {
                            Ex.load(false);
                        }, 100);
                    })
                }
                catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $scope.exportar = function () {
                try {
                    Ex.load(true);
                    $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                    $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";
                    service.Execute('Exportar', $scope.filtro, function (response, isInvalid) {
                        if (isInvalid) {
                            return;
                        }
                        window.location = "DownLoadPage.aspx";
                        setTimeout(function () {
                            Ex.load(false);
                        }, 100);
                    })
                }
                catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }



            $scope.verCimPagos = function () {
                var verCimPagos = $scope.pago.hasOwnProperty("Pagos") && ($scope.pago.Pagos.length > 0 && $scope.pago.Facturas.length > 0
                    || $scope.pago.Facturas.length > 0 && $scope.pago.Notas.length > 0)
                    //&& $scope.pago.Cerrado
                    && !$scope.pago.CimPago;
                return verCimPagos;
            };



            $scope.MostrarbtnInsumo = function () {
                var verbtnInsumo = false
                var datosSeleccionados = [];
                datosSeleccionados = _.where($scope.pagos, { Seleccionado: true });
                if (datosSeleccionados.length > 0)
                    verbtnInsumo = true;
                return verbtnInsumo;
            }

            $scope.MostrarmsgGuardado = function (Mostrar) {
                return Mostrar;
            }



            $scope.generarInsumo = function () {

                try {
                    Ex.load(true);
                    var datosSeleccionados = [];
                    datosSeleccionados = _.where($scope.pagos, { Seleccionado: true });

                    datosSeleccionadosP = _.where($scope.pagos, { Seleccionado: true, TipoConciliacion: 'P' });
                    datosSeleccionadosNC = _.where($scope.pagos, { Seleccionado: true, TipoConciliacion: 'NC' });

                    if (datosSeleccionadosP.length > 0 && datosSeleccionadosNC.length === 0) {
                        // Genera Insumo Tipo P
                        service.Execute('GenerarInsumo', datosSeleccionados, function (response, isInvalid) {
                            if (response.d == 0) {
                                Ex.mensajes('Algunas Facturas se encontraron en Diferentes Cruces, favor de Verificar', 4);
                                Ex.load(false);
                                return;
                            }
                            window.location = "DownLoadPage.aspx";
                            setTimeout(function () {
                                Ex.load(false);
                            }, 100);


                            $scope.getConciliaciones();
                        })
                    } else if (datosSeleccionadosP.length === 0 && datosSeleccionadosNC.length > 0) {
                        // Genera Insumo Tipo NC
                        service.Execute('GenerarInsumoNC', datosSeleccionados, function (response, isInvalid) {
                            if (response.d == 0) {
                                Ex.mensajes('Algunas Facturas se encontraron en Diferentes Cruces, favor de Verificar', 4);
                                Ex.load(false);
                                return;
                            }
                            window.location = "DownLoadPage.aspx";
                            setTimeout(function () {
                                Ex.load(false);
                            }, 100);


                            $scope.getConciliaciones();
                        })

                    } else {
                        Ex.mensajes('No puede mezclar cruces de Pagos con Notas de Crédito.', 4);
                        Ex.load(false);
                        return;
                    }


                }
                catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }

                //$Ex.Execute("GenerarInsumo", datosSeleccionados, function (response) {
                //    if (response.d >= 0) {

                //       Ex.mensajes(Ex.GetResourceValue("msgCargaExitosa"));
                //        //datosSeleccionados.CimPago = true;
                //        //datosSeleccionados.TieneFecha = true;

                //        //if (response.d === 3)



                //    } else {
                //        var mensaje = Ex.GetResourceValue(response.d === -1 ? "msgFechaInvalida" : "msgErrorCarga");
                //        Ex.mensajes(mensaje);
                //    }
                //});

                //$scope.getConciliaciones();

            };



            $scope.getConciliaciones();
        }]);
})();