<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Articulo.aspx.cs" Inherits="CYP.Pages.Articulo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="articulo">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-hide="esDetalle">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-10">
                                <input type="text" class="form-control" ng-model="filtro.Nombre" key-enter="getArticulos()"
                                    placeholder="<%= this.GetMessage("lblBusqueda") %> (<%= this.GetMessage("lblArticulo") %> / <%= this.GetMessage("lblNumArticulo") %>)">
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="getArticulos()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="agregar()">
                            <div class="glyphicon glyphicon-plus d-block"></div>
                            <%= this.GetCommonMessage("lblTooltipAgregar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="articulos" st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 800px">
                        <thead>
                            <tr>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblNumArticulo") %>
                                </th>
                                <th ui-field width="70">
                                    <%= this.GetMessage("lblArticulo") %>
                                </th>
                                <th ui-field width="10"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in articulos">
                                <td st-ratio="20">{{item.NumArticulo}}</td>
                                <td st-ratio="70">{{item.Nombre}}</td>
                                <td class="text-center" st-ratio="10">
                                    <button type="button" class="btn btn-link" ng-click="getArticulo(item)">
                                        <%= this.GetCommonMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="articulos.length == 0" class="nodata-row">
                                <td colspan="2" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="12">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="esDetalle" ng-form="forma" ng-class="{'submitted': submitted}">
            <div class="row">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("lblDetalleArticulo") %></div>
                </div>
                <div class="btn-tpm col-sm-6">
                    <div>
                        <div class="btn btn-top" ng-click="guardar()" tooltip-placement="bottom"
                             uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div>
                        <div class="btn btn-top" ng-click="esDetalle=false" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mail-box">
                <div class="padding-form">
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblNumArticulo") %> </span>
                            <input type="text" ng-model="articulo.NumArticulo" class="form-control-input" ng-disabled="articulo.ArticuloId !=0 " maxlength="50" required />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblNombreArticulo") %> </span>
                            <input type="text" ng-model="articulo.Nombre" class="form-control-input" required maxlength="100" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 10px">
                                <%= this.GetCommonMessage("lblActivo") %> 
                            </span>
                            <switcher ng-model="articulo.Active" true-label="<%= this.GetCommonMessage("lblSi") %>"
                                false-label="<%= this.GetCommonMessage("lblNo") %>"></switcher>
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblAlmacen") %> </span>
                            <input type="text" ng-model="articulo.Almacen" class="form-control-input" required maxlength="100" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblUnidadMedida") %> </span>
                            <input type="text" ng-model="articulo.UnidadMedida" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblLineaProductos") %> </span>
                            <input type="text" ng-model="articulo.LineaProductos" class="form-control-input" required maxlength="50" />
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblTipoArticulo") %> </span>
                            <input type="text" ng-model="articulo.TipoArticulo" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblEstado") %> </span>
                            <input type="text" ng-model="articulo.Estado" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblComprador") %> </span>
                            <input type="text" ng-model="articulo.Comprador" class="form-control-input" required maxlength="300" />
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblTiposATP") %> </span>
                            <input type="text" ng-model="articulo.TiposATPForzado" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblRestricionADD") %> </span>
                            <input type="text" ng-model="articulo.RestriccionADDSO" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                        </div>
                    </div>
                </div>
            </div>

           <%-- <div class="mail-box padding-form">
                <div class="row">
                    <div class="col-sm-12">
                        <span class="subtitulo-color"><%= this.GetMessage("lblConfiguracionListaPrecio") %> </span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-responsive">
                            <table class="table table-striped table-condensed table-hover">
                                <thead>
                                    <tr style="background-color: #f0f5f5">
                                        <th class="cell-separator">
                                            <i class="fa fa-plus pointer" ng-click="agregarLista()"></i>
                                        </th>
                                        <th class="text-center cell-separator" colspan="3" ng-repeat="item in articulo.Proveedores"
                                            style="width: 750px">{{item.Nombre}}
                                        </th>
                                    </tr>

                                    <tr class="jsgrid-header-row">
                                        <th class="cell-separator" style="min-width: 100px">
                                            <%= this.GetMessage("lblCantidades") %>
                                        </th>
                                        <th class="text-center" ng-repeat-start="item in articulo.Proveedores"
                                            style="min-width: 100px">
                                            <%= this.GetMessage("lblPrecio") %>
                                        </th>
                                        <th class="text-center" style="min-width: 100px">
                                            <%= this.GetMessage("lblDiasProduccion") %>
                                        </th>
                                        <th class="text-center cell-separator" ng-repeat-end style="min-width: 100px">
                                            <%= this.GetMessage("lblCodigo") %>
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr ng-repeat="lista in articulo.ListaPrecios">
                                        <td class="cell-separator">
                                            <input type="text" class="form-control-input" ng-model="lista.Cantidad" money
                                                maxlength="9" precision='0' required>
                                        </td>
                                        <td class="text-right" ng-repeat-start="item in lista.Proveedores">
                                            <input type="text" class="form-control-input" ng-model="item.Precio" money maxlength="12" required>
                                        </td>
                                        <td class="text-right">
                                            <input type="text" class="form-control-input" ng-model="item.DiasProduccion" money
                                                maxlength="5" precision='0' required>
                                        </td>
                                        <td class="text-right cell-separator" ng-repeat-end>
                                            <input type="text" class="form-control-input" ng-model="item.Codigo" required>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>--%>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/articulo.js?V002"></script>
</asp:Content>
