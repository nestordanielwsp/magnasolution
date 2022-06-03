<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="RepCliente.aspx.cs" Inherits="CYP.Pages.RepCliente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="repCliente">
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

                            <div class="col-md-10">
                                <input type="text" class="form-control" ng-model="filtro.Nombre" key-enter="actualizar()"
                                    placeholder="Busqueda rápida por (<%= this.GetMessage("lblNombre") %>)">
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
                            <select ng-model="filtro.CanalId" class="form-control-select"
                                ng-options="item.CanalId as item.NombreCanal for item in canales"
                                ng-change="actualizar()">
                                <option value="" ng-if="canales.length > 1">
                                    <%= this.GetMessage("lblTodos") %>
                                </option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblRegion") %></label>
                            <select ng-model="filtro.RegionId" class="form-control-select"
                                ng-options="item.RegionId as item.NombreRegion for item in regiones"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblVendedor") %> </label>
                            <ex-autocomplete ng-model="filtro.VendedorId" options="vendedorOptions"
                                on-select="actualizar()" clean-button />
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblJefeVentas") %> </label>
                            <ex-autocomplete ng-model="filtro.JefeId" options="jefeOptions"
                                on-select="actualizar()" clean-button />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblJac") %></label>
                            <select ng-model="filtro.JacId" class="form-control-select"
                                ng-options="item.UsuarioId as item.NombreUsuario for item in jacs"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblTipo") %></label>
                             <select ng-model="filtro.TipoId" class="form-control-select" 
                                 ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                                 <option value="1"><%= this.GetMessage("lblCobrarA") %></option>
                                 <option value="2"><%= this.GetMessage("lblPuntoEntrega") %></option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblAnalista") %></label>
                            <select ng-model="filtro.AnalistaId" class="form-control-select"
                                ng-options="item.UsuarioId as item.NombreUsuario for item in analistas"
                                ng-change="actualizar()">
                                <option value=""><%= this.GetMessage("lblTodos") %></option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="clientes" st-fixed>
                    <table class="jsgrid-table"  st-table="clientes" st-safe-src="_clientes"
                        style="width: 4000px; min-width: 4000px">
                        <thead>
                            <tr>
                                <th ui-field width="8">
                                    <%= this.GetMessage("gvReporte-Codigo") %>
                                </th>
                                <th ui-field width="8">
                                    <%= this.GetMessage("gvReporte-CobrA") %>
                                </th>
                                <th ui-field width="25">
                                    <%= this.GetMessage("gvReporte-NombreCliente") %>
                                </th>
                                <th ui-field width="25">
                                    <%= this.GetMessage("gvReporte-Direccion") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvReporte-Ciudad") %>
                                </th>
                                <th ui-field width="8">
                                    <%= this.GetMessage("gvReporte-CodigoPostal") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvReporte-Estado") %>
                                </th>
                                <th ui-field width="8">
                                    <%= this.GetMessage("gvReporte-Pais") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvReporte-Rfc") %>
                                </th>
                                <th ui-field width="8">
                                    <%= this.GetMessage("gvReporte-Canal") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvReporte-Almacen") %>
                                </th>
                                <th ui-field width="12">
                                    <%= this.GetMessage("gvReporte-Tipo") %>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvReporte-Vendedor") %>
                                </th>
                                 <th ui-field width="20">
                                    <%= this.GetMessage("gvReporte-JefeVentas") %>
                                </th>
                                 <th ui-field width="20">
                                    <%= this.GetMessage("gvReporte-AnalistaCartera") %>
                                </th>
                                 <th ui-field width="20">
                                    <%= this.GetMessage("gvReporte-Jac") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("gvReporte-NombreRegion") %>
                                </th>
                                 <th ui-field width="6">
                                    <%= this.GetMessage("gvReporte-Activo") %>
                                </th>
                                <th ui-field width="12">
                                    <%= this.GetMessage("gvReporte-RetencionCredito") %>
                                </th>
                                <th ui-field width="12">
                                    <%= this.GetMessage("gvReporte-NoIdentificador") %>
                                </th>
                                <th ui-field width="12">
                                    <%= this.GetMessage("gvReporte-TerminosCredito") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvReporte-ListaPrecios") %>
                                </th>
                                <th ui-field class="text-center" width="12">
                                    <%= this.GetMessage("gvReporte-LimiteCredito") %>
                                </th>
                                 <th ui-field class="text-center" width="12">
                                    <%= this.GetMessage("gvReporte-MontoCartera") %>
                                </th>
                                <th ui-field class="text-center" width="15">
                                    <%= this.GetMessage("gvReporte-MontoDisponible") %>
                                </th>
                                <th ui-field width="12">
                                    <%= this.GetMessage("gvReporte-CuentaLmClientes") %>
                                </th>
                                <th ui-field width="8">
                                    <%= this.GetMessage("gvReporte-Moneda") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("gvReporte-Observaciones") %>
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in clientes">
                                <td st-ratio="8">{{item.Codigo}}</td>
                                <td st-ratio="8">{{item.CobrA}}</td>
                                <td st-ratio="25">{{item.NombreCliente}}</td>
                                <td st-ratio="25">{{item.Direccion}}</td>
                                <td st-ratio="10">{{item.Ciudad}}</td>
                                <td st-ratio="8">{{item.CodigoPostal}}</td>
                                <td st-ratio="10">{{item.Estado}}</td>
                                <td st-ratio="8">{{item.Pais}}</td>
                                <td st-ratio="10">{{item.Rfc}}</td>
                                <td st-ratio="8">{{item.Canal}}</td>
                                <td st-ratio="10">{{item.Almacen}}</td>
                                <td st-ratio="12">{{item.Tipo}}</td>
                                <td st-ratio="20">{{item.Vendedor}}</td>
                                <td st-ratio="20">{{item.JefeVentas}}</td>
                                <td st-ratio="20">{{item.AnalistaCartera}}</td>
                                <td st-ratio="20">{{item.Jac}}</td>
                                <td st-ratio="15">{{item.NombreRegion}}</td>
                                <td st-ratio="6">{{item.Activo}}</td>
                                <td class="text-center" st-ratio="12">{{item.RetencionCredito}}</td>
                                <td st-ratio="12">{{item.NoIdentificador}}</td>
                                <td st-ratio="12">{{item.TerminosCredito}}</td>
                                <td st-ratio="10">{{item.ListaPrecios}}</td>
                                <td st-ratio="12" class="text-right">{{item.LimiteCredito | currency}}</td>
                                <td st-ratio="12" class="text-right">{{item.MontoCartera | currency}}</td>
                                <td st-ratio="15" class="text-right">{{item.MontoDisponible | currency}}</td>
                                <td st-ratio="12">{{item.CuentaLmClientes}}</td>
                                <td st-ratio="8">{{item.Moneda}}</td>
                                <td st-ratio="15">{{item.Observaciones}}</td>
                            </tr>
                            <tr ng-if="clientes.length === 0" class="nodata-row">
                                <td colspan="28" class="text-center">
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

    <script type="text/javascript" src="../scripts/pages/repCliente.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
