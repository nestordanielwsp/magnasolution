<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="CuentaContable.aspx.cs" Inherits="CYP.Pages.CuentaContable" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="cuentaContableController as vm">
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
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreCuentaContable" key-enter="vm.actualizar()"
                                        placeholder="Busqueda rápida por (<%= this.GetMessage("NombreCuentaContable") %>)">
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
                                <label><%= this.GetMessage("CuentaLm") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.CuentaLm"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("NombreCuentaContable") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreCuentaContable"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("DescripcionCuentaContable") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.DescripcionCuentaContable"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                        </div>
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.cuentasContables" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.cuentasContables" st-safe-src="vm.cuentasContables_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="5"><%= this.GetMessage("CuentaLm") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("NombreCuentaContable") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("DescripcionCuentaContable") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("UsarDescuentoContractuales") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("UsarDescuentoExtraContractuales") %></th>
                                                    <th ui-field width="5"><%= this.GetMessage("UsarApv") %></th>
                                                    <th ui-field width="8"><%= this.GetMessage("CuentaCentroCostos") %></th>
                                                    <th ui-field width="5"><%= this.GetMessage("Subcuenta") %></th>
                                                    <th ui-field width="5"><%= this.GetMessage("Activo") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.cuentasContables">
                                                    <td st-ratio="5" ng-bind="item.CuentaLm"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreCuentaContable"></td>
                                                    <td st-ratio="10" ng-bind="item.DescripcionCuentaContable"></td>
                                                    <td st-ratio="10" ng-bind="!item.UsarDescuentoContractuales?'No':'Si'"></td>
                                                    <td st-ratio="10" ng-bind="!item.UsarDescuentoExtraContractuales?'No':'Si'"></td>
                                                    <td st-ratio="5" ng-bind="!item.UsarApv?'No':'Si'"></td>
                                                    <td st-ratio="8" ng-bind="!item.CuentaCentroCostos?'No':'Si'"></td>
                                                    <td st-ratio="5" ng-bind="!item.Subcuenta?'No':'Si'"></td>
                                                    <td st-ratio="5" ng-bind="!item.Active?'No':'Si'"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.cuentasContables.length == 0" class="nodata-row">
                                                    <td colspan="10" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="10">
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
                                    <div class="col-sm-2">
                                        <span class="label-color"><%= this.GetMessage("CuentaLm") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.cuentaContable.CuentaLm" ng-disabled="vm.cuentaContable.CuentaContableId && vm.cuentaContable.CuentaContableId!=0" required />
                                    </div>
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("NombreCuentaContable") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.cuentaContable.NombreCuentaContable" ng-disabled="vm.cuentaContable.CuentaContableId && vm.cuentaContable.CuentaContableId!=0" required />
                                    </div>
                                    <div class="col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("DescripcionCuentaContable") %> </span>
                                        <textarea rows="3" class="form-control form-control-input" ng-model="vm.cuentaContable.DescripcionCuentaContable" ng-disabled="vm.cuentaContable.CuentaContableId && vm.cuentaContable.CuentaContableId!=0" required></textarea>

                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("UsarDescuentoContractuales") %> </div>
                                        <switcher ng-model="vm.cuentaContable.UsarDescuentoContractuales" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("UsarDescuentoExtraContractuales") %> </div>
                                        <switcher ng-model="vm.cuentaContable.UsarDescuentoExtraContractuales" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="label-color"><%= this.GetMessage("UsarApv") %> </div>
                                        <switcher ng-model="vm.cuentaContable.UsarApv" true-label="Si" false-label="No"></switcher>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("CuentaCentroCostos") %> </div>
                                        <switcher ng-model="vm.cuentaContable.CuentaCentroCostos" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("Subcuenta") %> </div>
                                        <switcher ng-model="vm.cuentaContable.Subcuenta" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("Activo") %> </div>
                                        <switcher ng-model="vm.cuentaContable.Active" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("TipoProyecto") %> </div>
                                        <switcher ng-model="vm.cuentaContable.ProyectoConcatenado"
                                            true-label="Concatenado" false-label="Normal"></switcher>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("RubroActivity") %> </div>
                                        <select ng-model="vm.cuentaContable.RubroId" class="form-control-select"
                                            ng-options="item.RubroId as item.Nombre for item in vm.rubros">
                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
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
    <script type="text/javascript" src="../scripts/pages/cuentaContableController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
