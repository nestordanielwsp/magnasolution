<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="DiasFestivos.aspx.cs" Inherits="CYP.Pages.DiasFestivos" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="diasFestivosController as vm">
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
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreDia" key-enter="vm.actualizar()"
                                        placeholder="Búsqueda rápida por (<%= this.GetMessage("Canal") %>)">
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
                                <label><%= this.GetMessage("Canal") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreDia"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Grupo") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.AnioId" required ng-change="vm.actualizar()"
                                    ng-options="item.AnioId as item.AnioId for item in vm.anios">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
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
                                    <div ui-table="vm.diasFestivos" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 1150px"
                                            st-table="vm.diasFestivos" st-safe-src="vm.diasFestivos_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="15"><%= this.GetMessage("Clave") %></th>
                                                    <th ui-field width="50"><%= this.GetMessage("Canal") %></th> 
                                                    <th ui-field width="20"><%= this.GetMessage("Estatus") %></th> 
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.diasFestivos">
                                                    <td st-ratio="15" ng-bind="item.DiaFestivo"></td>
                                                    <td st-ratio="50" ng-bind="item.NombreDia"></td> 
                                                    <td st-ratio="20" ng-bind="item.Estatus"></td> 
                                                      <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.diasFestivos.length == 0" class="nodata-row">
                                                    <td colspan="11" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="11">
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
                                    <div class="col-sm-6">
                                        <span class="label-color"><%= this.GetMessage("Canal") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.diaFestivo.NombreDia" required />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Clave") %> </span> 
                                          <datepicker ng-model="vm.diaFestivo.DiaFestivo" min-date="DiaFestivo" input-class="form-control-input no-disabled" required></datepicker>
                                    </div>
                                     <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("Estatus") %> </div>
                                        <switcher ng-model="vm.diaFestivo.Active" true-label="<%= this.GetMessage("lblSi") %>"
                                            false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                                    </div>
                                </div> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/diasFestivosController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>

</asp:Content>
