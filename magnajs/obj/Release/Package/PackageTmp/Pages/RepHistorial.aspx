<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepHistorial.aspx.cs" Inherits="CYP.Pages.RepHistorial" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repHistorial">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4">
                                <input type="text" class="form-control" ng-model="filtro.Usuario" key-enter="obtenerHistorial()"
                                    placeholder="Busqueda rápida por (<%= this.GetMessage("lblNombre") %>)">
                            </div>
                            

                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblCatalogo") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 va-m">
                                <div class="width-auto" selected-model="filtro.Catalogo"
                                    options="catalogo" extra-settings="catalogoOptions"
                                    translation-texts="translateTextMultiSelect"
                                    ng-dropdown-multiselect="" style="margin: 5px">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <i class="glyphicon glyphicon-filter d-block"></i>
                            <%= this.GetMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="obtenerHistorial()">
                            <div class="glyphicon glyphicon-refresh d-block"></div>
                            <%= this.GetMessage("btnActualizar") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <div class="glyphicon glyphicon-download-alt d-block"></div>
                            <%= this.GetCommonMessage("btnExcel") %>
                        </button>
                        <%--<button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <i class="glyphicon glyphicon-download-alt d-block"></i>
                            <%= this.GetMessage("btnExcel") %>
                        </button>--%>
                    </div>
                </div>
            </div>

            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblFechas") %></label>
                            <datepicker-range ng-model="filtro.Fecha" input-class="form-control-input" />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblActividad") %></label>
                            <select ng-model="filtro.ActividadId" class="form-control-select"
                                ng-options="item.ActividadId as item.NombreActividad for item in actividades">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="historial" st-fixed>
                    <table class="jsgrid-table" 
                        style="width: 1500px; min-width: 1500px">
                        <thead>
                            <tr>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Catalogo") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Registro") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Campo") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Anterior") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Actual") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Fecha") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-IDUsuario") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Usuario") %>
                                </th>
                                <th ui-field width="5">
                                    <%= this.GetMessage("gvReporte-Actividad") %>
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in historial">
                                <td st-ratio="5">{{item.NombreCatalogo}}</td>
                                <td st-ratio="5">{{item.Registro}}</td>
                                <td st-ratio="5">{{item.Campo}}</td>
                                <td st-ratio="5">{{item.ValorAnterior}}</td>
                                <td st-ratio="5">{{item.ValorActual}}</td>
                                <td st-ratio="5">{{item.FechaModificacion}}</td>
                                <td st-ratio="5">{{item.UsuarioId}}</td>
                                <td st-ratio="5">{{item.NombreUsuario}}</td>
                                <td st-ratio="5">{{item.NombreActividad}}</td>
                                
                            </tr>
                            <tr ng-if="clientes.length === 0" class="nodata-row">
                                <td colspan="8" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="28">
                                    <div st-pagination="5" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/repHistorial.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
