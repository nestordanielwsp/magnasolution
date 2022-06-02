<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="TipoDescuento.aspx.cs" Inherits="CYP.Pages.TipoDescuento" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="tipoDescuentoController as vm">
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
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreTipoDescuento" key-enter="vm.actualizar()"
                                        placeholder="Busqueda rápida por (<%= this.GetMessage("TipoDescuento") %>)">
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
                            <button type="button" class="btn btn-link itemEnd" ng-click="vm.descargar()">
                                <div class="glyphicon glyphicon-download-alt d-block"></div>
                                Excel
                            </button>
                        </div>
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.tipoDescuentos" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.tipoDescuentos" st-safe-src="vm.tipoDescuentos_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="20"><%= this.GetMessage("TipoDescuento") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("AutocalculadoPorFacturas") %></th>
                                                    <th ui-field width="5"><%= this.GetMessage("Activo") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.tipoDescuentos">
                                                    <td st-ratio="20" ng-bind="item.NombreTipoDescuento"></td>
                                                    <td st-ratio="10" ng-bind="!item.AutocalculadoPorFacturas?'No':'Si'"></td>
                                                    <td st-ratio="5" ng-bind="!item.Activo?'No':'Si'"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.tipoDescuentos.length == 0" class="nodata-row">
                                                    <td colspan="4" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="4">
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
                                        <span class="label-color"><%= this.GetMessage("TipoDescuento") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.tipoDescuento.NombreTipoDescuento" />
                                    </div>
                                    <div class="col-sm-2">
                                        <div class="label-color"><%= this.GetMessage("EsCartera") %> </div>
                                        <switcher ng-model="vm.tipoDescuento.EsCartera" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("TipoDescuentoContractual") %> </span>
                                        <select
                                            class="form-control form-control-select" ng-change="validarTipoDescuento(true)"
                                            ng-model="vm.tipoDescuento.TipoDescuentoContractualId" required
                                            ng-options="item.TipoDescuentoContractualId as item.NombreTipoDescuentoContractual for item in vm.tiposDescuentoContractual">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>                  
                                    <div class="col-sm-2">
                                        <div class="label-color"><%= this.GetMessage("Activo") %> </div>
                                        <switcher ng-model="vm.tipoDescuento.Activo" true-label="Si" false-label="No"></switcher>
                                    </div>
                                </div>
                                
                                <div class="row pt-15">                                    
                                    <div class="col-sm-2">
                                        <div class="label-color"><%= this.GetMessage("ProyectoTpm") %> </div>
                                        <switcher ng-model="vm.tipoDescuento.ProyectoTpmQad" true-label="Si" false-label="No"></switcher>
                                    </div>
                                    <div class="col-sm-2">
                                        <span class="label-color"><%= this.GetMessage("Grupo") %> </span>
                                        <input type="number" class="form-control form-control-input" ng-model="vm.tipoDescuento.Grupo" />
                                    </div>
                                    <div class="col-sm-2" ng-if="vm.tipoDescuento.TipoDescuentoContractualId !== 2" >
                                        <div class="label-color"><%= this.GetMessage("AutocalculadoPorFacturas") %> </div>
                                        <switcher ng-model="vm.tipoDescuento.AutocalculadoPorFacturas" ng-disabled="vm.desactivarReferenciaFactura"  true-label="Si" false-label="No"></switcher>
                                    </div>                                          
                                    <div class="col-sm-3" ng-if="!vm.tipoDescuento.AutocalculadoPorFacturas" >
                                        <div class="label-color"><%= this.GetMessage("ReferenciaFactura") %> </div>
                                        <switcher ng-model="vm.tipoDescuento.ReferenciaFactura" true-label="Si" false-label="No"></switcher>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/tipoDescuentoController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
