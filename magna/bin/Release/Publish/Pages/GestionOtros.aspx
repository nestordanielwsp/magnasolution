<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="GestionOtros.aspx.cs" Inherits="CYP.Pages.GestionOtros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="gestionOtros">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-10">
                                <input type="text" class="form-control" ng-model="filtro.Nombre" key-enter="getPerfiles()"
                                    placeholder="Busqueda rápida por (<%= this.GetMessage("lblNombre") %>)">
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="getPerfiles()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetMessage("btnBuscar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="descuentos" st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 800px">
                        <thead>
                            <tr>
                                <th ui-field width="8">
                                    <%= this.GetMessage("lblOrden") %>
                                </th>
                                <th ui-field width="30">
                                    <%= this.GetMessage("lblNombre") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("lblTipo") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("lblEsVendedor") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in perfiles">
                                <td st-ratio="8">{{item.OrdenAprobacion}}</td>
                                <td st-ratio="30">{{item.Nombre}}</td>
                                <td st-ratio="15">{{item.TipoPerfil}}</td>
                                <td st-ratio="15">
                                    <span ng-show="item.EsVendedor"><%= this.GetMessage("lblSi") %></span>
                                    <span ng-hide="item.EsVendedor"><%= this.GetMessage("lblNo") %></span>
                                </td>
                                <td st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="getPerfil(item)">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="perfiles.length == 0" class="nodata-row">
                                <td colspan="5" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="12">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/gestionOtros.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
