<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Region.aspx.cs" Inherits="CYP.Pages.Region" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="regionController as vm">
        <div class="content-top clearfix">
            <div class="row">
                <div class="col-sm-6">
                    <h1 class="al-title" ng-bind="vm.titulo"></h1>
                </div>
                <div class="btn-tpm col-sm-6" ng-if="vm.viewDetail">
                    <div class="padding-7">
                        <div class="btn btn-top " ng-click="vm.viewDetail && vm.guardar()" ng-disabled="!vm.viewDetail" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" tooltip-placement="bottom">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div class="padding-7">
                        <div class="btn btn-top" ng-click="vm.actualizar();vm.viewDetail=false" uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>" tooltip-placement="bottom" ng-disabled="!vm.viewDetail">
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
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreRegion" key-enter="vm.actualizar()"
                                        placeholder="Búsqueda rápida por (<%= this.GetMessage("Region") %>)">
                                </div>
                            </div>
                        </div>

                        <div class="clearfix visible-xs">
                            <br />
                        </div>

                        <div class="col-md-4 text-right">
                            <button type="button" class="btn btn-link" ng-click="vm.openFilterAdvance=!vm.openFilterAdvance;vm.clearFiltros()">
                                <div class="glyphicon glyphicon-filter d-block"></div>
                                Filtros
                            </button>
                            <button type="button" class="btn btn-link" ng-click="vm.actualizar()">
                                <div class="glyphicon glyphicon-search d-block"></div>
                                Buscar
                            </button>
                            <button type="button" class="btn btn-link" ng-click="vm.agregar()">
                                <div class="glyphicon glyphicon-plus d-block"></div>
                                Agregar
                            </button>
                            <button type="button" class="btn btn-link itemEnd" ng-click="vm.descargar()">
                                <div class="glyphicon glyphicon-download-alt d-block"></div>
                                Excel
                            </button>
                        </div>
                    </div>
                </div>

                <div class="mail-box filtros-avanzados" ng-if="vm.openFilterAdvance">
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Codigo") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.Codigo"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Region") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreRegion"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Jac") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.JacId" required ng-change="vm.actualizar()"
                                    ng-options="item.UsuarioId as item.NombreUsuario for item in vm.jacs">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("AnalistaCartera") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.AnalistaCarteraId" required ng-change="vm.actualizar()"
                                    ng-options="item.UsuarioId as item.NombreUsuario for item in vm.analistasCartera">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("JefeCartera") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.JefeCarteraId" required ng-change="vm.actualizar()"
                                    ng-options="item.UsuarioId as item.NombreUsuario for item in vm.jefesCartera">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>

                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.regiones" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.regiones" st-safe-src="vm.regiones_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="10"><%= this.GetMessage("Codigo") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("Region") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("Jac") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("AnalistaCartera") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("JefeCartera") %></th>
                                                    <th ui-field width="5"><%= this.GetMessage("Activo") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.regiones">
                                                    <td st-ratio="10" ng-bind="item.Codigo"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreRegion"></td>
                                                    <td st-ratio="15" ng-bind="item.NombreJac"></td>
                                                    <td st-ratio="15" ng-bind="item.NombreAnalistaCartera"></td>
                                                    <td st-ratio="15" ng-bind="item.NombreJefeCartera"></td>
                                                    <td st-ratio="5" ng-bind="!item.Activo?'No':'Si'"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.regiones.length == 0" class="nodata-row">
                                                    <td colspan="7" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="7">
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
                                        <span class="label-color"><%= this.GetMessage("Codigo") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.region.Codigo" required ng-disabled="vm.region.RegionId!=0" />
                                    </div>
                                    <div class="col-sm-8"></div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("Region") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.region.NombreRegion" required />
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("Jac") %> </div>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.region.JacId" required
                                            ng-options="item.UsuarioId as item.NombreUsuario for item in vm.jacs">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>

                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("AnalistaCartera") %> </div>
                                        <div class="width-auto" selected-model="vm.region.Analistas"
                                            options="vm.analistasCartera" extra-settings="analistaOptions"
                                            translation-texts="translateTextMultiSelect"
                                            ng-dropdown-multiselect="">
                                        </div>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("JefeCartera") %> </div>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.region.JefeCarteraId" required
                                            ng-options="item.UsuarioId as item.NombreUsuario for item in vm.jefesCartera">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("Activo") %> </div>
                                        <switcher ng-model="vm.region.Activo" true-label="Si" false-label="No"></switcher>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/regionController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
