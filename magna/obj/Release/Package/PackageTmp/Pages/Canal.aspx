<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Canal.aspx.cs" Inherits="CYP.Pages.Canal" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="canalController as vm">
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
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreCanal" key-enter="vm.actualizar()"
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
                                <label><%= this.GetMessage("Clave") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.Clave"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Canal") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreCanal"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Grupo") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.Grupo" required ng-change="vm.actualizar()"
                                    ng-options="item.GrupoId as item.NombreGrupo for item in vm.grupos">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("ProyectoQAD") %> </label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.ProyectoQAD"
                                        key-enter="vm.actualizar()">
                                </div>

                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Gerente") %> </label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.Gerente"
                                        key-enter="vm.actualizar()">
                                </div>

                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("CentroCostos") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.CentroCostoId" required ng-change="vm.actualizar()"
                                    ng-options="item.CentroCostoId as item.NombreCentroCosto for item in vm.centroCostos">
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
                                    <div ui-table="vm.canales" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 1150px"
                                            st-table="vm.canales" st-safe-src="vm.canales_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="5"><%= this.GetMessage("Clave") %></th>
                                                    <th ui-field width="9"><%= this.GetMessage("Canal") %></th>
                                                    <th ui-field width="9"><%= this.GetMessage("Grupo") %></th>
                                                    <th ui-field width="9"><%= this.GetMessage("Recaudo") %></th>
                                                    <th ui-field width="5" class="width-10">%</th>
                                                    <th ui-field width="8" class="text-center">
                                                        <%= this.GetMessage("AgregadoDias") %>
                                                    </th>
                                                    <th ui-field width="10"><%= this.GetMessage("ProyectoQAD") %></th>
                                                    <th ui-field width="10" class="text-center">
                                                        <%= this.GetMessage("NomenclaturaProyecto") %>
                                                    </th>
                                                    <th ui-field width="10"><%= this.GetMessage("Gerente") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("EspecialistaCC") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("CentroCostos") %></th>
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.canales">
                                                    <td st-ratio="5" ng-bind="item.Clave"></td>
                                                    <td st-ratio="9" ng-bind="item.NombreCanal"></td>
                                                    <td st-ratio="9" ng-bind="item.NombreGrupo"></td>
                                                    <td st-ratio="9" ng-bind="!item.Recaudo?'No':'Si'"></td>
                                                    <td st-ratio="5" ng-bind="item.Porcentaje"></td>
                                                    <td st-ratio="8" ng-bind="item.DiasVencimiento"></td>
                                                    <td st-ratio="10" ng-bind="item.ProyectoQad"></td>
                                                    <td st-ratio="10" ng-bind="item.NomenclaturaProyecto" class="text-center"></td>
                                                    <td st-ratio="10" ng-bind="item.Gerente"></td>
                                                    <td st-ratio="10" ng-bind="item.EspecialistaCC"></td>
                                                    <td st-ratio="10" ng-bind="item.NombreCentroCosto"></td>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.canales.length == 0" class="nodata-row">
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
                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("Clave") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.Clave" ng-disabled="vm.canal.CanalId && vm.vendedor.CanalId!=0" required />
                                    </div>
                                    <div class="col-sm-8"></div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Canal") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.NombreCanal" ng-disabled="vm.canal.CanalId && vm.vendedor.CanalId!=0" required />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Grupo") %> </span>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.canal.GrupoId" required
                                            ng-options="item.GrupoId as item.NombreGrupo for item in vm.grupos">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("Recaudo") %> </div>
                                        <switcher ng-model="vm.canal.Recaudo" true-label="Si" false-label="No"></switcher>

                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Porcentaje") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.Porcentaje"
                                            required numbers-only maxlength="9" />
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("AgregadoDias") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.DiasVencimiento"
                                            required numbers-only maxlength="9" />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ProyectoQAD") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.ProyectoQad" required />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Gerente") %> </span>
                                        <select class="form-control-select" ng-model="vm.canal.GerenteId" 
                                            ng-options="item.UsuarioId as item.NombreUsuario for item in vm.gerentes">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("EspecialistaCC") %> </span>
                                        <select class="form-control-select" ng-model="vm.canal.EspecialistaCCId" 
                                            ng-options="item.UsuarioId as item.NombreUsuario for item in vm.especialistaCC">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CentroCostos") %> </span>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.canal.CentroCostoId" required
                                            ng-options="item.CentroCostoId as item.NombreCentroCosto for item in vm.centroCostos">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <label class="label-color"><%= this.GetMessage("GerenteMac") %> </label>
                                        <select class="form-control-select" ng-model="vm.canal.GerenteMacId" rquired
                                            ng-options="item.UsuarioId as item.NombreUsuario for item in vm.gerentesMac">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>

                                    <div class="col-sm-3">
                                        <label class="label-color"><%= this.GetMessage("CoordinadorMac") %> </label>
                                        <div class="width-auto" selected-model="vm.canal.Coordinadores"
                                            options="vm.coordinadoresMac" extra-settings="coordinadorOptions"
                                            translation-texts="translateTextMultiSelect"
                                            ng-dropdown-multiselect="">
                                        </div>
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("Sufijo") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.Sufijo" />
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CentroCostosLogistica") %> </span>
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="vm.canal.CentroCostoIdLogistica"
                                            ng-options="item.CentroCostoId as item.NombreCentroCosto for item in vm.centroCostos">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>

                                <br />
                                <div class="row">
                                    <div class="col-sm-3">
                                        <div class="label-color"><%= this.GetMessage("AplicaCobrabilidad") %> </div>
                                        <switcher ng-model="vm.canal.AplicaCobrabilidad" true-label="Si" false-label="No"
                                            ng-change="vm.canal.ObjetivoCobrabilidad = null"></switcher>
                                    </div>

                                    <div class="col-sm-3">
                                        <label class="label-color"><%= this.GetMessage("ObjetivoCobrabilidad") %> </label>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.canal.ObjetivoCobrabilidad"
                                            ng-disabled="!vm.canal.AplicaCobrabilidad" money maxlength="6" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/canalController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>

</asp:Content>
