<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="TipoIndicador.aspx.cs" Inherits="CYP.Pages.TipoIndicador" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="tipoIndicador">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-12 text-right">
                        <button type="button" class="btn btn-link" ng-click="guardar()">
                            <div class="glyphicon glyphicon-floppy-disk d-block"></div>
                            <%= this.GetCommonMessage("lblTooltipGuardar") %>
                        </button>
                    </div>
                </div>  
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom" ng-form="forma">
                <div st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 400px">
                        <thead>
                            <tr>
                                <th width="30">
                                    <%= this.GetMessage("lblIndicador") %>
                                </th>
                                <th class="text-right" width="70">
                                    <i class="fa fa-plus pointer" ng-click="agregar()"></i>
                                </th>
                            </tr>
                        </thead>

                        <tbody ng-class="{'submitted': submitted}">
                            <tr ng-repeat="item in indicadores" ng-show="item.Active">
                                <td st-ratio="30">
                                    <input type="text" class="form-control-input" ng-model="item.Nombre" maxlength="100" required>
                                </td>
                                <td class="text-right" st-ratio="70">
                                    <button type="button" class="btn btn-link" ng-click="eliminar(item, $index)">
                                        <i class="fa fa-remove pointer"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="flujos.length == 0">
                                <td colspan="2" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="2">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/tipoIndicador.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
