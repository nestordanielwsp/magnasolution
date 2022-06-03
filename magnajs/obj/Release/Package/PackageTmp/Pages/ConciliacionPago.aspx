<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="ConciliacionPago.aspx.cs" Inherits="CYP.Pages.ConciliacionPago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="conciliacionPago">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-show="esPaginaPrincipal">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-5">
                                <input type="text" class="form-control-input" ng-model="filtro.Cliente" key-enter="getConciliaciones()"
                                    placeholder="Busqueda rápida por (<%= this.GetMessage("lblCliente") %>)" style="min-height: 0">
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <%-- <div class="col-md-5 col-sm-6">
                                <div class="checkbox-inline">
                                    <label>
                                        <input type="checkbox" ng-model="filtro.ConciliacionesAbiertas" style="min-height: 0"
                                            ng-change="getNotasCredito()" />
                                        <%= this.GetMessage("lblConciliacionesAbiertas") %>
                                    </label>
                                </div>
                            </div>--%>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="generarInsumo()" ng-if="MostrarbtnInsumo()">
                            <i class="glyphicon glyphicon-saved d-block"></i>
                            <%= this.GetMessage("btnGenerar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <i class="glyphicon glyphicon-filter d-block"></i>
                            <%= this.GetMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="getConciliaciones()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetMessage("btnActualizar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="agregar()">
                            <i class="glyphicon glyphicon-plus d-block"></i>
                            <%= this.GetMessage("btnAgregar") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <i class="glyphicon glyphicon-download-alt d-block"></i>
                            <%= this.GetMessage("btnExcel") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="descargar()" ng-show="filtro.Documento || (filtro.FacturaInicio && filtro.FacturaFin)">
                            <i class="glyphicon glyphicon-download d-block"></i>
                            <%= this.GetMessage("btnDescargar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label><%= this.GetMessage("gvReporte-GeneradoPor") %></label>
                            <input type="text" ng-model="filtro.GeneradoPor" class="form-control" key-enter="getConciliaciones()" />
                        </div>
                    </div>

                    <div class="col-sm-3">
                        <div class="form-group">
                            <label><%= this.GetMessage("gvReporte-Estatus") %></label>
                            <select ng-model="filtro.EstatusId" class="form-control-select"
                                ng-options="item.EstatusId as item.NombreEstatus for item in estatus"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblFecha") %> </label>
                            <datepicker-range ng-model="filtro.Fecha" required="required" input-class="form-control-input" />
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblDocumento") %></label>
                            <input type="text" ng-model="filtro.Documento" class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label><%= this.GetMessage("gvReporte-DeFactura") %></label>
                            <input type="text" ng-model="filtro.FacturaInicio" class="form-control" />
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label><%= this.GetMessage("gvReporte-AFactura") %></label>
                            <input type="text" ng-model="filtro.FacturaFin" class="form-control" />
                        </div>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="clientes" st-fixed>
                    <table class="jsgrid-table" st-table="pagos" st-safe-src="_pagos"
                        style="width: 4000px; min-width: 1100px">
                        <thead>
                            <tr>
                                <th ui-field width="2"></th>
                                <th ui-field width="10" class="text-center">
                                    <%= this.GetMessage("gvReporte-GenerarInsumo") %>
                                </th>
                                <th ui-field width="25">
                                    <%= this.GetMessage("gvReporte-Cliente") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("gvReporte-CobrarA") %>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvReporte-GeneradoPor") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Fecha") %>
                                </th>
                                <th ui-field class="text-center" width="15">
                                    <%= this.GetMessage("gvReporte-MontoFacturado") %>
                                </th>
                                <th ui-field class="text-center" width="10">
                                    <%= this.GetMessage("gvReporte-MontoPagado") %>
                                </th>
                                <th ui-field class="text-center" width="10">
                                    <%= this.GetMessage("gvReporte-MontoNc") %>
                                </th>
                                <th ui-field class="text-center" width="15">
                                    <%= this.GetMessage("gvReporte-MontoPorConciliar") %>
                                </th>
                                <th ui-field width="20" class="text-center">
                                    <%= this.GetMessage("gvReporte-NombreEstatus") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in pagos">
                                <td st-ratio="2" class="text-center">
                                    <button type="button" class="btn btn-link" ng-click="eliminar(item)" ng-if="!item.Cerrado"
                                        style="padding: 0">
                                        <i class="glyphicon glyphicon-remove d-block textorojo"></i>
                                    </button>
                                </td>
                                <td st-ratio="10" class="text-center">
                                    <input type="checkbox" ng-model="item.Seleccionado" ng-if="!item.Cerrado" ng-change="MostrarbtnInsumo()" />
                                </td>
                                <td st-ratio="25">{{item.Cliente}}</td>
                                <td st-ratio="15">{{item.CobrarA}}</td>
                                <td st-ratio="20">{{item.GeneradoPor}}</td>
                                <td st-ratio="5">{{item.Fecha}}</td>
                                <td st-ratio="15" class="text-right">{{item.MontoFacturado | currency}}</td>
                                <td st-ratio="10" class="text-right">{{item.MontoPagado | currency}}</td>
                                <td st-ratio="10" class="text-right">{{item.NcPorAplicar | currency}}</td>
                                <td st-ratio="10" class="text-right">{{item.MontoPorConciliar | currency}}</td>
                                <td st-ratio="20" class="text-center">{{item.NombreEstatus}}</td>
                                <td st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="verConciliacion(item)"
                                        style="padding: 0">
                                        <%= this.GetMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="pagos.length === 0" class="nodata-row">
                                <td colspan="9" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="9">
                                    <div st-pagination="5" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="page-content" ng-hide="esPaginaPrincipal || esDetalleFactura || esDetalleNota"
            form-disabled form="form">
            <div class="row">
                <div class="col-sm-4">
                    <div class="subtitulo-color"><%= this.GetMessage("TituloDetalle") %></div>
                </div>
                <div class="col-sm-4">
                    <div class="textoverde" ng-show="pago.msgGuardado">
                        <%= this.GetMessage("msgGuardado") %>
                    </div>
                </div>
                <div class="btn-tpm col-sm-4">
                    <div>
                        <div ng-click="guardar(false)" tooltip-placement="bottom" style="display: none"
                            class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipGuardarCerrar") %>">
                            <i class="fa fa-check"></i>
                        </div>
                    </div>
                    <div>
                        <div ng-click="guardar(true)" tooltip-placement="bottom" ng-show="!pago.Cerrado"
                            class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div>
                        <div class="btn btn-top" ng-click="esPaginaPrincipal=true" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                    <div>
                        <div ng-click="agregar()" tooltip-placement="bottom" style="display: none;"
                            class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipNuevoCruce") %>">
                            <i class="fa fa-file"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div ng-form="forma" ng-class="{'submitted': submittedForm}">
                <div class="mail-box">
                    <div class="padding-form">
                        <div class="row mb">
                            <div class="col-sm-12">
                                <span class="subtitulo-color"><%= this.GetMessage("lblDatosGenerales") %> </span>
                            </div>
                        </div>

                        <div class="row mb">
                            <div class="col-sm-8" ng-if="!pago.NotaCreditoId">
                                <span class="label-color"><%= this.GetMessage("lblCliente") %> </span>
                                <ex-autocomplete ng-model="pago.ClienteId" options="clienteOptions"
                                    on-select="setValorCliente(optionSelected)" item="clienteSeleccionado" required />
                            </div>

                            <div class="col-sm-4">
                                <span class="label-color"><%= this.GetMessage("lblAnalista") %> </span>
                                <input type="text" class="form-control-input readonly" ng-model="pago.Analista"
                                    readonly="readonly" required />
                            </div>
                        </div>
                        
                                <div class="row mb">
                                    <div class="col-md-3 col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("lblMontoFacturado") %> </span>
                                        <input type="text" ng-model="pago.MontoFacturado" class="form-control-input"
                                            readonly="readonly" money />
                                    </div>                                    
                                </div>

                                <div class="row mb">
                                    <div class="col-md-3 col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("lblMontoPagado") %> </span>
                                        <input type="text" ng-model="pago.MontoPagado" class="form-control-input"
                                            readonly="readonly" money />
                                    </div>

                                    <div class="col-md-3 col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("lblPagosPorAplicar") %> </span>
                                        <input type="text" ng-model="pago.PagosPorAplicar" class="form-control-input"
                                            readonly="readonly" money />
                                    </div>

                                    <div class="col-md-3 col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("lblFaltantePago") %> </span>
                                        <input type="text" ng-model="pago.FaltantePago" class="form-control-input"
                                            readonly="readonly" money min="-1000000" />
                                    </div>
                                    <div class="col-md-1 col-sm-6"></div>

                                    <div class="col-md-2 col-sm-6">
                                         <span class="label-color"><%= this.GetMessage("lblFechaConciliacion") %> </span>
                                            <datepicker id="fechaConciliacion" ng-model="pago.FechaConciliacion" no-disabled
                                                datepicker-options="datepickerOptions"></datepicker>
                                    </div>
                                </div>

                                <div class="row mb">
                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblSaldoPorGenerarNc") %> </span>
                                <input type="text" ng-model="pago.SaldoPorGenerarNc" class="form-control-input"
                                    readonly="readonly" money min="-1000000" />
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblNcPorAplicar") %> </span>
                                <input type="text" ng-model="pago.NcPorAplicar" class="form-control-input"
                                    readonly="readonly" money />
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblFaltanteNc") %> </span>
                                <input type="text" ng-model="pago.FaltanteNc" class="form-control-input"
                                    readonly="readonly" money min="-1000000" />
                            </div>
                        </div>
                            
                    </div>
                </div>

                <div class="mail-box padding-form">
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblPagos") %> </span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table min-w900">
                                    <thead>
                                        <tr class="jsgrid-header-row">
                                            <th width="25">
                                                <%= this.GetMessage("lblFactura") %>
                                            </th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblFecha") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblMontoTotal") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblMontoAbierto") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblMontoPorAplicar") %></th>
                                            <th class="text-center hide-if-disabled" width="5">
                                                <i class="fa pointer fa-search" ng-click="abrirDetalleFactura(true)"></i>
                                            </th>

                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="va-m" ng-repeat="item in pago.Pagos">
                                            <td>{{item.DocumentoId}}</td>
                                            <td class="text-center">{{item.Fecha}}</td>
                                            <td class="text-right">{{item.Monto| currency}}
                                            </td>
                                            <td class="text-right">{{item.MontoAbierto | currency}}
                                            </td>
                                            <td class="text-right">
                                                <input type="text" ng-model="item.MontoPorAplicar" class="form-control-input"
                                                    ng-change="getMontoPorAplicar('Pagos')" money required />
                                            </td>
                                            <td class="text-center hide-if-disabled">
                                                <i class="fa fa-trash-o pointer text-red" ng-click="quitarDetalle($index,'Pagos')"></i>
                                            </td>

                                        </tr>
                                        <tr ng-show="pago.Pagos.length > 0">
                                            <td colspan="2"></td>
                                            <td class="text-right">{{pago.PagosMontoTotal | currency}}</td>
                                            <td class="text-right">{{pago.PagosMontoAbierto | currency}}</td>
                                            <td class="text-right">{{pago.PagosMontoPorAplicar | currency}}</td>
                                        </tr>
                                        <tr ng-if="pago.Pagos == 0" class="nodata-row">
                                            <td colspan="7" class="text-center">
                                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mail-box padding-form">
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblFacturas") %> </span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table min-w900">
                                    <thead>
                                        <tr class="jsgrid-header-row">
                                            <th width="5" class="text-center"><%= this.GetMessage("lblConsecutivo") %></th>
                                            <th width="25"><%= this.GetMessage("lblFactura") %></th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblFecha") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblMontoTotal") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblMontoAbierto") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblMontoPorAplicar") %></th>
                                            <th width="15" class="text-center"><%= this.GetMessage("lblComentarios") %></th>
                                            <th class="text-center hide-if-disabled" width="5">
                                                <i class="fa pointer fa-search main-color" ng-click="abrirDetalleFactura(false)"></i>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="va-m" ng-repeat="item in pago.Facturas">
                                            <td><input type="text" ng-model="item.CruceId" class="form-control-input"
                                                    required numbers-only ng-change="getMontoPorAplicar('Notas')" /></td>
                                            <td>{{item.DocumentoId}}</td>
                                            <td class="text-right">{{item.Fecha}}</td>
                                            <td class="text-right">{{item.Monto| currency}}</td>
                                            <td class="text-right">{{item.MontoAbierto | currency}}</td>
                                            <td class="text-right">
                                                <input type="text" ng-model="item.MontoPorAplicar" class="form-control-input"
                                                    ng-change="getMontoPorAplicar('Facturas')" money required />
                                            </td>
                                            <td class="text-left">
                                                <input type="text" ng-model="item.Comentarios" class="form-control-input" />
                                            </td>
                                            <td class="text-center hide-if-disabled">
                                                <i class="fa fa-trash-o pointer text-red" ng-click="quitarDetalle($index,'Facturas', item.CruceId)"></i>
                                            </td>
                                        </tr>
                                        <tr ng-show="pago.Facturas.length > 0">
                                            <td colspan="3"></td>
                                            <td class="text-right">{{pago.FacturasMontoTotal | currency}}</td>
                                            <td class="text-right">{{pago.FacturasMontoAbierto | currency}}</td>
                                            <td class="text-right">{{pago.FacturasMontoPorAplicar | currency}}</td>
                                            <td class="text-left">{{pago.FacturasComentarios}}</td>
                                        </tr>
                                        <tr ng-if="pago.Facturas == 0" class="nodata-row">
                                            <td colspan="6" class="text-center">
                                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mail-box padding-form">
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblNotasCredito") %> </span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table min-w900">
                                    <thead>
                                        <tr>
                                            <th colspan="6"></th>
                                            <th class="text-right" ng-class="{'textorojo' : pago.NotasBalance > 0}"><b>{{pago.NotasBalance | currency}}</b></th>
                                            <th colspan="2"></th>
                                        </tr>
                                        <tr class="jsgrid-header-row">
                                            <th width="7"><%= this.GetMessage("lblCruceId") %></th>
                                            <th width="18"><%= this.GetMessage("lblNotaCreditoQad") %></th>
                                            <th width="20"><%= this.GetMessage("lblNotaCredito") %></th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblMontoTotal") %></th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblMontoAbierto") %></th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblMontoPorAplicar") %></th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblBalance") %></th>
                                            <th width="10" class="text-center"><%= this.GetMessage("lblSaldoFactura") %></th>
                                            <th class="text-center hide-if-disabled" width="5">
                                                <i class="fa pointer fa-search main-color" ng-click="abrirDetalleNota(false)"></i>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="va-m" ng-repeat="item in pago.Notas" ng-class="{'textorojo' : item.MontoBalance > 0}">
                                            <td ng-show="item.Eliminar">
                                                <input type="text" ng-model="item.CruceId" class="form-control-input"
                                                    required numbers-only ng-change="getMontoPorAplicar('Notas')" />
                                            </td>
                                            <td ng-show="!item.Eliminar">{{item.CruceId}}
                                            </td>
                                            <td>{{item.QAD}}</td>
                                            <td>{{item.FolioTpm}}</td>
                                            <td class="text-right">{{item.Monto | currency}}</td>
                                            <td class="text-right">{{item.MontoAbierto | currency}}</td>
                                            <td>
                                                <input type="text" ng-model="item.MontoPorAplicar" class="form-control-input"
                                                    required money ng-change="getMontoPorAplicar('Notas')" />
                                            </td>
                                            <td class="text-right">{{item.MontoBalance | currency}}</td>
                                            <td class="text-right">{{item.SaldoFactura | currency}}</td>
                                            <td class="text-center hide-if-disabled">
                                                <i class="fa fa-trash-o pointer text-red" ng-click="quitarDetalle($index,'Notas')"></i>
                                            </td>
                                        </tr>
                                        <tr ng-show="pago.Notas.length > 0">
                                            <td colspan="3"></td>
                                            <td class="text-right">{{pago.NotasMontoTotal | currency}}</td>
                                            <td class="text-right">{{pago.NotasMontoAbierto | currency}}</td>
                                            <td class="text-right">{{pago.NotasMontoPorAplicar | currency}}</td>
                                            <td colspan="4"></td>
                                        </tr>
                                        <tr ng-if="pago.Notas == 0" class="nodata-row">
                                            <td colspan="9" class="text-center">
                                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="row" ng-hide="true">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblDetalleCruceNotas") %> </span>
                        </div>
                    </div>

                    <div class="row" ng-hide="true">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table min-w900">
                                    <thead>
                                        <tr style="font-size: 14px">
                                            <th rowspan="2" width="20" style="border-bottom: 2px solid #1a78b7">
                                                <%= this.GetMessage("lblFactura") %>
                                            </th>
                                            <th rowspan="2" width="20" class="text-center" style="border-bottom: 2px solid #1a78b7">
                                                <%= this.GetMessage("lblMontoAbiertoDespuesPago") %>
                                            </th>
                                            <th class="text-center" colspan="3">
                                                <%= this.GetMessage("lblMontoAplicarNcQad") %>
                                            </th>
                                        </tr>
                                        <tr class="jsgrid-header-row">
                                            <th width="20" class="text-center">
                                                <%= this.GetMessage("lblCruceId") %> 1
                                            </th>
                                            <th width="20" class="text-center">
                                                <%= this.GetMessage("lblCruceId") %> 2
                                            </th>
                                            <th width="20" class="text-center">
                                                <%= this.GetMessage("lblCruceId") %> 3
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="va-m" ng-repeat="item in pago.CruceNotas">
                                            <td>{{item.DocumentoId}}</td>
                                            <td class="text-right">{{item.MontoAbierto | currency}}</td>
                                            <td>
                                                <input type="text" ng-model="item.MontoCruceId1" class="form-control-input"
                                                    ng-change="obtenerTotalCruce(1)" money />
                                            </td>
                                            <td>
                                                <input type="text" ng-model="item.MontoCruceId2" class="form-control-input"
                                                    ng-change="obtenerTotalCruce(2)" money />
                                            </td>
                                            <td>
                                                <input type="text" ng-model="item.MontoCruceId3" class="form-control-input"
                                                    ng-change="obtenerTotalCruce(3)" money />
                                            </td>
                                        </tr>
                                        <tr ng-show="pago.CruceNotas.length > 0">
                                            <td></td>
                                            <td class="text-right">{{pago.CruceNotasMontoAbierto | currency}}</td>
                                            <td class="text-right">{{pago.MontoTotalCruce1 | currency}}</td>
                                            <td class="text-right">{{pago.MontoTotalCruce2 | currency}}</td>
                                            <td class="text-right">{{pago.MontoTotalCruce3 | currency}}</td>
                                        </tr>
                                        <tr ng-if="pago.CruceNotas == 0" class="nodata-row">
                                            <td colspan="5" class="text-center">
                                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="row" ng-hide="true">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblNotasCreditoAdicionales") %> </span>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8 col-lg-7">
                            <div class="table-responsive" ng-hide="true">
                                <table class="table" style="min-width: 500px">
                                    <thead>
                                        <tr class="jsgrid-header-row">
                                            <th width="35">
                                                <%= this.GetMessage("lblNotaCredito") %>
                                            </th>
                                            <th width="20"><%= this.GetMessage("lblTipo") %></th>
                                            <th width="15"><%= this.GetMessage("lblFecha") %></th>
                                            <th width="20" class="text-center"><%= this.GetMessage("lblMonto") %></th>
                                            <th class="text-center" width="10">
                                                <i class="fa pointer fa-search hide-if-disabled" ng-click="abrirDetalleNota(true)"></i>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="va-m" ng-repeat="item in pago.NotasAdicionales">
                                            <td>{{item.Folio}}</td>
                                            <td>{{item.Tipo}}</td>
                                            <td>{{item.Fecha}}</td>
                                            <td class="text-right">{{item.Monto | currency}}</td>
                                            <td class="text-center">
                                                <i class="fa pointer fa-chevron-circle-right main-color" ng-click="openModalNotas(item)"></i>
                                                <i class="fa fa-trash-o pointer text-red hide-if-disabled"
                                                    ng-click="quitarDetalle($index,'NotasAdicionales')"></i>
                                            </td>
                                        </tr>
                                        <%--<tr ng-show="pago.NotasAdicionales.length > 0">--%>
                                        <tr>
                                            <td colspan="3"></td>
                                            <td class="text-right">{{pago.NotasAdicionalesMontoTotal | currency}}</td>
                                        </tr>
                                        <%--<tr ng-if="pago.NotasAdicionales == 0" class="nodata-row">--%>
                                        <tr>
                                            <td colspan="5" class="text-center">
                                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="col-md-4 col-lg-5">
                            <div class="row mb">
                                <div class="col-xs-6 col-lg-offset-6 col-lg-6">
                                    <!-- Aqui estaba Fecha Conciliacion -->
                                    <%--ng-if="!pago.Cerrado"--%>
                                </div>

                                <div class="col-xs-12 text-right">
                                    <button type="button" class="btn btn-primary btn-xs no-disabled" ng-click="generarCimNc()"
                                        <%--ng-if="pago.NotasAdicionales.length > 0 && pago.Cerrado && !pago.CimNota"--%>
                                        style="max-width: 120px; white-space: normal; display: none;">
                                        <%= this.GetMessage("btnGenerarCimNc") %>
                                    </button>

                                    <button type="button" class="btn btn-primary btn-xs no-disabled" ng-click="generatCimPago()"
                                        <%--    ng-if="verCimPagos()" --%>
                                        style="max-width: 120px; white-space: normal; display: none;">
                                        <%= this.GetMessage("btnGenerarCimPagos") %>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="esDetalleFactura">
            <div class="row mb">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("lblBusquedaFactura") %></div>
                </div>
                <div class="div-top-butons">
                    <div>
                        <div class="btn btn-top" ng-click="esDetalleFactura=false" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                    <div>
                        <div ng-click="seleccionarDetalle()" tooltip-placement="bottom" ng-hide="pago.ConciliacionPagoId"
                            class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" ng-hide="">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb" ng-hide="pago.ConciliacionPagoId">
                <div class="col-sm-12">
                    <span class="label-color"><%= this.GetMessage("lblValoresAbuscar") %> </span>
                    <div class="input-group">
                        <textarea ng-model="valoresABuscar" class="form-control" rows="2" key-enter="buscarFacturas()">
                                        </textarea>
                        <div class="input-group-addon pointer" ng-click="buscarFacturas()">
                            <i class="fa fa-search fa-2x"></i>
                        </div>
                    </div>

                    <div><%= this.GetMessage("mensajeBusqueda") %></div>
                </div>
            </div>

            <div class="row mb">
                <div class="col-lg-9">
                    <div class="table-responsive">
                        <table class="table table-condensed" style="min-width: 700px">
                            <thead>
                                <tr>
                                    <th width="50" colspan="3" class="textorojo">{{pago.Alerta}}</th>
                                    <th width="15" class="text-right">{{pago.MontoTotalAbierto | currency}}</th>
                                </tr>
                                <tr class="jsgrid-header-row">
                                    <th width="5"></th>
                                    <th width="30"><%= this.GetMessage("lblFactura") %></th>
                                    <th width="15" class="text-center"><%= this.GetMessage("lblMontoTotal") %></th>
                                    <th width="15" class="text-center"><%= this.GetMessage("lblMontoAbierto") %></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="item in Facturas">
                                    <td class="text-center va-m">
                                        <input type="checkbox" ng-model="item.Seleccionado" ng-hide="item.bndMensaje || item.CuantosClientes > 1" />
                                    </td>
                                    <td class="va-m" ng-class="{'textorojo': item.Duplicado}">{{item.DocumentoId}}
                                    </td>
                                    <td class="text-right va-m" ng-hide="item.bndMensaje  || item.bndUtilizado">{{item.Monto  | currency}}
                                    </td>
                                    <td ng-show="item.bndMensaje || item.bndUtilizado" class="textorojo">{{item.MensajeDuplicidad}}{{item.MensajeUtilizado}}
                                    </td>
                                    <td class="text-right va-m">{{item.MontoAbierto | currency}}
                                    </td>
                                </tr>
                                <tr ng-if="facturas.length == 0" class="nodata-row">
                                    <td colspan="4" class="text-center">
                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="esDetalleNota">
            <div class="row mb">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("lblBusquedaNc") %></div>
                </div>
                <div class="div-top-butons">
                    <div>
                        <div class="btn btn-top" ng-click="esDetalleNota=false" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                    <div>
                        <div ng-click="seleccionarDetalle('Notas')" tooltip-placement="bottom"
                            class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mb" ng-hide="pago.ConciliacionPagoId">
                <div class="col-sm-12">
                    <span class="label-color"><%= this.GetMessage("lblValoresAbuscar") %> </span>
                    <div class="input-group">
                        <textarea ng-model="valoresABuscarNotas" class="form-control" rows="2" key-enter="buscarNotas()">
                                        </textarea>
                        <div class="input-group-addon pointer" ng-click="buscarNotas()">
                            <i class="fa fa-search fa-2x"></i>
                        </div>
                    </div>

                    <div><%= this.GetMessage("mensajeBusqueda") %></div>
                </div>
            </div>

            <div class="row mb" ng-hide="pago.sonNotasAdicionales">
                <div class="col-lg-9">
                    <div class="table-responsive">
                        <table class="table table-condensed" style="min-width: 700px">
                            <thead>
                                <tr>
                                    <th width="50" colspan="4" class="textorojo">{{pago.AlertaNC}}</th>
                                    <th width="15" class="text-right">{{pago.MontoTotalAbiertoNC | currency}}</th>
                                </tr>
                                <tr class="jsgrid-header-row">
                                    <th width="10"></th>
                                    <th width="30"><%= this.GetMessage("lblTipo") %></th>
                                    <th width="30"><%= this.GetMessage("lblNotaCredito") %></th>
                                    <th width="15" class="text-center"><%= this.GetMessage("lblMontoTotal") %></th>
                                    <th width="15" class="text-center"><%= this.GetMessage("lblMontoAbierto") %></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="item in Notas">
                                    <td class="text-center">
                                        <input type="checkbox" ng-model="item.Seleccionado" ng-hide="item.bndMensaje || item.CuantosClientes > 1" />
                                    </td>
                                    <td ng-class="{'textorojo': item.Duplicado}">{{item.Tipo}}</td>
                                    <td ng-class="{'textorojo': item.Duplicado}">{{item.DocumentoId}}</td>
                                    <td class="text-right" ng-hide="item.bndMensaje">{{item.Monto | currency}}
                                    </td>
                                    <td ng-show="item.bndMensaje" class="textorojo">{{item.MensajeDuplicidad}}
                                    </td>
                                    <td class="text-right">{{item.MontoAbierto | currency}}
                                    </td>
                                </tr>
                                <tr ng-if="Notas.length == 0" class="nodata-row">
                                    <td colspan="5" class="text-center">
                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="row mb" ng-show="pago.sonNotasAdicionales">
                <div class="col-lg-9">
                    <div class="table-responsive">
                        <table class="table table-condensed" style="min-width: 700px">
                            <thead>
                                <tr class="jsgrid-header-row">
                                    <th width="10"></th>
                                    <th width="30"><%= this.GetMessage("lblNotaCredito") %></th>
                                    <th width="30"><%= this.GetMessage("lblTipo") %></th>
                                    <th width="15" class="text-center"><%= this.GetMessage("lblFecha") %></th>
                                    <th width="15" class="text-center"><%= this.GetMessage("lblMontoSolicitud") %></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="item in NotasAdicionales">
                                    <td class="text-center">
                                        <input type="checkbox" ng-model="item.Seleccionado" ng-hide="item.bndMensaje || item.CuantosClientes > 1" />
                                    </td>
                                    <td ng-class="{'textorojo': item.Duplicado}">{{item.Folio}}</td>
                                    <td>{{item.Tipo}}</td>
                                    <td ng-hide="item.bndMensaje" class="text-right">{{item.Fecha}}</td>
                                    <td ng-show="item.bndMensaje" class="textorojo">{{item.MensajeDuplicidad}}
                                    </td>
                                    <td class="text-right">{{item.Monto | currency}}</td>
                                </tr>
                                <tr ng-if="NotasAdicionales.length == 0" class="nodata-row">
                                    <td colspan="5" class="text-center">
                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <ui-modal modal="modalNotas">
            <div class="modal-dialog" form-disabled form="modalForm">
              <div class="modal-content" ng-form="notasForma">
                <div class="modal-header">
                  <button type="button" class="close no-disabled" data-dismiss="modal">&times;</button>
                  <h4 class="modal-title">{{tituloModal}}</h4>
                </div>

                <div class="modal-body" ng-class="{'submitted': submitted}">
                    <div class="row mb">
                        <div class="col-sm-6">
                            <span><%= this.GetMessage("lblDescripcionGeneral") %></span>
                            <input type="text" ng-model="notaCredito.DescripcionGeneral" class="form-control-input"
                                   maxlength="22"/>
                        </div>

                        <div class="col-sm-6">
                            <span><%= this.GetMessage("lblOrdenCompra") %></span>
                            <input type="text" ng-model="notaCredito.OrdenCompra" class="form-control-input"/>
                        </div>

                        <div class="col-sm-6">
                            <span><%= this.GetMessage("lblDescripcionDetallada") %></span>
                            <input type="text" ng-model="notaCredito.DescripcionDetallada" class="form-control-input"/>
                        </div>

                        <div class="col-sm-6">
                            <span><%= this.GetMessage("lblCuentaIva") %></span>
                            <select class="form-control-select" ng-model="notaCredito.Cuenta"
                                ng-options="cuenta.Id as cuenta.Nombre for cuenta in CuentasIva"
                                ng-required="notaCredito.AplicaIva" ng-disabled="!notaCredito.AplicaIva">
                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                            </select>
                        </div>

                        <div class="col-sm-6">
                            <span><%= this.GetMessage("lblLibroDiario") %></span>
                            <select class="form-control-select" ng-model="notaCredito.LibroDiario"
                                ng-options="libro.Id as libro.Nombre for libro in LibrosDiario" required>
                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                            </select>
                        </div>

                        <div class="col-sm-6">
                            <span><%= this.GetMessage("lblComentarios") %></span>
                            <input type="text" ng-model="notaCredito.Comentarios" class="form-control-input"/>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">                
                  <button type="button" class="btn btn-success" ng-click="guardarNotaAdicional(notasForma)">
                      <%= this.GetCommonMessage("lblTooltipGuardar") %>
                  </button>
                  <button type="button" class="btn btn-default no-disabled" data-dismiss="modal">
                       <%= this.GetMessage("lblCerrar") %>
                  </button>
                </div>
              </div>
            </div>
        </ui-modal>
    </div>

    <script type="text/javascript" src="../scripts/pages/conciliacionPago.js?V1<%= DateTime.Now.Millisecond %>"""></script>
</asp:Content>
