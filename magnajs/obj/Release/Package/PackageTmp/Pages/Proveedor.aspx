<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Proveedor.aspx.cs" Inherits="CYP.Pages.Proveedor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="proveedor">
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
                                <input type="text" class="form-control" ng-model="filtro.Nombre" key-enter="getProveedores()"
                                    placeholder="<%= this.GetMessage("lblNombreCodigo") %>">
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="getProveedores()">
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
                <div ui-table="proveedores" st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 800px">
                        <thead>
                            <tr>
                                <th ui-field width="30">
                                    <%= this.GetMessage("lblNombre") %>
                                </th>
                                <th ui-field width="60">
                                    <%= this.GetMessage("lblCodigoQad") %>
                                </th>
                                <th ui-field width="10"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in proveedores">
                                <td st-ratio="30">{{item.Nombre}}</td>
                                <td st-ratio="30">{{item.CodigoQad}}</td>
                                <td class="text-center" st-ratio="10">
                                    <button type="button" class="btn btn-link" ng-click="getProveedor(item)">
                                        <%= this.GetCommonMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="proveedores.length == 0" class="nodata-row">
                                <td colspan="3" class="text-center">
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

        <div class="page-content" ng-show="esDetalle">
            <div class="row">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("lblDetalleProveedor") %></div>
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

            <div class="mail-box" ng-form="forma" ng-class="{'submitted': submitted}">
                <div class="padding-form">
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblNombre") %> </span>
                            <input type="text" ng-model="proveedor.Nombre" class="form-control-input" required maxlength="100" />
                        </div>

                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblCodigoQad") %> </span>
                            <input type="text" ng-model="proveedor.CodigoQad" class="form-control-input" ng-disabled="proveedor.ProveedorId !=0 " required maxlength="100" />
                        </div>

                        <div class="col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 10px">
                                <%= this.GetCommonMessage("lblActivo") %> 
                            </span>
                            <switcher ng-model="proveedor.Active" true-label="<%= this.GetCommonMessage("lblSi") %>"
                                false-label="<%= this.GetCommonMessage("lblNo") %>"></switcher>
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblCodRelacionComercial") %> </span>
                            <input type="text" ng-model="proveedor.CodRelacionComercial" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblTipoProveedor") %> </span>
                            <input type="text" ng-model="proveedor.TipoProveedor" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 10px">
                                <%= this.GetMessage("lblPagaCargosBancarios") %> 
                            </span>
                            <switcher ng-model="proveedor.PagaCargosBancarios" true-label="<%= this.GetCommonMessage("lblSi") %>"
                                false-label="<%= this.GetCommonMessage("lblNo") %>"></switcher>
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblPais") %> </span>
                            <input type="text" ng-model="proveedor.Pais" class="form-control-input" required maxlength="100" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblEstado") %> </span>
                            <input type="text" ng-model="proveedor.Estado" class="form-control-input" required maxlength="100" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblCondado") %> </span>
                            <input type="text" ng-model="proveedor.Condado" class="form-control-input" required maxlength="100" />
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblCiudad") %> </span>
                            <input type="text" ng-model="proveedor.Ciudad" class="form-control-input" required maxlength="100" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblDireccion") %> </span>
                            <input type="text" ng-model="proveedor.Direccion" class="form-control-input" required maxlength="150" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblCodigoPostal") %> </span>
                            <input type="text" ng-model="proveedor.CodigoPostal" class="form-control-input" required maxlength="10" />
                        </div>
                    </div>
                     <br />
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblImpuestoFederal") %> </span>
                            <input type="text" ng-model="proveedor.ImpuestoFederal" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblImpuestoEstatal") %> </span>
                            <input type="text" ng-model="proveedor.ImpuestoEstatal" class="form-control-input" required maxlength="50" />
                        </div>
                        <div class="col-sm-4">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/proveedor.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
