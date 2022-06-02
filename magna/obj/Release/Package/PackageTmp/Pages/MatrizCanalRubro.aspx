<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="MatrizCanalRubro.aspx.cs" Inherits="CYP.Pages.MatrizCanalRubro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="matrizCanalRubro">
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

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <table class="jsgrid-table" style="min-width: 800px">
                    <thead>
                        <tr class="jsgrid-header-row">
                            <th></th>
                            <th class="text-center" ng-repeat="item in canales">
                                {{item.NombreCanal}}
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr ng-repeat="rubro in rubrosCanal">
                            <td>
                                {{rubro.Nombre}}
                            </td>
                            <td class="text-center" ng-repeat="item in rubro.canales">
                                <input type="checkbox" ng-model="item.Seleccionado">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/matrizCanalRubro.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
