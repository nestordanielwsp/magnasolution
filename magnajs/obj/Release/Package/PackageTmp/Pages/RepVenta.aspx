<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepVenta.aspx.cs" Inherits="CYP.Pages.RepVenta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repVenta">
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

                            <div class="col-sm-5">
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
                            <label><%= this.GetMessage("lblMarca") %></label>
                            <select ng-model="filtro.LineaCodigo" class="form-control-select"
                                ng-options="item.LineaCodigo as item.NombreMarca for item in marcas"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>                 
                </div>
                
                 <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblProducto") %> </label>
                            <ex-autocomplete ng-model="filtro.ProductoId" options="productoOptions"
                                on-select="actualizar()" clean-button />
                        </div>
                    </div>               
                </div>
            </div>

            <div class="mail-box">
                <div class="row">
                    <div class="col-sm-8">
                        <ul class="nav nav-tabs" style="font-size: 14px">
                            <li ng-repeat="item in vistas" ng-class="{'active': vista.vistaId === item.vistaId}">
                                <a class="pointer" ng-click="cambiarVista(item)">{{item.name}}
                                </a>
                            </li>
                        </ul>
                    </div>

                    <div class="col-sm-4 text-right" ng-show="vista.graficaTabla">
                        <button type="button" class="btn btn-link" ng-click="esGrafica = true">
                            <img src="../images/chart.png" />
                        </button>
                        <button type="button" class="btn btn-link" ng-click="esGrafica = false">
                            <img src="../images/table.png" />
                        </button>
                    </div>
                </div>

                <br />

                <div class="row" ng-show="sinInformacion">
                    <div class="col-sm-12 text-center">
                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                    </div>
                </div>

                <div class="padding-form pt-0" id="Home" ng-show="!sinInformacion">
                    <div ng-show="vista.vistaId === 1">
                        <div class="row">
                            <div class="col-md-5">
                                <table class="table table-condensed">
                                    <tr class="text-center">
                                        <td><%= this.GetMessage("lblTotalVentas") %></td>
                                        <td><%= this.GetMessage("lblCanalModerno") %></td>
                                        <td><%= this.GetMessage("lblCanalTradiciona") %></td>
                                    </tr>

                                    <tr class="text-center">
                                        <td class="text-right">
                                            <span class="label-color">{{totalVentas | currency }}</span>
                                        </td>
                                        <td class="text-right">
                                            <span class="label-color">{{ventasModerno | currency }}</span>
                                        </td>
                                        <td class="text-right">
                                            <span class="label-color">{{ventasTradicional | currency }}</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td></td>
                                        <td class="text-right">
                                            <span class="label-color">{{porcentajeModerno | number:2 }} %</span>
                                        </td>
                                        <td class="text-right">
                                            <span class="label-color">{{porcentajeTradicional | number:2 }} %</span>
                                        </td>
                                    </tr>
                                </table>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div id="cuentaCanal" ex-highchart chart="chartVenta" type="column"
                                            options="ventaOptions" style="height: 200px">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-7">
                                <div class="row text-center">
                                    <b><%= this.GetMessage("lblVentasRegion") %></b>
                                </div>
                                <div id="ventasRegion" ex-highchart chart="chartVentaRegion" type="column"
                                    options="regionOptions" style="height: 300px">
                                </div>
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-5">
                                <div class="row text-center">
                                    <b><%= this.GetMessage("lblTopClientes") %></b>
                                </div>
                                <div id="ventasCliente" ex-highchart chart="chartTopCliente" type="bar"
                                    options="clienteOptions" style="height: 250px">
                                </div>
                            </div>

                            <div class="col-md-7">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="row text-center">
                                            <b><%= this.GetMessage("lblVentasMarca") %></b>
                                        </div>
                                        <div class="row">
                                            <div id="ventasMarca" ex-highchart chart="chartVentasMarca" type="pie"
                                                options="chartOptions" style="height: 250px">
                                            </div>
                                        </div>

                                    </div>

                                    <div class="col-md-6">
                                        <div class="row text-center">
                                            <b><%= this.GetMessage("lblVentasCanal") %></b>
                                        </div>
                                        <br />
                                        <div class="row">
                                            <div id="ventasCanal" ex-highchart chart="chartVentasCanal" type="pie"
                                                options="chartOptions" style="height: 250px">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div ng-show="vista.vistaId === 2">
                        <div class="row" ng-show="esGrafica">
                            <div class="col-sm-12 text-center">
                                <h4><%= this.GetMessage("lblVentas") %></h4>
                            </div>
                            <div class="col-sm-12">
                                <div id="comparativoCanal" ex-highchart chart="chartCanal" type=""
                                    options="chartCanalOptions" style="height: 450px">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="table-responsive" ng-hide="esGrafica">
                                    <table class="table table-striped table-condensed table-hover">
                                        <thead>
                                            <tr class="jsgrid-header-row">
                                                <th>
                                                    <%= this.GetMessage("gvReporte-Canal") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-AnioActual") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-AnioAnterior") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-Variacion") %>
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr ng-repeat="item in tablaCanales">
                                                <td>{{item.name}}</td>
                                                <td class="text-right">{{item.AnioActual | currency}}</td>
                                                <td class="text-right">{{item.AnioAnterior | currency}}</td>
                                                <td class="text-right">{{item.Variacion | number:2}}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div ng-show="vista.vistaId === 3">
                        <div class="row">
                            <div class="col-sm-12" ui-table="tablaClientes" st-fixed>
                                <table class="jsgrid-table" st-table="tablaClientes" st-safe-src="_tablaClientes"
                                    style="min-width: 800px">
                                    <thead>
                                        <tr>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("gvReporte-CobrarA") %>
                                            </th>
                                            <th ui-field width="30">
                                                <%= this.GetMessage("gvReporte-Cliente") %>
                                            </th>
                                            <th ui-field width="20" class="text-center">
                                                <%= this.GetMessage("gvReporte-AnioActual") %>
                                            </th>
                                            <th ui-field width="20" class="text-center">
                                                <%= this.GetMessage("gvReporte-AnioAnterior") %>
                                            </th>
                                            <th ui-field width="20" class="text-center">
                                                <%= this.GetMessage("gvReporte-Variacion") %>
                                            </th>
                                            <th ui-field width="5"></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in tablaClientes">
                                            <td st-ratio="10">{{item.CobrarA}}</td>
                                            <td st-ratio="30">{{item.name}}</td>
                                            <td st-ratio="20" class="text-right">{{item.AnioActual | currency}}</td>
                                            <td st-ratio="20" class="text-right">{{item.AnioAnterior | currency}}</td>
                                            <td st-ratio="15" class="text-right">{{item.Variacion | number:2}}</td>
                                            <td st-ratio="5"></td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td colspan="5">
                                                <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div ng-show="vista.vistaId === 4">
                        <div class="row" ng-show="esGrafica">
                            <div class="col-sm-12 text-center">
                                <h4><%= this.GetMessage("lblVentas") %></h4>
                            </div>
                            <div class="col-sm-12">
                                <div id="comparativoMarca" ex-highchart chart="chartMarca" type=""
                                    options="chartMarcaOptions" style="height: 450px">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="table-responsive" ng-hide="esGrafica">
                                    <table class="table table-striped table-condensed table-hover">
                                        <thead>
                                            <tr class="jsgrid-header-row">
                                                <th>
                                                    <%= this.GetMessage("gvReporte-Subcuenta") %>
                                                </th>
                                                <th>
                                                    <%= this.GetMessage("gvReporte-Marca") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-AnioActual") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-AnioAnterior") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-Variacion") %>
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr ng-repeat="item in tablaMarcas">
                                                <td>{{item.Subcuenta}}</td>
                                                <td>{{item.name}}</td>
                                                <td class="text-right">{{item.AnioActual | currency}}</td>
                                                <td class="text-right">{{item.AnioAnterior | currency}}</td>
                                                <td class="text-right">{{item.Variacion | number:2}}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div ng-show="vista.vistaId === 5">
                        <div class="row">
                            <div class="col-sm-12" ui-table="tablaVendedores" st-fixed>
                                <table class="jsgrid-table" st-table="tablaVendedores" st-safe-src="_tablaVendedores"
                                    style="min-width: 800px">
                                    <thead>
                                        <tr>
                                            <th ui-field width="40">
                                                <%= this.GetMessage("gvReporte-Vendedor") %>
                                            </th>
                                            <th ui-field width="20" class="text-center">
                                                <%= this.GetMessage("gvReporte-AnioActual") %>
                                            </th>
                                            <th ui-field width="20" class="text-center">
                                                <%= this.GetMessage("gvReporte-AnioAnterior") %>
                                            </th>
                                            <th ui-field width="15" class="text-center">
                                                <%= this.GetMessage("gvReporte-Variacion") %>
                                            </th>
                                            <th ui-field width="5"></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in tablaVendedores">
                                            <td st-ratio="40">{{item.name}}</td>
                                            <td st-ratio="20" class="text-right">{{item.AnioActual | currency}}</td>
                                            <td st-ratio="20" class="text-right">{{item.AnioAnterior | currency}}</td>
                                            <td st-ratio="15" class="text-right">{{item.Variacion | number:2}}</td>
                                            <td st-ratio="5"></td>
                                        </tr>
                                    </tbody>

                                    <tfoot>
                                        <tr>
                                            <td colspan="5">
                                                <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div ng-show="vista.vistaId === 6">
                        <div class="row" ng-show="esGrafica">
                            <div class="col-sm-12 text-center">
                                <b><%= this.GetMessage("lblVentas") %></b>
                            </div>
                            <div class="col-sm-12">
                                <div id="comparativoRegion" ex-highchart chart="chartRegion" type=""
                                    options="chartRegionOptions" style="height: 450px">
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="table-responsive" ng-hide="esGrafica">
                                    <table class="table table-striped table-condensed table-hover">
                                        <thead>
                                            <tr class="jsgrid-header-row">
                                                <th>
                                                    <%= this.GetMessage("gvReporte-Region") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-AnioActual") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-AnioAnterior") %>
                                                </th>
                                                <th class="text-center">
                                                    <%= this.GetMessage("gvReporte-Variacion") %>
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <tr ng-repeat="item in tablaRegiones">
                                                <td>{{item.name}}</td>
                                                <td class="text-right">{{item.AnioActual | currency}}</td>
                                                <td class="text-right">{{item.AnioAnterior | currency}}</td>
                                                <td class="text-right">{{item.Variacion | number:2}}</td>
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

    <script type="text/javascript" src="../scripts/pages/repVenta.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
