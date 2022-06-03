<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="DescExtracontractual.aspx.cs" Inherits="CYP.Pages.DescExtracontractual" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="descExtracontractual">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-hide="esDetalle">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-10">
                                <input type="text" class="form-control" ng-model="filtro.Nombre" key-enter="getDescuentos()"
                                    placeholder="Busqueda rápida por (<%= this.GetMessage("lblNombre") %>)">
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <div class="glyphicon glyphicon-filter d-block"></div>
                            Filtros
                        </button>
                        <button type="button" class="btn btn-link" ng-click="getDescuentos()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            Buscar
                        </button>
                    <%--    <button type="button" class="btn btn-link" ng-click="agregar()" ng-if="!esAutorizador">
                            <div class="glyphicon glyphicon-plus d-block"></div>
                            Agregar
                        </button>--%>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <div class="glyphicon glyphicon-download-alt d-block"></div>
                            Excel
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblTipoActividad") %></label>
                            <select ng-model="filtro.TipoActividadId" class="form-control-select" required="required"
                                ng-options="item.TipoActividadId as item.NombreTipoActividad for item in tiposActividad"
                                ng-change="getDescuentos()">
                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblMarca") %></label>
                            <div class="width-auto" selected-model="filtro.Marcas"
                                options="marcas" extra-settings="marcasOptions"
                                translation-texts="translateTextMultiSelect"
                                ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCanal") %> </label>
                            <select ng-model="filtro.CanalId" class="form-control-select" required="required"
                                ng-options="item.CanalId as item.NombreCanal for item in canales"
                                ng-change="getDescuentos()">
                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblVigencia") %></label>
                            <datepicker-range ng-model="filtro.Fecha" required="required" input-class="form-control-input" />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblEstatus") %> </label>
                            <select ng-model="filtro.EstatusDescuentoId" class="form-control-select" required="required"
                                ng-options="item.EstatusDescuentoId as item.NombreEstatusDescuento for item in estatusLista"
                                ng-change="getDescuentos()">
                                <option value=""><%= this.GetMessage("lblAll") %></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="descuentos" st-fixed>
                    <table class="jsgrid-table" style="width: 1750px; min-width: 1750px">
                        <thead>
                            <tr>
                                <th ui-field width="15">
                                    <%= this.GetMessage("gvDescuento-ActivityId") %>
                                </th>
                                <th ui-field width="40">
                                    <%= this.GetMessage("gvDescuento-Nombre") %>
                                </th>
                                <th ui-field width="25">
                                    <%= this.GetMessage("gvDescuento-NombreTipoActividad") %>
                                </th>
                                <th ui-field width="35">
                                    <%= this.GetMessage("gvDescuento-Marcas") %>
                                </th>
                                <th ui-field width="35">
                                    <%= this.GetMessage("gvDescuento-NombreCanal") %>
                                </th>
                                <th ui-field width="25">
                                    <%= this.GetMessage("gvDescuento-Vigencia") %>
                                </th>
                                <th ui-field class="text-center" width="20">
                                    <%= this.GetMessage("gvDescuento-ValorActivity") %>
                                </th>
                                <th ui-field class="text-center" width="20">
                                    <%= this.GetMessage("gvDescuento-MontoAutorizacion") %>
                                </th>
                                <th ui-field class="text-center" width="20">
                                    <%= this.GetMessage("gvDescuento-MontoAutorizado") %>
                                </th>
                                <th ui-field class="text-center" width="20">
                                    <%= this.GetMessage("gvDescuento-MontoQad") %>
                                </th>
                                <th ui-field class="text-center" width="15">
                                    <%= this.GetMessage("gvDescuento-Balance") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvDescuento-NombreEstatusDescuento") %>
                                </th>
                                <th ui-field width="10"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in descuentos">
                                <td st-ratio="15">{{item.ActivityId}}</td>
                                <td st-ratio="40">{{item.Nombre}}</td>
                                <td st-ratio="25">{{item.NombreTipoActividad}}</td>
                                <td st-ratio="35">{{item.Marcas}}</td>
                                <td st-ratio="35">{{item.NombreCanal}}</td>
                                <td st-ratio="25">{{item.Vigencia}}</td>
                                <td st-ratio="20" class="text-right">{{item.ValorActivity | currency}}</td>
                                <td st-ratio="20" class="text-right">{{item.MontoAutorizacion | currency}}</td>
                                <td st-ratio="20" class="text-right">{{item.MontoAutorizado | currency}}</td>
                                <td st-ratio="20" class="text-right">{{item.MontoQad | currency}}</td>
                                <td st-ratio="15" class="text-right">{{item.Balance | currency}}</td>
                                <td st-ratio="10">{{item.NombreEstatusDescuento}}</td>
                                <td st-ratio="10">
                                    <button type="button" class="btn btn-link" ng-click="getDescuento(item)">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="descuentos.length == 0" class="nodata-row">
                                <td colspan="13" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="13">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="esDetalle">
            <div class="row">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("lblDetalleActivity") %></div>
                </div>
                <div class="btn-tpm col-sm-6">
                    <div>
                        <div class="btn btn-top" ng-click="guardar()" tooltip-placement="bottom" 
                             ng-show="(descuento.Active || !descuento.NoEditable) && !esAutorizador && descuento.OrigenActivityID === 0"
                             uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div>
                        <div class="btn btn-top" ng-click="esDetalle=false" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mail-box" ng-form="forma" ng-class="{'submitted': submitted}" disable-all="descuento.EsSoloLectura">
                <div class="padding-form">
                    <div class="row">
                        <div class="col-sm-3">
                            <span class="label-color"><%= this.GetMessage("lblActivityId") %> </span>
                            <input type="text" ng-model="descuento.ActivityId" class="form-control-input" required
                                ng-readonly="activityId" />
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-sm-3">
                            <span class="label-color"><%= this.GetMessage("lblNombre") %> </span>
                            <input type="text" ng-model="descuento.Nombre" class="form-control-input" required="required"
                                ng-readonly="descuento.NoEditable" />
                        </div>

                        <div class="col-sm-3">
                            <span class="label-color"><%= this.GetMessage("lblTipoActividad") %> </span>
                            <select ng-model="descuento.TipoActividadId" class="form-control-select" required="required"
                                ng-options="item.TipoActividadId as item.NombreTipoActividad for item in tiposActividad"
                                ng-disabled="descuento.NoEditable">
                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                            </select>
                        </div>

                        <div class="col-sm-3" custom-disabled="disabledOptions">
                            <span class="label-color"><%= this.GetMessage("lblCanal") %> </span>
                            <div class="width-auto" selected-model="descuento.Canales"
                                options="canales" extra-settings="canalesOptions"
                                translation-texts="translateTextMultiSelect"
                                ng-dropdown-multiselect="" events="multiselectCanalEventos">
                            </div>
                        </div>

                        <div class="col-sm-3">
                            <span class="label-color"><%= this.GetMessage("lblCentroCostos") %> </span>
                            <input type="text" ng-model="descuento.CentroCostos" class="form-control-input" readonly="readonly" />
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-sm-3">
                            <span class="label-color"><%= this.GetMessage("lblVigencia") %> </span>
                            <datepicker-range ng-model="descuento.Fecha" required="required" input-class="form-control-input"
                                ng-disabled="(!descuento.Active && descuento.NoEditable) || esAutorizador" />
                        </div>

                        <div class="col-sm-3">
                            <ex-fileupload ng-model="descuento.NombreArchivo" label="<%= this.GetMessage("lblEvidenciaActivity") %>"
                                label-button="Anexar" on-success="setParametrosArchivo(response)"
                                options="fileOptions" parameters="fileParameters" open-file="openDocumento()" 
                                ng-disabled="descuento.NoEditable" />
                        </div>

                        <div class="col-sm-3" custom-disabled="disabledOptions">
                            <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                            <div class="width-auto" selected-model="descuento.Marcas"
                                options="marcas" extra-settings="marcasOptions"
                                translation-texts="translateTextMultiSelect"
                                ng-dropdown-multiselect="" events="multiselectEventos">
                            </div>
                        </div>

                        <div class="col-sm-3">
                            <span class="label-color"><%= this.GetMessage("lblSubcuenta") %> </span>
                            <input type="text" ng-model="descuento.Subcuenta" class="form-control-input"
                                readonly="readonly" required="required" />
                        </div>
                    </div>
                    <br />

                    <div>
                        <div class="row" ng-class="{'form-disabled': descuento.NoEditable}">
                            <div class="col-sm-9">
                                <span class="label-color"><%= this.GetMessage("lblEstrategia") %> </span>
                                <textarea ng-model="descuento.Estrategia" class="form-control-input" rows="4"
                                    required="required"></textarea>
                            </div>

                            <div class="col-md-3 col-sm-3">
                                <span class="label-color"><%= this.GetMessage("lblCuentaContable") %> </span>
                                <ex-autocomplete ng-model="descuento.CuentaContableId" options="cuentaOptions"
                                    item="descuento" required />
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblMontoDescuetoNC") %> </span>
                                <input type="text" ng-model="descuento.MontoAutorizado" class="form-control-input"
                                    required="required" money ng-disabled="(!descuento.Active && descuento.NoEditable) || esAutorizador" 
                                    ng-change="calcularBalance()" />
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblNotaCreditoQad") %> </span>
                                <input type="text" ng-model="descuento.MontoQad" class="form-control-input"
                                    readonly="readonly" money />
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblNotaCreditoAutorizacion") %> </span>
                                <input type="text" ng-model="descuento.MontoEnAutorizacion" class="form-control-input"
                                    readonly="readonly" money />
                            </div>

                            <div class="col-md-3 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblBalance") %> </span>
                                <input type="text" ng-model="descuento.Balance" class="form-control-input"
                                    readonly="readonly" money />
                            </div>
                        </div>
                        <br />

                        <div class="row">
                            <div class="col-sm-3">
                                <span class="label-color"><%= this.GetMessage("lblImpactoA") %> </span>
                                <br />
                                <div class="checkbox-inline custom-check">
                                    <label>
                                        <input type="checkbox" ng-model="descuento.EsSellIn" ng-disabled="descuento.NoEditable" />
                                        <%= this.GetMessage("lblSellIn") %>
                                    </label>
                                </div>
                                <div class="checkbox-inline custom-check">
                                    <label>
                                        <input type="checkbox" ng-model="descuento.EsSellOut" ng-disabled="descuento.NoEditable" />
                                        <%= this.GetMessage("lblSellOut") %>
                                    </label>
                                </div>
                            </div>
                           
                            <div class="col-sm-3" ng-if="descuento.DescuentoId">
                                <div class="label-color"><%= this.GetMessage("lblInactivo") %> </div>
                                <switcher ng-model="descuento.Inactivo" true-label="<%= this.GetMessage("lblSi") %>"
                                    false-label="<%= this.GetMessage("lblNo") %>" ng-disabled="(!descuento.Active && descuento.NoEditable) || esAutorizador"></switcher>
                            </div>
                        </div>
                    </div>
                    <br />
                </div>
            </div>

            <div class="mail-box padding-form" ng-if="descuento.NotasCredito.length > 0">
                <div class="row">
                    <div class="col-sm-6">
                        <span class="subtitulo-color"><%= this.GetMessage("lblNotasCredito") %> </span>
                    </div>
                     <div class="col-sm-6 text-right">
                        <button type="button" class="btn btn-link p-0" ng-click="exportar(true)">
                            <div class="glyphicon glyphicon-download-alt d-block"></div>
                            Excel
                        </button>
                    </div>                    
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr class="jsgrid-header-row">
                                        <th><%= this.GetMessage("gvDescuento-Folio") %></th>
                                        <th><%= this.GetMessage("gvDescuento-CobrarA") %></th>
                                        <th><%= this.GetMessage("gvDescuento-Fecha") %></th>
                                        <th class="text-center"><%= this.GetMessage("gvDescuento-Subtotal") %></th>
                                        <th class="text-center"><%= this.GetMessage("gvDescuento-Monto") %></th>
                                        <th><%= this.GetMessage("gvDescuento-NombreSolicitante") %></th>
                                        <th><%= this.GetMessage("gvDescuento-QAD") %></th>
                                        <th><%= this.GetMessage("gvDescuento-Estatus") %></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr ng-repeat="item in descuento.NotasCredito">
                                        <td>{{item.Folio}}</td>
                                        <td>{{item.CobrarA}}</td>
                                        <td>{{item.Fecha}}</td>
                                        <td class="text-right">{{item.Subtotal | currency}}</td>
                                        <td class="text-right">{{item.Monto | currency}}</td>
                                        <td>{{item.NombreSolicitante}}</td>
                                        <td>{{item.QAD}}</td>
                                        <td>{{item.Estatus}}</td>
                                        <td class="text-center">
                                            <%-- <button type="button" class="btn btn-link p-0" ng-click="verNota(item)">
                                                <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                            </button>--%>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/DescExtracontractual.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
