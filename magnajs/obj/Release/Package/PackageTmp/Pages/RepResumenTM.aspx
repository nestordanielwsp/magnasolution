<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepResumenTM.aspx.cs" Inherits="CYP.Pages.RepResumenTM" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">

    <div ng-controller="repResumenTM">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div id="Home" class="padding-10 wrapper border-bottom">
                <div class="filter mail-box filtros">
                    <div class="row p-5">
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                                </div>
                                <div class="clearfix visible-sm visible-xs pt-5"></div>
                                <div class="col-md-1">
                                    <label class="label-filter"><%= this.GetMessage("lblYear") %></label>
                                </div>
                                <div class="col-md-2">
                                    <select
                                        class="form-control form-control-select"
                                        ng-model="filtro.Anio" required
                                        ng-options="anio as anio for anio in Year">
                                        <option value=""><%= this.GetMessage("lblSelect") %></option>
                                    </select>
                                </div>

                                <div class="col-md-1">
                                    <label class="label-filter"><%= this.GetMessage("lblMarca") %></label>
                                </div>
                                <div class="col-md-3">
                                    <div style="margin-top: 10px" selected-model="filtro.Marcas" options="marcas" extra-settings="marcasOptions"
                                        translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="" events="multiselectEventos">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix visible-xs">
                            <br />
                        </div>

                        <div class="col-md-4 text-right">
                            <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros" ng-show="filtro.vistaId !== 1">
                                <i class="glyphicon glyphicon-filter d-block"></i>
                                <%= this.GetCommonMessage("btnAvanzado") %>
                            </button>
                            <button type="button" class="btn btn-link" ng-click="Buscar();">
                                <div class="glyphicon glyphicon-search d-block"></div>
                                <%= this.GetCommonMessage("btnBuscar") %>
                            </button>
                            <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                                <i class="glyphicon glyphicon-download-alt d-block"></i>
                                <%= this.GetMessage("btnExcel") %>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="mail-box filtros-avanzados" ng-show="esVerFiltros && filtro.vistaId !== 1">
                    <div class="row">
                        <div class="col-sm-4" ng-show="filtro.vistaId === 2">
                            <label><%= this.GetMessage("lblActivity") %></label>
                            <input type="text" ng-model="filtro.Activity" class="form-control-input" key-enter="Buscar()" />
                        </div>

                        <div class="col-sm-4">
                            <label><%= this.GetMessage("lblCanal") %></label>
                            <div selected-model="filtro.Canales" options="canalesVisual" extra-settings="canalesOptions"
                                translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                            </div>
                        </div>

                        <div class="col-sm-4">
                            <label><%= this.GetMessage("lblEstatus") %> </label>
                            <div selected-model="filtro.Estatus" options="estatus" extra-settings="estatusOptions"
                                translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>
                </div>


                <div class="mail-box padding-form">
                    <div class="row">
                        <div class="col-sm-8">
                            <ul class="nav nav-tabs" style="font-size: 14px">
                                <li ng-repeat="item in vistas" ng-class="{'active': filtro.vistaId === item.vistaId}">
                                    <a class="pointer" ng-click="cambiarVista(item)">{{item.name}}
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="row" ng-show="filtro.vistaId === 1">
                        <div class="col-sm-12">
                            <div style="overflow-x: auto">
                                <table class="reporte-tm">
                                    <thead>
                                        <tr>
                                            <th style="min-width: 170px"><%= this.GetMessage("lblMarca") %></th>
                                            <th style="min-width: 250px"><%= this.GetMessage("lblConcepto") %></th>
                                            <th style="min-width: 80px"><%= this.GetMessage("lblCuenta") %></th>
                                            <th style="min-width: 150px"><%= this.GetMessage("lblUltimaAprobacionDg") %></th>
                                            <th style="min-width: 120px"><%= this.GetMessage("lblProyeccionTM") %></th>
                                            <th style="min-width: 125px">
                                                <%= this.GetMessage("lblRealEjecutado") %>
                                                <i class="fa pointer" ng-click="verMesesTM = !verMesesTM"
                                                    ng-class="{'fa-plus': !verMesesTM, 'fa-minus': verMesesTM}"></i>
                                            </th>
                                            <th style="min-width: 80px" ng-repeat="mes in Meses" ng-show="verMesesTM">{{mes.Name}}
                                            </th>
                                            <th style="min-width: 120px; width: 120px"><%= this.GetMessage("lblModificacion") %></th>
                                            <th style="min-width: 120px"><%= this.GetMessage("lblGastoFuturo") %></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr class="total-marca text-right" ng-repeat-start="marca in resumenTm">
                                            <td class="text-left">
                                                <i class="fa pointer" style="padding-right: 10px" ng-click="marca.Collapsed = !marca.Collapsed" ng-if="!marca.EsTotal"
                                                    ng-class="{'fa-chevron-right': marca.Collapsed, 'fa-chevron-down': !marca.Collapsed}"></i>
                                                {{marca.Nombre}} 
                                            </td>
                                            <td></td>
                                            <td><%= this.GetMessage("lblTotal") %></td>
                                            <td>{{marca.Presupuesto | number:2}}</td>
                                            <td>{{marca.Importe | number:2}}</td>
                                            <td>{{marca.Ejecutado | number:2}}</td>
                                            <td ng-repeat="mes in Meses" ng-show="verMesesTM">{{marca.EjecutadoPorMes[$index]}}
                                            </td>
                                            <td>{{marca.Modificacion | number:2}}</td>
                                            <td>{{marca.Importe + marca.Modificacion - marca.Ejecutado | number:2}}</td>
                                        </tr>
                                        <tr ng-hide="marca.Collapsed || marca.EsTotal">
                                            <td class="text-center tm-marca" style="border-right: 3px solid white">{{marca.Nombre}}</td>
                                            <td colspan="{{verMesesTM? 19: 7}}" style="padding: 0">
                                                <table>
                                                    <tr class="tm-header text-right" ng-repeat-start="concepto in marca.Conceptos">
                                                        <td class="text-left" style="min-width: 250px">
                                                            <i class="fa pointer" style="padding-right: 10px" ng-click="concepto.Collapsed = !concepto.Collapsed"
                                                                ng-class="{'fa-chevron-right': concepto.Collapsed, 'fa-chevron-down': !concepto.Collapsed}"></i>
                                                            {{concepto.Nombre}}
                                                        </td>
                                                        <td class="text-left" style="width: 80px"></td>
                                                        <td style="min-width: 150px">{{concepto.Presupuesto | number:2}}</td>
                                                        <td style="min-width: 120px">{{concepto.Importe | number:2}}</td>
                                                        <td style="min-width: 125px">{{concepto.Ejecutado | number:2}}</td>
                                                        <td style="min-width: 80px" ng-repeat="mes in Meses" ng-show="verMesesTM">{{concepto.EjecutadoPorMes[$index]}}
                                                        </td>
                                                        <td style="min-width: 120px">{{concepto.Modificacion | number:2}}</td>
                                                        <td style="min-width: 120px">{{concepto.Importe + concepto.Modificacion - concepto.Ejecutado | number:2}}</td>
                                                    </tr>

                                                    <tr class="tm-cuenta text-right" ng-repeat-end ng-repeat="cuenta in concepto.Cuentas" ng-hide="concepto.Collapsed">
                                                        <td class="text-left">{{cuenta.Nombre}}</td>
                                                        <td class="text-center">{{cuenta.Cuenta}}</td>
                                                        <td>{{cuenta.Presupuesto | number:2}}</td>
                                                        <td>{{cuenta.Importe | number:2}}</td>
                                                        <td>{{cuenta.Ejecutado | number:2}}</td>
                                                        <td ng-repeat="mes in Meses" ng-show="verMesesTM">{{cuenta.EjecutadoPorMes[$index]}}
                                                        </td>
                                                        <td>{{cuenta.Modificacion | number:2}}</td>
                                                        <td>{{cuenta.Importe + cuenta.Modificacion - cuenta.Ejecutado | number:2}}</td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>

                                        <tr ng-repeat-end style="height: 3px"></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="padding-10 wrapper border-bottom" ng-show="filtro.vistaId === 2">
                        <div class="padding-form" style="padding-top: 0!important">
                            <div class="row" ng-show="sinInformacion">
                                <div class="col-sm-12 text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </div>
                            </div>

                            <div ui-table="resumenActivity" st-fixed ng-hide="sinInformacion || verMesesVista2">
                                <table class="jsgrid-table" style="min-width: 1600px">
                                    <thead>
                                        <tr class="text-center">
                                            <th ui-field width="3"><%= this.GetMessage("lblMarca")%></th>
                                            <th ui-field width="4"><%= this.GetMessage("lblCodigoActividad")%></th>
                                            <th ui-field width="5"><%= this.GetMessage("lblDescripcionActivity")%></th>
                                            <th ui-field width="5"><%= this.GetMessage("lblCanal")%></th>
                                            <th ui-field width="2"><%= this.GetMessage("lblCuenta")%></th>
                                            <th ui-field width="7"><%= this.GetMessage("lblCuentaNombre")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblEstatus") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblSaldoInicial")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblModificacion1")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblModificacion2")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblTotalActivity")%></th>
                                            <th ui-field width="5">
                                                <%= this.GetMessage("lblTotalEjecutado")%>
                                                <i class="fa pointer" ng-click="verMesesVista2 = !verMesesVista2"
                                                    ng-class="{'fa-plus': !verMesesVista2, 'fa-minus': verMesesVista2}"></i>
                                            </th>
                                            <th ui-field width="3"><%= this.GetMessage("lblSaldoActivity")%>
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in Reg">
                                            <td st-ratio="3">{{item.Marca}}</td>
                                            <td st-ratio="4">{{item.CodigoActivity}}</td>
                                            <td st-ratio="5">{{item.DescripcionActivity}}</td>
                                            <td st-ratio="5">{{item.Canal}}</td>
                                            <td st-ratio="2">{{item.Cuenta}}</td>
                                            <td st-ratio="7">{{item.NombreCuenta}}</td>
                                            <td st-ratio="3">{{item.Estatus}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.Comprometido | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.Adicion | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.Recorte | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.TotalActivity | number:2}}</td>
                                            <td st-ratio="5" class="text-rigth">{{item.Ejecutado | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.SaldoActivity | number:2}}</td>
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

                            <div ui-table="resumenActivityMeses" st-fixed ng-hide="sinInformacion || !verMesesVista2">
                                <table class="jsgrid-table" style="min-width: 3000px">
                                    <thead>
                                        <tr class="text-center">
                                            <th ui-field width="3"><%= this.GetMessage("lblMarca")%></th>
                                            <th ui-field width="4"><%= this.GetMessage("lblCodigoActividad")%></th>
                                            <th ui-field width="5"><%= this.GetMessage("lblDescripcionActivity")%></th>
                                            <th ui-field width="5"><%= this.GetMessage("lblCanal")%></th>
                                            <th ui-field width="2"><%= this.GetMessage("lblCuenta")%></th>
                                            <th ui-field width="7"><%= this.GetMessage("lblCuentaNombre")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblEstatus") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblSaldoInicial")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblModificacion1")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblModificacion2")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblTotalActivity")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes1")%></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes2") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes3") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes4") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes5") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes6") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes7") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes8") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes9") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes10") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes11") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("lblMes12") %></th>
                                            <th ui-field width="5">
                                                <%= this.GetMessage("lblTotalEjecutado")%>
                                                <i class="fa pointer" ng-click="verMesesVista2 = !verMesesVista2"
                                                    ng-class="{'fa-plus': !verMesesVista2, 'fa-minus': verMesesVista2}"></i>
                                            </th>
                                            <th ui-field width="3"><%= this.GetMessage("lblSaldoActivity")%>
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in Reg">
                                            <td st-ratio="3">{{item.Marca}}</td>
                                            <td st-ratio="4">{{item.CodigoActivity}}</td>
                                            <td st-ratio="5">{{item.DescripcionActivity}}</td>
                                            <td st-ratio="5">{{item.Canal}}</td>
                                            <td st-ratio="2">{{item.Cuenta}}</td>
                                            <td st-ratio="7">{{item.NombreCuenta}}</td>
                                            <td st-ratio="3">{{item.Estatus}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.Comprometido | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.Adicion | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.Recorte | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.TotalActivity | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.ENE | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.FEB | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.MAR | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.ABR | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.MAY | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.JUN | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.JUL | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.AGO | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.SEP | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.OCT | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.NOV | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.DIC | number:2}}</td>
                                            <td st-ratio="5" class="text-rigth">{{item.Ejecutado | number:2}}</td>
                                            <td st-ratio="3" class="text-rigth">{{item.SaldoActivity | number:2}}</td>
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

                    <div class="padding-10 wrapper border-bottom" ng-show="filtro.vistaId === 3">
                        <div ui-table="resumenActivity" st-fixed>
                            <table class="jsgrid-table" style="min-width: 1000px">
                                <thead>
                                    <tr class="jsgrid-header-row">
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblMarca") %>
                                        </th>
                                        <th ui-field width="15">
                                            <%= this.GetMessage("lblDescripcionActivity") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblCanal") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblImporte") %>
                                        </th>
                                        <th ui-field width="5">
                                            <%= this.GetMessage("lblYear") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblEstatus") %>
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr ng-repeat="item in ProcesoCancelado">
                                        <td width="10">{{item.Marca}}</td>
                                        <td width="15">{{item.DescripcionActivity}}</td>
                                        <td width="5">{{item.Canal}}</td>
                                        <td width="10">{{item.Importe | currency}}</td>
                                        <td width="5">{{item.Anio}}</td>
                                        <td width="10">{{item.Estatus}}</td>
                                    </tr>
                                    <tr ng-if="ProcesoCancelado.length == 0" class="nodata-row">
                                        <td colspan="8" class="text-center">
                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div id="RepRealEjecutado" class="padding-10 wrapper border-bottom" ng-show="filtro.vistaId === 4">
                        <div class="table-responsive mail-box" style="height: 250pt;">
                            <table class="activity-table" style="min-width: 1632px">
                                <thead>
                                    <tr class="jsgrid-header-row">
                                        <th ui-field width="30">
                                            <%= this.GetMessage("gvRealEjecutado-Marca") %>
                                        </th>
                                        <th ui-field width="20">
                                            <%= this.GetMessage("gvRealEjecutado-Cuenta") %>
                                        </th>
                                        <th ui-field width="250">
                                            <%= this.GetMessage("gvRealEjecutado-CuentaContable") %>
                                        </th>
                                        <th ui-field width="100">
                                            <%= this.GetMessage("gvRealEjecutado-Descripcion") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(1)">
                                            <%= this.GetMessage("gvRealEjecutado-Enero") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(2)">
                                            <%= this.GetMessage("gvRealEjecutado-Febrero") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(3)">
                                            <%= this.GetMessage("gvRealEjecutado-Marzo") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(4)">
                                            <%= this.GetMessage("gvRealEjecutado-Abril") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(5)">
                                            <%= this.GetMessage("gvRealEjecutado-Mayo") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(6)">
                                            <%= this.GetMessage("gvRealEjecutado-Junio") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(7)">
                                            <%= this.GetMessage("gvRealEjecutado-Julio") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(8)">
                                            <%= this.GetMessage("gvRealEjecutado-Agosto") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(9)">
                                            <%= this.GetMessage("gvRealEjecutado-Septiembre") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(10)">
                                            <%= this.GetMessage("gvRealEjecutado-Octubre") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(11)">
                                            <%= this.GetMessage("gvRealEjecutado-Noviembre") %>
                                        </th>
                                        <th ui-field width="15" ng-if="MostrarColumnaMes(12)">
                                            <%= this.GetMessage("gvRealEjecutado-Diciembre") %>
                                        </th>
                                        <th ui-field width="15">
                                            <%= this.GetMessage("gvRealEjecutado-Total") %>
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr ng-repeat="item in DetalleRealEjecutado">
                                        <td width="30"><span ng-show="item.MostrarMarca">{{item.Marca}}</td>
                                        <td width="20"><span ng-show="item.MostrarCuenta">{{item.Cuenta}}</td>
                                        <td width="250">{{item.CuentaContable}}</td>
                                        <td width="100">{{item.Descripcion}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(1)">{{item.Enero | currency}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(2)">{{item.Febrero | currency}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(3)">{{item.Marzo | currency }}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(4)">{{item.Abril | currency }}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(5)">{{item.Mayo | currency }}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(6)">{{item.Junio | currency }}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(7)">{{item.Julio | currency }}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(8)">{{item.Agosto | currency}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(9)">{{item.Septiembre | currency}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(10)">{{item.Octubre | currency}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(11)">{{item.Noviembre | currency}}</td>
                                        <td width="15" ng-if="MostrarColumnaMes(12)">{{item.Diciembre | currency}}</td>
                                        <td width="15">{{item.Total | currency}}</td>
                                    </tr>
                                    <tr ng-if="DetalleRealEjecutado.length == 0" class="nodata-row">
                                        <td colspan="17" class="text-center">
                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
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
    <script src="../Scripts/pages/repResumenTM.js?v=1.2.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
