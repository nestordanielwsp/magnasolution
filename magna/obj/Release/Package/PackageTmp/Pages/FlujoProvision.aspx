<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="FlujoProvision.aspx.cs" Inherits="CYP.Pages.FlujoProvision" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="flujoProvision">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-8">
                        <%--<div class="row">
                            <div class="col-sm-1">
                                <label class="label-filter"><%= this.GetMessage("lblRubro") %></label>
                            </div>

                            <div class="clearfix visible-xs pt-5"></div>

                            <div class="col-sm-5">
                                <select class="form-control-select" ng-model="flujo.RubroId" ng-change="getFlujos()"
                                        ng-options="rubro.RubroId as rubro.Nombre for rubro in rubros">
                                </select>
                            </div>
                        </div>--%>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="guardar()">
                            <div class="glyphicon glyphicon-floppy-disk d-block"></div>
                            <%= this.GetCommonMessage("lblTooltipGuardar") %>
                        </button>
                    </div>
                </div>  
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom" ng-form="forma">
                <div st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 300px">
                        <thead>
                            <tr>
                                <th style="width:5%"></th>
                                <th style="width:5%"></th>
                                <th style="width:80%">
                                    <%= this.GetMessage("lblUsuario") %>
                                </th>
                                <th class="text-center" style="width:10%">
                                    <i class="fa fa-plus pointer" ng-click="agregar()"></i>
                                </th>
                            </tr>
                        </thead>

                        <tbody ng-class="{'submitted': submitted}" ui-sortable="sortableOptions" ng-model="flujo.Lista">
                            <tr ng-repeat="item in flujo.Lista">
                                <td class="text-center va-m" style="width:5%">
                                    <i class="drag fa fa-arrows pointer"></i>
                                </td>
                                <td class="va-m" style="width:5%">{{item.Orden}}</td>
                                <td style="width:80%">
                                    <div class="row">
                                        <div class="col-sm-8 col-md-5">
                                            <ex-autocomplete ng-model="item.UsuarioId" options="opcionesUsuario"
                                                             item="item" required />
                                        </div>
                                    </div>
                                </td>
                                <td class="text-center va-m" style="width:10%">
                                    <button type="button" class="btn btn-link" ng-click="eliminar($index)">
                                        <i class="fa fa-remove pointer"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="flujos.length == 0">
                                <td colspan="4" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="4">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/flujoProvision.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
