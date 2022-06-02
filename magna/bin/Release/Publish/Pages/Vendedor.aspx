<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Vendedor.aspx.cs" Inherits="CYP.Pages.Vendedor" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="vendedorController as vm">
        <div class="content-top clearfix">
            <div class="row">
                <div class="col-sm-6">
                    <h1 class="al-title" ng-bind="vm.titulo"></h1>
                </div>
                <div class="btn-tpm col-sm-6" ng-if="vm.viewDetail">
                    <div class="padding-7">
                        <div class="btn btn-top " ng-click="vm.viewDetail && vm.guardar()" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" tooltip-placement="bottom" ng-disabled="!vm.viewDetail">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div class="padding-7">
                        <div class="btn btn-top" ng-click="vm.actualizar();vm.viewDetail=false" uib-tooltip="<%= this.GetCommonMessage("LblTooltipRegresar") %>" tooltip-placement="bottom" ng-disabled="!vm.viewDetail">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-content">
            <div ng-show="!vm.viewDetail">
                <div class="filter mail-box filtros">
                    <div class="row p-5">
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                                </div>

                                <div class="clearfix visible-sm visible-xs pt-5"></div>

                                <div class="col-md-10">
                                   <input type="text" class="form-control" ng-model="vm.filtro.CodigoVendedor"  key-enter="vm.actualizar()"
                                        placeholder="Búsqueda rápida por (<%= this.GetMessage("CodigoVendedor") %>)">
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
                                <label><%= this.GetMessage("CodigoVendedor") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.CodigoVendedor"
                                         key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label ><%= this.GetMessage("NombreVendedor") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreVendedor"
                                         key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Jefe") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.JefeId" required ng-change="vm.actualizar()"
                                    ng-options="item.JefeId as item.NombreJefe for item in vm.jefes">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
               
                <div id="Home"  > 
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.vendedores" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.vendedores" st-safe-src="vm.vendedores_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="10"><%= this.GetMessage("CodigoVendedor") %></th>
                                                    <th ui-field width="30"><%= this.GetMessage("NombreVendedor") %></th>
                                                    <th ui-field width="30"><%= this.GetMessage("Jefe") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("EnvioCeroRiesgo") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("Region") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>                                              
                                                <tr ng-repeat="item in vm.vendedores">
                                                    <td st-ratio="10" ng-bind="item.VendedorId"></td>
                                                    <td st-ratio="30" ng-bind="item.NombreVendedor"></td>
                                                    <td st-ratio="30" ng-bind="item.NombreJefe"></td>
                                                    <td st-ratio="10" ng-bind="!item.EnvioCeroRiesgo?'No':'Si'"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreRegion"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.vendedores.length == 0" class="nodata-row">
                                                    <td colspan="6" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="6">
                                                        <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
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
                                        <span class="label-color"><%= this.GetMessage("CodigoVendedor") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.vendedor.VendedorId" ng-disabled="vm.vendedor.VendedorId && vm.vendedor.VendedorId!=0" required />
                                    </div>
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("NombreVendedor") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.vendedor.NombreVendedor" ng-disabled="vm.vendedor.VendedorId && vm.vendedor.VendedorId!=0" required />
                                    </div>
                                    <div class="col-sm-4"></div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("Jefe") %> </span>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.vendedor.JefeId" required
                                            ng-options="item.JefeId as (item.CodigoJefe+':'+item.NombreJefe) for item in vm.jefes">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("EnvioCeroRiesgo") %> </div>
                                        <switcher ng-model="vm.vendedor.EnvioCeroRiesgo" true-label="Si" false-label="No"></switcher>

                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("Region") %> </div>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.vendedor.RegionId" required
                                            ng-options="item.RegionId as item.NombreRegion for item in vm.regiones">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <script type="text/javascript" src="../scripts/pages/vendedorController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>

</asp:Content>

