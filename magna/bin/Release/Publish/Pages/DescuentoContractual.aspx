<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="DescuentoContractual.aspx.cs" Inherits="CYP.Pages.DescuentoContractual" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="descuentoContractualController as vm">
        <div class="content-top clearfix">
            <div class="row">
                <div class="col-sm-6">
                    <h1 class="al-title" ng-bind="vm.titulo"></h1>
                </div>
                <div class="btn-tpm col-sm-6" ng-if="vm.viewDetail">
                    <div class="padding-7">
                        <div class="btn btn-top " ng-click="vm.viewDetail && vm.guardar()"
                             uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>"
                             tooltip-placement="bottom">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div class="padding-7">
                        <div class="btn btn-top" ng-click="vm.actualizar();vm.viewDetail=false"
                             uib-tooltip="<%= this.GetCommonMessage("LblTooltipRegresar") %>"
                             tooltip-placement="bottom">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-content">
            <div ng-if="!vm.viewDetail">
                <div class="filtros">
                    <div class="filter mail-box filtros">
                        <div class="row p-5">
                            <div class="col-md-8">
                                <div class="row">
                                    <div class="col-md-2">
                                        <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                                    </div>

                                    <div class="clearfix visible-sm visible-xs pt-5"></div>

                                    <div class="col-md-10">
                                        <input type="text" class="form-control" ng-model="vm.filtro.Codigo" key-enter="vm.actualizar()"
                                            placeholder="Busqueda rápida por (<%= this.GetMessage("Codigo") %>)">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="clearfix visible-xs"><br /></div>

                            <div class="col-md-4 text-right">
                                <button type="button" class="btn btn-link" ng-click="vm.openFilterAdvance=!vm.openFilterAdvance;vm.clearFiltros()">
                                    <div class="glyphicon glyphicon-filter d-block"></div>
                                    Filtros
                                </button>
                                <button type="button" class="btn btn-link" ng-click="vm.actualizar()">
                                    <div class="glyphicon glyphicon-search d-block"></div>
                                    Buscar
                                </button>
                                <button type="button" class="btn btn-link" ng-click="vm.agregar()">
                                    <div class="glyphicon glyphicon-plus d-block"></div>
                                    Agregar
                                </button>
                                <button type="button" class="btn btn-link itemEnd" ng-click="vm.descargar()">
                                    <div class="glyphicon glyphicon-download-alt d-block"></div>
                                    Excel
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mail-box filtros-avanzados" ng-if="vm.openFilterAdvance">
                    <div class="row">
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label><%= this.GetMessage("Codigo") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.Codigo"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label><%= this.GetMessage("Cliente") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreCliente"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label><%= this.GetMessage("Tipo") %></label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.TipoDescuentoId" required ng-change="vm.actualizar()"
                                    ng-options="item.TipoDescuentoId as item.NombreTipoDescuento for item in vm.tipoDescuentos" required>
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label><%= this.GetMessage("FiltroVigencia") %> </label>
                                <datepicker id="VigenciaInicio" ng-model="vm.filtro.Vigencia" format="'dd/mm/yyyy'"></datepicker>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.descuentosContractuales" st-fixed>
                                        <table class="jsgrid-table" style="width: 1200px; min-width: 1200px"
                                            st-table="vm.descuentosContractuales" st-safe-src="vm.descuentosContractuales_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="5"><%= this.GetMessage("gvDescuento-Codigo") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("gvDescuento-CodigoCliente") %></th>
                                                    <th ui-field width="20"><%= this.GetMessage("gvDescuento-Cliente") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("gvDescuento-Canal") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("gvDescuento-Tipo") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("gvDescuento-Vigencia") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("gvDescuento-Estatus") %></th>
                                                    <th ui-field width="10" class="text-center"><%= this.GetMessage("gvDescuento-Monto") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.descuentosContractuales">
                                                    <td st-ratio="5" ng-bind="item.ActivityId"></td>
                                                    <td st-ratio="10" ng-bind="item.CodigoCliente"></td>
                                                    <td st-ratio="20" ng-bind="item.NombreCliente"></td>
                                                    <td st-ratio="15" ng-bind="item.NombreCanal"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreTipoDescuento"></td>
                                                    <td st-ratio="15" ng-bind="item.Vigencia"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreEstatusDescuento"></td>
                                                    <td st-ratio="10" class="text-right">{{item.Monto | number:2}}</td>
                                                    <td st-ratio="5" class="text-center">
                                                        <button type="button" class="btn btn-link p-0" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.descuentosContractuales.length == 0" class="nodata-row">
                                                    <td colspan="9" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="9">
                                                        <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <div ng-if="vm.viewDetail" ng-form="vm.form" ng-class="{'submitted': !vm.isValid}">
                <div class="mail-box padding-10 ">
                    <div class="mail-body">
                        <div class="ibox-content">
                            <div id="Filters" class="padding-form">
                                <div class="subtitulo-color"><%= this.GetMessage("TituloDetalle") %></div>
                                <div class="row">
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("Codigo") %> </span>

                                        <input type="text" class="form-control form-control-input" ng-model="vm.descuentoContractual.ActivityId" disabled />
                                    </div>
                                    <div class="col-sm-8"></div>
                                </div>
                                <br />

                                <div class="row" ng-class="{'form-disabled': vm.descuentoContractual.NoEditable}">
                                    <div class="col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("Cliente") %> </span>
                                        <ex-autocomplete ng-model="vm.descuentoContractual.ClienteId" options="vm.autoCompleteOptions" item="vm.clienteSeleccionado" required="required" />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("TipoDescuento") %> </span>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.descuentoContractual.TipoDescuentoId" required ng-change="changeTipoDescuento(true)"
                                            ng-options="item.TipoDescuentoId as item.NombreTipoDescuento for item in vm.tipoDescuentos" required>
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CuentaContable") %> </span>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.descuentoContractual.CuentaContableId" required
                                            ng-options="item.CuentaContableId as item.NombreCuentaContable for item in vm.cuentasContables" required>
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>
                                <br />

                                <div class="row" ng-class="{'form-disabled': vm.descuentoContractual.NoEditable}">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Vigencia") %> </span>
                                        <datepicker-range ng-model="vm.descuentoContractual.Fecha" required="required" input-class="form-control-input" />
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("TipoDescuentoContractual") %> </span>
                                        <select
                                            class="form-control form-control-select" ng-change="validarTipoDescuento(true)"
                                            ng-model="vm.descuentoContractual.TipoDescuentoContractualId" disabled="true"
                                            ng-options="item.TipoDescuentoContractualId as item.NombreTipoDescuentoContractual for item in vm.tiposDescuentoContractual">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("Monto") %> </div>
                                        <div class="input-group">
                                            <input type="text" class="form-control form-control-input" ng-model="vm.descuentoContractual.Monto"
                                                required money precision="4" />

                                        </div>

                                    </div>
                                    <div class="col-sm-3" ng-show="esPorMonto">
                                        <div class="label-color"><%= this.GetMessage("MontoFijo") %> </div>
                                        <switcher ng-model="vm.descuentoContractual.EsMontoFijo" true-label="<%= this.GetMessage("lblSi") %>"
                                            false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-3" ng-class="{'form-disabled': vm.descuentoContractual.NoEditable}">
                                        <div class="label-color"><%= this.GetMessage("Fiscal") %> </div>
                                        <switcher ng-model="vm.descuentoContractual.Fiscal" true-label="<%= this.GetMessage("lblSi") %>"
                                            false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                                    </div>
                                    <div class="col-sm-3" ng-class="{'form-disabled': vm.descuentoContractual.NoEditable}">
                                        <span class="label-color"><%= this.GetMessage("lblAplicaIva") %> </span>
                                        <br />
                                        <switcher ng-model="vm.descuentoContractual.EsIvaGeneral" true-label="<%= this.GetMessage("lblSi") %>"
                                            false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("lblCentroCostoLogistica") %> </span>
                                        <br />
                                        <switcher ng-model="vm.descuentoContractual.CentroCostoLogistica" true-label="<%= this.GetMessage("lblSi") %>"
                                            false-label="<%= this.GetMessage("lblNo") %>" class="skip-disabled"></switcher>
                                    </div>
                                     <div class="col-sm-3" ng-show="esProntoPago">
                                        <div class="label-color"><%= this.GetMessage("lblDiasProntoPago") %> </div>
                                          <input type="text" class="form-control form-control-input" ng-model="vm.descuentoContractual.DiasProntoPago"
                                                money precision="0"  />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <br />
                <div class="mail-box padding-10">
                    <div class="mail-body">
                        <div class="ibox-content">
                            <div id="Filters" class="padding-form">



                                <div class="subtitulo-color"><%= this.GetMessage("TitleNotasCredito") %></div>
                                <div class="row Home">
                                    <div ui-table="vm.descuentoContractual.NotasCredito" st-fixed height="300px" style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 750px"
                                            st-table="vm.descuentoContractual.NotasCredito" st-safe-src="vm.notasdeCredito_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="5"><%= this.GetMessage("Folio") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("Fecha") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("MontoNC") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("SolicitadaPor") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("QAD") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("EstatusNC") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-if="vm.loading">
                                                    <td colspan="7">
                                                        <div id="preloader">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr ng-repeat="item in vm.descuentoContractual.NotasCredito">
                                                    <td st-ratio="5" ng-bind="item.Folio"></td>
                                                    <td st-ratio="15" ng-bind="item.Fecha"></td>
                                                    <td st-ratio="10" ng-bind="item.Monto"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreSolicitante"></td>
                                                    <td st-ratio="10" ng-bind="item.QAD"></td>
                                                    <td st-ratio="10" ng-bind="item.Estatus"></td>
                                                    <td st-ratio="5">
                                                        <%--<button type="button" class="btn btn-link" ng-click="vm.EditarNC(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>--%>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.descuentoContractual.NotasCredito == 0" class="nodata-row">
                                                    <td colspan="7" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="7">
                                                        <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/descuentoContractualController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>

