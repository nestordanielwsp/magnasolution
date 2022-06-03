<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="CapturaRequisicion.aspx.cs" Inherits="CYP.Pages.CapturaRequisicion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="capturaRequisicion">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-show="pantallaId === pantallas.principal">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 col-lg-5">
                                <input type="text" class="form-control" maxlength="100" ng-model="filtro.NumRequisicion" key-enter="ObtenerRequisiciones()"
                                    placeholder="<%= this.GetMessage("lblBusquedaRequisicion") %>">
                            </div>

                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-4 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <div class="glyphicon glyphicon-filter d-block"></div>
                            <%= this.GetCommonMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="ObtenerRequisiciones()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                        <!--<button type="button" class="btn btn-link" ng-click="agregar()">
                            <div class="glyphicon glyphicon-plus d-block"></div>
                            <%= this.GetCommonMessage("btnNuevo") %>
                        </button>-->
                    </div>
                </div>
            </div>
            <%-- filtros avanzados --%>
            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                            <label class="label-color" style="margin-bottom:10px; margin-top:5px;"><%= this.GetMessage("lblCodigoActivity") %></label>
                            <div class="form-group">
                            <input type="text" ng-model="filtro.ActivityId" class="form-control" />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <label class="label-color"><%= this.GetMessage("lblProveedor") %></label>
                        <button type="button" class="btn btn-link" ng-click="filtro.ProveedorId = ''" >
                                <div class="glyphicon glyphicon-remove"></div>
                            </button>
                        <div class="form-group">
                                <ex-autocomplete ng-model="filtro.ProveedorId" options="proveedorOptions"
                                item="activity" append-to-body >
                                </ex-autocomplete>
                        </div>
                    </div>
                    </div>
                    <div class="row">
                     <div class="col-sm-4">
                         <div class="form-group">
                           <span class="label-color"><%= this.GetMessage("lblFechas") %> </span>
                               <datepicker-range ng-model="filtro.Fecha" input-class="form-control-input" />
                         </div>
                    </div>
                    <div class="col-sm-4">
                         <div class="form-group">
                           <span class="label-color"><%= this.GetMessage("lblMontoMin") %> </span>
                                <input type="text" ng-model="filtro.MontoMin" class="form-control" money precision="00" />
                         </div>
                        </div>
                    <div class="col-sm-4">
                         <div class="form-group">
                           <span class="label-color"><%= this.GetMessage("lblMontoMax") %> </span>
                                <input type="text" ng-model="filtro.MontoMax" class="form-control" money precision="00" />
                         </div>
                    </div>
                </div>
                <div class="row">
                     <div class="col-sm-4">
                         <label class="label-color"><%= this.GetMessage("lblRutaA") %></label>
                         <div class="form-group">
                          <select ng-model="filtro.RutaA" class="form-control-select no-disabled"
                                    ng-options="c.AprobadorId as c.Nombre for c in aprobador">
                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                        </select>
                         </div>
                    </div>
                </div>
                </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="activities" st-fixed>
                    <table class="jsgrid-table" style="min-width: 900px">
                        <thead>
                            <tr>
                                <th ui-field width="9">
                                    <%= this.GetMessage("lblNumeroRequisicion") %>
                                </th>
                                <th ui-field width="16">
                                    <%= this.GetMessage("lblProveedor") %>
                                </th>
                                <th ui-field width="9">
                                    <%= this.GetMessage("lblCantArticulos") %>
                                </th>
                                <th ui-field width="8" class="text-center">
                                    <%= this.GetMessage("lblRubro") %>
                                </th>
                                <th ui-field width="8" class="text-center">
                                    <%= this.GetMessage("lblActivity") %>
                                </th>
                                <th ui-field width="9" class="text-center">
                                    <%= this.GetMessage("lblFechaRequisicion") %>
                                </th>
                                <th ui-field width="9" class="text-center">
                                    <%= this.GetMessage("lblCosto") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in requisiciones">
                                <td st-ratio="9">{{item.NumRequisicion}}</td>
                                <td st-ratio="16">{{item.ProveedorNombre}}</td>
                                <td st-ratio="9" class="text-right">{{item.CantArticulos}}</td>
                                <td st-ratio="9" class="text-right">{{item.Rubro}}</td>
                                <td st-ratio="8" class="text-center">{{item.CodigoActivity}}</td>
                                <td st-ratio="9" class="text-center">{{item.FechaRequisicion}}</td>
                                <td st-ratio="9" style="text-align: right">{{item.TotalCosto | currency}}</td>
                                <td class="text-center" st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="ObtenerRequisicion(item)">
                                        <%= this.GetCommonMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="provisiones.length == 0" class="nodata-row">
                                <td colspan="8" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="page-content" ng-show="pantallaId === pantallas.verRequisicion">
            <div class="row mb">
                <div class="btn-tpm col-sm-12">
                    <div>
                        <div class="btn btn-top" ng-click="pantallaId = pantallas.principal" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mail-box padding-form" id="Requisicion">
                <div class="row">
                    <div class="col-sm-4 col-md-4">
                        <div class="subtitulo-color"><%= this.GetMessage("lblRequisicion") %></div>
                    </div>
                    <div class="col-sm-4 col-md-4">
                    </div>
                    <div class="col-sm-4 col-md-4" style="text-align:right">
                        <%= this.GetMessage("lblTotalCosto") %>
                        <strong>$ {{requisicion.TotalReq | number:2}}</strong>
                    </div>
                </div>
                <div class="row" style="padding-top:20px">
                    <div class="col-sm-4 col-md-3">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblNumeroRequisicion") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.NumRequisicion" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblProveedor") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.ProveedorNombre" class="form-control" readonly>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4 col-md-3">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblNumeroProveedor") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.NumProvedor" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblUbicacion") %></div>
                            <div class="input-group">
                                <%--<input type="text" ng-model="requisicion.Ubicacion" class="form-control" readonly>--%>
                                    <textarea ng-model="requisicion.Ubicacion"  class="form-control" rows="3" readonly></textarea>

                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblSolicitadopor") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.SolicitadoPor" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                     <div class="col-sm-4 col-md-3" ng-show="(requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblSolicitadopor") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.SolicitadoPorPOP" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblUsuarioFinal") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.UsuarioFinal" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblSubCuenta") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.SubCuentaId" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                     <div class="col-sm-4 col-md-3"  ng-show="(requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblCuenta") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.Cuenta" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                      <div class="col-sm-4 col-md-3" ng-show="(requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblMoneda") %></div>
                             <input type="text" ng-model="requisicion.Moneda" class="form-control" readonly="readonly">
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblCeCo") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.CentroCosto" class="form-control" readonly>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblProyecto") %></div>
                             <input type="text" ng-model="requisicion.CodigoProyecto" class="form-control" readonly="readonly">
                            <%--<div class="input-group">
                                <input type="text" ng-model="requisicion.ProyectoId" class="form-control">
                            </div>--%>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblEmpresa") %></div>
                            <input type="text" ng-model="requisicion.Empresa" class="form-control" readonly="readonly">
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblMoneda") %></div>
                             <input type="text" ng-model="requisicion.Moneda" class="form-control" readonly="readonly">
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3"  ng-show="(requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblAlmacen") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.Almacen" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                     <div class="col-sm-4 col-md-3" ng-show="(requisicion.esPOP)">
                         <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblFechaQueSeRequiere") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.FechaRequerida" class="form-control" readonly="readonly">
                            </div>
                        </div>
                     </div>
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblFormatoLinea") %></div>
                            <div class="input-group">
                               <input type="text" ng-model="requisicion.FormatoLinea" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblGrupoLibro") %></div>
                            <input type="text" ng-model="requisicion.GrupoLibro" class="form-control" readonly="readonly">
                           <%-- <div class="input-group">
                                <input type="text" ng-model="requisicion.GrupoLibro" class="form-control">
                            </div>--%>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblIdioma") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.Idioma" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblAlmacen") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.Almacen" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                     <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                         <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblFechaQueSeRequiere") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.FechaRequerida" class="form-control" readonly="readonly">
                            </div>
                        </div>
                     </div>
                     <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                         <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblFechaEntragaEstimada") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.FechaEstimada" class="form-control" readonly="readonly">
                            </div>
                        </div>
                     </div>
                     <div class="col-sm-4 col-md-3">
                     </div>
                </div>
                <%-- Tabla Articulos --%>
                <div class="row">
                    <div class="col-sm-4 col-md-4">
                        <div class="subtitulo-color"><%= this.GetMessage("lblArticulos") %></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                         <div class="table-responsive">
                             <table class="activity-table">
                                <thead>
                                    <tr class="jsgrid-header-row">
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblArticulo") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblUM") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblCantidad") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblCostoUnitario") %>
                                        </th>
                                        <th ui-field width="10">
                                            <%= this.GetMessage("lblTotal") %> 
                                        </th>
                                        <th ui-field width="10" >
                                            <%= this.GetMessage("lblObservaciones") %>
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr ng-repeat="articulo in requisicion.RequisicionDetalle" class ="va-m">
                                        <td st-ratio="20">
                                             {{articulo.ArticuloNombre}}
                                        </td>
                                        <td st-ratio="10">
                                             {{articulo.UnidadMedida}}
                                        </td>
                                        <td st-ratio="10" class="text-center">
                                             {{articulo.Cantidad}}
                                        </td>
                                        <td st-ratio="10">
                                            {{articulo.CostoUnitario | currency}}
                                        </td>
                                        <td st-ratio="10">
                                             {{articulo.Total | currency}}
                                        </td>
                                        <td st-ratio="10">

                                              <div class="btn btn-link btn-lg" data-toggle="modal"  id="{{articulo.RequisicionArticuloId}}" tooltip-placement="top"
                                                uib-tooltip="<%= this.GetMessage("lblVerComentario") %>" ng-click="guardarComentario(articulo)" ng-hide="articulo.Observaciones ===''">
                                                <i class="glyphicon glyphicon-zoom-in d-block"></i>
                                            </div>
                                            <div ng-hide="articulo.Observaciones !==''">
                                                <bold> <%= this.GetMessage("lblSinObservaciones") %></bold>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>


                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="modal fade" id="myModal" role="dialog">
                    <div class="modal-dialog">
   
                      <!-- Modal content-->
                      <div class="modal-content">
                        <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal">&times;</button>
                          <h4 class="modal-title">Observaciones</h4>
                        </div>
                        <div class="modal-body">
                          <input type="text" ng-model="ArticuloSolo.Observaciones" class="form-control" disabled readonly>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-default" data-dismiss="modal" >Cerrar</button>
                        </div>
                      </div>
      
                    </div>
              </div>

                <div class="row" style="padding-top: 50px;">
                    <div class="col-sm-4 col-md-3"  ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblRutaA") %></div>
                            <div class="input-group">
                                 <input type="text" ng-model="requisicion.RutaA" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4 col-md-3" ng-show="(!requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblComprador") %></div>
                            <div class="input-group">
                                 <input type="text" ng-model="requisicion.Comprador" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                       <div class="col-sm-4 col-md-3"  ng-show="(requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblAprobador") %></div>
                            <div class="input-group">
                                 <input type="text" ng-model="requisicion.RutaA" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                     <div class="col-sm-4 col-md-3" ng-show="(requisicion.esPOP)">
                        <div class="form-group">
                            <div class="label-color"><%= this.GetMessage("lblRequisitor") %></div>
                            <div class="input-group">
                                <input type="text" ng-model="requisicion.SolicitadoPor" class="form-control" readonly="readonly">
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>

    </div>
    <script src="../Scripts/pages/capturaRequisicion.js"></script>
</asp:Content>
