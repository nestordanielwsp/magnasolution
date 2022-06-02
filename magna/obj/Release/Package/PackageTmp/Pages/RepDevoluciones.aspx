<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepDevoluciones.aspx.cs" Inherits="CYP.Pages.RepDevoluciones" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repDevoluciones">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>
        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-sm-8">
                        <div class="row">
                            <div class="col-sm-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>
                            <div class="clearfix visible-xs pt-5"></div>
                            <div class="col-sm-5">
                                <select ng-model="filtro.Anio" class="form-control-select"
                                    ng-options="anio as anio for anio in anios"
                                    ng-change="actualizar()">
                                </select>
                            </div>
                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>
                            <div class="col-sm-5">
                                <select ng-model="filtro.MesId" class="form-control-select"
                                    ng-options="item.Id as item.Name for item in meses"
                                    ng-change="actualizar()">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <i class="glyphicon glyphicon-filter d-block"></i>
                            <%= this.GetMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="actualizar()">
                            <div class="glyphicon glyphicon-refresh d-block"></div>
                            <%= this.GetMessage("btnActualizar") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <i class="glyphicon glyphicon-download-alt d-block"></i>
                            <%= this.GetMessage("btnExcel") %>
                        </button>
                    </div>
                </div>
            </div>
            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCanal") %></label>
                            <select ng-model="filtro.CanalId" class="form-control-select" ng-options="item.CanalId as item.NombreCanal for item in canales" ng-change="actualizar()">
                                <option value="" ng-if="canales.length > 1">
                                    <%= this.GetMessage("lblTodos") %>
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCliente") %> </label>
                            <ex-autocomplete ng-model="filtro.ClienteId" options="clienteOptions" on-select="actualizar()" clean-button />
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblMarca") %></label>
                            <select ng-model="filtro.LineaCodigo" class="form-control-select" ng-options="item.LineaCodigo as item.NombreMarca for item in marcas" ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div> 
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCausal") %></label>
                            <select ng-model="filtro.CausalDevolucionId" class="form-control-select" ng-options="item.CausalDevolucionId as item.NombreCausal for item in causales" ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>                                        
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblEstatus") %></label>
                            <select ng-model="filtro.EstatusNotaCreditoId" class="form-control-select" ng-options="item.EstatusNotaCreditoId as item.Estatus for item in estatus" ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>
                </div>
                
            </div>
            
            <div class="padding-form mail-box" id="Home" ng-show="!sinInformacion">
                <div class="padding-10 wrapper border-bottom">
                    <div class="padding-form" style="padding-top: 0!important">
                        <div class="row" ng-show="sinInformacion">
                            <div class="col-sm-12 text-center">
                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                            </div>
                        </div>
                        <div ui-table="concentrado" st-fixed ng-hide="sinInformacion">
                                <table class="jsgrid-table" style="min-width: 3000px" st-table="concentrado" st-safe-src="_concentrado">
                                    <thead>
                                        <tr class="text-center">
                                            <th ui-field width="2"><%= this.GetMessage("gvReporte-Folio") %></th>
                                            <th ui-field width="2"><%= this.GetMessage("gvReporte-Codigo") %></th>
                                            <th ui-field width="5"><%= this.GetMessage("gvReporte-CobrarA") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("gvReporte-Canal") %></th>
                                            <th ui-field width="5"><%= this.GetMessage("gvReporte-Marca") %></th>
                                            <th ui-field width="2"><%= this.GetMessage("gvReporte-CodigoProducto") %></th>
                                            <th ui-field width="7"><%= this.GetMessage("gvReporte-Producto") %></th>
                                            <th ui-field width="2"><%= this.GetMessage("gvReporte-CantidadSolicitada") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-CausalDevolucion") %></th>
                                            <th ui-field width="2"><%= this.GetMessage("gvReporte-Subtotal") %></th>
                                            <th ui-field width="2"><%= this.GetMessage("gvReporte-Total") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-SolicitadoPor") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-PendienteAutorizar") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-UltimoAutorizador") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-FechaSolucitud") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-FechaAprobacion") %></th>
                                            <th ui-field width="4"><%= this.GetMessage("gvReporte-QAD") %></th>
                                            <th ui-field width="3"><%= this.GetMessage("gvReporte-Estatus") %></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr ng-repeat="item in concentrado">
                                            <td st-ratio="2" class="text-center">{{item.Folio}}</td>
                                            <td st-ratio="2" class="text-center">{{item.Codigo}}</td>
                                            <td st-ratio="5">{{item.CobrarA}}</td>
                                            <td st-ratio="3" class="text-center">{{item.Canal}}</td>
                                            <td st-ratio="5" class="text-center">{{item.Marca}}</td>
                                            <td st-ratio="2" class="text-center">{{item.CodigoProducto}}</td>
                                            <td st-ratio="7">{{item.Producto}}</td>
                                            <td st-ratio="2" class="text-center">{{item.CantidadSolicitada}}</td>
                                            <td st-ratio="4">{{item.CausalDevolucion}}</td>
                                            <td st-ratio="2" class="text-right">{{item.Subtotal | currency}}</td>
                                            <td st-ratio="2" class="text-right">{{item.Total | currency}}</td>
                                            <td st-ratio="4">{{item.SolicitadoPor}}</td>
                                            <td st-ratio="4">{{item.PendienteAutorizar}}</td>
                                            <td st-ratio="4">{{item.UltimoAutorizador}}</td>
                                            <td st-ratio="4" class="text-center">{{item.FechaSolucitud}}</td>
                                            <td st-ratio="4" class="text-center">{{item.FechaAprobacion}}</td>
                                            <td st-ratio="4" class="text-center">{{item.QAD}}</td>
                                            <td st-ratio="3" class="text-center">{{item.Estatus}}</td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="18">
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
    <script src="../Scripts/pages/repDevoluciones.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
