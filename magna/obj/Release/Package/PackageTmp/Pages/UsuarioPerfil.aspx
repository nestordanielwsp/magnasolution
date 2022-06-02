<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="UsuarioPerfil.aspx.cs" Inherits="CYP.Pages.UsuarioPerfil" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="usuarioPerfilController as vm">

        <div class="content-top clearfix">
            <div class="row">
                <div class="col-sm-6">
                    <h1 class="al-title" ng-bind="vm.titulo"></h1>
                </div>
                <div class="btn-tpm col-sm-6" ng-if="vm.viewDetail">
                    <div class="padding-7">
                        <div class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" tooltip-placement="bottom" ng-click="vm.viewDetail && vm.guardar()" ng-disabled="!vm.viewDetail">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div class="padding-7">
                        <div class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>" tooltip-placement="bottom" ng-click="vm.actualizar();vm.viewDetail=false" ng-disabled="!vm.viewDetail">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-content">
            <div ng-if="!vm.viewDetail">
                <div class="filter mail-box filtros">
                    <div class="row p-5">
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                                </div>

                                <div class="clearfix visible-sm visible-xs pt-5"></div>

                                <div class="col-md-10">
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombrePerfil" key-enter="vm.actualizar()"
                                        placeholder="Busqueda rápida por (<%= this.GetMessage("NombrePerfil") %>)">
                                </div>
                            </div>
                        </div>

                        <div class="clearfix visible-xs">
                            <br />
                        </div>

                        <div class="col-md-4 text-right">
                            <button type="button" class="btn btn-link" ng-click="vm.actualizar()">
                                <div class="glyphicon glyphicon-search d-block"></div>
                                Buscar
                            </button>
                            <button type="button" class="btn btn-link" ng-click="vm.agregar()">
                                <div class="glyphicon glyphicon-plus d-block"></div>
                                Agregar
                            </button>
                        </div>
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.perfiles" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.perfiles" st-safe-src="vm.perfiles_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="10"><%= this.GetMessage("NombrePerfil") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("Active") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.perfiles">
                                                    <td st-ratio="10" ng-bind="item.NombrePerfil"></td>
                                                    <td st-ratio="10" ng-bind="item.Active==0?'No':'Si'"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.perfiles.length == 0" class="nodata-row">
                                                    <td colspan="3" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="3">
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

            <div ng-if="vm.viewDetail" ng-form="vm.form" ng-class="{'submitted': !vm.isValid}">
                <div class="mail-box padding-10">
                    <div class="mail-body">
                        <div class="ibox-content">
                            <div id="Filters" class="padding-form">
                                <div class="subtitulo-color"><%= this.GetMessage("TituloDetalle") %></div>
                                <div class="row">
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("NombrePerfil") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.perfil.NombrePerfil" required />
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("Active") %> </div>
                                        <switcher ng-model="vm.perfil.Active" true-label="Si" false-label="No"></switcher>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mail-box padding-form">
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblAccesos") %> </span>
                        </div>
                    </div>
                    <br />
                    <ui-checkbox-tree ng-model="vm.perfil.MenuPerfil" plain-datasource="vm.menus"></ui-checkbox-tree>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/usuarioPerfilController.js"></script>

</asp:Content>
