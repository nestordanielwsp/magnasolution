<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepDashboard.aspx.cs" Inherits="CYP.Pages.RepDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="dashboardController as vm">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box">
                <div class="row p-5">
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-sm-2">
                                <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-xs visible-xs pt-5"></div>

                            <div class="col-sm-2 col-md-1">
                                <label class="label-filter"><%= this.GetMessage("lblFecha") %></label>
                            </div>

                            <div class="col-sm-8 col-md-4">
                                <datepicker-range ng-model="filtro.Fecha" input-class="form-control-input" />
                            </div>

                            <div class="col-sm-2 col-md-1">
                                <label class="label-filter"><%= this.GetMessage("lblMarca") %></label>
                            </div>

                            <div class="col-sm-8 col-md-4">
                                <div selected-model="filtro.Marcas" options="marcas" extra-settings="marcasOptions"
                                     translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-sm-2 text-right">
                        <button type="button" class="btn btn-link" ng-click="actualizar()" style="padding: 0 12px">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box padding-10 wrapper">
                <div class="row">
                    <div class="col-sm-6 col-lg-3 text-center">
                        <label><%= this.GetMessage("lblTotalActivities") %></label>
                        <div class="form-group">
                            <label class="dashboard-subtitulo">{{Dashboard.TotalActivities | number}}</label>
                        </div>
                    </div>

                    <div class="col-sm-6 col-lg-3 text-center">
                        <label><%= this.GetMessage("lblMontoActivities") %></label>
                        <div class="form-group">
                            <label class="dashboard-subtitulo">{{Dashboard.MontoActivities | currency }}</label>
                        </div>
                    </div>

                    <div class="col-sm-6 col-lg-3 text-center">
                        <label><%= this.GetMessage("lblMontoEjecutado") %></label>
                        <div class="form-group">
                            <div class="col-xs-7">
                                <label class="dashboard-subtitulo">{{Dashboard.MontoEjecutado | currency }}  </label>
                            </div>
                            <div class="col-xs-5">
                                <label style="color: #0ba457; font-size: 15px; font-weight: bold">
                                    {{Dashboard.Porcentaje | number :1  }} %
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-lg-3 text-center">
                        <label><%= this.GetMessage("lblMontoEnAutorizacion") %></label>
                        <div class="form-group">
                            <label class="dashboard-subtitulo">{{Dashboard.MontoEnAutorizacion | currency }}</label>
                        </div>
                    </div>
                </div>

                <div class="row mb">
                    <div class="col-md-5">
                        <div class="row text-center">
                            <b><%= this.GetMessage("TituloPptoPorRubro") %></b>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div id="presupuestoRubro" ex-highchart chart="chartPptoRubro" type="pie"
                                     options="chartPieOptions" style="height: 250px">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-7">
                        <div class="row text-center">
                            <b><%= this.GetMessage("TituloPptoPorCanal") %></b>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div id="presupuestoCanal" ex-highchart chart="chartPptoCanal" type="column"
                                     options="chartPptoCanalOptions" style="height: 250px">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mb text-center">
                    <div class="col-xs-12 col-md-offset-3 col-md-4">
                        <b><%= this.GetMessage("TituloPptoPorMarca") %></b>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-5">
                        <div id="presupuestoMarca" ex-highchart chart="chartPptoMarca" type="pie"
                             options="chartPieOptions" style="height: 250px">
                        </div>
                    </div>
                    
                    <div class="col-md-7">
                        <div id="presupuestoMarcaDetalle" ex-highchart chart="chartPptoMarcaDetalle" type="column"
                             options="chartPptoMarcaDetalleOptions" style="height: 250px">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../Scripts/pages/repDashboard.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
