<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="UsuarioQad.aspx.cs" Inherits="CYP.Pages.UsuarioQad" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
     <div ng-controller="usuarioQad">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-hide="esDetalle">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 col-lg-5">
                                <input type="text" class="form-control" maxlength="500" ng-model="filtro.Nombre" key-enter="ObtenerUsuariosQad()"
                                    placeholder="<%= this.GetMessage("lblBusquedaUsuariosQad") %>">
                            </div>

                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="ObtenerUsuariosQad()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="agregar()">
                            <div class="glyphicon glyphicon-plus d-block"></div>
                            <%= this.GetCommonMessage("btnNuevo") %>
                        </button>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="activities" st-fixed>
                    <table class="jsgrid-table" style="min-width: 500px">
                        <thead>
                            <tr>
                                <th ui-field width="5">
                                    <%= this.GetMessage("lblUsuario") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("lblNombre") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("lblActive") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in usuariosQad">
                                <td st-ratio="10">{{item.Usuario}}</td>
                                <td st-ratio="10">{{item.Nombre}}</td>
                                <td st-ratio="10">
                                    <input type="checkbox" ng-model="item.Active"  disabled />
                                </td>
                                <td class="text-center" st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="ObtenerUsuarioQad(item)">
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
                    </table>
                </div>
            </div>
        </div>

    <div class="page-content" ng-show="esDetalle">
            <div class="row">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("lblDetalleUsuarioQad") %></div>
                </div>
                <div class="btn-tpm col-sm-6">
                    <div>
                        <div class="btn btn-top" ng-click="guardar()" tooltip-placement="bottom"
                             uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div>
                        <div class="btn btn-top" ng-click="esDetalle=false" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mail-box" ng-form="forma" ng-class="{'submitted': submitted}">
                <div class="padding-form">
                    <div class="row mb">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblUsuario") %> </span>
                            <input type="text" ng-model="usuarioQad.Usuario" class="form-control-input" required maxlength="20" />
                        </div>
                        
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblNombre") %> </span>
                            <input type="text" ng-model="usuarioQad.Nombre" class="form-control-input" required maxlength="500"/>
                        </div>

                        <div class="form-group col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 10px">
                                <%= this.GetCommonMessage("lblActivo") %> 
                            </span>
                            <switcher ng-model="usuarioQad.Active" true-label="<%= this.GetCommonMessage("lblSi") %>"
                                false-label="<%= this.GetCommonMessage("lblNo") %>"></switcher>
                        </div>
                    </div>
                </div>
            </div>
        </div>
         
    </div>
    <script src="../Scripts/pages/usuarioQad.js"></script>
</asp:Content>
