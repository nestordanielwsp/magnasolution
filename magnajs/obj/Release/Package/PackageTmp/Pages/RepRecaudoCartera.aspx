<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepRecaudoCartera.aspx.cs" Inherits="CYP.Pages.RepRecaudoCartera" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repRecaudoCartera">
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
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <i class="glyphicon glyphicon-download-alt d-block"></i>
                            <%= this.GetMessage("btnExcel") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box">
                <div class="row">
                    <div class="col-sm-12 text-right">
                        <button type="button" class="btn btn-link" ng-click="esGrafica = true">
                            <img src="../images/chart.png" />
                        </button>
                        <button type="button" class="btn btn-link" ng-click="esGrafica = false">
                            <img src="../images/table.png" />
                        </button>
                    </div>
                </div>

                <div class="row" ng-show="sinInformacion">
                    <div class="col-sm-12 text-center">
                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                    </div>
                </div>

                <div id="Home" class="padding-form" ng-show="!sinInformacion" style="padding-top: 0!important">
                    <div class="row" ng-show="esGrafica">
                        <div class="col-md-7">
                            <div class="row">
                                <div class="col-sm-12 text-center">
                                    <h4><%= this.GetMessage("lblEvolucionRecaudo") %></h4>
                                </div>
                                <div class="col-sm-12">
                                    <div id="evolucion" ex-highchart chart="chartEvolucion" type="line"
                                        options="chartEvolucionOptions" style="height: 300px">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="row">
                                <div class="col-sm-12 text-center">
                                    <h4><%= this.GetMessage("lblParticipacionCanal") %> ({{mes}})</h4>
                                </div>
                                <div class="col-sm-12">
                                    <div id="recaudoPorCanal" class="normal-size" ex-highchart chart="chartCanal"
                                        type="pie" options="chartOptions" style="height: 300px">
                                    </div>
                                    <div id="recaudoPorCanalM" class="mobile-size" ex-highchart chart="chartCanalMobile"
                                        type="pie" options="chartOptionsMobile" style="height: 300px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div ng-hide="esGrafica" class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-condensed table-hover">
                                    <thead>
                                        <tr style="background-color: #f0f5f5">
                                            <th>
                                                <%= this.GetMessage("gvReporte-NombreCanal") %>
                                            </th>
                                            <th class="text-center cell-separator" colspan="2">
                                                <%= this.GetMessage("gvReporte-Semana1") %>
                                            </th>
                                            <th class="text-center cell-separator" colspan="2">
                                                <%= this.GetMessage("gvReporte-Semana2") %>
                                            </th>
                                            <th class="text-center cell-separator" colspan="2">
                                                <%= this.GetMessage("gvReporte-Semana3") %>
                                            </th>
                                            <th class="text-cente cell-separator" colspan="2">
                                                <%= this.GetMessage("gvReporte-Semana4") %>
                                            </th>
                                            <th class="text-center" colspan="2">
                                                <%= this.GetMessage("gvReporte-Total") %>
                                            </th>
                                            <th></th>
                                        </tr>

                                        <tr class="jsgrid-header-row">
                                            <th></th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Objetivo") %>
                                            </th>
                                            <th class="text-center cell-separator">
                                                <%= this.GetMessage("gvReporte-Real") %>
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Objetivo") %>
                                            </th>
                                            <th class="text-center cell-separator">
                                                <%= this.GetMessage("gvReporte-Real") %>
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Objetivo") %>
                                            </th>
                                            <th class="text-center cell-separator">
                                                <%= this.GetMessage("gvReporte-Real") %>
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Objetivo") %>
                                            </th>
                                            <th class="text-center cell-separator">
                                                <%= this.GetMessage("gvReporte-Real") %>
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Objetivo") %>
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Real") %>
                                            </th>
                                            <th class="text-center">
                                                <%= this.GetMessage("gvReporte-Variacion") %>
                                            </th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <tr ng-repeat="item in tablaCanales">
                                            <td>{{item.NombreCanal}}</td>
                                            <td class="text-right">{{item.Objetivo1 | currency}}</td>
                                            <td class="text-right cell-separator">{{item.Real1 | currency}}</td>
                                            <td class="text-right">{{item.Objetivo2 | currency}}</td>
                                            <td class="text-right cell-separator">{{item.Real2 | currency}}</td>
                                            <td class="text-right">{{item.Objetivo3 | currency}}</td>
                                            <td class="text-right cell-separator">{{item.Real3 | currency}}</td>
                                            <td class="text-right">{{item.Objetivo4 | currency}}</td>
                                            <td class="text-right cell-separator">{{item.Real4 | currency}}</td>
                                            <td class="text-right">{{item.ObjetivoTotal | currency}}</td>
                                            <td class="text-right">{{item.RealTotal | currency}}</td>
                                            <td class="text-right">{{item.Variacion | currency}}</td>
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

    <script type="text/javascript" src="../scripts/pages/repRecaudoCartera.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
