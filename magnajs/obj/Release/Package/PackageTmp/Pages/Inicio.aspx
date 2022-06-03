<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Inicio.aspx.cs" Inherits="CYP.Pages.Inicio" %>


<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="inicio">
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

                            <div class="clearfix visible-xs pt-5"><br /></div>

                            <div class="col-sm-5">
                                <select ng-model="filtro.MesId" class="form-control-select"
                                    ng-options="item.Id as item.Name for item in meses"
                                    ng-change="actualizar()">
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="clearfix visible-xs"><br /></div>

                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="actualizar()">
                            <div class="glyphicon glyphicon-refresh d-block"></div>
                            <%= this.GetMessage("btnActualizar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box padding-form">
                <div class="row" ng-show="sinInformacion">
                    <div class="col-sm-12 text-center">
                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                    </div>
                </div>

                <div ng-show="!sinInformacion">
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblVentas") %> </span>
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-md-5">
                            <table class="table table-condensed">
                                <tr class="text-center">
                                    <td><%= this.GetMessage("lblTotalVentas") %></td>
                                    <td><%= this.GetMessage("lblRechazos") %></td>
                                    <td><%= this.GetMessage("lblDescuentos") %></td>
                                </tr>

                                <tr class="text-center">
                                    <td class="text-right" ng-repeat="item in resumen">
                                        <span class="label-color">{{item.y | currency}}</span>
                                    </td>
                                </tr>

                                <tr>
                                    <td></td>
                                    <td class="text-right">
                                        <span class="label-color">{{porcentajeRechazo | number:2 }} %</span>
                                    </td>
                                    <td class="text-right">
                                        <span class="label-color">{{porcentajeDescuentos | number:2 }} %</span>
                                    </td>
                                </tr>
                            </table>

                            <%--  <div class="row">
                                <div class="col-sm-12">
                                    <b><%= this.GetMessage("lblVentasNetas") %></b>
                                </div>
                            </div>
                            <br />--%>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div id="cuentaCanal" ex-highchart chart="chartVentaNeta" type="column"
                                        options="ventaNetaOptions" style="height: 200px">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-7">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="row text-center">
                                        <b><%= this.GetMessage("lblVentasMarca") %></b> <%= this.GetMessage("lblMillones") %>
                                    </div>
                                    <div class="row">
                                        <div id="ventasMarca" ex-highchart chart="chartVentasMarca" type="pie"
                                            options="chartOptions" style="height: 250px">
                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-6">
                                    <div class="row text-center">
                                        <b><%= this.GetMessage("lblVentasCanal") %></b> <%= this.GetMessage("lblMillones") %>
                                    </div>
                                    <div class="row">
                                        <div id="ventasCanal" ex-highchart chart="chartVentasCanal" type="pie"
                                            options="chartOptions" style="height: 250px">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" ng-hide="true">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblCarteraAlDia") %></span>
                        </div>
                    </div>

                    <div class="row" ng-hide="true">
                        <div class="col-md-6" ng-repeat="canal in canales">
                            <div class="row">
                                <div class="col-sm-12 text-center">
                                    <span>{{canal.Grupo}}</span>
                                </div>
                            </div>
                            <br />
                            <table class="table table-hover table-striped table-condensed">
                                <thead>
                                    <tr class="text-center">
                                        <th><%= this.GetMessage("lblSubCanal") %></th>
                                        <th><%= this.GetMessage("lblTotal") %></th>
                                        <th><%= this.GetMessage("lblCorriente") %></th>
                                        <th>%</th>
                                        <th><%= this.GetMessage("lblVencido") %></th>
                                        <th>%</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr ng-repeat="item in canal.Subcanales">
                                        <td>{{item.NombreCanal}}</td>
                                        <td class="text-right">{{item.Monto | number:2}}</td>
                                        <td class="text-right">{{item.Corriente | number:2}}</td>
                                        <td class="text-right">{{item.PorcentajeCorriente | number:2}}</td>
                                        <td class="text-right">{{item.Vencido | number:2}}</td>
                                        <td class="text-right">{{item.PorcentajeVencido | number:2}}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/inicio.js"></script>

</asp:Content>

