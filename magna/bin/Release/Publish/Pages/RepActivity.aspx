<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepActivity.aspx.cs" Inherits="CYP.Pages.RepActivity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
     <div ng-controller="repActivity">
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
                                    <option value=""><%= this.GetMessage("lblSelectMonth") %></option>
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
                </div>

                <br />

                <div class="padding-form" style="padding-top: 0!important">
                    <div class="row" ng-show="sinInformacion">
                        <div class="col-sm-12 text-center">
                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                        </div>
                    </div>

                    <div ng-show="filtro.vistaId === 1 && !sinInformacion">
                    <div class="mail-box padding-10 wrapper border-bottom" id="Home">
                    <div ui-table="resumenActivity" st-fixed>
                    <table class="jsgrid-table" style="min-width: 950px">
                        <thead>
                            <tr>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblRubro")%>
                                </th>
                                 <th ui-field width="20">
                                    <%= this.GetMessage("lblPresupuestado")%>
                                </th>
                                 <th ui-field width="20">
                                    <%= this.GetMessage("lblEjecutado")%>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="item in Res">
                                <td st-ratio="20">{{item.Rubro}}
                                </td>
                                <td st-ratio="20">{{item.Presupuestado}}
                                </td>
                                <td st-ratio="20">{{item.Ejecutado}}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                    </div>
               </div>

                 <div id="Home" class="row" ng-show="filtro.vistaId === 2 && !sinInformacion" style="overflow-y: auto">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-condensed table-hover" st-table="tablaDetalle"
                                    st-safe-src="_tablaDetalle">
                                    <thead class="main-header">
                                        <tr>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblMarca")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblCodigoActividad")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblDescripcionActivity")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblCanal")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblCuenta")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblCuentaNombre")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblEstatus")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblMes")%>
                                            </th>
                                             <th ui-field width="20">
                                                <%= this.GetMessage("lblSaldoInicial")%>
                                            </th>
                                             <th ui-field width="20">
                                                <%= this.GetMessage("lblModificacion1")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblModificacion2")%>
                                            </th>
                                             <th ui-field width="20">
                                                <%= this.GetMessage("lblTotalActivity")%>
                                            </th>
                                             <th ui-field width="20">
                                                <%= this.GetMessage("lblTotalEjecutado")%>
                                            </th>
                                             <th ui-field width="20">
                                                <%= this.GetMessage("lblSaldoActivity")%>
                                            </th>
                                            </tr>
                                    </thead>

                                    <tbody>
                                    <tr ng-repeat="item in Reg">
                                        <td st-ratio="20">{{item.Marca}}
                                        </td>
                                        <td st-ratio="20">{{item.CodigoActivity}}
                                        </td>
                                        <td st-ratio="20">{{item.DescripcionActivity}}
                                        </td>
                                        <td st-ratio="20">{{item.Canal}}
                                        </td>
                                        <td st-ratio="20">{{item.Cuenta}}
                                        </td>
                                        <td st-ratio="20">{{item.CuentaNombre}}
                                        </td>
                                        <td st-ratio="20">{{item.EstatusActivity}}
                                        </td>
                                        <td st-ratio="20">{{item.Mes}}
                                        </td>
                                        <td st-ratio="20">{{item.SaldoInicial}}
                                        </td>
                                        <td st-ratio="20">{{item.Modificacion1}}
                                        </td>
                                        <td st-ratio="20">{{item.Modificacion2}}
                                        </td>
                                        <td st-ratio="20">{{item.TotalActivity}}
                                        </td>
                                        <td st-ratio="20">{{item.TotalEjecutado}}
                                        </td>
                                        <td st-ratio="20">{{item.SaldoActivity}}
                                        </td>
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
                </div>
            </div>
        </div>  
    </div>
    <script type="text/javascript" src="../scripts/pages/repActivity.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
