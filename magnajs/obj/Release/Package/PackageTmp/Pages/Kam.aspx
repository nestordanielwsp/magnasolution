<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Kam.aspx.cs" Inherits="CYP.Pages.Kam" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="kamController as vm">
        <div class="content-top clearfix">
            <h1 class="al-title" ng-bind="vm.titulo"></h1>
             <div class="div-top-butons" ng-if="vm.viewDetail">
                <div class="padding-7">
                    <div class="btn btn-top" ng-click="vm.actualizar();vm.viewDetail=false" uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>" tooltip-placement="bottom" ng-disabled="!vm.viewDetail">
                        <i class="glyphicon glyphicon-arrow-left"></i>
                    </div>
                </div>
                <div class="padding-7">
                    <div class="btn btn-top " ng-click="vm.viewDetail && vm.guardar()" ng-disabled="!vm.viewDetail" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" tooltip-placement="bottom">
                        <i class="fa fa-save"></i>
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
                                     <input type="text" class="form-control" ng-model="vm.filtro.NombreVendedor" key-enter="vm.actualizar()"
                                        placeholder="Busqueda rápida por (<%= this.GetMessage("NombreVendedor") %>)">
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
                                <label><%= this.GetMessage("NombreVendedor") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreVendedor"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label ><%= this.GetMessage("Cliente") %></label>
                                  <isteven-multi-select required
                                            input-model="vm.clientes"
                                            output-model="vm.filtro.Clientes_"
                                            button-label="NombreCliente"
                                            item-label="NombreCliente"
                                            tick-property="selected"
                                            selection-mode="multiple"
                                            max-labels="3">
                                        </isteven-multi-select>
                            </div>
                        </div> 
                         
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.kams" st-fixed height="500px" style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.kams" st-safe-src="vm.kams_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="30"><%= this.GetMessage("NombreVendedor") %></th>
                                                    <th ui-field width="60"><%= this.GetMessage("Cliente") %></th>
                                                    <th ui-field width="10"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.kams">
                                                    <td st-ratio="30" ng-bind="item.NombreVendedor"></td>
                                                    <td st-ratio="60">
                                                        <div ng-repeat="cl in item.ClientesView" style="text-overflow: ellipsis; overflow: hidden" ng-bind="cl"></div>
                                                    </td>
                                                    <td st-ratio="10">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.kams.length == 0" class="nodata-row">
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
                                        <span class="label-color"><%= this.GetMessage("NombreVendedor") %> </span>
                                       <%-- <select
                                            class="form-control form-control-select"
                                            ng-model="vm.kam.VendedorId" required
                                            ng-disabled="vm.kam.VendedorIdOrigin && vm.kam.VendedorIdOrigin!=0"
                                            ng-options="item.VendedorId as item.NombreVendedor disable when item.disabled for item in vm.vendedores">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>--%>
                                         <isteven-multi-select required
                                             is-disabled="vm.kam.VendedorIdOrigin && vm.kam.VendedorIdOrigin!=0"
                                            input-model="vm.vendedores"
                                            output-model="outSelect" 
                                            button-label="NombreVendedor"
                                            item-label="NombreVendedor"
                                            tick-property="selected"
                                            selection-mode="single"
                                            disable-property="disabled" 
                                            <%--output-properties="VendedorId"--%>
                                             on-item-click="vm.kam.VendedorId=data.VendedorId"
                                             >
                                        </isteven-multi-select> 
                                    </div>
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("Cliente") %> </span> 

                                        <isteven-multi-select required
                                            input-model="vm.clientes"
                                            output-model="vm.kam.Clientes_"
                                            button-label="NombreCliente"
                                            item-label="NombreCliente"
                                            tick-property="selected"
                                            selection-mode="multiple"
                                            max-labels="3">
                                        </isteven-multi-select>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/kamController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>

