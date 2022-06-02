<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="PerfilFuncional.aspx.cs" Inherits="CYP.Pages.PerfilFuncional" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="perfilFuncional">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-hide="esDetalle">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-10">
                                <input type="text" class="form-control" ng-model="filtro.Nombre" key-enter="getPerfiles()"
                                    placeholder="Busqueda rápida por (<%= this.GetMessage("lblNombre") %>)">
                            </div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="getPerfiles()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetMessage("btnBuscar") %>
                        </button>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="descuentos" st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 800px">
                        <thead>
                            <tr>
                                <th ui-field width="8">
                                    <%= this.GetMessage("lblOrden") %>
                                </th>
                                <th ui-field width="30">
                                    <%= this.GetMessage("lblNombre") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("lblTipo") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("lblEsVendedor") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in perfiles">
                                <td st-ratio="8">{{item.OrdenAprobacion}}</td>
                                <td st-ratio="30">{{item.Nombre}}</td>
                                <td st-ratio="15">{{item.TipoPerfil}}</td>
                                <td st-ratio="15">
                                    <span ng-show="item.EsVendedor"><%= this.GetMessage("lblSi") %></span>
                                    <span ng-hide="item.EsVendedor"><%= this.GetMessage("lblNo") %></span>
                                </td>
                                <td st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="getPerfil(item)">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="perfiles.length == 0" class="nodata-row">
                                <td colspan="5" class="text-center">
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
                    <div class="subtitulo-color"><%= this.GetMessage("lblDetallePerfil") %></div>
                </div>
                <div class="btn-tpm col-sm-6">
                    <div>
                        <div class="btn btn-top" ng-click="guardar()" tooltip-placement="bottom"
                             uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>"
                             <%--ng-show="perfil.EsAprobarPorMonto"--%>
                            >
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
                        <div class="col-md-3 col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblNombre") %> </span>
                            <input type="text" ng-model="perfil.Nombre" class="form-control-input" readonly="readonly" />
                        </div>

                        <div class="form-group col-md-2 col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 10px">
                                <%= this.GetMessage("lblEsVendedor") %> 
                            </span>
                            <switcher ng-model="perfil.EsVendedor" true-label="<%= this.GetMessage("lblSi") %>"
                                false-label="<%= this.GetMessage("lblNo") %>" ng-disabled="true"></switcher>
                        </div>

                        <div class="col-md-2 col-sm-4" ng-show="perfil.OrdenAprobacion">
                            <span class="label-color"><%= this.GetMessage("lblOrden") %> </span>
                            <input type="text" ng-model="perfil.OrdenAprobacion" class="form-control-input"
                                money precision="0" maxlength="2" readonly="readonly" />
                        </div>

                        <div class="clearfix visible-sm"></div>

                        <div class="col-md-3 col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 12px">
                                <%= this.GetMessage("lblTipo") %> 
                            </span>
                            <label class="radio-inline">
                                <input type="radio" ng-model="perfil.Tipo" value="0" disabled>
                                <%= this.GetMessage("lblVentas") %>
                            </label>
                            <label class="radio-inline">
                                <input type="radio" ng-model="perfil.Tipo" value="1" disabled>
                                <%= this.GetMessage("lblCartera") %>
                            </label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="form-group col-md-2 col-sm-4">
                            <span class="label-color" style="display: block; margin-bottom: 10px">
                                <%= this.GetMessage("lblEsEsCrearModificarActivity") %> 
                            </span>
                            <switcher ng-model="perfil.EsCrearModificarActivity" true-label="<%= this.GetMessage("lblSi") %>"
                                false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                        </div>
                    </div>

                    <div ng-show="perfil.EsAprobarPorMonto">
                        <div class="row">
                            <div class="col-sm-12">
                                <span class="subtitulo-color"><%= this.GetMessage("lblAutorizaEn") %> </span>
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-2 col-sm-6">
                                <span class="label-color" style="display: block; margin-bottom: 10px">
                                    <%= this.GetMessage("lblContractual") %> 
                                </span>
                                <switcher ng-model="perfil.ApruebaContractual" true-label="<%= this.GetMessage("lblSi") %>"
                                    false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                            </div>

                            <div class="col-md-2 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblMontoAutorizacion") %> </span>
                                <input type="text" ng-model="perfil.MontoContractual" class="form-control-input"
                                    money maxlength="12" />
                            </div>

                            <div class="clearfix visible-sm"></div>

                            <div class="col-md-2 col-sm-6">
                                <span class="label-color" style="display: block; margin-bottom: 10px">
                                    <%= this.GetMessage("lblExtracontractual") %> 
                                </span>
                                <switcher ng-model="perfil.ApruebaExtracontractual" true-label="<%= this.GetMessage("lblSi") %>"
                                    false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                            </div>

                            <div class="col-md-2 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblMontoAutorizacion") %> </span>
                                <input type="text" ng-model="perfil.MontoExtracontractual" class="form-control-input"
                                    money maxlength="12" />
                            </div>

                            <div class="clearfix visible-sm"></div>

                            <div class="col-md-2 col-sm-6">
                                <span class="label-color" style="display: block; margin-bottom: 10px">
                                    <%= this.GetMessage("lblApv") %> 
                                </span>
                                <switcher ng-model="perfil.ApruebaApv" true-label="<%= this.GetMessage("lblSi") %>"
                                    false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                            </div>

                            <div class="col-md-2 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblMontoAutorizacion") %> </span>
                                <input type="text" ng-model="perfil.MontoApv" class="form-control-input"
                                    money maxlength="12" />
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="col-md-2 col-sm-6">
                                <span class="label-color" style="display: block; margin-bottom: 10px">
                                    <%= this.GetMessage("lblDevolucion") %> 
                                </span>
                                <switcher ng-model="perfil.ApruebaDevolucion" true-label="<%= this.GetMessage("lblSi") %>"
                                    false-label="<%= this.GetMessage("lblNo") %>"></switcher>
                            </div>

                            <div class="col-md-2 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblMontoAutorizacion") %> </span>
                                <input type="text" ng-model="perfil.MontoDevolucion" class="form-control-input"
                                    money maxlength="12" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/perfilFuncional.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
