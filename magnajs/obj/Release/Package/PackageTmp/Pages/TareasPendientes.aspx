<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="TareasPendientes.aspx.cs" Inherits="CYP.Pages.TareasPendientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="tareasPendientes">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>
        <%-- Tabla Principal --%>
        <div class="page-content" ng-show="pantallaId === pantallas.principal">
            <%-- Filtros --%>
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" maxlength="100" ng-model="filtro.Activity" key-enter="ObtenerTareas()"
                                    placeholder="<%= this.GetMessage("lblBusqueda") %>">
                            </div>
                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>

                            <div class="col-md-2 col-lg-1">
                                <label class="label-filter"><%= this.GetMessage("lblEstatus") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 va-m">
                                <select
                                    class="form-control form-control-select"
                                    ng-model="filtro.EstatusId"
                                    ng-options="estatus.EstatusId as estatus.Nombre for estatus in estatus">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>

                    </div>
                    <div class="clearfix visible-xs">
                        <br />
                    </div>
                    <div class="col-md-3 text-right">
                        <button type="button" class="btn btn-link" ng-click="esVerFiltros = !esVerFiltros">
                            <div class="glyphicon glyphicon-filter d-block"></div>
                            <%= this.GetCommonMessage("btnAvanzado") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="ObtenerTareas()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                    </div>
                </div>
            </div>
            <%-- Filtros Avanzados --%>
            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblFiltroTareas") %></label>
                            <div class="width-auto" selected-model="filtro.Tareas" options="filtroTareas" extra-settings="tareasOptions"
                                translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblFiltroFecha") %></label>
                            <datepicker-range ng-model="filtro.Fecha" input-class="form-control-input" />
                        </div>
                    </div>
                </div>
            </div>
            <%-- Tabla Tareas --%>
            <div class="mail-box padding-10 wrapper border-bottom" id="Home">
                <div ui-table="codigoPromocional" st-fixed>
                    <table class="jsgrid-table" style="min-width: 950px">
                        <thead>
                            <tr>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblActivity")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblTarea")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblFecha")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblResponsable")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblFechaEjecuto")%>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("lblEstatus")%>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="item in tareas | orderBy:'Fecha':reverse">
                                <td st-ratio="20">{{item.Codigo}}
                                </td>
                                <td st-ratio="20">{{item.Tarea}}
                                </td>
                                <td st-ratio="20">{{item.Fecha}}
                                </td>
                                <td st-ratio="20">{{item.Responsable}}
                                </td>
                                <td st-ratio="20">{{item.FechaEjecucion}}
                                </td>
                                <td st-ratio="20">{{item.Estatus}}
                                </td>
                                <td st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="ObtenerTarea(item)">
                                        <%= this.GetCommonMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
        <%-- DETALLE TAREA --%>
        <div class="page-content" ng-show="pantallaId === pantallas.tarea">
            <div class="mail-box padding-10 wrapper border-bottom" id="Tarea">
                <div class="row" style="padding-left: 15px; padding-right: 15px; padding-bottom: 10px">
                    <div class="pull-left">
                        <div class="subtitulo-color" ng-show="tarea.TareaPendienteId === 1"><%= this.GetMessage("lblTituloAltaProyecto") %></div>
                        <div class="subtitulo-color" ng-show="tarea.TareaPendienteId === 3"><%= this.GetMessage("lblCierreProyecto") %></div>
                        <div class="subtitulo-color" ng-show="tarea.TareaPendienteId === 4"><%= this.GetMessage("lblTituloCreacionCodigo") %></div>
                        <div class="subtitulo-color" ng-show="tarea.TareaPendienteId === 5"><%= this.GetMessage("lblCierreCodigo") %></div>
                    </div>
                    <div class="pull-right col-xs-4">
                        <div class="row">
                            <div class="btn-tpm col-sm-12">
                                <div>
                                    <div class="btn btn-top" ng-click="ActualizarTarea()" tooltip-placement="bottom" uib-tooltip="Guardar" ng-hide="habilitado">
                                        <i class="fa fa-save"></i>
                                    </div>
                                </div>
                                <div>
                                    <div class="btn btn-top" ng-click="pantallaId = pantallas.principal" tooltip-placement="bottom" uib-tooltip="Regresar">
                                        <i class="glyphicon glyphicon-arrow-left"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb" ng-if="tarea.CambioFecha">
                    <div class="col-sm-3 col-md-2">
                        <strong><%= this.GetMessage("lblActivity") %></strong>:
                        {{tarea.Activity}}
                    </div>

                    <div class="col-sm-5 col-md-4 col-lg-3">
                        <table>
                            <tr>
                                <td style="padding-bottom: 8px">
                                    <strong><%= this.GetMessage("lblFechaCierreActual") %></strong>
                                </td>
                                <td style="padding: 0 8px 8px">{{tarea.FechaCierreActual}} </td>
                            </tr>
                            <tr>
                                <td>
                                    <strong><%= this.GetMessage("lblNuevaFechaCierre") %></strong>
                                </td>
                                <td style="padding-left: 8px">{{tarea.FechaCierreNueva}}</td>
                            </tr>
                        </table>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-inline">
                            <div class="checkbox" style="padding-left: 20px" ng-hide="verTabla">
                                <label>
                                    <input type="checkbox" ng-model="tarea.Realizado" ng-disabled="habilitado">
                                    <%= this.GetMessage("lblRealizado") %>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row mb">
                    <div class="col-xs-12" ng-if="!tarea.FechaCierreActual">
                        <div class="form-inline">
                            <strong><%= this.GetMessage("lblActivity") %></strong>:
                            {{tarea.Activity}}
                            <div class="checkbox" style="padding-left: 20px" ng-hide="verTabla">
                                <label>
                                    <input type="checkbox" ng-model="tarea.Realizado" ng-disabled="habilitado">
                                    <%= this.GetMessage("lblRealizado") %>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-form="forma" ng-class="{'submitted': submitted}">
                    <div class="col-xs-3 col-sm-3 col-md-2 subtitle" ng-if="tarea.TienePoP  && tarea.TareaPendienteId ===1">
                        <h5>
                            <strong><%= this.GetMessage("lblPopTable") %></strong>
                        </h5>
                        <div></div>
                    </div>
                    <br />

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive" id="Home2" ng-if="tarea.TienePoP && tarea.TareaPendienteId ===1">
                                <table class="activity-table" style="min-width: 650px">
                                    <thead>
                                        <tr class="jsgrid-header-row ">
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblProveedor")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblDescripcion")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblProveedorSel")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblCodigoArticulo")%>
                                            </th>
                                            <th ui-field width="10"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit" ng-repeat="(key, item) in tarea.PoP">
                                            <td st-ratio="10" class="va-m">{{item.ProveedorCap}}
                                            </td>
                                            <td st-ratio="10" class="va-m">{{item.Descripcion}}
                                            </td>
                                            <td st-ratio="20" class="va-m">
                                                <ex-autocomplete ng-model="item.ProveedorId" options="proveedoresMatrizOptions" item="item"
                                                    required append-to-body class="table-edit"
                                                    on-select="setPropiedadProveedor(optionSelected, item)"
                                                    clean-button ng-hide="habilitado" parameters="FilterProveedor">
                                        </ex-autocomplete>
                                                <input type="text" class="form-control-input" ng-model="item.Proveedor" ng-show="habilitado" readonly />
                                            </td>
                                            <td st-ratio="20" class="va-m">
                                                <ex-autocomplete ng-model="item.MaterialId" options="materialMatrizOptions" item="item"
                                                    required append-to-body class="table-edit"
                                                    on-select="setMaterialCodigo(optionSelected, item)"
                                                    clean-button ng-hide="habilitado" parameters="FilterArticulo">
                                           </ex-autocomplete>
                                                <input type="text" class="form-control-input " ng-model="item.Articulo" ng-show="habilitado" readonly />
                                            </td>
                                            <td st-ratio="10"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-xs-3 col-sm-3 col-md-2 subtitle" ng-if="tarea.tieneOtros  && tarea.TareaPendienteId ===1">
                        <h5>
                            <strong><%= this.GetMessage("lblOtrosTable") %></strong>
                        </h5>
                        <div></div>
                    </div>
                    <br />

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive" id="Home3" ng-if="tarea.tieneOtros  && tarea.TareaPendienteId ===1">
                                <table class="jsgrid-table" style="min-width: 650px">
                                    <thead>
                                        <tr class="jsgrid-header-row">
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblProveedor")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblDescripcion")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblCodigoArticulo")%>
                                            </th>
                                            <th ui-field width="10"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit" ng-repeat="(key, item) in sourceOtros">
                                            <td st-ratio="10" class="va-m">{{item.Proveedor}}
                                            </td>
                                            <td st-ratio="10" class="va-m">{{item.Descripcion}}
                                            </td>
                                            <td class="va-m" ng-if="item.FormaPagoId ===1">
                                                <ex-autocomplete ng-model="item.ArticuloId" options="articuloOptions" item="item"
                                                    required append-to-body width="232px" ng-disabled="habilitado" ng-hide="habilitado">
                                                </ex-autocomplete>
                                                <input type="text" class="form-control-input " ng-model="item.Articulo" ng-show="habilitado" readonly />
                                            </td>
                                            <td class="va-m" ng-if="item.FormaPagoId ===2"></td>
                                            <td st-ratio="10"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="col-xs-3 col-sm-3 col-md-2 subtitle" ng-if="tarea.tieneConcurso  && tarea.TareaPendienteId ===1">
                        <h5>
                            <strong><%= this.GetMessage("lblConcursoTable") %></strong>
                        </h5>
                        <div></div>
                    </div>
                    <br />

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive" id="Home4" ng-if="tarea.tieneConcurso  && tarea.TareaPendienteId ===1">
                                <table class="jsgrid-table" style="min-width: 650px">
                                    <thead>
                                        <tr class="jsgrid-header-row">
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblProveedor")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblDescripcion")%>
                                            </th>
                                            <th ui-field width="10">
                                                <%= this.GetMessage("lblCodigoArticulo")%>
                                            </th>
                                            <th ui-field width="10"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit" ng-repeat="(key, item) in sourceConcurso">
                                            <td st-ratio="10" class="va-m">{{item.Proveedor}}
                                            </td>
                                            <td st-ratio="10" class="va-m">{{item.Descripcion}}
                                            </td>
                                            <td class="va-m">
                                                <ex-autocomplete ng-model="item.ArticuloId" options="articuloOptions" item="item"
                                                    required width="232px" append-to-body ng-disabled="habilitado" ng-hide="habilitado">
                                           </ex-autocomplete>
                                                <input type="text" class="form-control-input " ng-model="item.Articulo" ng-show="habilitado" readonly />
                                            </td>
                                            <td st-ratio="10"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="wrapper border-bottom" id="Home" ng-show="verTabla">
                    <div class="col-xs-3 col-sm-3 col-md-2 subtitle" ng-if="tarea.TienePromocion">
                        <h5>
                            <strong><%= this.GetMessage("lblPromocionTable") %></strong>
                        </h5>
                        <div></div>
                    </div>
                    <br />

                    <div class="row">
                        <div class="col-sm-12">
                            <div ui-table="codigoPromocional" st-fixed>
                                <table class="jsgrid-table" style="min-width: 650px">
                                    <thead>
                                        <tr>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblCodigoPromocion")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblMarca")%>
                                            </th>
                                            <th ui-field width="20">
                                                <%= this.GetMessage("lblFechas")%>
                                            </th>
                                            <th ui-field width="20"></th>
                                            <th ui-field width="20"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr ng-repeat="(key, item) in tarea.Promociones">
                                            <td st-ratio="20">
                                                <input type="text" ng-model="item.CodigoPromocion" class="form-control " readonly="">
                                            </td>
                                            <td st-ratio="20">
                                                <input type="text" ng-model="item.Marca" class="form-control " readonly="">
                                            </td>
                                            <td st-ratio="20">
                                                <input type="text" ng-model="item.Fecha" class="form-control " readonly="">
                                            </td>
                                            <td st-ratio="20" style="text-align: center; vertical-align: middle;">
                                                <a ng-click="DescargarExcel(item.PromocionId,key)"><i style="color: #0069af" class="glyphicon glyphicon-paperclip"></i></a>
                                            </td>
                                            <td st-ratio="20">
                                                <label>
                                                    <input type="checkbox" ng-model="item.Estatus" ng-init="ChangeStatus(key, item.Estatus, tarea.TareaPendienteId)" ng-disabled="tarea.Realizado">
                                                    <%= this.GetMessage("lblRealizado") %>
                                                </label>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/tareasPendientes.js"></script>
</asp:Content>
