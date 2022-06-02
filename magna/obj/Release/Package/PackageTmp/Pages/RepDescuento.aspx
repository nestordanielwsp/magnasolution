<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepDescuento.aspx.cs" Inherits="CYP.Pages.RepDescuento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repDescuento">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-8">
                        <div class="row">
                            <div class="col-sm-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-xs pt-5"></div>

                            <div class="col-sm-5">
                                <select ng-model="filtro.Anio" class="form-control-select"
                                    ng-options="anio as anio for anio in anios"
                                    ng-change="actualizar()">
                                </select>
                            </div>

                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>

                            <div class="col-sm-5" ng-show="filtro.vistaId === 1 || filtro.vistaId === 2">
                                <select ng-model="filtro.MesId" class="form-control-select"
                                    ng-options="item.Id as item.Name for item in meses"
                                    ng-change="actualizar()">
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <i class="glyphicon glyphicon-filter d-block"></i>
                            <%= this.GetMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="actualizar()">
                            <div class="glyphicon glyphicon-refresh d-block"></div>
                            <%= this.GetMessage("btnActualizar") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <i class="glyphicon glyphicon-download-alt d-block"></i>
                            <%= this.GetMessage("btnExcel") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCanal") %></label>
                            <select ng-model="filtro.CanalId" class="form-control-select"
                                ng-options="item.CanalId as item.NombreCanal for item in canales"
                                ng-change="actualizar()">
                                <option value="" ng-if="canales.length > 1">
                                    <%= this.GetMessage("lblTodos") %>
                                </option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblRegion") %></label>
                            <select ng-model="filtro.RegionId" class="form-control-select"
                                ng-options="item.RegionId as item.NombreRegion for item in regiones"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblVendedor") %> </label>
                            <ex-autocomplete ng-model="filtro.VendedorId" options="vendedorOptions"
                                on-select="actualizar()" clean-button />
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblJefeVentas") %></label>
                            <ex-autocomplete ng-model="filtro.JefeId" options="jefeOptions"
                                on-select="actualizar()" clean-button />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCuentaContable") %> </label>
                            <div class="width-auto" selected-model="filtro.Cuentas"
                                options="cuentas" extra-settings="cuentasOptions"
                                translation-texts="translateTextMultiSelect"
                                ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblTipoDescuento") %> </label>
                            <select ng-model="filtro.TipoNotaCreditoId" class="form-control-select"
                                ng-options="item.TipoNotaCreditoId as item.NombreTipoNotaCredito for item in tiposNota"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblConceptoDescuento") %> </label>
                            <div class="width-auto" selected-model="filtro.TiposDescuento"
                                options="tiposDescuento" extra-settings="tiposDecuentoOptions"
                                translation-texts="translateTextMultiSelect"
                                ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mail-box">
                <div class="row">
                    <div class="col-sm-8">
                        <ul class="nav nav-tabs" style="font-size: 14px">
                            <li ng-repeat="item in vistas" ng-class="{'active': filtro.vistaId === item.vistaId}">
                                <a class="pointer" ng-click="cambiarVista(item)">{{item.name}}
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="col-sm-4 text-right" ng-show="filtro.vistaId === 2">
                        <button type="button" class="btn btn-link" ng-click="esGrafica = true">
                            <img src="../images/chart.png" />
                        </button>
                        <button type="button" class="btn btn-link" ng-click="esGrafica = false">
                            <img src="../images/table.png" />
                        </button>
                    </div>
                </div>

                <br />

                <div class="padding-form" style="padding-top: 0!important">
                    <div class="row" ng-show="sinInformacion">
                        <div class="col-sm-12 text-center">
                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                        </div>
                    </div>

                    <div ng-show="filtro.vistaId === 1 && !sinInformacion">
                        <div class="row" style="margin-top: -10px">
                            <div class="col-md-3 text-center">
                                <h4><%= this.GetMessage("lblTopClienteDescuento") %></h4>
                            </div>
                            <div class="col-md-9">
                                <div id="topClientes" class="big-size" ex-highchart chart="chartTopClientes"
                                    type="pie" options="topClientesOptions" style="height: 250px">
                                </div>
                                <div id="topClientesT" class="tablet-size" ex-highchart chart="chartClientesTablet"
                                    type="pie" options="chartOptions" style="height: 320px">
                                </div>
                                <div id="topClientesM" class="mobile-size" ex-highchart chart="chartClientesMobile"
                                    type="pie" options="chartOptionsMobile" style="height: 350px;">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-sm-12 text-center">
                                        <h4><%= this.GetMessage("lblTotalDescuentoCanal") %></h4>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div id="totalPorCanal" class="normal-size" ex-highchart chart="chartTotalCanal"
                                            type="pie" options="chartOptions" style="height: 250px">
                                        </div>
                                        <div id="totalPorCanalM" class="mobile-size" ex-highchart chart="chartCanalMobile"
                                            type="pie" options="chartOptionsMobile" style="height: 300px;">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-sm-12 text-center">
                                        <h4><%= this.GetMessage("lblTotalDescuentoTipo") %></h4>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div id="totalPorTipo" class="normal-size" ex-highchart chart="chartTotalTipo"
                                            type="pie" options="chartOptionsTipoMobile" style="height: 250px">
                                        </div>
                                        <div id="totalPorTipoM" class="mobile-size" ex-highchart chart="chartTipoMobile"
                                            type="pie" options="chartOptionsMobile" style="height: 250px;">
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div ng-show="filtro.vistaId === 2 && !sinInformacion">
                        <div ng-show="esGrafica">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div id="canalTipo" ex-highchart chart="chartTipoData" class="normal-size"
                                        type="column" options="canalTipoOptions">
                                    </div>
                                    <div id="canalTipoM" ex-highchart chart="chartTipoDataMobile" class="mobile-size"
                                        type="column" options="chartOptionsTipoMobile">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="table-responsive p-20">
                                        <table class="table table-striped table-condensed table-hover">
                                            <thead>
                                                <tr class="jsgrid-header-row">
                                                    <th style="width: 80px"></th>
                                                    <th class="text-center" ng-repeat="item in canalTipoOptions.categories">{{item}}</th>
                                                </tr>
                                            </thead>

                                            <tbody>
                                                <tr ng-repeat="canal in canalesTipo">
                                                    <td style="width: 80px">{{canal.name}}</td>
                                                    <td class="text-right" ng-repeat="item in canalTipoOptions.categories">{{canal[item] | currency:$:2}}
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row" ng-hide="esGrafica" style="overflow-y: auto">
                            <div class="col-sm-12">
                                <div class="table-responsive">
                                    <table class="table table-striped table-condensed table-hover">
                                        <thead class="main-header">
                                            <tr>
                                                <th></th>
                                                <th colspan="3" class="text-center">
                                                    <%= this.GetMessage("lblTipoDescuento") %>
                                                </th>
                                                <th></th>
                                            </tr>
                                            <tr>
                                                <th>
                                                    <%= this.GetMessage("lblCanal") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("lblApoyoVentas") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("lblContractual") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("lblExtracontractual") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("lblTotalGeneral") %>
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr ng-hide="item.esOculto || tablaCanalTipo.length == 1" ng-repeat="item in tablaCanalTipo"
                                                ng-class="{'header': item.EsCanal}">
                                                <td ng-class="{'pl-25': !item.EsCanal}">
                                                    <i class="glyphicon pointer" ng-show="item.EsCanal" ng-click="expandirCanal(item, 'canalTipo')"
                                                        ng-class="item.esColapsado? 'glyphicon-plus':'glyphicon-minus'"></i>
                                                    {{item.Nombre}}
                                                </td>
                                                <td class="text-right">{{item.Apv | currency}}</td>
                                                <td class="text-right">{{item.Contractual | currency}}</td>
                                                <td class="text-right">{{item.Extracontractual | currency}}</td>
                                                <td class="text-right">{{item.Total | currency}}</td>
                                            </tr>
                                            <tr ng-if="tablaCanalTipo.length == 1" class="nodata-row">
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

                    <div id="Home" class="row" ng-show="filtro.vistaId === 3 && !sinInformacion" style="overflow-y: auto">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-condensed table-hover" st-table="tablaClienteCuenta"
                                    st-safe-src="_tablaClienteCuenta">
                                    <thead class="main-header">
                                        <tr>
                                            <th></th>
                                            <th class="text-center" colspan="{{mesActualId}}">
                                                <%= this.GetMessage("lblMes") %>
                                            </th>
                                            <th></th>
                                        </tr>
                                        <tr>
                                            <th>
                                                <%= this.GetMessage("lblCliente") %>
                                            </th>
                                            <th class="text-center" ng-repeat="mes in meses">{{mes.Name}}
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("lblTotalGeneral") %>
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-hide="item.esOculto" ng-repeat="item in tablaClienteCuenta"
                                            ng-class="{'total': item.EsTotalGeneral, 'sub-header': item.EsPrimerNivel, 'header': item.EsSegundoNivel}">
                                            <td ng-class="{'pl-25': !item.EsPrimerNivel}">
                                                <i class="glyphicon pointer" ng-show="item.EsPrimerNivel" ng-click="expandirFila(item, true)"
                                                    ng-class="item.esColapsado? 'glyphicon-plus':'glyphicon-minus'"></i>
                                                {{item.Nombre}}
                                    <span ng-if="item.EsTotalGeneral"><%= this.GetMessage("lblTotalGeneral") %></span>
                                            </td>
                                            <td class="text-right" ng-repeat="mes in meses">{{item["MontoMes" + mes.Id] | currency}}
                                            </td>
                                            <td class="text-right">{{item.Total | currency}}</td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td colspan="{{mesActualId}}">
                                                <div st-pagination="10" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div ng-show="filtro.vistaId === 4 && !sinInformacion">
                        <div class="row" style="overflow-y: auto">
                            <div class="col-sm-12">
                                <div class="table-responsive">
                                    <table class="table table-striped table-condensed table-hover">
                                        <thead class="main-header">
                                            <tr>
                                                <th></th>
                                                <th class="text-center" colspan="{{mesActualId}}">
                                                    <%= this.GetMessage("lblMes") %>
                                                </th>
                                                <th></th>
                                            </tr>
                                            <tr>
                                                <th>
                                                    <%= this.GetMessage("lblDescuentoCanal") %>
                                                </th>
                                                <th class="text-center" ng-repeat="mes in meses">{{mes.Name}}
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("lblTotalGeneral") %>
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr ng-hide="item.esOculto" ng-repeat="item in tablaCuentaCanal"
                                                ng-class="{'total': item.EsTotalGeneral, 'sub-header': item.EsPrimerNivel, 'header': item.EsSegundoNivel}">
                                                <td ng-class="{'pl-25': !item.EsPrimerNivel}">
                                                    <i class="glyphicon pointer" ng-show="item.EsPrimerNivel" ng-click="expandirFila(item, false)"
                                                        ng-class="item.esColapsado? 'glyphicon-plus':'glyphicon-minus'"></i>
                                                    {{item.Nombre}}
                                                    <span ng-if="item.EsTotalGeneral"><%= this.GetMessage("lblTotalGeneral") %></span>
                                                </td>
                                                <td class="text-right" ng-repeat="mes in meses">{{item["MontoMes" + mes.Id] | currency}}
                                                </td>
                                                <td class="text-right">{{item.Total | currency}}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/repDescuento.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
