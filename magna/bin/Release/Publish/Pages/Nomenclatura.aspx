<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Nomenclatura.aspx.cs" Inherits="CYP.Pages.Nomenclatura" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="nomenclaturaController as vm">

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
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreNomenclatura" key-enter="vm.actualizar()"
                                        placeholder="Busqueda rápida por (<%= this.GetMessage("NombreNomenclatura") %>)">
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
                                    <div ui-table="vm.nomenclaturas" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.nomenclaturas" st-safe-src="vm.nomenclaturas_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="10"><%= this.GetMessage("NombreNomenclatura") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("Tipo") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("Active") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.nomenclaturas">
                                                    <td st-ratio="10" ng-bind="item.NombreNomenclatura"></td>
                                                    <td st-ratio="10" ng-bind="item.Tipo"></td>
                                                    <td st-ratio="10" ng-bind="item.Active==0?'No':'Si'"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.nomenclaturas.length == 0" class="nodata-row">
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
                                        <span class="label-color"><%= this.GetMessage("NombreNomenclatura") %> </span>
                                        <input type="text" class="form-control form-control-input" maxlength="8" ng-model="vm.nomenclatura.NombreNomenclatura" required />
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("Tipo") %> </div>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.nomenclatura.Tipo" required>                                            
                                            <option value="P"><%= this.GetMessage("lblPago") %></option>
                                            <option value="F"><%= this.GetMessage("lblFactura") %></option>
                                            <option value="N"><%= this.GetMessage("lblNotaCredito") %></option>
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("Active") %> </div>
                                        <switcher ng-model="vm.nomenclatura.Active" true-label="Si" false-label="No"></switcher>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/nomenclaturaController.js"></script>

</asp:Content>
