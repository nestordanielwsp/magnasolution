<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Provision.aspx.cs" Inherits="CYP.Pages.Provision" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="provision">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-show="pantallaId === pantallas.principal">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 col-lg-5">
                                <input type="text" class="form-control" maxlength="100" ng-model="filtro.Activity" key-enter="Obtenerprovisiones()"
                                    placeholder="<%= this.GetMessage("lblBusquedaActivity") %>">
                            </div>

                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>

                            <div class="col-md-2 col-lg-1">
                                <label class="label-filter"><%= this.GetMessage("lblEstatus") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 va-m">
                                <div class="width-auto" selected-model="filtro.Estatus" options="estatusProvisiones" extra-settings="estatusOptions"
                                    translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="Obtenerprovisiones()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                    </div>
                </div>
            </div>


            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="activities" st-fixed>
                    <table class="jsgrid-table" style="min-width: 950px">
                        <thead>
                            <tr>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvProvision-Mes") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvProvision-Year") %>
                                </th>
                                <th ui-field width="10" class="text-center">
                                    <%= this.GetMessage("gvProvision-Provision") %>
                                </th>
                                <th ui-field width="10" class="text-center">
                                    <%= this.GetMessage("gvProvision-Estatus") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in provisiones">
                                <td st-ratio="20">{{item.Mes}}
                                </td>
                                <td st-ratio="10">{{item.Year}}</td>
                                <td st-ratio="20" style="text-align: right">{{item.Provision | number:2}}</td>
                                <td st-ratio="10" class="text-center">{{item.Estatus}}</td>
                                <td class="text-center" st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="ObtenerDetalle(item.ProvisionesId)">
                                        <%= this.GetCommonMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="provisiones.length == 0" class="nodata-row">
                                <td colspan="8" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="8">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="pantallaId === pantallas.detalle">
            <div class="col-sm-2 col-md-1">
                <div class="subtitulo-color"><%= this.GetMessage("lblActivities") %></div>
            </div>


            <div class="row mb">
                <div class="btn-tpm col-sm-12">
                    <div>
                        <div class="btn btn-Approve" ng-click="aprobar()" tooltip-placement="bottom"
                             uib-tooltip="<%= this.GetMessage("lblTooltipAprobar") %>" ng-show="habilitarAciones">
                            <i class="glyphicon glyphicon glyphicon-ok"></i>
                        </div>
                    </div>
                    <div>
                        <div class="btn btn-top" ng-click="pantallaId = pantallas.principal" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                    <div>
                        <%-- <div class="btn btn-Reject" ng-click="rechazar()" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetMessage("lblTooltipRechazar") %>"  ng-show="habilitarAciones">
                            <i class="glyphicon glyphicon glyphicon-remove"></i>
                        </div>--%>
                    </div>
                </div>
            </div>


            <div class="row mb">
                <div class="col-sm-11 col-md-11" style="text-align: right">
                    <h4 style="margin-top: 0"><strong>Poliza : </strong><a ng-click="DescargarExcel()"><i style="color: #0069af" class="glyphicon glyphicon-paperclip"></i></a></h4>
                </div>
            </div>


            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div class="row">
                    <div class="col-sm-12">
                        <div ui-table="activities" st-fixed>
                            <table class="jsgrid-table" style="min-width: 950px">
                                <thead>
                                    <tr>
                                        <th ui-field width="50">
                                            <%= this.GetMessage("gvProvision-NombreCuenta") %>
                                        </th>
                                        <th ui-field width="20">
                                            <%= this.GetMessage("gvProvision-Cuenta") %>
                                        </th>
                                        <th ui-field width="15">
                                            <%= this.GetMessage("gvProvision-Subcuenta") %>
                                        </th>
                                        <th ui-field width="15">
                                            <%= this.GetMessage("gvProvision-CentroCostos") %>
                                        </th>
                                        <th ui-field width="13">
                                            <%= this.GetMessage("gvProvision-Proyecto") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("gvProvision-Entidad") %>
                                        </th>
                                        <th ui-field width="25">
                                            <%= this.GetMessage("gvProvision-Descripcion") %>
                                        </th>
                                        <th ui-field width="15">
                                            <%= this.GetMessage("gvProvision-Cargo") %>
                                        </th>
                                        <th ui-field width="15">
                                            <%= this.GetMessage("gvProvision-Abono") %>
                                        </th>

                                    </tr>
                                </thead>

                                <tbody>
                                    <tr ng-repeat="item in provisionesDetalle">
                                        <td st-ratio="50">{{item.NombreCuenta}}</td>
                                        <td st-ratio="20">{{item.Cuenta}}</td>
                                        <td st-ratio="15">{{item.Subcuenta}}</td>
                                        <td st-ratio="15">{{item.CentroCostos}}</td>
                                        <td st-ratio="13">{{item.Proyecto}}</td>
                                        <td st-ratio="10">{{item.Entidad}}</td>
                                        <td st-ratio="25">{{item.Descripcion}}</td>
                                        <td st-ratio="15">{{item.Cargo | currency}}</td>
                                        <td st-ratio="15">{{item.Abono | currency}}</td>
                                    </tr>
                                    <tr ng-if="provisiones.length == 0" class="nodata-row">
                                        <td colspan="8" class="text-center">
                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                        </td>
                                    </tr>
                                </tbody>

                                <tfoot>
                                    <tr>
                                        <td colspan="8">
                                            <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <br />


        </div>






    </div>

    <script type="text/javascript" src="../scripts/pages/provision.js"></script>
</asp:Content>

