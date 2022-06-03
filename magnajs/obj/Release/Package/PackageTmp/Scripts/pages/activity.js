(function () {
    app.controller('activity', ['$scope', '$http', 'enums', 'util', '$timeout',
        function ($scope, $http, enums, util, $timeout) {
            $Ex.Http = $http;

            $scope.filtro = {
                Estatus: [], Marcas: [], Canales: [], Rubros: [], Fecha: { StartDate: "", EndDate: "" }
            };
            $scope.forma = {};
            $scope.esVisibleJV = true;
            $scope.activity = { Marcas: [] };
            $scope.esCrearModificarActivity = esCrearModificarActivityInfo;
            $scope.usuario = {};
            $scope.activities = [];
            $scope.formaPrincipal = {};
            $scope.tiposActivity = TipoActivityInfo;
            $scope.tiposActividad = TipoActividadInfo;
            $scope.marcas = MarcaInfo;
            $scope.canalesTodos = CanalInfo;
            $scope.canales = [];
            $scope.canalesFiltro = [];
            $scope.subcanales = SubcanalInfo;
            $scope.areas = AreaInfo;
            $scope.areasGeneral = AreaGeneralInfo;
            $scope.rubros = RubroInfo;
            $scope.subrubros = SubRubroInfo;
            $scope.cuentas = CuentasInfo;
            $scope.cuentasOtros = CuentasOtrosInfo;
            $scope.cuentasSNP = CuentasOtrosInfo;
            $scope.empresas = EmpresaInfo;
            $scope.formaPagos = FormaPagoInfo;
            $scope.tiposMovimiento = TipoMovimientoInfo;
            $scope.aid = activityInfoId;
            $scope.ModificaPop = false;
            $scope.tiposMovimientoPromocionNueva = TipoMovimientoCreacionInfo;//TipoMovimientoInfo;

            $scope.tiposMovimientoPromocionExistente = TipoMovimientoInfo;
            $scope.tiposSolicitud = TipoSolicitudInfo;
            $scope.almacenes = AlmacenInfo;
            $scope.tiposAlmacen = TipoAlmacenInfo;
            $scope.unidadesMedida = UnidadMedidaInfo;
            $scope.tiposElemento = TipoElementoInfo;
            $scope.estatus = EstatusActivityInfo;
            $scope.monedaCmb = MonedaInfo;
            $scope.formatoLinea = FormatoLineaInfo;
            $scope.proveedorAll = ProveedorAllInfo;
            $scope.proyecto = ProyectoInfo;
            $scope.comprador = CompradorInfo;
            $scope.aprobador = AprobadorInfo;
            $scope.usuarioQad = UsuarioQadInfo;
            $scope.centrocos = CentroCostoInfo;
            $scope.subCuenta = SubcuentaInfo;
            $scope.productosInfo = ProductosInfo;
            $scope.productoOptions = { idProp: "ProductoId", displayProp: "Producto", methodName: "GetProductos" };
            $scope.articuloOptions = { idProp: "ArticuloId", displayProp: "Articulo", methodName: "GetArticulos" };
            $scope.subcuentaOptions = { idProp: "SubcuentaId", displayProp: "Subcuenta", methodName: "GetSubcuentas" };
            $scope.centroCostoOptions = { idProp: "CentroCostoId", displayProp: "CentroCosto", methodName: "GetCentroCosto" };
            $scope.proveedoresOptions = { idProp: "ProveedorId", displayProp: "Proveedor", methodName: "GetProveedores" };
            $scope.proveedoresMatrizOptions = MatrizProveedorPOPInfo;// { idProp: "ProveedorId", displayProp: "Proveedor", methodName: "GetProveedoresMatriz" };
            $scope.materialMatrizOptions = { idProp: "MaterialId", displayProp: "Material", methodName: "GetMaterialMatriz" };
            $scope.originalProveedoresMatrizOptions = $scope.proveedoresMatrizOptions;
            $scope.originalMaterialMatrizOptions = $scope.materialMatrizOptions;
            $scope.matrizOptions = MatrizPOPInfo;//{ idProp: "ArticuloId", displayProp: "Articulo", methodName: "GetMatrizPOP" };
            $scope.matrizProveedorOptions = MatrizProveedorPOPInfo;
            $scope.opcionesFechaActivity = { startDisabled: false };
            $scope.SuperFiltro = { Marcas: [] };
            $scope.FilterProveedor = { ArticuloId: 0 };
            $scope.FilterArticulo = { ProveedorId: 0 };
            $scope.marcasSeleccionadas = [];
            $scope.fechaActual = new Date(FechaInfo[0].Anio, FechaInfo[0].Mes, FechaInfo[0].Dia);
            $scope.fechaLlegadaQualaActual = $scope.fechaActual;
            $scope.fechaLlegadaDistritoActual = $scope.fechaActual;
            $scope.lblNotaOs = '';
            $scope.esMedioOtros = false;
            $scope.esPermiteMediosOtros = PermisoMediosOtrosInfo[0].EsPermisoMediosOtros;
            $scope.condicionPagoCmb = CondicionPagoInfo;
            $scope.tipoProveedor = TipoProveedorInfo;
            $scope.validaEmail = false;
            $scope.verRequisiciones = false;

            var subcuentas = [];

            $scope.SetValuesMarca = function () {
                _.each($scope.activity.Promocion.Detalle, function (promocion) {
                    _.each(promocion.Productos, function (producto) {
                        producto.ProductoId = "";
                        producto.Codigo = "";
                    });
                });
            };

            var setSubcuenta = function (item) {

                removerTodoSubCuenta();
                $scope.marcasJoin = _.pluck($scope.filtro.Marcas, 'id').join(",");

                var marca;
                if (item.id === "1007" || item.id === "1021") {
                    $scope.activity.Marcas = [{ id: "1007" }, { id: "1021" }]
                    marca = _.findWhere($scope.marcas, { LineaCodigo: "1021" });
                    subcuentas.push(marca.SubcuentaContable);
                    $scope.marcasSeleccionadas.push(marca);
                    marca = _.findWhere($scope.marcas, { LineaCodigo: "1007" });
                    subcuentas.push(marca.SubcuentaContable);
                    $scope.marcasSeleccionadas.push(marca);
                } else {
                    $scope.activity.Marcas = [{ id: item.id }]
                    marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                    subcuentas.push(marca.SubcuentaContable);

                    if ($scope.activity.Marcas.length > 1)
                        $scope.activity.Marcas.splice(0, 1);

                    $scope.marcasSeleccionadas.push(marca);
                }



                $scope.activity.Subcuenta = subcuentas.join(",");
                $scope.SuperFiltro.Marcas = _.pluck($scope.activity.Marcas, 'id').join(",");

                $scope.fileParametersPromocion.Marca = marca.NombreMarca;
                $scope.fileParametersEstructuraComercial.Marca = marca.NombreMarca;

                //Obtener lista de canales asociados a la Marca que se está seleccionando
                var datos = { LineaCodigo: item.id };
                $Ex.Execute("GetCanalesPorLineaCodigo", datos, function (response, isInvalid) {
                    $scope.canales = response.d;
                    $scope.getRubrosCanal();
                });
            }

            var removeSubcuenta = function (item) {
                var marca = _.findWhere($scope.marcas, { LineaCodigo: item.id });
                var index = _.indexOf(subcuentas, marca.SubcuentaContable);
                var indexMarca = _.indexOf($scope.marcasSeleccionadas, marca.SubcuentaContable);
                subcuentas.splice(index, 1);
                $scope.marcasSeleccionadas.splice(index, 1);
                $scope.activity.Subcuenta = subcuentas.join(",");
                $scope.SuperFiltro.Marcas = _.pluck($scope.activity.Marcas, 'id').join(",");
                $scope.SetValuesMarca();

                //Reset Canales
                $scope.canales = [];
                $scope.getRubrosCanal();
            };

            var removerTodoSubCuenta = function () {
                $scope.activity.Marcas = [];

                $scope.activity.Subcuenta = "";
                subcuentas = [];
                $scope.marcasSeleccionadas = [];
                $scope.SuperFiltro.Marcas = [];
                $scope.SetValuesMarca();

                //Reset Canales
                $scope.canales = [];
                $scope.getRubrosCanal();
            }

            $scope.estatusOptions = util.getOptionsMultiselect("EstatusId", "Nombre");
            $scope.marcasOptions = util.getOptionsMultiselect("LineaCodigo", "NombreMarca");
            $scope.multiselectEventos = {
                onItemSelect: setSubcuenta,
                onItemDeselect: removerTodoSubCuenta,
                onDeselectAll: removerTodoSubCuenta
            };

            $scope.translateTextMultiSelect = $Ex.GetTranslateMultiSelectSettings();
            $scope.canalesOptions = util.getOptionsMultiselect("CanalId", "NombreCanal");
            $scope.rubrosOptions = util.getOptionsMultiselect("RubroId", "Nombre");

            $scope.cuentasPromocion = _.where(CuentasInfo, { RubroId: enums.rubros.Promocion });
            $scope.cuentasNotasCredito = _.where(CuentasInfo, { RubroId: enums.rubros.NotaCredito });
            $scope.cuentasConcurso = _.where(CuentasInfo, { RubroId: enums.rubros.Concurso });
            $scope.cuentasOtros = _.where(CuentasInfo, { RubroId: enums.rubros.Otros });
            $scope.cuentasPop = _.where(CuentasInfo, { RubroId: enums.rubros.Pop });
            $scope.cuentasOs = [];
            $scope.cuentasSNP = _.where(CuentasInfo, { RubroId: enums.rubros.Otros });

            $scope.showMotivo = false;

            //Eventos para los multiselect Marca y Canal en filtro (Avanzado)
            $scope.marcasJoin = '';

            var removeCanales = function (item) {

                obtenerCanales(_.pluck($scope.filtro.Marcas, 'id').join(","));
            };

            var getCanales = function (item) {

                $scope.marcasJoin = _.pluck($scope.filtro.Marcas, 'id').join(",");

                obtenerCanales($scope.marcasJoin);
            }

            var obtenerCanales = function (marcas) {

                try {
                    var marcasSel = {};
                    marcasSel.Marcas = marcas;

                    $Ex.Execute("ObtenerCanalesPorMarca", marcasSel, function (response) {

                        $scope.filtro.Canales = [];
                        var canalesVisual = response.d.CanalesVisual;

                        $scope.canalesFiltro = canalesVisual;

                        Ex.load(false);

                    });


                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }

            }

            $scope.multiselectEventosFiltroMarca = {
                onItemSelect: getCanales,
                onItemDeselect: removeCanales,
                onDeselectAll: function () {

                    $scope.canalesFiltro = [];
                    $scope.filtro.Canales = [];

                },
                onSelectAll: function () {

                    $timeout(function () {
                        obtenerCanales($scope.marcasJoin);

                    }, 3000);

                },

            };

            ///////////////////////////////////////////////////

            $scope.fileOptionsEstructuraComercial = {
                url: "../Codes/UploadExcelFile.ashx",
                autoUpload: true,
                maxFilesize: Ex.GetResourceValue('maxFileSize')
            };
            $scope.fileParametersEstructuraComercial = { SessionName: "EstructuraComercial" };

            $scope.fileOptionsPromocion = {
                url: "../Codes/UploadExcelFile.ashx",
                autoUpload: true,
                maxFilesize: Ex.GetResourceValue('maxFileSize')
            };
            $scope.fileParametersPromocion = { SessionName: "Promocion", Folder: Ex.GetResourceValue("folderArchivosPromociones") };

            $scope.fileOptionsPop = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true,
                maxFilesize: Ex.GetResourceValue('maxFileSize'),
                puedeEliminar: false
            };
            $scope.fileOptionsConcurso = angular.copy($scope.fileOptionsPop);
            $scope.fileOptionsDetalle = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true,
                validExtensions: Ex.GetResourceValue('validExtensions'),
                maxFilesize: Ex.GetResourceValue('maxFileSize'),
                puedeEliminar: true
            };
            $scope.fileOptionsOs = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true,
                validExtensions: Ex.GetResourceValue('validExtensions'),
                maxFilesize: Ex.GetResourceValue('maxFileSize'),
                puedeEliminar: true,
                disabled: false
            };

            $scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };

            var configuracionGeneral = ConfiguracionInfo[0];
            var rubrosCanal = [];

            //Enumeraciones
            $scope.tipoActivity = enums.tiposActivity;
            $scope.rubro = enums.rubros;
            $scope.tipoElemento = enums.tiposElemento;
            $scope.tipoAlmacen = enums.tiposAlmacen;
            $scope.tipoDescuento = enums.tiposDescuento;
            $scope.unidadMedida = enums.unidadesMedida;

            //***************************** VALIDACIONES ********************************
            var validarPromocion = function (mensajeError) {
                var promociones = _.where($scope.activity.Promocion.Detalle, { Eliminar: false });
                var objetivos = _.where($scope.activity.Promocion.Objetivos, { Eliminar: false });

                if (mensajeError === "" && objetivos.length > 0) {
                    var objetivosPromocion = [];

                    _.each(promociones, function (item) {
                        var nombrePromocion = item.Nombre !== null ? item.Nombre : "";

                        var productos = _.where(item.Productos, { Eliminar: false });

                        //var totalParticipacion = _.reduce(productos, function (value, e) {
                        //    var participacion = value + (isNaN(e.Participacion) ? 0 : e.Participacion);
                        //    return participacion;
                        //}, 0);

                        //if (totalParticipacion !== 100)
                        //    mensajeError = nombrePromocion + ": " + Ex.GetResourceValue("msjParticipacionPrecio");

                        objetivosPromocion.push(item.NumeroObjetivo);

                        if (nombrePromocion == "") {
                            mensajeError = "Favor de capturar una promoción válida.";
                        }

                    });

                    objetivosPromocion = _.uniq(objetivosPromocion);

                    if (objetivosPromocion.length !== objetivos.length) {
                        var objetivoNoLigado = 0;
                        _.each(objetivos, function (item) {
                            if (!_.contains(objetivosPromocion, item.NumeroObjetivo))
                                objetivoNoLigado = item.NumeroObjetivo;
                        });

                        mensajeError = Ex.GetResourceValue("msjParticipacionObjetivos")
                            .replace("{NumeroObjetivo}", objetivoNoLigado);
                    }
                }

                return mensajeError;
            };

            var validarRubro = function (nombreRubro, descripcionRubro, mensajeError) {
                if (mensajeError === "") {
                    var rubro = $scope.activity[nombreRubro];
                    var objetivos = _.where(rubro.Objetivos, { Eliminar: false });

                    rubro.RubroId = enums.rubros[nombreRubro];

                    if (!rubro.NoAplicaObjetivo &&
                        rubro.Importe > 0 &&
                        objetivos.length === 0 &&
                        rubro.Detalle.length > 0 &&
                        nombreRubro !== "Os" &&
                        (nombreRubro !== "Pop" || rubro.TipoPopId !== 1)) {
                        mensajeError = descripcionRubro + ": " + Ex.GetResourceValue("msjFaltaObjetivo");
                    }

                    if (rubro.Importe > 0) {
                        var rubroId = nombreRubro === "Os" && $scope.activity.TipoActivityId === enums.tiposActivity.Idm
                            ? 7
                            : rubro.RubroId;

                        $scope.activity.Rubros.push({ RubroId: rubroId, Importe: rubro.Importe });
                    }

                    if (rubro.NoAplicaObjetivo)
                        $scope.activity.NoAplicaObjetivo = true;

                    if (nombreRubro === "Os") {
                        angular.forEach(rubro.Detalle, function (item, key) {
                            if (item.Importe <= 0) {
                                mensajeError = 'Favor de verificar el monto del detalle de la OS';
                            }
                            // Ojo Aquí JE
                            if (item.ProveedorId == undefined) {
                                mensajeError = 'Favor de capturar un proveedor válido';
                            }
                            if (item.ArticuloId == undefined) {
                                mensajeError = 'Favor de capturar un artículo válido';
                            }
                            if (item.MonedaId == undefined || item.MonedaId == 0) {
                                mensajeError = 'Favor de seleccionar una moneda válida';
                            }
                            if (item.CuentaContableId == undefined || item.CuentaContableId == 0) {
                                mensajeError = 'Favor de seleccionar una cuenta válida';
                            }
                        });
                    }

                    if (nombreRubro === "Pop")
                        $scope.activity.TipoPopId = rubro.TipoPopId;

                    if (nombreRubro === "Concurso") {
                        if (rubro.ObjetivosFVE !== undefined) {
                            if (rubro.ObjetivosFVE.length > 0) {
                                if (rubro.TipoVentaExternaId === undefined) {
                                    mensajeError = 'Debe especificar opción de Fuerza de Venta Externa.';
                                }
                                if (rubro.TipoVentaExternaId !== undefined) {
                                    if (rubro.TipoVentaExternaId === "") {
                                        mensajeError = 'Debe especificar opción de Fuerza de Venta Externa.';
                                    }
                                }
                            }
                        }
                    }

                }

                return mensajeError;
            };

            var validarSubRubro = function (nombreRubro, descripcionSubRubro, mensajeError) {
                if (mensajeError === "") {
                    var rubro = $scope.activity[descripcionSubRubro]; 
                    var rubroPadre = $scope.activity[nombreRubro];
                    var objetivos = _.where(rubroPadre.Objetivos, { Eliminar: false });
                    var objetivosSR = _.where(rubro.Objetivos, { Eliminar: false });

                    rubro.RubroId = enums.rubros[nombreRubro];

                    if (!rubro.NoAplicaObjetivo &&
                        rubro.Importe > 0 &&
                        objetivos.length === 0 &&
                        objetivosSR.length === 0) {
                        mensajeError = descripcionSubRubro + ": " + Ex.GetResourceValue("msjFaltaObjetivo");
                    }
                    

                    var subRubro = _.where($scope.subrubros, { SubRubro: descripcionSubRubro, RubroId: rubro.RubroId });
                    if (subRubro.length > 0) { 
                        rubro.SubRubroId = subRubro[0].SubrubroId;
                    } 
                     
                    if (rubro.Importe > 0) {
                        var rubroId = nombreRubro === "Os" && $scope.activity.TipoActivityId === enums.tiposActivity.Idm
                            ? 7
                            : rubro.RubroId;

                        $scope.activity.Rubros.push({ RubroId: rubroId, Importe: rubro.Importe });
                    }
                     
                    $scope.activity.NoAplicaObjetivo = true;
                     
                }

                return mensajeError;
            };
            
            var validarMultimarcas = function (mensajeError) {

                if (mensajeError === "") {

                    var TotalGrupos = _.size(_.groupBy($scope.marcasSeleccionadas, 'Grupo'));

                    if (TotalGrupos === 1) {

                        var TotalElementosGrupo = _.size(_.where($scope.marcas, { Grupo: $scope.marcasSeleccionadas[0].Grupo }));
                        if ($scope.activity.Marcas.length !== TotalElementosGrupo) {
                            mensajeError = Ex.GetResourceValue("msgGrupoMarcas");
                        }
                    }
                    //else if (TotalGrupos > 1) {
                    //    mensajeError = Ex.GetResourceValue("msgMultiMarcas");
                    //}
                }

                return mensajeError;
            }

            var obtenerFechasObjetivosConcurso = function () {
                if ($scope.activity.Concurso.hasOwnProperty("Objetivos")) {
                    _.each($scope.activity.Concurso.Objetivos, function (objetivo) {
                        objetivo.FechaInicio = objetivo.Fecha.StartDate;
                        objetivo.FechaFin = objetivo.Fecha.EndDate;
                    });
                }
            };

            var obtenerFechasObjetivosConcursoFVE = function () {
                if ($scope.activity.Concurso.hasOwnProperty("ObjetivosFVE")) {
                    _.each($scope.activity.Concurso.ObjetivosFVE, function (objetivoFVE) {
                        objetivoFVE.FechaInicio = objetivoFVE.Fecha.StartDate;
                        objetivoFVE.FechaFin = objetivoFVE.Fecha.EndDate;
                    });
                }
            };

            var mostrarMensajeError = function (response) {
                if (response.hasOwnProperty("ErrorParaUsuario")) {
                    Ex.mensajes(response.ErrorParaUsuario);
                    console.log(response.ErrorParaTi);
                }
            };

            //***************************** GENERAL ********************************
            var getTotalActivity = function () {
                var importe = $scope.activity.Os.Importe;

                if ($scope.activity.TipoActivityId === enums.tiposActivity.General) {
                    importe = $scope.activity.Promocion.Importe +
                        $scope.activity.NotaCredito.Importe +
                        $scope.activity.Concurso.Importe +
                        $scope.activity.Pop.Importe +
                        $scope.activity.Otros.Importe;
                }
                else if ($scope.activity.TipoActivityId === enums.tiposActivity.Pop)
                    importe = $scope.activity.Pop.Importe;


                $scope.activity.Importe = +importe.toFixed(2);
            };

            var getTotalRubro = function (nombreRubro) {
                var lista = $scope.activity[nombreRubro].Detalle;
                var importeObjetivos = 0;
                var importeTotal = 0;

                lista = _.where(lista, { Eliminar: false });

                var importe = _.reduce(lista, function (valor, rubro) {
                    valor = valor + (isNaN(rubro.Importe) ? 0 : rubro.Importe);
                    return valor;
                }, 0);

                if (nombreRubro === 'Concurso') {

                    var listaObjetivos = $scope.activity[nombreRubro].Objetivos;

                    importeObjetivos = _.reduce(listaObjetivos, function (valor, objetivo) {
                        valor = valor + (isNaN(objetivo.CostoTotal) ? 0 : objetivo.CostoTotal);
                        return valor;
                    }, 0);
                }
               
                importeTotal = +importe.toFixed(2) + +importeObjetivos.toFixed(2);
 
                //validamos si es un sub rubro * para sumar por activity *
                var subRubro = _.where($scope.subrubros, { SubRubro: nombreRubro });
                var rubro = _.where($scope.subrubros, { Rubro: nombreRubro });

                if (subRubro.length > 0 || rubro.length > 0) {
                    defineTotalRubroConSubRuro(
                        subRubro.length > 0 ? subRubro[0].SubRubro : rubro[0].SubRubro
                        , subRubro.length > 0 ? subRubro[0].Rubro : rubro[0].Rubro
                    );
                }
                else {
                    $scope.activity[nombreRubro].Importe = + importeTotal.toFixed(2);
                } 
            };

            var defineTotalRubroConSubRuro = function (nombreSubRubro, nombreRubro) {

                //validamos si es un sub rubro * para sumar por activity *
                var importeRubro = getTotalRubroTemporal(nombreRubro);
                var importeSubRubro = getTotalRubroTemporal("SNP");
                var importeTotal = importeRubro + importeSubRubro;

                // re start
                $scope.activity[nombreRubro].Importe = 0;
                $scope.activity[nombreRubro].Importe = + importeTotal.toFixed(2);

                // set
                $scope.activity["SNP"].Importe = 0;
                $scope.activity["SNP"].Importe = + importeSubRubro.toFixed(2);
            }

            var getTotalRubroTemporal = function (nombreRubro) {
                var lista = $scope.activity[nombreRubro].Detalle;
                var importeObjetivos = 0;
                var importeTotal = 0;

                lista = _.where(lista, { Eliminar: false });

                var importe = _.reduce(lista, function (valor, rubro) {
                    valor = valor + (isNaN(rubro.Importe) ? 0 : rubro.Importe);
                    return valor;
                }, 0);

                if (nombreRubro === 'Concurso') {

                    var listaObjetivos = $scope.activity[nombreRubro].Objetivos;

                    importeObjetivos = _.reduce(listaObjetivos, function (valor, objetivo) {
                        valor = valor + (isNaN(objetivo.CostoTotal) ? 0 : objetivo.CostoTotal);
                        return valor;
                    }, 0);
                }

                importeTotal = +importe.toFixed(2) + +importeObjetivos.toFixed(2);

                $scope.activity[nombreRubro].Importe = + importeTotal.toFixed(2);

                return parseFloat($scope.activity[nombreRubro].Importe);
            };

            var getPromocion = function () {
                $scope.activity.Promocion.Importe = 0;
                arrayPromocionOriginal = [];
                _.each($scope.activity.Promocion.Detalle, function (promocion, index) {
                    $scope.fileParametersPromocion.TipoMovimientoId = promocion.TipoMovimientoId;
                    $scope.fileParametersPromocion.TipoMovimiento = promocion.NombreTipoMovimiento;
                    $scope.fileParametersPromocion.ExisteCodigoPromocion = 2;
                    $scope.fileParametersPromocion.Marca = $scope.activity.Marca;
                    $scope.fileParametersEstructuraComercial.Marca = $scope.activity.Marca;
                    $scope.fileParametersPromocion.TipoSolicitudId = promocion.TipoSolicitudId;
                    $scope.fileParametersPromocion.TipoSolicitud = promocion.NombreTipoSolicitud;

                    $scope.fileParametersPromocion.ActivityId = $scope.activity.ActivityId != undefined ? $scope.activity.ActivityId : 0;
                    $scope.fileParametersPromocion.PromocionId = promocion.PromocionId != undefined ? promocion.PromocionId : 0;

                    arrayPromocionOriginal.push({
                        PromocionId: promocion.PromocionId,
                        CodigoPromocion: promocion.CodigoPromocion,
                        Index: index,
                        PromocionOriginal: {},
                        TipoMovimientoId: promocion.TipoMovimientoId,
                        TipoMovimiento: promocion.NombreTipoMovimiento,
                        TipoSolicitudId: promocion.TipoSolicitudId,
                        TipoSolicitud: promocion.NombreTipoSolicitud
                    });

                    _.each(promocion.ListaPrecios, function (lista) {
                        lista.FechaPromocion = { StartDate: lista.FechaInicio, EndDate: lista.FechaFin };
                    });

                    $scope.activity.Promocion.Importe += promocion.Importe;

                    //Cargar todos los tipos de movimiento excepto Creacion y Reactivacion

                    promocion.TipoMovimientoInfo = $scope.tiposMovimientoPromocionExistente;

                    //getTotalPromocionMacro(promocion);
                });

                $scope.activity.Promocion.NumerosObjetivo =
                    _.pluck($scope.activity.Promocion.Objetivos, "NumeroObjetivo");

                var nuevosObjetivos = _.filter($scope.activity.Promocion.Objetivos, function (item) {
                    return item.NuevoObjetivo;
                });

                $scope.activity.tieneNuevoObjetivo = nuevosObjetivos.length > 0;
            };

            //Permite ocultar o cambiar de pantalla, de inicio se muestra la pantalla principal.
            $scope.pantallas = {
                principal: 1,
                detalle: 2,
                configuracionListaPrecio: 3,
                configuracionAlmacen: 4,
                informacionPromocion: 5,
                requisicion: 6,
                requisicionMedio: 7
            };
            $scope.pantallaId = $scope.pantallas.principal;

            $scope.vistas = [
                { id: 1, nombre: Ex.GetResourceValue("lblActivity") },
                { id: 2, nombre: Ex.GetResourceValue("lblEvaluacion") },
                { id: 3, nombre: Ex.GetResourceValue("lblLog") }
            ];

            $scope.vista = $scope.vistas[0];

            $scope.agregar = function () {
                rubrosCanal = [];
                //$scope.canales = CanalInfo;
                console.log($scope.formaPagos);
                $scope.canales = [];
                $scope.vista = $scope.vistas[0];
                $scope.formaPrincipal.disableForm(false);
                $scope.opcionesFechaActivity.startDisabled = false;
                $scope.showMotivo = false;
                $scope.activity = {
                    AreaId: areaInfo,
                    Reactivo: false,
                    Importe: 0,
                    TipoActivityId: 1,
                    Fecha: null,
                    PuedeModificar: true,
                    CentroCostos: configuracionGeneral.CentroCosto,
                    DetalleItem: [],
                    DetalleArchivo: [],
                    Marcas: [],
                    Promocion: { Importe: 0, Detalle: [] },
                    NotaCredito: { Importe: 0, Detalle: [] },
                    Concurso: { Importe: 0, Detalle: [], TipoFuerzaId: 1, ObjetivosFVE: [] },
                    Otros: { Importe: 0, Detalle: [] },
                    Pop: { Importe: 0, Detalle: [] },
                    Os: { Importe: 0, Detalle: [] },
                    SNP: { Importe: 0, Detalle: [] }
                };
                $scope.activity.Pop.TipoPopId = 1; //Elimina Objetivos de POP
                subcuentas = [];
                $scope.fileOptionsPop.puedeEliminar = true;
                $scope.pantallaId = $scope.pantallas.detalle;
                $scope.submitted = false;
                $scope.marcasSeleccionadas = [];
                $scope.esMedioOtros = false;

                $scope.fechaLlegadaQualaActual = $scope.fechaActual;
                $scope.fechaLlegadaDistritoActual = $scope.fechaActual;

            };

            $scope.cambiarVista = function (vista) {
                $scope.vista = vista;
            };

            function pad(s) {
                return s < 10 ? '0' + s : s;
            };

            $scope.getRubrosCanal = function () {
                $Ex.Execute("GetRubrosCanal", $scope.activity, function (response, isInvalid) {
                    rubrosCanal = _.pluck(response.d, "RubroId");

                    $scope.activity.Promocion = { Importe: 0, Detalle: [] };
                    $scope.activity.NotaCredito = { Importe: 0, Detalle: [], TipoFuerzaId: 1 };
                    $scope.activity.Concurso = { Importe: 0, Detalle: [], ObjetivosFVE: [] };
                    $scope.activity.Otros = { Importe: 0, Detalle: [] };
                    $scope.getSubCanales();
                    getTotalActivity();
                });
            };

            $scope.getSubCanales = function () {
                $Ex.Execute("GetSubCanal", $scope.activity, function (response, isInvalid) {
                    $scope.subcanales = response.d;

                    $timeout(function () {
                        $scope.forma.$setPristine();
                    }, 0);
                });
            };

            $scope.getCanalesPop = function () {
                $scope.esMedioOtros = false;
                if ($scope.activity.TipoActivityId == enums.tiposActivity.Medios
                    || $scope.activity.TipoActivityId == enums.tiposActivity.OtrosGastos) {
                    $scope.activity.AreaId = 3;
                    if ($scope.activity.TipoActivityId == enums.tiposActivity.OtrosGastos) {
                        $scope.activity.AreaId = 4;
                    }
                    $scope.esMedioOtros = true;
                    $scope.activity.FechaDetalle = (FechaInfo[0] == undefined ? '' : FechaInfo[0].FechaFormat);
                    $scope.activity.CentroCostoId = 10;
                }
                if ($scope.activity.TipoActivityId === enums.tiposActivity.Pop) {
                    $Ex.Execute("GetCanalesPop", {}, function (response, isInvalid) {
                        $scope.canales = response.d;
                    });
                }
                else
                    $scope.canales = CanalInfo;

                if ($scope.activity.TipoActivityId === enums.tiposActivity.Medios) {
                    $scope.cuentasOs = _.where(CuentasInfo, { RubroId: 6 });
                    $scope.lblNotaOs = Ex.GetResourceValue("lblNotaOs") + ' Medios';
                }

                if ($scope.activity.TipoActivityId === enums.tiposActivity.Idm) {
                    $scope.cuentasOs = _.where(CuentasInfo, { RubroId: 7 });
                    $scope.lblNotaOs = Ex.GetResourceValue("lblNotaOs") + ' IDM';
                    $scope.activity.AreaId = 5;
                }

                if ($scope.activity.TipoActivityId === enums.tiposActivity.OtrosGastos) {
                    $scope.cuentasOs = CuentasOtrosInfo;
                }

                getTotalActivity();
            };

            var esGetActivity = false; //sirve para que de inicio no setee la fecha de Cierre de Presupuesto
            $scope.setCierrePresupuesto = function (startDate, endDate) {
                var currDate = new Date();
                currDate = currDate.setHours(0, 0, 0, 0)
                $scope.showMotivo = startDate != null && startDate < currDate;
                $scope.activity.Motivo = $scope.showMotivo && $scope.activity.Motivo ? $scope.activity.Motivo : "";

                if (!esGetActivity) {
                    var fecha = new Date(endDate.getFullYear(),
                        endDate.getMonth(),
                        endDate.getDate() + configuracionGeneral.DiasCierrePresupuesto);

                    $scope.activity.CierrePresupuesto =
                        [pad(fecha.getDate()), pad(fecha.getMonth() + 1), fecha.getFullYear()].join('/');
                }

                $timeout(function () {
                    esGetActivity = false;
                }, 500);
            };

            $scope.agregarDetalle = function (nombreRubro) {
                var rubro = $scope.activity[nombreRubro];
                var numeroObjetivo = rubro.NumerosObjetivo != null ? rubro.NumerosObjetivo[0] : null;

                var detalle = { NumeroObjetivo: numeroObjetivo, RubroId: enums.rubros[nombreRubro], Importe: 0, Eliminar: false };

                if (nombreRubro === "Promocion") {
                    var promocion = {
                        Canales: [],
                        Almacenes: [],
                        CanalValido: false,
                        TipoMovimientoInfo: $scope.tiposMovimientoPromocionNueva
                    };

                    detalle = _.defaults(promocion, detalle);

                    arrayPromocionOriginal.push({
                        PromocionId: 0,
                        CodigoPromocion: "",
                        Index: arrayPromocionOriginal.length,
                        PromocionOriginal: {},
                        TipoMovimientoId: 0,
                        TipoMovimiento: "",
                        TipoSolicitudId: 0,
                        TipoSolicitud: ""
                    });
                }

                if (nombreRubro === "NotaCredito" && $scope.activity.Concurso.TipoVentaExternaId === 1) {
                    $scope.activity.NotaCredito.EsSellIn = true;
                    $scope.activity.NotaCredito.EsSellOut = true;
                }

                if (nombreRubro === "Pop") {
                    var pops = {
                        Proveedores: $scope.proveedoresMatrizOptions,
                        Index: detalle.length == undefined ? 1 : detalle.length,
                    };

                    detalle = _.defaults(pops, detalle);

                }

                rubro.Detalle.push(detalle);
            };

            $scope.quitarDetalle = function (detalle, nombreRubro, index) {
                if (detalle.hasOwnProperty(nombreRubro + "Id"))
                    detalle.Eliminar = true;
                else {
                    $scope.activity[nombreRubro].Detalle.splice(index, 1);
                    arrayPromocionOriginal.splice(index, 1);
                }
                getTotalRubro(nombreRubro);
                getTotalActivity();
            };

            $scope.getActivity = function (activity) {
                $Ex.Execute("GetActivity", activity, function (response) {

                    $scope.canales = [];
                    //Llenar el combo canales con el elemento asociado al activity
                    var canal = _.findWhere($scope.canalesTodos, { CanalId: response.d.activity.CanalId });
                    $scope.canales.push(canal);

                    $scope.activity = response.d.activity;

                    $scope.fechaLlegadaQualaActual = $scope.activity.Pop.FechaLlegadaQuala;
                    $scope.fechaLlegadaDistritoActual = $scope.activity.Pop.FechaLlegadaDistrito;


                    $scope.activity.DetalleFlujo = response.d.activity.DetalleFlujo;
                    $scope.esMedioOtros = false;
                    if ($scope.activity.esMedioOtros) {
                        if ($scope.activity.TipoActivityId == enums.tiposActivity.Medios
                            || $scope.activity.TipoActivityId == enums.tiposActivity.OtrosGastos) {
                            $scope.esMedioOtros = true;
                            $scope.activity.CentroCostoId = 10;
                        }
                        if ($scope.activity.TipoActivityId === enums.tiposActivity.Medios) {
                            $scope.cuentasOs = _.where(CuentasInfo, { RubroId: 6 });
                            $scope.lblNotaOs = Ex.GetResourceValue("lblNotaOs") + ' Medios';
                        }
                        if ($scope.activity.TipoActivityId === enums.tiposActivity.Idm) {
                            $scope.cuentasOs = _.where(CuentasInfo, { RubroId: 7 });
                            $scope.lblNotaOs = Ex.GetResourceValue("lblNotaOs") + ' IDM';
                        }
                        if ($scope.activity.TipoActivityId === enums.tiposActivity.OtrosGastos) {
                            $scope.cuentasOs = CuentasOtrosInfo;
                        }
                        $scope.vista = $scope.vistas[0];
                        $scope.pantallaId = $scope.pantallas.detalle;
                        $scope.calcularDetalleItem();
                        $scope.activity.PuedeModificar = 0;
                        if ($scope.activity.EstatusId == 1) {
                            $scope.activity.PuedeModificar = 1;
                            $scope.fileOptionsDetalle.puedeEliminar = true;
                        }
                    } else {
                        //angular.copy($scope.activity.Marcas, $scope.marcasSeleccionadas);
                        rubrosCanal = _.pluck(response.d.rubrosCanal, "RubroId");
                        $scope.ReqProveedorId = 0;

                        $scope.activity.Fecha = { StartDate: $scope.activity.FechaInicio, EndDate: $scope.activity.FechaFin };
                        getPromocion();

                        _.each($scope.activity.Concurso.Objetivos, function (objetivo) {
                            objetivo.Fecha = { StartDate: objetivo.FechaInicio, EndDate: objetivo.FechaFin };
                        });
                        _.each($scope.activity.Pop.Detalle, function (objetivo) {

                            objetivo.Proveedores = $scope.matrizProveedorOptions.map(function (num) {
                                if (num.MaterialId == objetivo.MaterialId) {
                                    return num;
                                }
                            }).filter(notUndefined => notUndefined !== undefined);

                        });

                        _.each($scope.activity.Concurso.ObjetivosFVE, function (objetivoFVE) {
                            objetivoFVE.Fecha = { StartDate: objetivoFVE.FechaInicio, EndDate: objetivoFVE.FechaFin };
                        });

                        $timeout(function () {
                            $scope.formaPrincipal.disableForm(!$scope.activity.PuedeModificar);
                        }, 100);
                        $scope.opcionesFechaActivity.startDisabled = !$scope.activity.PuedeModificar;
                        subcuentas = $scope.activity.Subcuenta.split(",");

                        $scope.objetivosConcurso = [];

                        _.each($scope.activity.Concurso.Objetivos, function (objetivo) {
                            $scope.objetivosConcurso.push(objetivo);
                        });
                        if ($scope.activity.Concurso.TipoVentaExternaId === 2) {
                            _.each($scope.activity.Concurso.ObjetivosFVE, function (objetivoFVE) {
                                $scope.objetivosConcurso.push(objetivoFVE);
                            });
                        }

                        $scope.vista = $scope.vistas[0];
                        $scope.pantallaId = $scope.pantallas.detalle;
                        $scope.evaluacionSubmitted = false;
                        $scope.fileOptionsPop.puedeEliminar = $scope.campoHabilitado() && !$scope.SinRequisiciones('Pop');
                        $scope.fileOptionsConcurso.puedeEliminar = $scope.activity.PuedeEvaluar;

                        if ($scope.activity.TipoActivityId === enums.tiposActivity.Medios)
                            $scope.cuentasOs = _.where(CuentasInfo, { RubroId: 6 });

                        if ($scope.activity.TipoActivityId === enums.tiposActivity.Idm)
                            $scope.cuentasOs = _.where(CuentasInfo, { RubroId: 7 });

                        $scope.marcasSeleccionadas = [];
                        _.each($scope.activity.Marcas, function (objetivo) {
                            var marca = _.findWhere($scope.marcas, { LineaCodigo: objetivo.id });
                            $scope.marcasSeleccionadas.push(marca);
                        });

                        $scope.SuperFiltro.Marcas = _.pluck($scope.activity.Marcas, 'id').join(",");

                        esGetActivity = true;
                        $scope.getSubCanales();

                        var promocion = $scope.activity.Promocion;
                    }

                    $timeout(function () {
                        $scope.forma.$setPristine();
                        $scope.forma.$setUntouched();
                        $scope.forma.$setValidity();
                    }, 0);

                });
            };

            $scope.getActivities = function () {
                $scope.filtro.EstatusIds = _.pluck($scope.filtro.Estatus, 'id').join(",");
                $scope.filtro.MarcaIds = _.pluck($scope.filtro.Marcas, 'id').join(",");
                $scope.filtro.CanalIds = _.pluck($scope.filtro.Canales, 'id').join(",");
                $scope.filtro.RubroIds = _.pluck($scope.filtro.Rubros, 'id').join(",");

                $scope.filtro.FechaInicio = $scope.filtro.Fecha ? $scope.filtro.Fecha.StartDate : "";
                $scope.filtro.FechaFin = $scope.filtro.Fecha ? $scope.filtro.Fecha.EndDate : "";

                $Ex.Execute("GetActivities", $scope.filtro, function (response) {
                    $scope.activities = response.d;
                });
            };

            $scope.guardar = function (esEnviar) {
                $scope.submitted = true;


                if ($scope.activity.Marcas.length === 0 && !$scope.esMedioOtros) {
                    Ex.mensajes("Favor de capturar Marca.");
                    return;
                }
                if (!$Ex.IsValidateRequiredFieldForm($scope.forma)) {
                    return;
                }
                if ($scope.forma.$invalid || $scope.activity.Importe === 0) {
                    var mensaje = $scope.forma.$invalid
                        ? Ex.GetGlobalResourceValue("msgRequiredFields")
                        : Ex.GetResourceValue("msgImporteInvalido");

                    Ex.mensajes(mensaje);
                } else {
                    var error = "";
                    $scope.activity.Rubros = [];

                    if (!$scope.esMedioOtros) {
                        error = validarPromocion(error);
                        error = validarRubro("Promocion", "Promoción Configurada", error);
                        error = validarRubro("NotaCredito", "Descuentos vía Notas de Crédito", error);
                        error = validarRubro("Concurso", "Concursos", error);
                        error = validarRubro("Otros", "Otros", error);
                        error = validarRubro("Pop", "Pop", error);
                        error = validarRubro("Os", "Os", error);

                        error = validarSubRubro("Otros", "SNP", error);

                        error = validarMultimarcas(error);
                    } else {
                        //Valida Campo de Email
                        if ($scope.activity.Correo != undefined && $scope.activity.Correo != '') {
                            re = /^([\da-z_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
                            if (!re.exec($scope.activity.Correo)) {
                                error = 'Formato de correo no válido';
                            }
                        }
                        //Valida Documentos
                        angular.forEach($scope.activity.DetalleArchivo, function (item, key) {
                            if (item.NombreArchivo == '') {
                                error = 'Favor de Adjuntar un archivo válido.';
                            }
                        });
                    }
                    if ($scope.activity.TipoActivityId == 1 || $scope.activity.TipoActivityId == 2 && esEnviar) {
                        //Valida POP
                        angular.forEach($scope.activity.Pop.Detalle, function (item, key) {
                            if (item.NombreArchivo == '' && item.ItemModificado) {
                                error = 'Favor de adjuntar un Acta de Negociación';
                            }
                        });
                    }
                    //Valida Archivos IDM
                    if ($scope.activity.TipoActivityId == 4 && esEnviar) {
                        //Valida IDM
                        angular.forEach($scope.activity.Os.Detalle, function (item, key) {
                            if (item.NombreArchivo == '' && item.ItemModificado) {
                                error = 'Favor de adjuntar una Cotización';
                            }
                        });
                    }
                    if (error === "") {
                        if ($scope.activity.Fecha != null) {
                            $scope.activity.FechaInicio = $scope.activity.Fecha.StartDate;
                            $scope.activity.FechaFin = $scope.activity.Fecha.EndDate;
                        }
                        var canal = _.findWhere($scope.canales, { CanalId: $scope.activity.CanalId });
                        if (canal != undefined) {
                            $scope.activity.Canal = canal.NombreCanal;
                        } else {
                            $scope.activity.CanalId = 0;
                            if ($scope.activity.TipoActivityId != enums.tiposActivity.Idm) {
                                $scope.activity.FechaInicio = $scope.activity.FechaDetalle;
                                $scope.activity.FechaFin = $scope.activity.FechaDetalle;
                                $scope.activity.CierrePresupuesto = $scope.activity.FechaDetalle;
                            }
                        }
                        obtenerFechasObjetivosConcurso();
                        obtenerFechasObjetivosConcursoFVE();

                        $scope.activity.Enviar = esEnviar;

                        //Validar fechas de inicio y fin de listas de precio en promociones

                        var arrayStartDate = $scope.activity.FechaInicio.split("/");
                        var arrayEndDate = $scope.activity.FechaFin.split("/");

                        var activityStartDate = new Date(arrayStartDate[2], arrayStartDate[1] - 1, arrayStartDate[0], 0, 0, 0, 0);
                        var activityEndDate = new Date(arrayEndDate[2], arrayEndDate[1] - 1, arrayEndDate[0], 0, 0, 0, 0);

                        var errorVigencia = "";

                        _.each($scope.activity.Promocion.Detalle, function (promocion) {

                            var codigoPromocionCargado = _.findWhere($scope.CodigosPromocionCargados, { CodigoPromocion: promocion.CodigoPromocion });

                            if (codigoPromocionCargado != undefined) {
                                promocion.LoadComplete = true;
                                _.each(promocion.ListaPrecios, function (item) {

                                    var fechaInicioDate = new Date(item.FechaInicio.substring(0, 4), item.FechaInicio.substring(4, 6) - 1, item.FechaInicio.substring(6, 8), 0, 0, 0, 0);
                                    var fechaFinDate = new Date(item.FechaFin.substring(0, 4), item.FechaFin.substring(4, 6) - 1, item.FechaFin.substring(6, 8), 0, 0, 0, 0);

                                    if ((fechaInicioDate < activityStartDate || fechaInicioDate > activityEndDate) || (fechaFinDate < activityStartDate || fechaFinDate > activityEndDate)) {
                                        errorVigencia = errorVigencia + "Fecha no vigente en el Número Lista " + item.NumeroLista + ", CodigoPromocion " + promocion.CodigoPromocion;
                                    }

                                });
                            }

                        });

                        if (errorVigencia != "") {
                            Ex.mensajes(errorVigencia);
                        }
                        else {
                            //Si pasa todas las validaciones, entonces si existe al menos un detalle en promociones, calcular el total del activity
                            if ($scope.activity.Promocion.Detalle.length > 0)
                                getTotalActivity();

                            $Ex.Execute("Guardar", $scope.activity, function (response, isInvalid) {
                                if (!isInvalid) {
                                    $scope.LoadComplete = false;
                                    arrayPromocionOriginal = [];
                                    $scope.CodigosPromocionCargados = [];

                                    $scope.getActivities();
                                    $scope.pantallaId = $scope.pantallas.principal;
                                    mostrarMensajeError(response.d);
                                }
                            });
                        }

                    } else {
                        Ex.mensajes(error);
                    }
                }
            };

            $scope.guardarPromocionCreacion = function () {
                $scope.submitted = true;
                if ($scope.activity.Marcas.length === 0) {
                    Ex.mensajes("Favor de capturar Marca.");
                }
                var error = "";
                $scope.activity.Rubros = [];
                error = validarPromocion(error);
                error = validarRubro("Promocion", "Promoción Configurada", error);
                angular.forEach($scope.activity.Promocion.Detalle, function (item, key) {
                    item.TipoMovimientoId = 1;
                });
                if (error === "") {
                    var canal = _.findWhere($scope.canales, { CanalId: $scope.activity.CanalId });
                    $scope.activity.Canal = canal.NombreCanal;
                    obtenerFechasObjetivosConcurso();
                    obtenerFechasObjetivosConcursoFVE();
                    $scope.activity.Enviar = 0;
                    $Ex.Execute("GuardarPromocionCreacion", $scope.activity, function (response, isInvalid) {
                        if (!isInvalid) {
                            Ex.mensajes("Promoción guardada correctamente.");
                        }
                    });
                } else {
                    Ex.mensajes(error);
                }
            }

            $scope.guardarPromocionRefresh = function () {

                $scope.ErrorRefresh = "";

                if ($scope.ErrorRefresh != "") {
                    Ex.mensajes($scope.ErrorRefresh);
                }
                else {
                    $scope.submitted = true;
                    if ($scope.activity.Marcas.length === 0) {
                        Ex.mensajes("Favor de capturar Marca.");
                    }
                    var error = "";
                    $scope.activity.Rubros = [];
                    error = validarPromocion(error);
                    error = validarRubro("Promocion", "Promoción Configurada", error);
                    angular.forEach($scope.activity.Promocion.Detalle, function (item, key) {
                        item.TipoMovimientoId = 1;
                    });
                    if (error === "") {
                        var canal = _.findWhere($scope.canales, { CanalId: $scope.activity.CanalId });
                        $scope.activity.Canal = canal.NombreCanal;
                        obtenerFechasObjetivosConcurso();
                        obtenerFechasObjetivosConcursoFVE();
                        $scope.activity.Enviar = 0;
                        $Ex.Execute("GuardarPromocionRefresh", $scope.activity, function (response, isInvalid) {
                            if (!isInvalid) {
                                Ex.mensajes("Promoción guardada correctamente.");
                            }
                        });
                    } else {
                        Ex.mensajes(error);
                    }
                }
            }

            $scope.validEmail = function () {
                $scope.validaEmail = false;
                if ($scope.activity.Correo != undefined) {
                    $scope.validaEmail = true;
                }
            };

            $scope.aprobar = function (rechazar) {
                $scope.activity.Rechazar = rechazar;
                $Ex.Execute("Aprobar", $scope.activity, function (response, isInvalid) {
                    $scope.getActivities();
                    $scope.pantallaId = $scope.pantallas.principal;

                    mostrarMensajeError(response.d);
                });
            };

            $scope.aprobarDetalle = function (rechazar) {
                $scope.activity.Rechazar = rechazar;
                $Ex.Execute("AprobarDetalle", $scope.activity, function (response, isInvalid) {
                    $scope.getActivities();
                    $scope.pantallaId = $scope.pantallas.principal;

                    mostrarMensajeError(response.d);
                });
            };

            $scope.exportarDetalle = function (rechazar) {
                $Ex.Execute("ExportarActivity", $scope.activity, function (response, isInvalid) {
                    if (response.d) {
                        window.location = "DownLoadPage.aspx?d=" + getRandom();
                    }
                });
            };

            $scope.evaluar = function () {
                $scope.evaluacionSubmitted = true;

                var ejecutadoPromocion = _.reduce($scope.activity.Objetivos, function (valor, objetivo) {
                    if (objetivo.EsPromocion)
                        valor = valor + (isNaN(objetivo.Ejecutado) ? 0 : objetivo.Ejecutado);

                    return valor;
                }, 0);

                var ejecutadoPromocionLegalizacion = _.reduce($scope.activity.Legalizacion, function (valor, objetivo) {
                    if (objetivo.EsPromocion)
                        valor = valor + (isNaN(objetivo.Ejecutado) ? 0 : objetivo.Ejecutado);

                    return valor;
                }, 0);

                var ejecutadoPromocionIncorrecto = $scope.activity.Promocion.Importe < (ejecutadoPromocion + ejecutadoPromocionLegalizacion);
                var archivoInvalido = $scope.activity.Concurso.TipoFuerzaId === 1 &&
                    $scope.objetivosConcurso.length > 0 &&
                    !$scope.activity.Concurso.NombreArchivo;

                if (archivoInvalido || ejecutadoPromocionIncorrecto) {
                    var mensaje = ejecutadoPromocionIncorrecto ? "msgEjecutadoPromocion" : "msgAnexoResultados";
                    Ex.mensajes(Ex.GetResourceValue(mensaje));
                }
                else {
                    $scope.activity.ObjetivosConcurso = $scope.objetivosConcurso;
                    $Ex.Execute("Evaluar", $scope.activity, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.getActivities();
                            $scope.pantallaId = $scope.pantallas.principal;

                            mostrarMensajeError(response.d);
                        }
                    }, $scope.formaEvaluacion);
                }
            };

            $scope.cerrar = function () {

                try {

                    var activity = $scope.activity;

                    $Ex.Execute("ValidarMovimientoCierre", activity, function (response) {
                        if (response.d) {
                            var existeMovimientoCierre = response.d.TipoMovimientoCierre;

                            if (existeMovimientoCierre) {
                                Ex.mensajes(Ex.GetResourceValue("msgCerrar"), 2, null, null, null, function () {
                                    $Ex.Execute("Cerrar", $scope.activity, function (response, isInvalid) {
                                        $scope.getActivities();
                                        $scope.pantallaId = $scope.pantallas.principal;
                                    });
                                }, function () { }, null);
                            }

                            else {
                                Ex.mensajes(Ex.GetResourceValue("msgErrorCerrarActivity").replace("{Codigo}", activity.Codigo));
                            }
                        }
                    });


                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }




            };

            $scope.campoHabilitado = function () {
                return $scope.activity.PuedeModificar || $scope.activity.PuedeReenviar;
            };

            $scope.campoHabilitadoPOP = function () {
                return ($scope.activity.EsConfirmado) && ($scope.activity.PuedeModificar || $scope.activity.PuedeReenviar);
            };



            $scope.calcularMontos = function (nombreRubro) {
                if (nombreRubro !== "Concurso" || $scope.activity.Concurso.TipoFuerzaId === 2)
                    getTotalRubro(nombreRubro);

                if (nombreRubro === "Concurso") {
                    var cuentasRubro = "Concurso";
                    $scope.cuentasConcurso = _.where(CuentasInfo, { RubroId: enums.rubros[cuentasRubro] });

                    $scope.activity.NotaCredito.EsSellIn = $scope.activity.Concurso.TipoVentaExternaId === 1 && $scope.activity.NotaCredito.Detalle.length > 0;
                    $scope.activity.NotaCredito.EsSellOut = $scope.activity.Concurso.TipoVentaExternaId === 1 && $scope.activity.NotaCredito.Detalle.length > 0;
                }
                

                getTotalActivity();
            };

            $scope.rubroVisible = function (rubroId) {
                var activityId = $scope.activity.TipoActivityId;
                return activityId === enums.tiposActivity.General && _.contains(rubrosCanal, rubroId);
            };

            $scope.osVisible = function () {
                var activityId = $scope.activity.TipoActivityId;
                return activityId === enums.tiposActivity.Idm;//Jvillarreal
                //return activityId === enums.tiposActivity.Medios || activityId === enums.tiposActivity.Idm;
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

            $scope.descargarTipoMovimiento = function (promocion, index) {
                try {
                    $Ex.Execute("DescargarTipoMovimiento", promocion, function (response) {
                        if (response.d) {
                            window.location = "DownLoadPage.aspx?d=" + getRandom();

                        }
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                }
            };

            $scope.validarObjetivoConcurso = function (objetivo, nombreCampo) {
                var objetivoSeleccionado = _.findWhere($scope.activity.Concurso.Objetivos, { ObjetivoId: objetivo.ObjetivoId });

                var valorAnterior = nombreCampo === "Total"
                    ? objetivoSeleccionado["Incentivo"]
                    : objetivoSeleccionado[nombreCampo];

                var valorActual = objetivo[nombreCampo];

                if (valorActual > valorAnterior)
                    objetivo[nombreCampo] = valorAnterior;

                var numPremios = isNaN(objetivo.NumeroPremios) ? 0 : objetivo.NumeroPremios;
                objetivo.Total = objetivo.NumeroPremios * objetivo.Incentivo;
            };

            $scope.objetivosEvaluacion = function () {
                var tieneObjetivos = $scope.activity.Objetivos != null && $scope.activity.Objetivos.length > 0;
                var tieneObjetivosConcurso = $scope.objetivosConcurso != null && $scope.objetivosConcurso.length > 0;
                return tieneObjetivos || tieneObjetivosConcurso;
            };
            //***************************** SECCIÓN PROMOCION CONFIGURADA ********************************
            var getTotalPromocion = function (promocion) {
                var importe = _.reduce(promocion.ListaPrecios, function (valor, lista) {
                    valor = valor + (isNaN(lista.Descuento) ? 0 : lista.Descuento);
                    return valor;
                }, 0);

                promocion.ImporteLista = +(importe / promocion.ListaPrecios.length).toFixed(2);

                //Re-Calcular total
                promocion.CantidadPromocion = promocion.CantidadPromocion == undefined ? 1 : promocion.CantidadPromocion;
                promocion.Importe = promocion.ImporteLista * promocion.CantidadPromocion;

                getTotalRubro("Promocion");
                //getTotalActivity();
            };

            $scope.LoadComplete = false;

            $scope.ErrorRefresh = "";

            $scope.cargarPromocion = function (response, promocion, index) {
                promocion.LoadComplete = false;
                $scope.LoadComplete = false;

                //Verificar si la promoción ya existe en BD, si existe entonces validar que el excel corresponda al mismo código de promoción
                if (promocion.PromocionId && response.CodigoPromocion != promocion.CodigoPromocion) {
                    Ex.mensajes("En esta promoción solo se permita la carga del CodigoPromocion " + promocion.CodigoPromocion);
                } else {
                    var objPromocion = response.TipoMovimientoId == 1 || response.TipoMovimientoId == 6 ? _.findWhere(arrayPromocionOriginal, { CodigoPromocion: response.CodigoPromocion, TipoMovimientoId: response.TipoMovimientoId }) : undefined;

                    if (objPromocion != undefined && index != objPromocion.Index) {
                        Ex.mensajes("Ya existe una promoción con el mismo TipoMovimiento Creacion/Reactivación y CodigoPromocion");
                    } else {
                        if (response.Error !== "")
                            Ex.mensajes(response.Error);
                        else {
                            for (const property in response) {
                                if (response.hasOwnProperty(property)) {
                                    promocion[property] = response[property];
                                }
                            }

                            if (response.TipoMovimientoId != 2) {
                                //getTotalPromocion(promocion);
                                $scope.calcularImportePromocion(promocion);
                                getTotalActivity();
                            }
                            //get canalIDs
                            var arrayCanalIDs = response["CanalIDs"].split(",");

                            $scope.activity.Canales = [];
                            for (var i = 0; i < arrayCanalIDs.length; i++) {
                                $scope.activity.Canales.push({ "CanalId": arrayCanalIDs[i] });
                            }

                            $scope.LoadComplete = true;
                            promocion.LoadComplete = true;
                            $scope.ErrorRefresh = response["ErrorRefresh"];

                            $scope.CodigosPromocionCargados.push({ CodigoPromocion: promocion.CodigoPromocion });

                            arrayPromocionOriginal[index].CodigoPromocion = promocion.CodigoPromocion;

                        }
                    }
                }
            };

            $scope.cargarEstructuraComercial = function (response, promocion, index) {
                promocion.LoadComercialStructureComplete = false;

                if (response.Error !== "")
                    Ex.mensajes(response.Error);
                else {

                    promocion["Productos"] = response["Productos"];
                    promocion["UnidadMedidaProductos"] = response["UnidadMedidaProductos"];

                    promocion.LoadComercialStructureComplete = true;

                }
            };

            $scope.getTipoSolicitud = function (tipoSolicitudId) {
                var tipoSolicitudSeleccionado = _.findWhere($scope.tiposSolicitud, { TipoSolicitudId: tipoSolicitudId });

                return tipoSolicitudSeleccionado["Nombre"];
            };

            $scope.getTipoMovimiento = function (tipoMovimientoId) {
                var tipoMovimientoSeleccionado = _.findWhere($scope.tiposMovimiento, { TipoMovimientoId: tipoMovimientoId });

                return tipoMovimientoSeleccionado["Nombre"];
            };

            $scope.clickEstructuraComercialUpload = function (promocion, index) {

                $scope.fileParametersEstructuraComercial.CodigoPromocion = promocion.CodigoPromocion;

            };

            $scope.clickFileUpload = function (promocion, index) {

                var tipoMovimientoSeleccionado = _.findWhere($scope.tiposMovimiento, { TipoMovimientoId: promocion.TipoMovimientoId });
                $scope.fileParametersPromocion.TipoMovimientoId = promocion.TipoMovimientoId;
                $scope.fileParametersPromocion.TipoMovimiento = tipoMovimientoSeleccionado["Nombre"];
                $scope.fileParametersPromocion.PromocionId = promocion.PromocionId == undefined ? 0 : promocion.PromocionId;
                var tipoSolicitudSeleccionado = _.findWhere($scope.tiposSolicitud, { TipoSolicitudId: promocion.TipoSolicitudId });
                $scope.fileParametersPromocion.TipoSolicitudId = promocion.TipoSolicitudId;
                $scope.fileParametersPromocion.TipoSolicitud = tipoSolicitudSeleccionado["Nombre"];

                $scope.fileParametersPromocion.LoadComercialStructureComplete = promocion.LoadComercialStructureComplete;
                $scope.fileParametersPromocion.ExisteCodigoPromocion = promocion.ExisteCodigoPromocion;
                $scope.fileParametersPromocion.CodigoPromocion = promocion.CodigoPromocion;
                $scope.fileParametersPromocion.UnidadMedidaProductos = promocion["UnidadMedidaProductos"];

                $scope.fileParametersPromocion.IsRefresh = promocion.IsRefresh == undefined ? false : promocion.IsRefresh;
            };

            $scope.changeCodigoPromocion = function (promocion, index) {
                promocion.LoadComercialStructureComplete = false;
                promocion.ExisteCodigoPromocion = 0;
            }

            var arrayPromocionOriginal = [];

            $scope.changeTipoMovimiento = function (promocion, index) {

                var tipoMovimientoSeleccionado = _.findWhere($scope.tiposMovimiento, { TipoMovimientoId: promocion.TipoMovimientoId });
                $scope.fileParametersPromocion.TipoMovimientoId = promocion.TipoMovimientoId;
                $scope.fileParametersPromocion.TipoMovimiento = tipoMovimientoSeleccionado["Nombre"];
                $scope.fileParametersPromocion.ExisteCodigoPromocion = $scope.ExisteCodigoPromocion;
                $scope.fileParametersPromocion.ActivityId = $scope.activity.ActivityId != undefined ? $scope.activity.ActivityId : 0;
                $scope.fileParametersPromocion.PromocionId = promocion.PromocionId != undefined ? promocion.PromocionId : 0;

                if (promocion.TipoMovimientoId != promocion.TipoMovimientoIdOriginal && _.isEmpty(arrayPromocionOriginal[index].PromocionOriginal)) {
                    arrayPromocionOriginal[index].PromocionId = promocion.PromocionId != undefined ? promocion.PromocionId : 0;
                    arrayPromocionOriginal[index].CodigoPromocion = promocion.CodigoPromocion != undefined ? promocion.CodigoPromocion : "";
                    arrayPromocionOriginal[index].PromocionOriginal = angular.copy(promocion);
                    arrayPromocionOriginal[index].TipoMovimientoId = promocion.TipoMovimientoId;
                    arrayPromocionOriginal[index].TipoMovimiento = tipoMovimientoSeleccionado["Nombre"];

                }

                $scope.ExisteCodigoPromocion = 0;
                $scope.LoadComplete = false;
                if (promocion.TipoMovimientoId != promocion.TipoMovimientoIdOriginal) {

                    promocion.Almacenes = [];
                    promocion.AlmacenPrincipal = "";
                    promocion.Canales = [];
                    promocion.CanalValido = false;
                    promocion.ClaseImpuesto = "";
                    promocion.CodigoBarras = "";

                    //promocion.CodigoPromocion = "";
                    promocion.Empresa = "";
                    promocion.Error = "";
                    promocion.EstatusAdicional = "";
                    promocion.FechaSolicitud = "";
                    promocion.Folio = "";
                    promocion.Grupo = "";
                    promocion.ImporteLista = 0;
                    promocion.Impuesto = "";
                    promocion.Linea = "";
                    promocion.ListaPrecios = [];
                    promocion.Marca = "";
                    promocion.Nombre = "";
                    promocion.Planeador = "";
                    promocion.Productos = [];
                    promocion.Tipo = "";
                    promocion.TipoAlmacen = "";

                    promocion.UnidadMedidaProductos = "";
                    promocion.UnidadMedida = "";
                    promocion.EsExtemporanea = false;

                    promocion.TipoMovimiento = "";

                } else {

                    var promocionOriginal = arrayPromocionOriginal[index].PromocionOriginal;

                    promocion.Almacenes = promocionOriginal.Almacenes;
                    promocion.AlmacenPrincipal = promocionOriginal.AlmacenPrincipal;
                    promocion.Canales = promocionOriginal.Canales;
                    promocion.CanalValido = promocionOriginal.CanalValido;
                    promocion.ClaseImpuesto = promocionOriginal.ClaseImpuesto;
                    promocion.CodigoBarras = promocionOriginal.CodigoBarras;

                    //promocion.CodigoPromocion = promocionOriginal.CodigoPromocion;
                    promocion.Empresa = promocionOriginal.Empresa;
                    promocion.Error = promocionOriginal.Error;
                    promocion.EstatusAdicional = promocionOriginal.EstatusAdicional;
                    promocion.FechaSolicitud = promocionOriginal.FechaSolicitud;
                    promocion.Folio = promocionOriginal.Folio;
                    promocion.Grupo = promocionOriginal.Grupo;
                    promocion.ImporteLista = promocionOriginal.ImporteLista;
                    promocion.Impuesto = promocionOriginal.Impuesto;
                    promocion.Linea = promocionOriginal.Linea;
                    promocion.ListaPrecios = promocionOriginal.ListaPrecios;
                    promocion.Marca = promocionOriginal.Marca;
                    promocion.Nombre = promocionOriginal.Nombre;
                    promocion.Planeador = promocionOriginal.Planeador;
                    promocion.Productos = promocionOriginal.Productos;
                    promocion.Tipo = promocionOriginal.Tipo;
                    promocion.TipoAlmacen = promocionOriginal.TipoAlmacen;

                    promocion.UnidadMedidaProductos = promocionOriginal.UnidadMedidaProductos;
                    promocion.UnidadMedida = promocionOriginal.UnidadMedida;
                    promocion.EsExtemporanea = promocionOriginal.EsExtemporanea;

                    promocion.TipoMovimiento = promocionOriginal.TipoMovimiento;
                }

            };

            $scope.changeTipoSolicitud = function (promocion, index) {
                var tipoSolicitudSeleccionado = _.findWhere($scope.tiposSolicitud, { TipoSolicitudId: promocion.TipoSolicitudId });
                $scope.fileParametersPromocion.TipoSolicitudId = promocion.TipoSolicitudId;
                $scope.fileParametersPromocion.TipoSolicitud = tipoSolicitudSeleccionado["Nombre"];

                arrayPromocionOriginal[index].TipoSolicitudId = promocion.TipoSolicitudId;
                arrayPromocionOriginal[index].TipoSolicitud = tipoSolicitudSeleccionado["Nombre"];
            };

            $scope.CodigosPromocionCargados = [];
            $scope.changePromocionHistorial = function (promocion, index) {
                var i = index;
                var promocionRow = promocion;
                $Ex.Execute("GetActivityPromocionHistorialId", promocion, function (response, isInvalid) {
                    if (response.d.Detalle.Promocion.length > 0) {
                        $scope.activity.Promocion.Detalle[i] = response.d.Detalle.Promocion[0];
                        $scope.activity.Promocion.Detalle[i].TipoMovimientoInfo = $scope.tiposMovimientoPromocionExistente;
                        $scope.activity.Promocion.Detalle[i].Historial = response.d.Detalle.Historial;

                        $scope.activity.Promocion.Detalle[i].Productos = response.d.Detalle.Productos;
                        $scope.activity.Promocion.Detalle[i].Canales = response.d.Detalle.Canales;
                        $scope.activity.Promocion.Detalle[i].ListaPrecios = response.d.Detalle.ListaPrecios;
                        $scope.activity.Promocion.Detalle[i].Almacenes = response.d.Detalle.Almacenes;

                        var tipoMovimientoSeleccionado = _.findWhere($scope.tiposMovimiento, { TipoMovimientoId: response.d.Detalle.Promocion[0].TipoMovimientoId });
                        $scope.fileParametersPromocion.TipoMovimientoId = response.d.Detalle.Promocion[0].TipoMovimientoId;
                        $scope.fileParametersPromocion.TipoMovimiento = tipoMovimientoSeleccionado["Nombre"];

                        var codigoPromocionCargado = _.findWhere($scope.CodigosPromocionCargados, { CodigoPromocion: response.d.Detalle.Promocion[0].CodigoPromocion });

                        if (codigoPromocionCargado != undefined) {
                            var index = _.indexOf($scope.CodigosPromocionCargados, codigoPromocionCargado);
                            $scope.CodigosPromocionCargados.splice(index, 1);
                        }

                        if ($scope.activity.Promocion.Detalle[i].ActivityPromocionHistorialId == $scope.activity.Promocion.Detalle[i].ActivityPromocionHistorialIdOriginal)
                            getTotalPromocion($scope.activity.Promocion.Detalle[i]);
                    }
                    $scope.LoadComplete = false;
                });
            };


            //ExisteCodigoPromocion = 0    
            //ExisteCodigoPromocion = 1    No existe codigo de Promocion
            //ExisteCodigoPromocion = 2    Existe codigo de Promocion
            //$scope.ExisteCodigoPromocion = 0;
            $scope.searchCodigoPromocion = function (promocion) {
                var objCodigoPromocion = {};
                objCodigoPromocion.IsCreation = 1;
                objCodigoPromocion.CodigoPromocion = promocion.CodigoPromocion;
                promocion.ExisteCodigoPromocion = 1;

                $Ex.Execute("SearchCodigoPromocion", objCodigoPromocion, function (response, isInvalid) {

                    if (response.d.length > 0) {
                        promocion.ExisteCodigoPromocion = 2;
                        Ex.mensajes("El CodigoPromocion existe, favor de cargar la promocion");
                    } else {
                        Ex.mensajes("El CodigoPromocion no existe, favor de cargar la estructura comercial");
                        //Ex.mensajes("Antes de la Reactivación, debe existir un movimiento de Creación, para el código de promoción " + promocion.CodigoPromocion + ".");

                    }

                    $scope.fileParametersPromocion.ExisteCodigoPromocion = promocion.ExisteCodigoPromocion;
                });
            };

            var promocionSeleccionada = {};
            $scope.verListaPrecio = function (promocion) {
                promocionSeleccionada = promocion;
                $scope.promocion = angular.copy(promocion);
                $scope.promocion.canalesExpandidos = false;
                $scope.pantallaId = $scope.pantallas.configuracionListaPrecio;
            };

            $scope.editarPromocion = function (promocion) {
                promocion.editable = true;
                $scope.activity.Promocion.editable = true;

                var objetivos = $scope.activity.Promocion.Objetivos;
                var objetivoPromocion = _.findWhere(objetivos, { NumeroObjetivo: promocion.NumeroObjetivo });
                $scope.EsAmpliacion(promocion);

                objetivoPromocion.editable = true;
            };

            $scope.getCanalAlmacen = function (detalle) {
                var tipoAlmacenSeleccionado = _.findWhere($scope.tiposAlmacen, { TipoAlmacenId: detalle.TipoAlmacenId });

                detalle.TipoAlmacen = tipoAlmacenSeleccionado.Nombre;
                detalle.Canales = detalle.TipoAlmacenId === $scope.tipoAlmacen.ambos ? $scope.canales : [];
                detalle.Almacenes = _.filter($scope.almacenes, function (item) {
                    if (detalle.TipoAlmacenId === enums.tiposAlmacen.ambos)
                        return item.TipoAlmacenId === enums.tiposAlmacen.preventa || item.TipoAlmacenId === enums.tiposAlmacen.otrosCanales;
                    else
                        return item.TipoAlmacenId === detalle.TipoAlmacenId;
                });
            };

            $scope.getListaPrecios = function (promocion, obtenerCanales) {
                if (obtenerCanales) {
                    var canales = _.filter(promocion.Canales, { Seleccionado: true });
                    promocion.ListaCanales = _.pluck(canales, "NombreCanal").join(",");
                }
            };

            $scope.calcularImportePromocion = function (promocion) {
                //var totalCajas = 0;

                //_.each(promocion.Productos, function (producto) {
                //    if (producto.EsVendido)
                //        totalCajas = totalCajas + producto.Cantidad;
                //});

                //promocion.Importe = promocion.ImporteLista * totalCajas;
                //var totalCajas = 0;

                //_.each(promocion.Productos, function (producto) {
                //    if (producto.EsVendido)
                //        totalCajas = totalCajas + producto.Cantidad;
                //});
                getTotalPromocion(promocion);
                promocion.CantidadPromocion = promocion.CantidadPromocion == undefined ? 1 : promocion.CantidadPromocion;
                promocion.Importe = promocion.ImporteLista * promocion.CantidadPromocion;

                getTotalRubro("Promocion");
                getTotalActivity();
            };

            $scope.EsAmpliacion = function (promocion) {
                promocion.EsAmpliacion = promocion.TipoMovimientoId === 3;
            };

            $scope.configurarAlmacen = function (detalle, forma) {
                detalle.submitted = true;
                if (forma.$valid) {
                    promocionSeleccionada = detalle;
                    $scope.promocion = angular.copy(detalle);
                    $scope.pantallaId = $scope.pantallas.configuracionAlmacen;
                } else
                    Ex.mensajes(Ex.GetGlobalResourceValue("msgRequiredFields"));
            };



            $scope.validarReqProveedor = function (item, nombreRubro) {
                if (nombreRubro == 'Pop') {
                    var bcheck = item.CheckBox;
                    angular.forEach($scope.activity[nombreRubro].Detalle, function (i, key) {
                        i.CheckBox = false;
                    });
                    item.CheckBox = bcheck;
                }
                //$scope.activity[nombreRubro].ReqProveedorId = item.CheckBox ? item.ProveedorId : 0;
                if (_.where($scope.activity[nombreRubro].Detalle, { c: true }).length === 0) {
                    $scope.activity[nombreRubro].ReqProveedorId = 0;
                } else {
                    $scope.activity[nombreRubro].ReqProveedorId = item.ProveedorId;
                }
            };


            $scope.guardarAlmacen = function () {
                promocionSeleccionada.Almacenes = $scope.promocion.Almacenes;
                $scope.pantallaId = $scope.pantallas.detalle;
            };

            $scope.getInformacion = function (promocion) {
                $scope.promocion = promocion;
                $scope.pantallaId = $scope.pantallas.informacionPromocion;
            };

            $scope.promocionEditable = function (promocion) {
                return $scope.activity.PuedeModificar || $scope.campoHabilitado() && promocion.editable;
            };

            $scope.volverPantalla = function () {
                $scope.ModificaPop = false;
                $scope.pantallaId = $scope.pantallas.principal
            }

            $scope.volverPantallaDetalle = function () {
                $scope.ModificaPop = false;
                $scope.pantallaId = $scope.pantallas.detalle;
                var element = angular.element("#codigoPromocion");
                element.focus();
            }
            //***************************** SECCIÓN NOTA CRÉDITO********************************
            $scope.calcularPrecioNotaCredito = function (notaCredito, nombreRubro) {
                if (notaCredito.Cantidad != null &&
                    notaCredito.Precio != null &&
                    notaCredito.TipoDescuentoId != null &&
                    notaCredito.Descuento != null) {
                    var descuentoPesos = parseInt(notaCredito.TipoDescuentoId) === $scope.tipoDescuento.importe
                        ? notaCredito.Descuento
                        : notaCredito.Precio * notaCredito.Descuento / 100;

                    notaCredito.Subtotal = notaCredito.Cantidad * notaCredito.Precio;
                    notaCredito.DescuentoPesos = +(descuentoPesos).toFixed(2);
                    notaCredito.TotalDescuento = +(notaCredito.Cantidad * descuentoPesos).toFixed(2);
                    notaCredito.TotalPrecio = +(notaCredito.Subtotal - notaCredito.TotalDescuento).toFixed(2);
                    notaCredito.Importe = notaCredito.TotalDescuento;

                    getTotalRubro(nombreRubro);
                    getTotalActivity();
                }
            };

            $scope.getPrecio = function (item, nombreRubro) {
                if (nombreRubro == 'NotaCredito') {
                    var dInfo = _.where($scope.productosInfo, { ProductoId: item.ProductoId });
                    item.Codigo = dInfo[0].Codigo;
                }
                if (item.ProductoId != null && item.UnidadMedidaId != null && item.SubcanalId != null) {
                    $Ex.Execute("GetPrecio", item, function (response, isInvalid) {
                        item.Precio = response.d.Precio;
                        $scope.calcularPrecioNotaCredito(item, nombreRubro);
                    });
                }
            };


            $scope.SameSellIn = function (item, ruta) {

                //if (ruta === "con" && $scope.activity.NotaCredito.lengh > 0) {
                if (ruta === "con") {
                    $scope.activity.NotaCredito.EsSellIn = item.EsSellIn;
                } else if (ruta === "nc") {
                    $scope.activity.Concurso.EsSellIn = item.EsSellIn;
                }
            }


            $scope.SameSellOut = function (item, ruta) {

                if (ruta === "con") {
                    $scope.activity.NotaCredito.EsSellOut = item.EsSellOut;
                } else if (ruta === "nc") {
                    $scope.activity.Concurso.EsSellOut = item.EsSellOut;
                }
            }
            //**************************** SECCIÓN REQUISICIONES **********************

            $scope.atrasRequisicion = function () {
                $scope.getActivity($scope.activity);
                $scope.pantallaId = $scope.pantallas.detalle;
            };

            $scope.guardarComentario = function (item) {
                $window.open("//www.aspsnippets.com/", "popup", "width=300,height=200,left=10,top=150");
            };

            $scope.usuarioActual = function () {
                $Ex.Execute("GetUsuario", $scope.filtro, function (response, isInvalid) {
                    $scope.usuarioAct = response.d;
                });
            };

            $scope.confirmarPOP = function () {
                var item = $scope.activity;
                $Ex.Execute("ConfirmarActivity", $scope.activity, function (response) {
                    Ex.mensajes('Activity confirmada correctamente');
                    $scope.atrasRequisicion();
                });
            };

            $scope.SinRequisiciones = function (nombreRubro) {
                if ($scope.activity[nombreRubro] == null || $scope.activity[nombreRubro].Detalle == null) return false;

                var detalleReq = _.where($scope.activity[nombreRubro].Detalle, { EnRequisicion: true });

                if (detalleReq.length === $scope.activity[nombreRubro].Detalle.length) {
                    return true;
                } else {
                    return false;
                }
            };

            $scope.agregarRequisicion = function (nombreRubro) {

                if (_.some($scope.activity[nombreRubro].Detalle, { CheckBox: true })) {
                    $scope.pantallaId = $scope.pantallas.requisicion;
                    $scope.SelectedItems = _.where($scope.activity[nombreRubro].Detalle, { CheckBox: true });

                    if (nombreRubro === "Os" && $scope.activity.TipoActivityId !== enums.tiposActivity.General) {
                        _.each($scope.SelectedItems, function (item) {
                            var articulo = _.findWhere($scope.activity[nombreRubro].Detalle, { OrdenServicioDetalleId: item.OrdenServicioDetalleId });
                            item.Articulo = articulo.Descripcion;
                        });
                    }

                    var prov = _.where($scope.proveedorAll, { ProveedorId: $scope.SelectedItems[0].ProveedorId });
                    $timeout(function () {
                        $scope.formaPrincipal.disableForm(false);
                    }, 100);
                    if (nombreRubro == 'Pop') {
                        angular.forEach($scope.SelectedItems, function (item, key) {
                            item.UnidadMedida = 'PZ';
                        });

                        var solicitanteReq = $scope.activity.SolicitanteActivity.substring(0, 25);
                        $scope.req = {
                            ActivityId: $scope.activity.ActivityId, FormatoLineaId: 1, SolicitadoPor: $scope.usuarioAct.UsuarioQadId, SolicitadoPorPOP: solicitanteReq,
                            ProveedorNombre: $scope.SelectedItems[0].Proveedor, ProveedorId: prov[0].ProveedorId, UsuarioFinal: "CIM",
                            Almacen: "", IdiomaRequisicion: "ls", Ubicacion: '', RubroId: $scope.SelectedItems[0].RubroId
                            , TipoActivityId: $scope.activity.TipoActivityId, CodigoProyecto: $scope.activity.Codigo, RequisicionId: "",
                            MonedaId: $scope.SelectedItems[0].MonedaId, CostoMoneda: $scope.SelectedItems[0].CostoMoneda,
                            esPOP: true, Cuenta: $scope.activity.Pop.CuentaContable
                        };
                    } else {

                        var monedaId = ($scope.SelectedItems != undefined ? $scope.SelectedItems[0].MonedaId : 0);

                        $scope.req = {
                            ActivityId: $scope.activity.ActivityId, FormatoLineaId: 1, SolicitadoPor: $scope.usuarioAct.UsuarioQadId, SolicitadoPorPOP: '',
                            ProveedorNombre: $scope.SelectedItems[0].Proveedor, ProveedorId: prov[0].ProveedorId, UsuarioFinal: "CIM",
                            Almacen: "MXQUAGRS", IdiomaRequisicion: "ls", Ubicacion: prov[0].Direccion + '\n' +
                                prov[0].Ciudad + '\n ' + prov[0].Condado + '\n CP.' + prov[0].CodigoPostal, RubroId: $scope.SelectedItems[0].RubroId
                            , TipoActivityId: $scope.activity.TipoActivityId, CodigoProyecto: $scope.activity.Codigo, RequisicionId: "",
                            ArticuloId: $scope.SelectedItems[0].ArticuloId, Articulo: $scope.SelectedItems[0].Articulo,
                            CodigoArticulo: $scope.SelectedItems[0].Articulo, MonedaId: monedaId,
                            esPOP: false,
                        };
                    }
                    $scope.req.reqGenerar = true;

                    //$scope.req.OcultarUnidad = $scope.activity.TipoActivityId === 3 || $scope.activity.TipoActivityId === 4 ? true : false;

                } else {
                    Ex.mensajes("Favor de seleccionar al menos un artículo.");
                }
            };

            $scope.verRequisicionesActivity = function () {
                $scope.verRequisiciones = !$scope.verRequisiciones;
            };


            $scope.verRequisicion = function (item) {
                $scope.ModificaPop = false;
                $Ex.Execute("GetActivityRequisicion", item, function (response) {
                    $scope.verRequisiciones = !$scope.verRequisiciones;
                    $scope.req = response.d.requisicion[0];
                    $scope.SelectedItems = response.d.requisicionDetalle;
                    $scope.req.reqGenerar = false;
                    $scope.pantallaId = $scope.pantallas.requisicion;
                });
            };




            $scope.guardarRequisicion = function (forma) {
                $scope.requisicionSubmitted = true;
                if (forma.$valid) {
                    $scope.req.articulos = $scope.SelectedItems;
                    $Ex.Execute("GuardarRequisicion", $scope.req, function (response, isInvalid) {
                        if (response.d.hasOwnProperty("Error")) {
                            Ex.mensajes(Ex.GetResourceValue("msgErrorRequisicion"));
                        } else {
                            $scope.req.RequisicionId = response.d.RequisicionId;
                            $scope.req.reqGenerar = false;
                            $scope.requisicionSubmitted = false;
                        }
                    });

                } else
                    Ex.mensajes(Ex.GetGlobalResourceValue("msgRequiredFields"));
            };

            $scope.guardarComentario = function (item) {
                $scope.ArticuloSolo = item;
                var backOfferButton = document.getElementById(item.Id);
                backOfferButton.dataset.target = "#myModal";
            };

            $scope.articuloUnidad = function (articuloSeleccionado, articulo) {
                articulo.Articulo = articuloSeleccionado.Nombre;
                articulo.UnidadMedida = articuloSeleccionado.UnidadMedida;
                articuloSeleccionado.Articulo = articuloSeleccionado.NumArticulo;
            };
            //***************************** SECCIÓN POP********************************
            $scope.limpiarPop = function (item) {
                $scope.activity.EsConfirmado = 0;
                $scope.activity.PuedeModificar = true;
                item.ArticuloId = null;
                item.Articulo = "";
                item.ProveedorId = null;
                item.Proveedor = "";
                item.Precio = null;
                item.FechaEstimada = null;
                item.CodigoArticulo = "";
                item.NombreArchivo = "";

                $scope.calcularMontos("Pop");
            };

            $scope.getProveedores = function (opcionSeleccionada, item) {
                $Ex.Execute("GetProveedores", opcionSeleccionada, function (response, isInvalid) {
                    item.ProveedorId = null;
                    item.proveedores = response.d;
                });
            };

            $scope.getArticuloPrecio = function (item) {
                if (item.EsProductoMatriz && item.ArticuloId != null && item.ProveedorId != null && item.Cantidad != null) {
                    $Ex.Execute("GetArticuloPrecio", item, function (response, isInvalid) {
                        item.Precio = response.d.Precio;
                        item.DiasProduccion = response.d.DiasProduccion;
                        item.CodigoArticulo = response.d.Codigo;

                        if (item.Fecha != null)
                            $scope.setFechaEstimadaPop(item.Fecha, item);

                        $scope.calcularTotalPop(item);
                    });
                } else if (!item.EsProductoMatriz)
                    $scope.calcularTotalPop(item);
            };

            $scope.setMaterialCodigo = function (articuloSeleccionado, item) {
                item.CheckBox = false;
                item.ItemModificado = true;

                var _articuloSeleccionado = _.findWhere($scope.matrizOptions, { MaterialId: articuloSeleccionado.MaterialId });
                //Inicia variable como confirmado, si modifica la información no puede confirmar
                $scope.ModificaPop = true;

                item.Material = _articuloSeleccionado.Material;
                item.CodigoMaterial = _articuloSeleccionado.CodigoMaterial;
                item.CodigoArticulo = _articuloSeleccionado.CodigoMaterial;
                $scope.FilterProveedor = { MaterialId: _articuloSeleccionado.MaterialId };

                item.Proveedores = $scope.matrizProveedorOptions.map(function (num) {
                    if (num.MaterialId == _articuloSeleccionado.MaterialId) {
                        return num;
                    }
                }).filter(notUndefined => notUndefined !== undefined);

                $scope.calcularCantidadTotalPop(item, true);
            };

            $scope.setPropiedadProveedor = function (proveedorSeleccionado, item) {
                item.CheckBox = false;
                item.ItemModificado = true;
                //Inicia variable como confirmado, si modifica la información no puede confirmar
                $scope.ModificaPop = true;
                item.Proveedor = proveedorSeleccionado.Proveedor;
                $scope.FilterArticulo = { ProveedorId: proveedorSeleccionado.ProveedorId };

                $scope.calcularCantidadTotalPop(item, true);
            };

            $scope.calcularCantidadTotalPop = function (item, valida) {
                $Ex.Execute("GetPrecioMatrizPOP", item, function (response, isInvalid) {
                    var data = response.d[0];
                    if (data != undefined) {
                        item.Precio = data.Precio;
                    }
                    item.CheckBox = false;
                    if (item.MonedaId == 1) {
                        item.CostoMoneda = 1;
                    }
                    if (item.MonedaId == null) {
                        item.CostoMoneda = 0;
                    }
                    if (item.Precio != null && item.Cantidad != null && item.CostoMoneda != null) {
                        var importe = (item.Precio * item.Cantidad * item.CostoMoneda);
                        item.Importe = +importe.toFixed(2);
                        item.ItemModificado = true;
                        $scope.calcularMontos("Pop");

                    }
                    if (valida) {
                        //Si cambia el importe, solicita modificar el archivo
                        if (item.Importe != item.ImporteAnterior && item.ImporteAnterior != undefined) {
                            //Inicia variable como confirmado, si modifica la información no puede confirmar
                            $scope.ModificaPop = true;
                            item.NombreArchivo = '';
                            Ex.mensajes('Favor de actualizar el Acta de Negociación');
                        }
                    }
                });
            };

            $scope.calcularTotalPop = function (item, valida) {
                item.CheckBox = false;
                if (item.MonedaId == 1) {
                    item.CostoMoneda = 1;
                }
                if (item.MonedaId == null) {
                    item.CostoMoneda = 0;
                }
                if (item.Precio != null && item.Cantidad != null && item.CostoMoneda != null) {
                    var importe = (item.Precio * item.Cantidad * item.CostoMoneda);
                    item.Importe = +importe.toFixed(2);
                    item.ItemModificado = true;
                    $scope.calcularMontos("Pop");

                }
                if (valida) {
                    //Si cambia el importe, solicita modificar el archivo
                    if (item.Importe != item.ImporteAnterior && item.ImporteAnterior != undefined) {
                        //Inicia variable como confirmado, si modifica la información no puede confirmar
                        $scope.ModificaPop = true;
                        item.NombreArchivo = '';
                        Ex.mensajes('Favor de actualizar el Acta de Negociación');
                    }
                }
            };

            $scope.setFechaEstimadaPop = function (date, item) {
                var fecha = new Date(date.getFullYear(), date.getMonth(), date.getDate() + item.DiasProduccion);

                $timeout(function () {
                    item.Fecha = date;

                    item.FechaEstimada =
                        [pad(fecha.getDate()), pad(fecha.getMonth() + 1), fecha.getFullYear()].join('/');
                }, 0);
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

            $scope.guardarEvaluacionVentaExterna = function () {

                $scope.activity.ObjetivosConcurso = $scope.activity.Concurso.ObjetivosFVE;
                $Ex.Execute("GuardarEvaluacionVentaExterna", $scope.activity, function (response, isInvalid) {
                    if (!isInvalid) {
                        $scope.activity.PuedeEvaluarVentaExterna = false;
                        $scope.getActivities();
                        $scope.pantallaId = $scope.pantallas.principal;
                    }
                });
            };

            //Jvillarreal
            $scope.geEmpresa = function () {
                if ($scope.activity.EmpresaId == 1) {
                    $scope.activity.Entidad = '1501';
                }
                if ($scope.activity.EmpresaId == 2) {
                    $scope.activity.Entidad = '1502';
                }
            };

            $scope.setActivityPropiedadProveedor = function (proveedorSeleccionado) {
                $scope.activity.Proveedor = proveedorSeleccionado;
                $scope.activity.Correo = proveedorSeleccionado.Correo;
                $scope.activity.Telefono = proveedorSeleccionado.Telefono;
                $scope.calcularDetalleItem();
            };

            $scope.setActivityPropiedadTipoProveedor = function () {
                $scope.activity.IvaFactor = ($scope.activity.TipoProveedorId == 1 ? 0.16 : 0)
                $scope.activity.IvaFactorEtiqueta = ($scope.activity.TipoProveedorId == 1 ? '16' : '0') + "%"
                $scope.calcularDetalleItem();
            };

            $scope.setActivityPropiedadMoneda = function () {
                var m = _.where(MonedaInfo, { MonedaId: $scope.activity.MonedaId });
                $scope.activity.Moneda = "";
                $scope.activity.MonedaDescripcion = "";
                if (m[0] != undefined) {
                    $scope.activity.Moneda = m[0].Nombre;
                    $scope.activity.MonedaDescripcion = m[0].Descripcion;
                }
                $scope.calcularDetalleItem();
            };

            $scope.calcularPrecioDetalleItem = function (item) {
                if (item.Cantidad != null && item.Precio != null) {
                    item.Importe = + (item.Cantidad * item.Precio).toFixed(4);
                    //scope.calcularMontos();
                    item.ItemModificado = true;
                }
                $scope.calcularDetalleItem();
            };

            $scope.calcularDetalleItem = function () {
                var subtotal = 0, retencion = 0, iva = 0, total = 0;
                angular.forEach($scope.activity.DetalleItem, function (item, key) {
                    if (item.Importe != null) {
                        subtotal += parseFloat(item.Importe);
                    }
                });
                if (subtotal > 0) {
                    subtotal = parseFloat(subtotal);
                    iva = (subtotal * $scope.activity.IvaFactor);
                    retencion = 0;
                    //SET
                    $scope.activity.Subtotal = subtotal.toFixed(2);
                    $scope.activity.Iva = iva.toFixed(2);
                    $scope.activity.Retencion = retencion.toFixed(2);
                    total = (parseFloat($scope.activity.Subtotal) + parseFloat($scope.activity.Iva) - parseFloat($scope.activity.Retencion)) // (subtotal + iva - retencion);
                    $scope.activity.Total = total.toFixed(2);;
                    $scope.activity.Importe = total.toFixed(2);;
                }
                $Ex.Execute("GetDescripcionMoneda", $scope.activity, function (response, isInvalid) {
                    var data = response.d;
                    $scope.activity.CantidadLetra = data.ImporteEnLetra;
                });
            };


            $scope.quitarDetalleItem = function (item, index) {
                $scope.activity.DetalleItem.splice(index, 1);
                $scope.calcularDetalleItem();
            };


            $scope.agregarRubro = function () {
                if ($scope.activity.ProveedorId == undefined || $scope.activity.ProveedorId == null) {
                    Ex.mensajes("Favor de capturar un proveedor válido.");
                    return;
                }
                if ($scope.activity.TipoProveedorId == undefined || $scope.activity.TipoProveedorId == null) {
                    Ex.mensajes("Favor de seleccionar un tipo de proveedor válido.");
                    return;
                }
                var detalle = {
                    ItemId: 0
                    , Descripcion: ''
                    , Cantidad: 0
                    , Precio: 0
                    , Importe: 0,
                    Eliminar: false
                };
                $scope.activity.DetalleItem.push(detalle);
            }

            //Archivos
            $scope.agregarDetalleArchivo = function () {
                if ($scope.activity.DetalleArchivo.length == 5) {
                    Ex.mensajes("Solo se permite adjuntar un máximo de 5 archivos, favor de verficar.");
                    return;
                }
                var detalle = {
                    ArchivoId: 0
                    , NombreDocumento: ''
                    , NombreArchivo: ''
                    , RutaArchivo: ''
                    , EsArchivoNuevo: true
                    , Eliminar: false
                };
                $scope.activity.DetalleArchivo.push(detalle);
            }

            $scope.quitarDetalleArchivo = function (item, index) {
                $scope.activity.DetalleArchivo.splice(index, 1);
            };

            $scope.solicitar = function () {
                $scope.submitted = true;
                if ($scope.activity.Marcas.length === 0 && !$scope.esMedioOtros) {
                    Ex.mensajes("Favor de capturar Marca.");
                    return;
                }
                if ($scope.forma.$invalid || $scope.activity.Importe === 0) {
                    var mensaje = $scope.forma.$invalid
                        ? Ex.GetGlobalResourceValue("msgRequiredFields")
                        : Ex.GetResourceValue("msgImporteInvalido");

                    Ex.mensajes(mensaje);
                } else {
                    $scope.activity.CanalId = 0;
                    $scope.activity.FechaInicio = $scope.activity.FechaDetalle;
                    $scope.activity.FechaFin = $scope.activity.FechaDetalle;
                    $scope.activity.CierrePresupuesto = $scope.activity.FechaDetalle;
                    $Ex.Execute("Solicitar", $scope.activity, function (response, isInvalid) {
                        if (!isInvalid) {
                            $scope.getActivities();
                            $scope.pantallaId = $scope.pantallas.principal;
                            mostrarMensajeError(response.d);
                        }
                    });
                }
            };

            $scope.usuarioActual();
            if ($scope.aid > 0) {
                var item = {};
                item.ActivityId = $scope.aid
                $scope.getActivity(item);
            } else {
                $scope.getActivities();
            }

            ////todo comentar
            //(function ambientePruebas() {
            //    $timeout(function () {
            //        $scope.agregar();
            //        $scope.activity.Nombre = "Activity Prueba";
            //        $scope.activity.Marcas = [{ id: "1025" }];
            //        $scope.activity.CanalId = 1;
            //        $scope.activity.AreaId = 1;
            //        $scope.activity.TipoActividadId = 1;
            //        $scope.activity.Estrategia = "Estrategia";
            //        $scope.activity.CuentaPucIdPromocion = 120;
            //        $scope.activity.Fecha = { StartDate: '02/11/2020', EndDate: "15/11/2020" };
            //        setSubcuenta($scope.activity.Marcas[0]);
            //        $scope.getRubrosCanal();

            //        $timeout(function () {
            //            $scope.activity.Promocion = { Importe: 0, Detalle: [], Expandido: true };
            //        }, 2000);
            //    }, 0);
            //}());
        }]);
})();