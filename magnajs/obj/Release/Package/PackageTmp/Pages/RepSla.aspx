<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepSla.aspx.cs" Inherits="CYP.Pages.RepSla" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repSla">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-2">
                                <label><%= this.GetMessage("lblAnio") %></label>
                                <select ng-model="filtro.Anio" class="form-control-select" ng-options="anio as anio for anio in anios"
                                    ng-change="actualizar()" style="height: auto; padding: 1.5px 4px">
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label><%= this.GetMessage("lblMarca") %></label>
                                <div selected-model="filtro.Marcas" options="marcas" extra-settings="marcasOptions"
                                    translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                                </div>
                            </div>

                            <div class="col-md-4">
                                <label><%= this.GetMessage("lblCanal") %></label>
                                <div selected-model="filtro.Canales" options="canales" extra-settings="canalesOptions "
                                    translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-sm-2 text-right">
                        <button type="button" class="btn btn-link" ng-click="actualizar()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box padding-10 wrapper">
                <div class="row">
                    <div class="col-md-offset-3 col-md-6">
                        <table class="table table-condensed">
                            <tr class="text-center">
                                <th><%= this.GetMessage("lblTotalActivities") %></th>
                                <th><%= this.GetMessage("lblDiasPromedioFlujo") %></th>
                                <th><%= this.GetMessage("lblDiasPromedioFueraTiempo") %></th>
                            </tr>

                            <tr class="text-center" style="font-weight: bold; font-size: 16px">
                                <td>
                                    <span class="label-color">{{promedioActivities.TotalActivities | number}}</span>
                                </td>
                                <td>
                                    <span class="label-color">{{promedioActivities.DiasFlujo | number:2}}</span>
                                </td>
                                <td>
                                    <span class="label-color">{{activitiesExtemporaneos.PromedioDiasExtemporaneo | number}}</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="row text-center">
                            <b><%= this.GetMessage("lblDiasPromedioFlujoMarca") %></b>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div id="diasPromedioMarca" ui-highchart chart="chartPromedioMarca" type="column"
                                     options="promedioMarcaOptions" style="height: 350px">
                                </div>
                            </div>
                        </div>
                    </div>
                                        
                    <div class="col-md-6">
                        <div class="row text-center">
                            <b><%= this.GetMessage("lblActivitiesPorMarca") %></b>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <div id="extemporaneoMarca" ui-highchart chart="chartExtemporaneoMarca" type="column"
                                     options="extemporaneoMarcaOptions" style="height: 350px">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/repSla.js"></script>
</asp:Content>
