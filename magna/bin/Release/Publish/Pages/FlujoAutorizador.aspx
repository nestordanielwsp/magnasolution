<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="FlujoAutorizador.aspx.cs" Inherits="CYP.Pages.FlujoAutorizador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="flujoAutorizador">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-12">
                        <div class="row">
                            <div class="col-sm-1">
                                <label class="label-filter"><%= this.GetMessage("lblArea") %></label>
                            </div>
                            <div class="col-sm-2">
                                <select class="form-control-select" ng-model="flujo.AreaId" 
                                    ng-options="area.AreaId as area.Nombre for area in areas" ng-change="getFlujos()">
                                </select>
                            </div>
                            <div class="col-sm-1">
                                <label class="label-filter"><%= this.GetMessage("lblCanal") %></label>
                            </div>

                            <div class="col-sm-2">
                                <select class="form-control-select" ng-model="flujo.CanalId" ng-change="llenaMarca(flujo.CanalId)"
                                    ng-options="canal.CanalId as canal.NombreCanal for canal in canales">
                                </select>
                            </div>
                            <div class="col-sm-1">
                                <label class="label-filter"><%= this.GetMessage("lblMarca") %></label>
                            </div>
                            <div class="col-sm-2">
                                    <div class="width-auto" selected-model="flujo.Marcas"
                                            options="marcas" extra-settings="marcasOptions"
                                            translation-texts="translateTextMultiSelect"
                                            ng-dropdown-multiselect="" events="multiselectEventos">
                                    </div>
                                       
                            </div>
                            <div class="col-sm-3 text-right">
                                <button type="button" class="btn btn-link" ng-click="guardar()">
                                    <div class="glyphicon glyphicon-floppy-disk d-block"></div>
                                    <%= this.GetCommonMessage("lblTooltipGuardar") %>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="Home" class="mail-box padding-10 wrapper border-bottom" ng-form="forma">
                    <div st-fixed style="width: 100%">
                        <table class="jsgrid-table" style="min-width: 400px">
                            <thead>
                                <tr>
                                    <th style="width: 5%"></th>
                                    <th style="width: 5%"></th>
                                    <th style="width: 25%">
                                        <%= this.GetMessage("lblCargo") %>
                                    </th>
                                    <th style="width: 20%">
                                        <%= this.GetMessage("lblMonto") %>
                                    </th>
                                    <th style="width: 10%">
                                        <%= this.GetMessage("lblModificacion") %>
                                    </th>
                                    <th style="width: 40%">
                                        <%= this.GetMessage("lblTipoModificacion") %>
                                    </th>
                                    <th class="text-center" style="width: 5%">
                                        <i class="fa fa-plus pointer" ng-click="agregar()"></i>
                                    </th>
                                </tr>
                            </thead>

                            <tbody ng-class="{'submitted': submitted}" ui-sortable="sortableOptions" ng-model="flujo.Lista">
                                <tr ng-repeat="item in flujo.Lista">
                                    <td class="text-center va-m" style="width: 5%">
                                        <i class="drag fa fa-arrows pointer"></i>
                                    </td>
                                    <td class="va-m" style="width: 5%">{{item.Orden}}</td>
                                    <td style="width: 25%">
                                        <div class="row">
                                            <div class="col-xs-11 col-md-7">
                                                <select ng-model="item.PerfilFuncionalId" class="form-control-select" required
                                                    ng-options="cargo.PerfilId as cargo.Nombre for cargo in cargos">
                                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                                </select>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 20%">
                                        <div class="row">
                                            <div class="col-xs-11 col-md-7">
                                                <input type="text" class="form-control-input" ng-model="item.Monto" money maxlength="12"
                                                    ng-show="(!item.EsModificacion)" ng-disabled="(item.EsModificacion)" required>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 10%" align="center">
                                        <div class="row">
                                            <div class="col-xs-11 col-md-7">
                                                <input type="checkbox" ng-model="item.EsModificacion" ng-click="cambiaflujoModificacion(item);">
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 40%">
                                        <div class="row">
                                            <div class="col-xs-11 col-md-7">
                                                <select ng-show="(item.EsModificacion)"
                                                    ng-model="item.FlujoAutorizacionModificacionId" class="form-control-select" ng-required="(item.EsModificacion)"
                                                    ng-options="md.FlujoAutorizacionModificacionId as md.NombreFlujoAutorizacionModificacion for md in modificacionInfo">
                                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                                </select>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center va-m" style="width: 5%">
                                        <button type="button" class="btn btn-link" ng-click="eliminar($index)">
                                            <i class="fa fa-remove pointer"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr ng-if="flujos.length == 0">
                                    <td colspan="5" class="text-center">
                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                    </td>
                                </tr>
                            </tbody>

                            <tfoot>
                                <tr>
                                    <td colspan="5">
                                        <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript" src="../scripts/pages/flujoAutorizador.js?V1<%= DateTime.Now.Millisecond %>""""></script>
</asp:Content>
