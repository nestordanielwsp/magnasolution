<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepCarteraCierreMes.aspx.cs" Inherits="CYP.Pages.RepCarteraCierreMes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repCarteraCierreMes">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %> {{titulo}}</h1>
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

                            <div ng-show="!esVistaPrincipal">
                                <div class="col-sm-5">
                                    <select ng-model="filtro.Anio" class="form-control-select"
                                        ng-options="anio as anio for anio in anios"
                                        ng-change="actualizar()">
                                    </select>
                                </div>

                                <div class="clearfix visible-xs pt-5">
                                    <br />
                                </div>

                                <div class="col-sm-5">
                                    <select ng-model="filtro.MesId" class="form-control-select"
                                        ng-options="item.Id as item.Name for item in meses"
                                        ng-change="actualizar()">
                                    </select>
                                </div>
                            </div>

                            <div class="col-md-5" ng-show="esVistaPrincipal">
                                <select ng-model="filtro.Anio" class="form-control-select"
                                    ng-options="anio as anio for anio in anios"
                                    ng-change="actualizar()">
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros"
                            ng-show="!esVistaPrincipal">
                            <i class="glyphicon glyphicon-filter d-block"></i>
                            <%= this.GetMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="actualizar()">
                            <div class="glyphicon glyphicon-refresh d-block"></div>
                            <%= this.GetMessage("btnActualizar") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()"
                            ng-show="!esVistaPrincipal">
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
                            <label><%= this.GetMessage("lblJefeVentas") %> </label>
                            <ex-autocomplete ng-model="filtro.JefeId" options="jefeOptions"
                                on-select="actualizar()" clean-button />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblJac") %></label>
                            <select ng-model="filtro.JacId" class="form-control-select"
                                ng-options="item.UsuarioId as item.NombreUsuario for item in jacs"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblAnalista") %> </label>
                            <select ng-model="filtro.AnalistaId" class="form-control-select"
                                ng-options="item.UsuarioId as item.NombreUsuario for item in analistas"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mail-box">
                <div class="row">
                    <div class="col-sm-8">
                        <ul class="nav nav-tabs" style="font-size: 14px">
                            <li ng-repeat="item in vistasPadre" ng-show="esVistaPrincipal">
                                <a class="pointer" ng-click="cambiarVistaPrincipal(false, item)">{{item.name}}</a>
                            </li>
                            <li ng-repeat="item in vistas" ng-class="{'active': vista.vistaId === item.vistaId}"
                                ng-show="item.vistaPadreId === vistaPadreId">
                                <a class="pointer" ng-click="cambiarVista(item)">{{item.name}}</a>
                            </li>
                        </ul>
                    </div>

                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="cambiarVistaPrincipal(true)" ng-show="!esVistaPrincipal">
                            <i class="glyphicon glyphicon-arrow-left d-block"></i>
                            <%= this.GetCommonMessage("lblTooltipRegresar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="esGrafica = true"
                            ng-show="vista.graficaTabla && !esVistaPrincipal">
                            <img src="../images/chart.png" />
                        </button>
                        <button type="button" class="btn btn-link" ng-click="esGrafica = false"
                            ng-show="vista.graficaTabla && !esVistaPrincipal">
                            <img src="../images/table.png" />
                        </button>
                    </div>
                </div>

                <div class="row" ng-show="sinInformacion">
                    <div class="col-sm-12 text-center">
                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                    </div>
                </div>

                <div id="Home" class="padding-form pt-0" ng-show="!sinInformacion">
                    <div ng-show="esVistaPrincipal">
                        <br />
                        <div class="row">
                            <div class="col-sm-12">
                                <div class="row text-center">
                                    <b><%= this.GetMessage("lblEvolucionCartera") %></b>
                                </div>
                                <div id="evolucion" ex-highchart chart="chartEvolucion"
                                    type="column" options="columnaOptions" style="height: 250px">
                                </div>
                            </div>
                            <br />
                            <br />
                            <br />
                            <div class="col-sm-12">
                                <div class="row text-center">
                                    <b><%= this.GetMessage("lblEvolucionCalidadDias") %></b>
                                </div>
                                <div id="calidadDias" ex-highchart chart="chartCalidadDias"
                                    type="" options="chartCalidadDiasOptions" style="height: 250px">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div ng-show="vistaPadreId == 1">
                        <div ng-show="vista.vistaId === 1">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="row text-center">
                                        <b><%= this.GetMessage("lblDistribucionCanal") %></b>
                                    </div>
                                    <div id="distribucionCanal" class="normal-size" ex-highchart chart="chartCanal"
                                        type="pie" options="chartOptions" style="height: 250px">
                                    </div>
                                    <div id="distribucionCanalM" class="mobile-size" ex-highchart chart="chartCanalMobile"
                                        type="pie" options="chartOptionsMobile" style="height: 250px">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="row text-center">
                                        <b><%= this.GetMessage("lblComportamientoAnual") %></b>
                                    </div>
                                    <div id="comportamientoAnual" ex-highchart chart="chartComportaientoAnual" type="column"
                                        options="chartComportamientoOptions" style="height: 250px">
                                    </div>

                                    <div class="row text-center">
                                        <b><%= this.GetMessage("lblTotalCartera") %></b>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="table-responsive">
                                                <table class="table table-condensed" style="font-size: 10px; padding: 0">
                                                    <thead>
                                                        <tr>
                                                            <th></th>
                                                            <th ng-repeat="item in nombreMeses" class="text-right" style="padding: 2px">{{item.Name}}
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <%= this.GetMessage("lblVencida") %>
                                                            </td>
                                                            <td ng-repeat="item in monto" class="text-right" style="padding: 2px">{{item.MontoVencido/1000000 | number: 2}}
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <%= this.GetMessage("lblCorriente") %>
                                                            </td>
                                                            <td ng-repeat="item in monto" class="text-right" style="padding: 2px">{{item.MontoCorriente/1000000 | number: 2}}
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <%= this.GetMessage("lblTotal") %>
                                                            </td>
                                                            <td ng-repeat="item in monto" class="text-right" style="padding: 2px">{{item.Total | number: 2}}
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

                        <div ng-show="vista.vistaId === 2" class="row">
                            <tabla-cartera primer-columna="NombreCanal" columnas="columasCartera" datos="tablaCanales" />
                        </div>

                        <div ng-show="vista.vistaId === 3" class="row">
                            <div class="col-sm-12" ui-table="tablaClientes" st-fixed>
                                <table class="jsgrid-table" st-table="tablaClientes" st-safe-src="_tablaClientes"
                                    style="min-width: 950px">
                                    <thead>
                                        <tr>
                                            <th ui-field width="22">
                                                <%= this.GetMessage("gvReporte-NombreCliente") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-0Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-30Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-60Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-90Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-120Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-Total") %>
                                            </th>
                                            <th ui-field width="5"></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in tablaClientes">
                                            <td st-ratio="22">{{item.NombreCliente}}</td>
                                            <td class="text-right" st-ratio="10">{{item["0Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["30Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["60Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["90Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["120Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Total | currency}}</td>
                                            <td st-ratio="5"></td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td colspan="8">
                                                <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>

                        <div ng-show="vista.vistaId === 4" class="row">
                            <tabla-cartera primer-columna="NombreAnalista" columnas="columasCartera" datos="tablaAnalistas" />
                        </div>

                        <div ng-show="vista.vistaId === 5" class="row">
                            <div class="col-sm-12" ui-table="tablaVendedores" st-fixed>
                                <table class="jsgrid-table" st-table="tablaVendedores" st-safe-src="_tablaVendedores"
                                    style="min-width: 950px">
                                    <thead>
                                        <tr>
                                            <th ui-field width="22">
                                                <%= this.GetMessage("gvReporte-NombreVendedor") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-0Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-30Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-60Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-90Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-120Dias") %>
                                            </th>
                                            <th class="text-center" ui-field width="10">
                                                <%= this.GetMessage("gvReporte-Total") %>
                                            </th>
                                            <th ui-field width="5"></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in tablaVendedores">
                                            <td st-ratio="22">{{item.NombreVendedor}}</td>
                                            <td class="text-right" st-ratio="10">{{item["0Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["30Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["60Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["90Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item["120Dias"] | currency}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Total | currency}}</td>
                                            <td st-ratio="5"></td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td colspan="8">
                                                <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>

                        <div ng-show="vista.vistaId === 6" class="row">
                            <tabla-cartera primer-columna="NombreRegion" columnas="columasCartera" datos="tablaRegiones" />
                        </div>
                    </div>

                    <div ng-show="vistaPadreId == 2">
                        <br />
                        <div ng-show="vista.vistaId === 7" class="row">
                            <div class="col-sm-12" ng-show="esGrafica">
                                <div id="canalDia" ex-highchart chart="chartCanalDiasCalidad"
                                    type="" options="canalDiasCalidadOptions" style="height: 350px">
                                </div>
                            </div>

                            <div class="col-sm-12" ng-hide="esGrafica">
                                <tabla-calidad-dias datos="tablaCalidadDias" titulos="titulosCalidadDias" />
                            </div>
                        </div>

                        <div ng-show="vista.vistaId === 8" class="row">
                            <div class="col-sm-12" ui-table="calidadDiasCliente" st-fixed>
                                <table class="jsgrid-table" st-table="tablaCalidadDias" st-safe-src="_tablaCalidadDias"
                                    style="width: 1500px; min-width: 1500px">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblEne") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblFeb") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblMar") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblAbr") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblMay") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblJun") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblJul") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblAgo") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblSep") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblOct") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblNov") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetCommonMessage("lblDic") %>
                                            </th>
                                        </tr>

                                        <tr>
                                            <th ui-field width="22"></th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                            <th ui-field width="5" class="text-center">{{lblDias}}</th>
                                            <th ui-field width="5" class="text-center">{{lblCalidad}}</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in tablaCalidadDias">
                                            <td st-ratio="22">{{item.Nombre}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias1 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad1 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias2 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad2 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias3 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad3 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias4 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad4 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias5 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad5 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias6 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad6 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias7 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad7 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias8 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad8 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias9 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad9 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias10 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad10 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias11 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad11 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Dias12 | number}}</td>
                                            <td class="text-right" st-ratio="10">{{item.Calidad12 | number}}</td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td colspan="25">
                                                <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>

                        <div ng-show="vista.vistaId === 9" class="row">
                            <div class="col-md-12" ng-show="esGrafica">
                                <div id="regionDias" ex-highchart chart="chartRegionDiasCalidad"
                                    type="" options="regionDiasCalidadOptions" style="height: 350px">
                                </div>
                            </div>

                            <div class="col-sm-12" ng-hide="esGrafica">
                                <tabla-calidad-dias datos="tablaCalidadDias" titulos="titulosCalidadDias" />
                                <br />
                            </div>
                        </div>
                    </div>

                    <div ng-show="vistaPadreId === 3" class="row">
                        <div class="col-md-12" ng-show="esGrafica">
                            <div id="chartCobrabilidad" ui-highchart chart="chartCobrabilidad"
                                type="" options="chartCobrabilidadOptions" style="height: 350px">
                            </div>
                        </div>

                        <div class="col-sm-12" ng-hide="esGrafica">
                            <table style="width: 550px">
                                <tbody>
                                    <tr ng-repeat="cliente in cobrabilidad">
                                        <td>
                                            <table class="cobrabilidad">
                                                <tr style="background-color: #003d99">
                                                    <td colspan="2" style="width: 350px">
                                                        {{cliente.Nombre}}
                                                    </td>
                                                    <td class="text-center" style="width: 100px">
                                                        <%= this.GetMessage("lblValor") %>
                                                    </td>
                                                    <td class="text-center" style="width: 100px">
                                                        <%= this.GetMessage("lblPorcentaje") %>
                                                    </td>
                                                </tr>

                                                <tr class="totales">
                                                    <td colspan="2"><%= this.GetMessage("lblValor") %></td>
                                                    <td class="text-right">{{cliente.Descuento + cliente.Cobrabilidad | number:2}}</td>
                                                    <td class="text-right">100.00</td>
                                                </tr>

                                                <tr class="totales">
                                                    <td colspan="2"><%= this.GetMessage("lblDescuentos") %></td>
                                                    <td class="text-right">{{cliente.Descuento | number:2}}</td>
                                                    <td class="text-right">
                                                        {{cliente.Descuento * 100 /(cliente.Descuento + cliente.Cobrabilidad) | number:2}}
                                                    </td>
                                                </tr>

                                                <tr ng-repeat-start="descuento in cliente.TiposNotaCredito" 
                                                    style="background-color: #80b3ff">
                                                    <td rowspan="{{descuento.TiposDescuento.length + 1}}" style="width: 148px">
                                                        {{descuento.Nombre}}
                                                    </td>
                                                </tr>
                                                <tr ng-repeat-end ng-repeat="item in descuento.TiposDescuento">
                                                    <td style="background-color: #66cc66; width: 202px">{{item.Nombre}}</td>
                                                    <td class="text-right" style="color: black; font-weight: normal">
                                                        {{item.Descuento | number:2}}
                                                    </td>
                                                    <td class="text-right" style="color: black; font-weight: normal">
                                                        {{item.Descuento * 100 /cliente.Descuento | number:2}}
                                                    </td>
                                                </tr>
                                                
                                                <tr class="totales">
                                                    <td colspan="2">
                                                        <%= this.GetMessage("lblCobrabilidad") %> {{cliente.Nombre}}
                                                    </td>
                                                    <td class="text-right">{{cliente.Cobrabilidad | number:2}}</td>
                                                    <td class="text-right">
                                                        {{cliente.Cobrabilidad * 100 /(cliente.Descuento + cliente.Cobrabilidad) | number:2}}
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/repCarteraCierreMes.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
