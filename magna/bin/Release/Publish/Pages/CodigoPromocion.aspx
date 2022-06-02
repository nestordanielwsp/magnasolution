<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="CodigoPromocion.aspx.cs" Inherits="CYP.Pages.CodigoPromocion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="codigoPromocional">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-hide="esNuevo">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblBusquedaActivity") %></label>
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" maxlength="100" ng-model="filtro.Activity" key-enter="Obtenercodigos()"
                                    placeholder="<%= this.GetMessage("lblPlaceholderBusquedaActivity") %>">
                            </div>
                            <div class="col-md-1">
                                <label class="label-filter"><%= this.GetMessage("lblMes") %></label>
                            </div>
                            <div class="col-md-2">
                                <select
                                    class="form-control form-control-select"
                                    ng-model="filtro.mes" required
                                    ng-options="item.Id as item.Name for item in Meses">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                            <div class="col-md-1">
                                <label class="label-filter"><%= this.GetMessage("lblYear") %></label>
                            </div>
                            <div class="col-md-2">
                                <select
                                    class="form-control form-control-select"
                                    ng-model="filtro.year" required
                                    ng-options="anio as anio for anio in Year">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                        </div>

                    </div>
                    <div class="clearfix visible-xs">
                        <br />
                    </div>
                    <div class="col-md-3 text-right">
                        <button type="button" class="btn btn-link" ng-click="Obtenercodigos()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="guardar()">
                            <div class="glyphicon glyphicon-floppy-disk d-block"></div>
                            Guardar
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box padding-10 wrapper border-bottom" id="Home" ng-if="pantallaId === pantallas.principal">
                <div ui-table="codigoPromocional" st-fixed>
                    <table class="jsgrid-table" style="min-width: 950px">
                        <thead>
                            <tr>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvCodigo-CodigoPromocional")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvCodigo-Producto")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvCodigo-Activity")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvCodigo-Fecha")%>
                                </th>
                                <th ui-field width="2">
                                    <i class="fa fa-plus pointer" ng-click="agregar()"></i>
                                </th>
                            </tr>
                        </thead>
                        <tbody ng-form="forma">
                            <tr ng-repeat="item in promociones">
                                <td st-ratio="20">{{item.Codigo}}
                                </td>
                                <td st-ratio="20">
                                    <span ng-show="!{{item.esNuevo}}">{{item.Nombre}}
                                    </span>
                                    <span ng-show="{{item.esNuevo}}">
                                        <select
                                            class="form-control form-control-select"
                                            ng-model="item.ProductoId" required
                                            ng-options="item.ProductoId as item.Nombre for item in productos">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </span>
                                </td>
                                <td st-ratio="20">{{item.MarcaId}}
                                        {{item.Activity}}
                                </td>
                                <td st-ratio="20">{{item.Fecha | date:'mediumDate'}}
                                </td>
                                <td st-ratio="20" ng-show="{{item.esNuevo}}">
                                    <button type="button" class="btn btn-link" ng-click="eliminar(item, $index)">
                                        <i class="fa fa-remove pointer"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="esNuevo">
            <div class="mail-box" ng-form="forma" ng-class="{'submitted': submitted}">
                <div class="padding-form">
                    <div class="row">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblNombre") %> </span>
                            <input type="text" ng-model="promocion.Producto" class="form-control-input" />
                        </div>

                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                            <input type="text" ng-model="promocion.Marca" class="form-control-input" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>



    <script type="text/javascript" src="../scripts/pages/codigoPromocion.js"></script>

</asp:Content>
