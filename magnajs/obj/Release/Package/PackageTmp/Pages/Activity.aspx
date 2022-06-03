<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Activity.aspx.cs" Inherits="CYP.Pages.Activity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="activity" class="activity">
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
                                <input type="text" class="form-control" ng-model="filtro.Activity" key-enter="getActivities()"
                                    placeholder="<%= this.GetMessage("lblBusquedaFolio") %>">
                            </div>

                            <div class="clearfix visible-xs pt-5">
                                <br />
                            </div>

                            <div class="col-md-2 col-lg-1">
                                <label class="label-filter"><%= this.GetMessage("lblEstatus") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-4 va-m">
                                <div class="width-auto" selected-model="filtro.Estatus"
                                    options="estatus" extra-settings="estatusOptions"
                                    translation-texts="translateTextMultiSelect"
                                    ng-dropdown-multiselect="" style="margin: 5px">
                                </div>
                            </div>
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
                        <button type="button" class="btn btn-link" ng-click="getActivities()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetCommonMessage("btnBuscar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="agregar()" ng-if="esCrearModificarActivity">
                            <div class="glyphicon glyphicon-plus d-block"></div>
                            <%= this.GetCommonMessage("btnNuevo") %>
                        </button>
                        <button type="button" class="btn btn-link itemEnd" ng-click="exportar()">
                            <div class="glyphicon glyphicon-download-alt d-block"></div>
                            <%= this.GetCommonMessage("btnExcel") %>
                        </button>
                    </div>
                </div>
            </div>

            <div class="mail-box filtros-avanzados" ng-show="esVerFiltros">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblMarca") %></label>
                            <div class="width-auto" selected-model="filtro.Marcas" options="marcas" extra-settings="marcasOptions"
                                translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="" events="multiselectEventosFiltroMarca">
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblCanal") %></label>
                            <div class="width-auto" selected-model="filtro.Canales" options="canalesFiltro" extra-settings="canalesOptions"
                                translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblArea") %> </label>
                            <select
                                ng-model="filtro.AreaId" class="form-control-select"
                                ng-options="item.AreaId as item.Nombre for item in areas">
                                <option value=""><%= this.GetMessage("lblAll") %></option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblFechas") %></label>
                            <datepicker-range ng-model="filtro.Fecha" input-class="form-control-input" />
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label><%= this.GetMessage("lblRubros") %> </label>
                            <div class="width-auto" selected-model="filtro.Rubros" options="rubros" extra-settings="rubrosOptions"
                                translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="activities" st-fixed>
                    <table class="jsgrid-table" style="min-width: 950px">
                        <thead>
                            <tr>
                                <th ui-field width="15">
                                    <%= this.GetMessage("gvActivity-Codigo") %>
                                </th>
                                <th ui-field width="20">
                                    <%= this.GetMessage("gvActivity-Marca") %>
                                </th>
                                <th ui-field width="10">
                                    <%= this.GetMessage("gvActivity-Canal") %>
                                </th>
                                <th class="text-center" ui-field width="15">
                                    <%= this.GetMessage("lblFecha") %>
                                </th>
                                <th class="text-center" ui-field width="8">
                                    <%= this.GetMessage("gvActivity-Importe") %>
                                </th>
                                <th class="text-center" ui-field width="8">
                                    <%= this.GetMessage("gvActivity-Ejecutado") %>
                                </th>
                                <th class="text-center" ui-field width="10">
                                    <%= this.GetMessage("gvActivity-Porcentaje") %>
                                </th>
                                <th ui-field width="9">
                                    <%= this.GetMessage("gvActivity-Estatus") %>
                                </th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr class="va-m" ng-repeat="item in activities">
                                <td st-ratio="20">
                                    <h5 style="margin: 0"><strong>{{item.Codigo}}</strong></h5>
                                    <small>{{item.Nombre}}</small>
                                </td>
                                <td st-ratio="20">{{item.Marca}}</td>
                                <td st-ratio="10">{{item.Canal}}</td>
                                <td class="text-center" st-ratio="15">{{item.FechaInicio}} - {{item.FechaFin}}</td>
                                <td st-ratio="10" class="text-right">{{item.Importe | number:2}}</td>
                                <td st-ratio="10" class="text-right">{{item.Ejecutado | number:2}}</td>
                                <td st-ratio="10" class="text-right">
                                    <div class="progress tpm-progress" style="margin-top: 0">
                                        <div class="progress-bar progress-bar-success" role="progressbar"
                                            aria-valuemin="0" aria-valuemax="100" style="width: {{item.Porcentaje}}%">
                                        </div>
                                    </div>
                                    <h6 class="text-center" style="margin: 0"><strong>{{item.Porcentaje}} %</strong></h6>
                                </td>
                                <td st-ratio="9"><strong>{{item.Estatus}}</strong></td>
                                <td class="text-center" st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="getActivity(item)">
                                        <%= this.GetCommonMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="activities.length == 0" class="nodata-row">
                                <td colspan="8" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="8">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div form-disabled form="formaPrincipal">
            <div class="page-content" ng-show="pantallaId === pantallas.detalle">
                <div class="row mb">
                    <div class="col-sm-2 col-md-1">
                        <div class="subtitulo-color"><%= this.GetMessage("lblActivities") %></div>
                    </div>

                    <div class="col-sm-6 col-md-3">
                        <div class="form-inline">
                            <div class="form-group">
                                <input type="text" ng-model="activity.Codigo" class="form-control" readonly>
                            </div>
                            <div class="checkbox" style="padding-left: 20px">
                                <label>
                                    <input type="checkbox" ng-model="activity.Reactivo">
                                    <%= this.GetMessage("lblReactivo") %>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="col-xs-4 col-sm-4 col-md-2 text-center">
                        <small><%= this.GetMessage("lblImporte") %></small>
                        <h5 style="margin-top: 0"><strong>{{activity.Importe | number: 2}}</strong></h5>
                    </div>

                    <div class="col-xs-4 col-sm-4 col-md-2 text-center">
                        <small><%= this.GetMessage("lblEjecutado") %></small>
                        <h5 style="margin-top: 0"><strong>{{activity.Ejecutado | number: 2}}</strong></h5>
                    </div>

                    <div class="col-sm-4 col-md-2 text-center">
                        <div class="progress tpm-progress">
                            <div class="progress-bar progress-bar-success" role="progressbar"
                                aria-valuemin="0" aria-valuemax="100" style="width: {{activity.PorcentajeEjecutado}}%">
                            </div>
                        </div>
                        <h5 style="margin-top: 0"><strong>{{activity.PorcentajeEjecutado}} %</strong></h5>
                    </div>

                    <div class="btn-tpm col-sm-3 col-md-2" ng-show="vista.id === 1">
                        <div>
                            <button type="button" class="btn btn-link no-disabled" ng-click="cerrar()" ng-if="esCrearModificarActivity && activity.PuedeCerrar && (!esMedioOtros)"
                                style="color: red">
                                <div class="glyphicon glyphicon-remove d-block"></div>
                                <%= this.GetMessage("btnCerrar") %>
                            </button>
                        </div>

                        <div>
                            <div ng-click="aprobar(true)" tooltip-placement="bottom" ng-if="activity.EsAprobador && (!esMedioOtros)"
                                class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipRechazar") %>"
                                style="background-color: red">
                                <i class="fa fa-remove"></i>
                            </div>
                            <div ng-click="aprobarDetalle(true)" tooltip-placement="bottom" ng-if="activity.EsAprobadorDetalle && (esMedioOtros)"
                                class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipRechazar") %>"
                                style="background-color: red">
                                <i class="fa fa-remove"></i>
                            </div>
                        </div>

                        <div>
                            <div ng-click="aprobar(false)" tooltip-placement="bottom" ng-if="activity.EsAprobador && (!esMedioOtros)"
                                class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipAprobar") %>">
                                <i class="fa fa-check"></i>
                            </div>
                            <div ng-click="aprobarDetalle(false)" tooltip-placement="bottom" ng-if="activity.EsAprobadorDetalle && (esMedioOtros)"
                                class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipAprobar") %>">
                                <i class="fa fa-check"></i>
                            </div>
                        </div>

                        <div>
                            <div ng-click="exportarDetalle()" tooltip-placement="bottom" ng-if="activity.EstatusId == 12 && (esMedioOtros)"
                                class="btn btn-top" uib-tooltip="<%= this.GetMessage("lblTooltipExportar") %>">
                                <i class="fa fa-file-excel-o"></i>
                            </div>
                        </div>

                        <div>
                            <div class="btn btn-top" ng-click="guardar(false)" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>"
                                ng-if="(activity.PuedeModificar && (!esMedioOtros || esMedioOtros && esPermiteMediosOtros))">
                                <i class="fa fa-save"></i>
                            </div>
                        </div>

                        <div>
                            <div class="btn btn-top" ng-click="guardar(true)" tooltip-placement="bottom" uib-tooltip="<%= this.GetCommonMessage("lblTooltipEnviar") %>"
                                ng-if="campoHabilitado() && (activity.EstatusId === 1 || forma.$dirty) && (!esMedioOtros)">
                                <i class="fa fa-paper-plane-o"></i>
                            </div>
                            <div class="btn btn-top" ng-click="solicitar()" tooltip-placement="bottom" uib-tooltip="<%= this.GetMessage("lblTooltipSolicitar") %>"
                                ng-if="(activity.PuedeModificar) && (esMedioOtros) && (esPermiteMediosOtros)">
                                <i class="fa fa-paper-plane-o"></i>
                            </div>
                        </div>

                        <div>
                            <div class="btn btn-top" ng-click="volverPantalla()" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                                <i class="glyphicon glyphicon-arrow-left"></i>
                            </div>
                        </div>
                    </div>

                    <div class="btn-tpm col-sm-3 col-md-2" ng-show="objetivosEvaluacion() && activity.PuedeEvaluar && vista.id === 2">
                        <div class="btn btn-top" ng-click="evaluar()" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <ul class="nav nav-tabs" style="font-size: 14px">
                            <li ng-repeat="item in vistas" ng-class="{'active': vista.id === item.id}">
                                <a class="pointer" ng-click="cambiarVista(item)">{{item.nombre}}
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <br />

                <div ng-form="forma" ng-class="{'submitted': submitted}" ng-show="vista.id === 1">
                    <div class="mail-box padding-form">
                        <div class="row mb">
                            <div class="col-sm-12">
                                <span class="subtitulo-color"><%= this.GetMessage("lblDatosGenerales") %> </span>
                            </div>
                        </div>

                        <div class="row mb">
                            <div class="col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblNombre") %> </span>
                                <input type="text" ng-model="activity.Nombre" class="form-control-input" required />
                            </div>

                            <div class="col-sm-6">
                                <br />
                                <label class="radio-inline" ng-repeat="item in tiposActivity">
                                    <input type="radio" ng-model="activity.TipoActivityId" ng-value="item.TipoActivityId"
                                        ng-change="getCanalesPop()" ng-disabled="activity.ActivityId">
                                    <span class="label-color">{{item.Nombre}}</span>
                                </label>
                            </div>
                        </div>

                        <div ng-show="(!esMedioOtros)">

                            <div class="row mb">
                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                                    <div class="width-auto" selected-model="activity.Marcas" options="marcas" extra-settings="marcasOptions"
                                        translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="" events="multiselectEventos">
                                    </div>
                                </div>
                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.Marca" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar" ng-if="(activity.TipoActivityId != tipoActivity.Idm)">
                                    <span class="label-color"><%= this.GetMessage("lblCanal") %> </span>
                                    <select ng-model="activity.CanalId" class="form-control-select" ng-required="(!esMedioOtros)"
                                        ng-options="item.CanalId as item.NombreCanal for item in canales"
                                        ng-change="getRubrosCanal()"
                                        ng-if="(activity.TipoActivityId != tipoActivity.Idm)">
                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                    </select>
                                </div>
                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar" ng-if="(activity.TipoActivityId != tipoActivity.Idm)">
                                    <span class="label-color"><%= this.GetMessage("lblCanal") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.Canal" />
                                </div>

                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblArea") %> </span>
                                    <select ng-model="activity.AreaId" class="form-control-select"
                                        ng-disabled="(activity.TipoActivityId === tipoActivity.Idm)"
                                        ng-required="(!esMedioOtros)"
                                        ng-options="item.AreaId as item.Nombre for item in areas">
                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                    </select>
                                </div>

                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblFechas") %> </span>
                                    <datepicker-range ng-model="activity.Fecha" ng-required="(!esMedioOtros)" input-class="form-control-input"
                                        on-changed="setCierrePresupuesto(startDate, endDate)" option="opcionesFechaActivity"
                                        ng-disabled="!campoHabilitado()" />
                                </div>
                            </div>

                            <div class="row mb">
                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblSubcuenta") %> </span>
                                    <input type="text" ng-model="activity.Subcuenta" class="form-control" readonly ng-required="(!esMedioOtros)" />
                                </div>

                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblCentroCostos") %> </span>
                                    <input type="text" ng-model="activity.CentroCostos" class="form-control" readonly />
                                </div>

                                <div class="col-sm-6 col-md-3 text-nowrap">
                                    <span class="label-color"><%= this.GetMessage("lblCierrePresupuestoEvaluación") %> </span>
                                    <input type="text" ng-model="activity.CierrePresupuesto" class="form-control" readonly />
                                </div>
                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar" ng-if="(activity.TipoActivityId != tipoActivity.Idm)">
                                    <label class="label-color"><%= this.GetMessage("lblTipoActividad") %></label>
                                    <select ng-model="activity.TipoActividadId" class="form-control-select" ng-required="(!esMedioOtros)"
                                        ng-options="item.TipoActividadId as item.NombreTipoActividad for item in tiposActividad">
                                        <option value=""><%= this.GetMessage("lblSeleccionar") %></option>
                                    </select>
                                </div>
                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar" ng-if="(activity.TipoActivityId != tipoActivity.Idm)">
                                    <span class="label-color"><%= this.GetMessage("lblTipoActividad") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.TipoActividad" />
                                </div>
                            </div>

                            <div class="row mb">
                                <div class="col-sm-12">
                                    <span class="label-color"><%= this.GetMessage("lblEstrategia") %> </span>
                                    <textarea ng-model="activity.Estrategia" class="form-control-input" rows="4"
                                        ng-required="(!esMedioOtros)"></textarea>
                                </div>
                            </div>

                            <div class="row mb" ng-if="showMotivo && activity.PuedeModificar || activity.Motivo">
                                <div class="col-sm-12">
                                    <span class="label-color"><%= this.GetMessage("lblMotivoFechaInicio") %> </span>
                                    <textarea ng-model="activity.Motivo" class="form-control-input" rows="4"
                                        ng-required="(!esMedioOtros)"></textarea>
                                </div>
                            </div>



                        </div>

                    </div>

                    <div ng-show="(esMedioOtros)">
                        <div class="row mb">
                            <div class="col-sm-12">
                                <span class="subtitulo-color"><%= this.GetMessage("lblSolicitud") %> </span>
                            </div>
                        </div>
                        <div class="mail-box padding-form">
                            <div class="row mb">
                                <div class="col-sm-12">
                                    <span class="subtitulo-color"><%= this.GetMessage("lblServicio") %> </span>
                                </div>
                                <div style="padding-bottom: 5px;">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-comentario"><%= this.GetMessage("lblServicioDescripcion") %> </span>
                                    </div>
                                </div>
                                <hr />
                                <div class="col-sm-12">
                                    <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                        <h5>
                                            <strong><%= this.GetMessage("lblDetalle") %></strong>
                                        </h5>
                                        <div></div>
                                    </div>
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblFecha") %> </span>
                                    <datepicker ng-model="activity.FechaDetalle"
                                        ng-disabled="(true)"
                                        input-class="form-control-input no-disabled" format="'dd/mm/yyyy'"
                                        ng-required="(esMedioOtros)"></datepicker>
                                </div>

                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblFecha") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.FechaDetalle" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblEmpresa") %> </span>
                                    <select ng-model="activity.EmpresaId" class="form-control-select no-disabled"
                                        ng-required="(esMedioOtros)"
                                        ng-change="geEmpresa()"
                                        ng-options="e.EmpresaId as e.Nombre for e in empresas">
                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                    </select>
                                </div>

                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblEmpresa") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.NombreEmpresa" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblCuenta") %> </span>
                                    <select ng-model="activity.CuentaId"
                                        ng-required="(esMedioOtros)"
                                        ng-options="item.CuentaContableId as item.NombreCuentaContable for item in cuentasOs"
                                        class="form-control-select no-disabled">
                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                    </select>
                                </div>
                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblCuenta") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.NombreCuentaContable" />
                                </div>
                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblEntidadEmpresa") %> </span>
                                    <input type="text" class="form-control-input" ng-model="activity.Entidad" readonly />
                                </div>

                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblCentrodeCostos") %> </span>
                                    <select ng-model="activity.CentroCostoId" class="form-control-select" ng-disabled="(true)"
                                        ng-options="e.CentroCostoId as e.CentroCosto for e in centrocos">
                                    </select>
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                                    <select ng-model="activity.MarcaId" class="form-control-select no-disabled"
                                        ng-required="(esMedioOtros)"
                                        ng-options="m.LineaCodigo as m.NombreMarca for m in marcas">
                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                    </select>
                                </div>

                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.MarcaActivity" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblTipoProveedor") %> </span>
                                    <select ng-model="activity.TipoProveedorId" class="form-control-select no-disabled"
                                        ng-required="(esMedioOtros)"
                                        ng-change="setActivityPropiedadTipoProveedor()"
                                        ng-options="tp.TipoProveedorId as tp.NombreTipoProveedor for tp in tipoProveedor">
                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                    </select>
                                </div>
                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblTipoProveedor") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.NombreTipoProveedor" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.TipoActivityId == tipoActivity.Medios || activity.TipoActivityId == tipoActivity.OtrosGastos">
                                    <div class="form-group">
                                        <label><%= this.GetMessage("lblArea") %> </label>
                                        <select ng-model="activity.AreaId" class="form-control-select"
                                            ng-required="(esMedioOtros)"
                                            ng-disabled="(true)"
                                            ng-options="item.AreaId as item.Nombre for item in areasGeneral">
                                        </select>
                                    </div>
                                </div>

                                <div class="col-sm-6 col-md-6" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblProveedor") %> </span>
                                    <ex-autocomplete ng-model="activity.ProveedorId" options="proveedoresOptions"
                                        ng-required="(esMedioOtros)"
                                        append-to-body class="table-edit"
                                        item="activity"
                                        on-select="setActivityPropiedadProveedor(optionSelected)">
                                                 </ex-autocomplete>
                                </div>
                                <div class="col-sm-6 col-md-6" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblProveedor") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.NombreProveedor" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblTelefono") %> </span>
                                    <input type="text" class="form-control-input no-disabled" ng-model="activity.Telefono" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblTelefono") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.Telefono" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblCorreo") %> </span>
                                    <input type="text" class="form-control-input no-disabled" ng-model="activity.Correo" />
                                </div>

                                <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                    <span class="label-color"><%= this.GetMessage("lblCorreo") %> </span>
                                    <input type="text" class="form-control-input" readonly ng-model="activity.Correo" />
                                </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                    <h5>
                                        <strong><%= this.GetMessage("lblItems") %></strong>
                                    </h5>
                                    <div></div>
                                </div>
                            </div>
                            &nbsp;
                             <div class="table-responsive">
                                 <table class="activity-table" style="min-width: 1337px">
                                     <thead>
                                         <tr class="text-center jsgrid-header-row">
                                             <th style="width: 20px" ng-show="activity.PuedeModificar">
                                                 <button type="button" class="btn btn-link" ng-click="agregarRubro()">
                                                     <i class="glyphicon glyphicon-plus"></i>
                                                 </button>
                                             </th>
                                             <th style="width: 150px">
                                                 <%= this.GetMessage("lblDescripcion") %>
                                             </th>
                                             <th style="width: 50px">
                                                 <%= this.GetMessage("lblCantidad") %>
                                             </th>
                                             <th style="width: 80px">
                                                 <%= this.GetMessage("lblUm") %>
                                             </th>
                                             <th style="width: 50px">
                                                 <%= this.GetMessage("lblValorUnitario") %>
                                             </th>
                                             <th style="width: 50px">
                                                 <%= this.GetMessage("lblValorTotal") %>
                                             </th>
                                         </tr>
                                     </thead>
                                     <tbody>
                                         <tr class="table-edit" ng-repeat="item in activity.DetalleItem" ng-if="!item.Eliminar">
                                             <th ng-show="activity.PuedeModificar">
                                                 <button type="button" class="btn btn-link btn-delete" ng-click="quitarDetalleItem(item, $index)">
                                                     <i class="fa fa-remove pointer"></i>
                                                 </button>
                                             </th>
                                             <td>
                                                 <div tooltip-placement="bottom"
                                                     uib-tooltip="<%= this.GetMessage("lblTooltipDescripcion") %>">
                                                     <input type="text" class="form-control-input"
                                                         ng-required="(esMedioOtros)"
                                                         ng-model="item.Descripcion"
                                                         ng-disabled="!activity.PuedeModificar" />
                                                 </div>
                                             </td>
                                             <td>
                                                 <input type="text" class="form-control-input" ng-blur="calcularPrecioDetalleItem(item)"
                                                     ng-model="item.Cantidad" money precision="0" ng-required="(esMedioOtros)" ng-disabled="!campoHabilitado()  || item.EnRequisicion" />
                                             </td>
                                             <td>
                                                 <input type="text" class="form-control-input" ng-model="item.UM" />
                                             </td>
                                             <td>
                                                 <input type="text" class="form-control-input" ng-blur="calcularPrecioDetalleItem(item)"
                                                     ng-model="item.Precio" maxlength="50"
                                                     ng-required="(esMedioOtros)" money precision="4" />
                                             </td>
                                             <td>
                                                 <input type="text" class="form-control-input" ng-model="item.Importe"
                                                     readonly money precision="4" />
                                             </td>
                                         </tr>
                                     </tbody>
                                 </table>
                             </div>
                            <div class="col-sm-12">
                                <div class="pull-right padding-top-25">
                                    <table class="activity-table-montos" style="min-width: 300px">
                                         <tr>
                                             <td class="bold"><%= this.GetMessage("lblSubtotal") %></td>
                                             <td class="bold">$</td>
                                             <td class="pull-right">{{activity.Subtotal|number: 2 }}</td>
                                         </tr>
                                           <tr>
                                             <td class="bold"><%= this.GetMessage("lblIVA") %> {{activity.IvaFactorEtiqueta}}</td>
                                                <td class="bold">$</td>
                                             <td class="pull-right">{{activity.Iva|number: 2 }}</td>
                                         </tr>
                                         <tr>
                                             <td class="bold"><%= this.GetMessage("lblRetenido") %></td>
                                              <td class="bold">$</td>
                                             <td class="pull-right">{{activity.Retencion|number: 2 }}</td>
                                         </tr>
                                          <tr>
                                             <td class="bold"><%= this.GetMessage("lblTotalAPagar") %></td>
                                               <td class="bold">$</td>
                                             <td class="pull-right">{{activity.Total|number: 2 }}</td>
                                         </tr>
                                         <tr>
                                             <td class="bold"><%= this.GetMessage("lblMonedaPago") %></td>
                                             <td colspan="2">
                                                   <select ng-model="activity.MonedaId" class="form-control-select no-disabled"  ng-required="(esMedioOtros)"
                                                        ng-options="mon.MonedaId as mon.Nombre for mon in monedaCmb"
                                                        ng-change="setActivityPropiedadMoneda()">
                                                        <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                    </select>
                                            </td>                                        
                                         </tr>
                                     </table>
                                </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="row mb padding-top-25">
                                    <div class="col-sm-6 col-md-3">
                                        <span class="bold"><%= this.GetMessage("lblCantidadLetra") %> 
                                        </span>
                                    </div>
                                    <div class="col-sm-9 col-md-9">
                                        <input type="text" class="form-control-input" ng-disabled="(true)" ng-model="activity.CantidadLetra" />
                                    </div>

                                    <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblFechaServicio") %> </span>
                                        <datepicker ng-model="activity.FechaServicio" min-date="fechaActual"
                                            input-class="form-control-input no-disabled" format="'dd/mm/yyyy'"
                                            ng-required="(esMedioOtros)"></datepicker>
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblFechaServicio") %> </span>
                                        <input type="text" class="form-control-input" readonly ng-model="activity.FechaServicioFormato" />
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblFechaEntrega") %> </span>
                                        <datepicker ng-model="activity.FechaEntrega" min-date="fechaActual"
                                            input-class="form-control-input no-disabled" format="'dd/mm/yyyy'"
                                            ng-required="(esMedioOtros)"></datepicker>
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblFechaEntrega") %> </span>
                                        <input type="text" class="form-control-input" readonly ng-model="activity.FechaEntregaFormato" />
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblLugarEntrega") %> </span>
                                        <input type="text" ng-required="(esMedioOtros)"
                                            class="form-control-input no-disabled" ng-model="activity.LugarEntrega" />
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblLugarEntrega") %> </span>
                                        <input type="text" class="form-control-input" readonly ng-model="activity.LugarEntrega" />
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-show="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblCondicionesPago") %> </span>
                                        <select ng-model="activity.CondicionPagoId" class="form-control-select no-disabled" ng-required="(esMedioOtros)"
                                            ng-options="c.CondicionPagoId as c.Nombre for c in condicionPagoCmb">
                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                        </select>
                                    </div>
                                    <div class="col-sm-6 col-md-3" ng-hide="activity.PuedeModificar">
                                        <span class="label-color"><%= this.GetMessage("lblCondicionesPago") %> </span>
                                        <input type="text" class="form-control-input" readonly ng-model="activity.NombreCondicionPago" />
                                    </div>
                                </div>
                            </div>
                            <div class="row mb padding-top-25">
                                <p>
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                </p>
                            </div>
                            <div class="col-sm-12">
                                <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                    <h5>
                                        <strong><%= this.GetMessage("lblJustificacion") %></strong>
                                    </h5>
                                    <div></div>
                                </div>
                            </div>
                            <div class="row mb">
                                <div class="col-sm-12 padding-top-25">
                                    <input type="text" ng-model="activity.Justificacion" maxlength="500"
                                        class="form-control-input no-disabled" ng-required="(esMedioOtros)" />
                                </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                    <h5>
                                        <strong><%= this.GetMessage("lblArchivos") %></strong>
                                    </h5>
                                    <div></div>
                                </div>
                            </div>
                            &nbsp;
                             <div class="table-responsive">
                                 <table class="activity-table" style="min-width: 1337px">
                                     <thead>
                                         <tr class="text-center jsgrid-header-row">
                                             <th class="col">Nombre Documento
                                             </th>
                                             <th class="col">Anexo
                                             </th>
                                             <th class="col">&nbsp;
                                             </th>
                                             <th class="col">
                                                 <i class="fa fa-plus-circle text-success fa-2x pointer" ng-click="agregarDetalleArchivo()"></i>
                                             </th>
                                         </tr>
                                     </thead>
                                     <tbody>
                                         <tr class="table-edit" ng-repeat="item in activity.DetalleArchivo" ng-if="!item.Eliminar">
                                             <td>
                                                 <input type="text" class="form-control-input" ng-required="(esMedioOtros)" ng-model="item.NombreDocumento"
                                                       ng-disabled="!activity.PuedeModificar" maxlength="25" />
                                             </td>
                                             <td class="text-center">
                                                 <ex-fileupload ng-model="item.NombreArchivo" image-button="fa-search"
                                                     download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                                     options="fileOptionsDetalle" parameters="fileParameters" open-file="abrirDocumento(item)">
                                                  </ex-fileupload>
                                             </td>
                                             <td>
                                                 <span>{{item.NombreArchivo}}</span>
                                             </td>
                                             <td class="text-center">
                                                 <button type="button" class="btn btn-link btn-delete" ng-click="quitarDetalleArchivo(item, $index)">
                                                     <i class="fa fa-remove pointer"></i>
                                                 </button>
                                             </td>
                                         </tr>
                                     </tbody>
                                 </table>
                             </div>
                            <div class="padding-top-25">
                                &nbsp;
                            </div>
                            <div class="table-responsive padding-top-25" ng-show="(activity.SolicitanteId >0)">
                                <table class="activity-table padding-top-25" style="border: solid 1px #CDCDCD">
                                    <tr>
                                        <td colspan="5" style="background-color: #D0CECE; border-bottom: solid 2px #3B865D; padding-top: 5px; padding-bottom: 5px; text-align: center">
                                            <b>AUTORIZACIÓN DE SOLICITUD Y PAGO DE SERVICIO </b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="col">
                                            <table cellpadding="0" cellspadding="0" width="100%">
                                                <tr>
                                                    <td style="background-color: #CDCDCD; min-height: 80px; text-align: center">
                                                        <br />
                                                        <br />
                                                        {{activity.Solicitante}}
                                                        <br />
                                                        <br />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center">NOMBRE Y FIRMA 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="background-color: #CDCDCD; min-height: 80px; text-align: center">
                                                        <b>SOLICITANTE</b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center">
                                                        <b>FECHA </b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center; min-height: 40px;">
                                                        <b>&nbsp; {{activity.FechaSolicita}} &nbsp;  </b>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="col">
                                            <table cellpadding="0" cellspadding="0" width="100%">
                                                <tr>
                                                    <td style="background-color: #CDCDCD; min-height: 80px;">
                                                        <br />
                                                        <br />
                                                        <br />
                                                        <br />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center">NOMBRE Y FIRMA 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="background-color: #CDCDCD; min-height: 80px; text-align: center">
                                                        <b>VoBo</b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center">
                                                        <b>FECHA </b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center; min-height: 40px;">
                                                        <b>&nbsp; &nbsp; &nbsp;  </b>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td class="col">
                                            <table cellpadding="0" cellspadding="0" width="100%">
                                                <tr>
                                                    <td style="background-color: #CDCDCD; min-height: 80px;">
                                                        <br />
                                                        <br />
                                                        <br />
                                                        <br />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center">NOMBRE Y FIRMA 
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="background-color: #CDCDCD; min-height: 80px; text-align: center">
                                                        <b>APROBADOR</b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center">
                                                        <b>FECHA </b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center; min-height: 40px;">
                                                        <b>&nbsp; &nbsp; &nbsp;  </b>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            &nbsp;
                        </div>
                    </div>

                    <div class="row mb" ng-show="(!esMedioOtros)">
                        <div class="col-sm-12">
                            <span class="subtitulo-color" style="padding-left: 15px">
                                <%= this.GetMessage("lblRubros") %>
                            </span>
                        </div>
                    </div>

                    <div rubro-activity="activity.Promocion" titulo="<%= this.GetMessage("lblPromocionConfigurada") %>"
                        nombre="Promocion" nota="<%= this.GetMessage("lblNotaPromocion") %>"
                        ng-show="rubroVisible(rubro.Promocion)" activity="activity">

                        <div class="divider"></div>

                        <div class="row" style="margin-top: 30px">
                            <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                <h5>
                                    <strong><%= this.GetMessage("lblDetalle") %></strong>
                                </h5>
                                <div></div>
                            </div>

                            <div class="col-xs-9 col-sm-5">
                                <div class="row">
                                    <div class="col-xs-4 col-md-3" style="margin-top: 10px; white-space: nowrap">
                                        <%= this.GetMessage("lblCuentaPuc") %>
                                    </div>

                                    <div class="col-xs-8 col-md-9" ng-show="activity.PuedeModificar">
                                        <select ng-model="activity.CuentaPucIdPromocion" ng-required="activity.Promocion.Detalle.length > 0"
                                            ng-options="item.CuentaContableId as item.NombreCuentaContable for item in cuentasPromocion"
                                            class="form-control-select">
                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                        </select>
                                    </div>
                                    <div class="col-xs-8 col-md-9" ng-hide="activity.PuedeModificar">
                                        <input type="text" class="form-control-input" readonly ng-model="activity.CuentaContablePuc" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-sm-4 col-md-5 text-right">
                                <button type="button" class="btn btn-link" ng-click="agregarDetalle('Promocion')">
                                    <i class="fa fa-plus"></i>
                                    <%= this.GetMessage("btnAgregarPromocion") %>
                                </button>
                            </div>
                        </div>

                        <div class="blue-divider"></div>

                        <div ng-repeat="detalle in activity.Promocion.Detalle" ng-if="!detalle.Eliminar">
                            <div class="form-inline">
                                <div class="row padding-10">
                                    <div class="col-sm-3" ng-show="(detalle.Historial.length>0)">
                                        <label style="padding-left: 10px"><%= this.GetMessage("lblHistorial") %></label>
                                        <select ng-model="detalle.ActivityPromocionHistorialId" class="form-control-select"
                                            ng-options="item.ActivityPromocionHistorialId as item.MovimientoHistorial for item in detalle.Historial"
                                            ng-change="changePromocionHistorial(detalle,$index);">
                                        </select>                                        
                                    </div>
                                    <div class="col-sm-1">
                                        <div class="btn btn-top" ng-show="(detalle.Historial.length>0)" ng-click="changePromocionHistorial(detalle,$index);" tooltip-placement="bottom"
                                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipHistoricSelected") %>"
                                            ng-show="detalle.PromocionId">
                                            <i style="font-size:15px;">Ir</i>
                                        </div>
                                    </div>
                                    <div class="col-sm-7">
                                    </div>
                                    <div class="col-sm-1">
                                        <div class="btn btn-top" style="float: right;" ng-show="detalle.PromocionId && detalle.ActivityPromocionHistorialId == detalle.ActivityPromocionHistorialIdOriginal" ng-click="descargarTipoMovimiento(detalle,$index)"
                                            tooltip-placement="bottom"
                                            uib-tooltip="<%= this.GetCommonMessage("lblDownloadLastMovement") %>">
                                            <i class="glyphicon glyphicon-download-alt d-block" style="font-size:15px;"></i>                                        
                                        </div>
                                    </div>                                   
                                    
                                </div>
                                <div class="row padding-10">

                                    <div class="col-sm-3">
                                        <label style="padding-left: 10px">Tipo de Solicitud </label>
                                        <select ng-model="detalle.TipoSolicitudId" class="form-control-select" ng-disabled="detalle.PromocionId"
                                            ng-options="item.TipoSolicitudId as item.Nombre for item in tiposSolicitud" ng-change="changeTipoSolicitud(detalle, $index);">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>

                                    <div class="col-sm-3">
                                        <label style="padding-left: 10px">Tipo de Movimiento </label>
                                        <select ng-model="detalle.TipoMovimientoId" class="form-control-select" 
                                                ng-disabled="(!activity.PuedeModificar && activity.EstatusId == 1) || detalle.EsPromocionCompleta || (activity.EstatusId && activity.EstatusId != 1 && activity.EstatusId != 5 && activity.EstatusId != 6) || detalle.ActivityPromocionHistorialId != detalle.ActivityPromocionHistorialIdOriginal"
                                            ng-options="item.TipoMovimientoId as item.Nombre for item in detalle.TipoMovimientoInfo" ng-change="changeTipoMovimiento(detalle, $index);">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>

                                    <div class="col-sm-4">
                                        <div>
                                            <label style="padding-left: 10px"><%= this.GetMessage("lblCodigoPromocion") %></label>
                                        </div>
                                        <div>
                                            <input type="text" class="form-control" ng-model="detalle.CodigoPromocion" ng-disabled="detalle.PromocionId || detalle.TipoMovimientoId != 6" style="width: auto"
                                                id="codigoPromocion" ng-change="changeCodigoPromocion(detalle, $index)" />
                                            <%--&nbsp;--%>
                                            <button ng-show="!detalle.PromocionId && detalle.TipoMovimientoId == 6" type="button" class="btn btn-primary" ng-click="searchCodigoPromocion(detalle)"
                                                style="par">
                                                <b><%= this.GetMessage("lblBuscar") %> </b> <%--<i class="fa fa-search"></i>--%>
                                            </button>
                                            <%--<span style="padding-left: 30px; padding-right: 5px" ng-if="activity.PuedeModificar || (!detalle.EsPromocionCompleta && (!activity.EstatusId || activity.EstatusId == 1 || activity.EstatusId == 5 || activity.EstatusId == 6))">
                                                <b><%= this.GetMessage("lblCargarPromocion") %> </b>
                                            </span>
                                            <ex-fileupload
                                                ng-model="activity.Promocion.NombreArchivo" image-button="fa-search" multiple
                                                on-success="cargarPromocion(response, detalle, $index)"
                                                ng-click="clickFileUpload(detalle, $index);"
                                                options="fileOptionsPromocion"
                                                parameters="fileParametersPromocion" ng-if="activity.PuedeModificar || (!detalle.EsPromocionCompleta && (!activity.EstatusId || activity.EstatusId == 1 || activity.EstatusId == 5 || activity.EstatusId == 6))"></ex-fileupload>--%>
                                            <span style="padding-left: 15px; padding-right: 5px" ng-hide="true">
                                                <b><%= this.GetMessage("lblIsRefresh") %> </b>
                                            </span>
                                            <br />
                                            <%--<span style="padding-right: 5px" ng-show="detalle.TipoMovimientoId == 6 && !detalle.PromocionId && detalle.ExisteCodigoPromocion == 1">
                                                <b><%= this.GetMessage("lblCargarEstructuraComercial") %> </b>
                                            </span>
                                            <ex-fileupload
                                                ng-model="activity.Promocion.NombreArchivoEstructuraComercial" image-button="fa-search" multiple
                                                ng-show="detalle.TipoMovimientoId == 6 && !detalle.PromocionId && detalle.ExisteCodigoPromocion == 1"
                                                on-success="cargarEstructuraComercial(response, detalle, $index)"
                                                ng-click="clickEstructuraComercialUpload(detalle, $index);"
                                                options="fileOptionsEstructuraComercial"
                                                parameters="fileParametersEstructuraComercial">--%>
                                            <%--</ex-fileupload>--%>
                                            <input type="checkbox" ng-model="detalle.IsRefresh"
                                                class="no-disabled" ng-hide="true" />
                                        </div>
                                    </div>
                                    <div class="col-sm-2">
                                        <label style="padding-left: 10px">
                                            <%= this.GetMessage("lblCantidadPromociones") %>
                                        </label>
                                        <input type="text" class="form-control-input"                                            
                                            ng-disabled="(!activity.PuedeModificar && activity.EstatusId == 1) || detalle.EsPromocionCompleta || (activity.EstatusId && activity.EstatusId != 1 && activity.EstatusId != 5 && activity.EstatusId != 6) || detalle.ActivityPromocionHistorialId != detalle.ActivityPromocionHistorialIdOriginal"
                                            required ng-model="detalle.CantidadPromocion" ng-change="calcularImportePromocion(detalle);" maxlength="8" money precision="0" />

                                    </div>
                                    <%--<div class="col-sm-3">
                                        <span ng-show="detalle.TipoMovimientoId && (detalle.TipoMovimientoId == 1 || (detalle.TipoMovimientoId != 1 && ExisteCodigoPromocion == 1))" style="padding-left: 15px; padding-right: 5px">
                                            <b><%= this.GetMessage("lblCargarPromocion") %> CREACION</b>
                                        </span>
                                        <span ng-show="detalle.TipoMovimientoId && detalle.TipoMovimientoId != 1 && ExisteCodigoPromocion == 2" style="padding-left: 15px; padding-right: 5px">
                                            <b><%= this.GetMessage("lblCargarPromocion") %> </b>
                                        </span>

                                        <%--<div class="btn btn-top" ng-click="guardarPromocionCreacion()" tooltip-placement="bottom"
                                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>"
                                            ng-show="detalle.TipoMovimientoId && detalle.TipoMovimientoId != 1 && ExisteCodigoPromocion == 1 && (detalle.Historial.length==0 || detalle.Historial == undefined)">
                                            <i class="fa fa-save"></i>
                                        </div>

                                        <div class="btn btn-top" ng-click="guardarPromocionRefresh()" tooltip-placement="bottom"
                                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRefresh") %>"
                                            ng-show="detalle.TipoMovimientoId == detalle.TipoMovimientoIdOriginal && detalle.PromocionId">
                                            <i class="fa fa-refresh"></i>
                                        </div>
                                    </div>--%>
                                </div>
                                <div class="row padding-10">
                                    <div class="col col-sm-offset-6 col-sm-4">
                                        <span  ng-if="activity.PuedeModificar || (!detalle.EsPromocionCompleta && (!activity.EstatusId || activity.EstatusId == 1 || activity.EstatusId == 5 || activity.EstatusId == 6)) && detalle.ActivityPromocionHistorialId == detalle.ActivityPromocionHistorialIdOriginal">
                                                    <b><%= this.GetMessage("lblCargarPromocion") %> </b>
                                                </span>
                                                <ex-fileupload
                                                    ng-model="activity.Promocion.NombreArchivo" image-button="fa-search" multiple
                                                    on-success="cargarPromocion(response, detalle, $index)"
                                                    ng-click="clickFileUpload(detalle, $index);"
                                                    options="fileOptionsPromocion"
                                                    parameters="fileParametersPromocion" ng-if="activity.PuedeModificar || (!detalle.EsPromocionCompleta && (!activity.EstatusId || activity.EstatusId == 1 || activity.EstatusId == 5 || activity.EstatusId == 6)) && detalle.ActivityPromocionHistorialId == detalle.ActivityPromocionHistorialIdOriginal">
                                                    <b><%= this.GetMessage("lblCargarPromocion") %> </b> "></ex-fileupload>
                                    </div>
                                </div>

                                <div class="row padding-10">
                                    <div class="col col-sm-offset-6 col-sm-4">
                                         <span  ng-show="detalle.TipoMovimientoId == 6 && !detalle.PromocionId && detalle.ExisteCodigoPromocion == 1">
                                                    <b><%= this.GetMessage("lblCargarEstructuraComercial") %> </b>
                                                </span>
                                                <ex-fileupload
                                                    ng-model="activity.Promocion.NombreArchivoEstructuraComercial" image-button="fa-search" multiple
                                                    ng-show="detalle.TipoMovimientoId == 6 && !detalle.PromocionId && detalle.ExisteCodigoPromocion == 1"
                                                    on-success="cargarEstructuraComercial(response, detalle, $index)"
                                                    ng-click="clickEstructuraComercialUpload(detalle, $index);"
                                                    options="fileOptionsEstructuraComercial"
                                                    parameters="fileParametersEstructuraComercial">
                                    </div>
                                </div>

                                <div class="row padding-10">
                                    <%--<div class="form-group">--%>
                                    <div class="col-sm">
                                        <div class="col-sm-3">
                                            <label style="padding-left: 10px"><%= this.GetMessage("lblFolio") %></label>
                                            <input type="text" class="form-control" ng-model="detalle.Folio" readonly style="width: 100%"
                                                id="folio" />
                                        </div>
                                        <div class="col-sm-3">
                                            <label style="padding-left: 10px"><%= this.GetMessage("lblFechaSolicitud") %></label>
                                            <input type="text" class="form-control" ng-model="detalle.FechaSolicitudVisible" readonly style="width: 100%"
                                                id="fechaSolicitud" />
                                        </div>                                        
                                    </div>
                                </div>

                                <div class="row padding-10" ng-if="detalle.EsExtemporanea">
                                    <div class="col-sm-8">
                                        <label style="padding-left: 10px"><%= this.GetMessage("lblJustificacionExtemporanea") %></label>
                                        <textarea ng-model="detalle.Justificacion" class="form-control" style="width: 100%;" rows="4" readonly></textarea>
                                    </div>
                                    <div class="col-sm-4">
                                    </div>
                                </div>
                                <%--<button type="button" class="btn btn-link no-disabled" ng-click="editarPromocion(detalle)"
                                    ng-if="!detalle.Cerrado && campoHabilitado() && activity.EstatusId > 1 && !detalle.editable">
                                    <i class="fa fa-edit"></i>
                                    <%= this.GetMessage("btnEditar") %>
                                </button>
--%>
                                <button type="button" class="btn btn-link btn-delete" ng-click="quitarDetalle(detalle, 'Promocion', $index)"
                                    style="float: right">
                                    <i class="fa fa-remove fa-lg"></i>
                                </button>
                            </div>

                            <div class="table-responsive" ng-form="formaPromocion" ng-class="{submitted: detalle.submitted}">
                                <table class="activity-table" style="min-width: 1400px">
                                    <thead>
                                        <tr class="text-center">
                                            <th style="width: 1%"></th>
                                            <th style="width: 6%">
                                                <%= this.GetMessage("lblObjetivos") %>
                                            </th>
                                            <th style="width: 20%">
                                                <%= this.GetMessage("lblNombre") %>
                                            </th>
                                            <th style="width: 12%">
                                                <%= this.GetMessage("lblEmpresa") %>
                                            </th>
                                            <th style="width: 14%">
                                                <%= this.GetMessage("lblMarca") %>
                                            </th>
                                            <th style="width: 12%">
                                                <%= this.GetMessage("lblTipoMovimiento") %>
                                            </th>
                                            <th style="width: 12%">
                                                <%= this.GetMessage("lblAlmacenCanal") %>
                                            </th>
                                            <th style="width: 12%">
                                                <%= this.GetMessage("lblUm") %>
                                            </th>
                                            <th style="width: 8%">
                                                <%= this.GetMessage("lblConfiguracionListaPrecio") %>
                                            </th>
                                            <th style="width: 7%">
                                                <%= this.GetMessage("lblConfiguracionAlmacenes") %>
                                            </th>
                                            <th style="width: 1%"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit">
                                            <th>
                                                <i ng-class="{'fa-chevron-right': !detalle.expandido, 'fa-chevron-down': detalle.expandido}"
                                                    class="fa pointer" ng-click="detalle.expandido = !detalle.expandido"></i>
                                            </th>
                                            <td>
                                                <select ng-model="detalle.NumeroObjetivo" class="form-control-select" required
                                                    ng-options="item as item for item  in activity.Promocion.NumerosObjetivo">
                                                </select>
                                            </td>
                                            <td>
                                                <div class="input-group">
                                                    <div class="input-group-addon p-0" style="border: none; background-color: transparent">
                                                        <span>{{detalle.Prefijo}}</span>
                                                    </div>
                                                    <input type="text" class="form-control-input" ng-model="detalle.Nombre" readonly />
                                                </div>
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="detalle.Empresa" readonly />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="detalle.Marca" readonly />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="detalle.TipoMovimiento" readonly />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="detalle.TipoAlmacen" readonly />
                                            </td>
                                            <td>
                                                <%--<input type="text" class="form-control-input" ng-model="detalle.UnidadMedidaProductos" readonly/>--%>
                                                <input type="text" class="form-control-input" ng-model="detalle.UnidadMedida" readonly />
                                            </td>
                                            <td class="text-center">
                                                <%--<button type="button" class="btn btn-link no-disabled" ng-click="configurarListaPrecio(detalle, formaPromocion)">
                                                    <i class="fa fa-gear fa-lg"></i>
                                                </button>--%>
                                                <button type="button" class="btn btn-link no-disabled" ng-click="verListaPrecio(detalle)">
                                                    <i class="fa fa-gear fa-lg"></i>
                                                </button>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-link no-disabled" ng-click="configurarAlmacen(detalle, formaPromocion)">
                                                    <i class="fa fa-gear fa-lg"></i>
                                                </button>
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-link no-disabled" ng-click="getInformacion(detalle)">
                                                    <i class="fa fa-info fa-lg"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="table-responsive" ng-show="detalle.expandido">
                                <table class="activity-table" style="width: 1050px; background-color: #f2f2f2;">
                                    <thead>
                                        <tr class="text-center" style="height: 35px">
                                            <th style="width: 100px">
                                                <%= this.GetMessage("lblNumeroElemento") %>
                                            </th>
                                            <th style="width: 80px">
                                                <%= this.GetMessage("lblCantidad") %>
                                            </th>
                                            <th style="width: 150px">
                                                <%= this.GetMessage("lblUm") %>
                                            </th>
                                            <th style="width: 150px">
                                                <%= this.GetMessage("lblTipoElemento") %>
                                            </th>
                                            <th style="width: 150px">
                                                <%= this.GetMessage("lblParticipacionPrecio") %>
                                            </th>
                                            <th style="width: 250px">
                                                <%= this.GetMessage("lblDescripcion") %>
                                            </th>
                                            <th style="width: 150px">
                                                <%= this.GetMessage("lblArticulo") %>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit" ng-repeat="producto in detalle.Productos" ng-if="!producto.Eliminar">
                                            <td>
                                                <input type="text" ng-model="producto.NumeroProducto" class="form-control-input" readonly />
                                            </td>
                                            <td>
                                                <%--<input type="text" class="form-control-input" required ng-disabled="!promocionEditable(detalle)"
                                                    ng-model="producto.Cantidad" ng-change="calcularImportePromocion(detalle);" money precision="0" />--%>
                                                <input type="text" class="form-control-input" ng-model="producto.Cantidad" readonly />
                                            </td>
                                            <td>
                                                <input type="text" ng-model="producto.UnidadMedida" class="form-control-input" readonly />
                                            </td>
                                            <td>
                                                <input type="text" ng-model="producto.TipoElemento" class="form-control-input" readonly />
                                            </td>
                                            <td>
                                                <input type="text" ng-model="producto.Participacion" class="form-control-input" readonly />
                                            </td>
                                            <td>
                                                <input type="text" ng-model="producto.Producto" class="form-control-input" readonly />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" readonly ng-model="producto.Codigo" />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="row">
                                <hr />
                            </div>
                            <div style="padding-bottom: 15px"></div>
                        </div>
                    </div>

                    <div rubro-activity="activity.NotaCredito" titulo="<%= this.GetMessage("lblDescuentoNotaCredito") %>"
                        nombre="NotaCredito" nota="<%= this.GetMessage("lblDescripcionNotaCredito") %>"
                        ng-show="rubroVisible(rubro.NotaCredito)" activity="activity">

                        <div class="divider"></div>

                        <div class="row" style="margin-top: 30px">
                            <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                <h5>
                                    <strong><%= this.GetMessage("lblDetalle") %></strong>
                                </h5>
                                <div></div>
                            </div>

                            <div class="col-xs-9 col-sm-5">
                                <div class="row">
                                    <div class="col-xs-4 col-md-3" style="margin-top: 10px; white-space: nowrap">
                                        <%= this.GetMessage("lblCuentaPuc") %>
                                    </div>

                                    <div class="col-xs-8 col-md-9" ng-show="activity.PuedeModificar">
                                        <select ng-model="activity.NotaCredito.CuentaContableId" ng-required="activity.NotaCredito.Detalle.length > 0"
                                            ng-options="item.CuentaContableId as item.NombreCuentaContable for item in cuentasNotasCredito"
                                            class="form-control-select">
                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                        </select>
                                    </div>

                                    <div class="col-xs-8 col-md-9" ng-hide="activity.PuedeModificar">
                                        <input type="text" class="form-control-input" readonly ng-model="activity.NotaCredito.CuentaContable" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4 custom-check">
                                <span><%= this.GetMessage("lblImpactoA") %> </span>
                                <label style="margin-left: 10px;">
                                    <input type="checkbox" ng-model="activity.NotaCredito.EsSellIn" ng-change="SameSellIn(activity.NotaCredito,'nc')"
                                        ng-disabled="activity.Concurso.TipoVentaExternaId === 1" />
                                    <%= this.GetMessage("lblSellIn") %>
                                </label>
                                <label style="margin-left: 10px;">
                                    <input type="checkbox" ng-model="activity.NotaCredito.EsSellOut" ng-change="SameSellOut(activity.NotaCredito,'nc')"
                                        ng-disabled="activity.Concurso.TipoVentaExternaId === 1" />
                                    <%= this.GetMessage("lblSellOut") %>
                                </label>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="activity-table" style="min-width: 1632px">
                                <thead>
                                    <tr class="text-center jsgrid-header-row">
                                        <th style="width: 32px" ng-show="activity.PuedeModificar">
                                            <button type="button" class="btn btn-link" ng-click="agregarDetalle('NotaCredito')">
                                                <i class="glyphicon glyphicon-plus"></i>
                                            </button>
                                        </th>
                                        <th style="width: 250px">
                                            <%= this.GetMessage("lblDescripcion") %>
                                        </th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblCodigoProducto") %>
                                        </th>
                                        <th style="width: 120px">
                                            <%= this.GetMessage("lblUm") %>
                                        </th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblCantidad") %>
                                        </th>
                                        <th style="width: 250px">
                                            <%= this.GetMessage("lblCliente") %>
                                        </th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblPrecioActual") %>
                                        </th>
                                        <th style="width: 80px"></th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblDescuento") %>
                                        </th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblDescuentoPesos") %>
                                        </th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblTotalDescuento") %>
                                        </th>
                                        <th style="width: 100px">
                                            <%= this.GetMessage("lblTotalPrecio") %>
                                        </th>
                                        <th style="width: 500px">
                                            <%= this.GetMessage("lblObjetivoCajas") %>
                                        </th>
                                        <th style="width: 250px" hidden>
                                            <%= this.GetMessage("lblObjetivoPesos") %>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="table-edit" ng-repeat="notaCredito in activity.NotaCredito.Detalle" ng-if="!notaCredito.Eliminar">
                                        <th ng-show="activity.PuedeModificar">
                                            <button type="button" class="btn btn-link btn-delete" ng-click="quitarDetalle(notaCredito, 'NotaCredito', $index)">
                                                <i class="fa fa-remove pointer"></i>
                                            </button>
                                        </th>
                                        <td>
                                            <ex-autocomplete ng-model="notaCredito.ProductoId" options="productoOptions"
                                                item="notaCredito" required append-to-body width="232px" class="table-edit"
                                                on-select="getPrecio(notaCredito, 'NotaCredito');" ng-if="activity.PuedeModificar"
                                                parameters="SuperFiltro">
                                            </ex-autocomplete>
                                            <input type="text" class="form-control-input" readonly ng-model="notaCredito.Producto"
                                                ng-if="!activity.PuedeModificar" />
                                        </td>
                                        <td>
                                            <input type="text" class="form-control-input" readonly ng-model="notaCredito.Codigo" />
                                        </td>
                                        <td>
                                            <select ng-model="notaCredito.UnidadMedidaId" class="form-control-select" required
                                                ng-options="item.UnidadMedidaId as item.Nombre for item in unidadesMedida">
                                                <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" ng-change="calcularPrecioNotaCredito(notaCredito, 'NotaCredito')"
                                                ng-model="notaCredito.Cantidad" ng-disabled="!campoHabilitado()" money precision="0"
                                                class="form-control-input" required />
                                        </td>
                                        <td>
                                            <select ng-model="notaCredito.SubcanalId" class="form-control-select" required
                                                ng-options="item.SubcanalId as item.Nombre for item in subcanales">
                                                <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                            </select><!-- CSSR-->
                                        </td>
                                        <td>
                                            <input type="text" class="form-control-input" money precision="2"
                                                ng-model="notaCredito.Precio" ng-blur="calcularPrecioNotaCredito(notaCredito, 'NotaCredito')" />
                                        </td>
                                        <td class="va-m text-nowrap">
                                            <label class="radio-inline">
                                                <input type="radio" ng-model="notaCredito.TipoDescuentoId" value="1" required
                                                    ng-change="calcularPrecioNotaCredito(notaCredito, 'NotaCredito')">
                                                <span class="label-color">$</span>
                                            </label>
                                            <label class="radio-inline">
                                                <input type="radio" ng-model="notaCredito.TipoDescuentoId" value="2" required
                                                    ng-change="calcularPrecioNotaCredito(notaCredito, 'NotaCredito')">
                                                <span class="label-color">%</span>
                                            </label>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control-input" money precision="2" ng-disabled="!campoHabilitado()"
                                                ng-model="notaCredito.Descuento" ng-change="calcularPrecioNotaCredito(notaCredito, 'NotaCredito')" />
                                        </td>
                                        <td class="text-center">
                                            <input type="text" class="form-control-input" money precision="2" readonly
                                                ng-model="notaCredito.DescuentoPesos" />
                                        </td>
                                        <td class="text-center">
                                            <input type="text" class="form-control-input" money precision="2" readonly
                                                ng-model="notaCredito.TotalDescuento" />
                                        </td>
                                        <td class="text-center">
                                            <input type="text" class="form-control-input" money precision="2" readonly
                                                ng-model="notaCredito.TotalPrecio" />
                                        </td>
                                        <td class="text-center">
                                            <input type="text" class="form-control-input" maxlength="259" ng-model="notaCredito.ObjetivoCajas"
                                                required />
                                        </td>
                                        <td class="text-center" hidden>
                                            <input type="text" class="form-control-input" money precision="2" ng-model="notaCredito.ObjetivoPesos"
                                                money />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div rubro-activity="activity.Concurso" titulo="<%= this.GetMessage("lblConcursos") %>"
                        nombre="Concurso" nota="<%= this.GetMessage("lblNotaConcurso") %>" cuentas="cuentasConcurso"
                        calcular-montos="calcularMontos('Concurso')" ng-show="rubroVisible(rubro.Concurso)" activity="activity">

                        <div class="divider">
                        </div>

                        

                        <div ng-if="activity.Concurso.TipoVentaExternaId === 1">
                            <div class="row" style="margin-top: 35px">
                                <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                    <h5>
                                        <strong><%= this.GetMessage("lblDetalle") %></strong>
                                    </h5>
                                    <div></div>
                                </div>

                                <div class="col-xs-9 col-sm-5">
                                    <div class="row">
                                        <div class="col-xs-4 col-md-3" style="margin-top: 10px; white-space: nowrap">
                                            <%= this.GetMessage("lblCuentaPuc") %>
                                        </div>

                                        <div class="col-xs-8 col-md-9" ng-show="activity.PuedeModificar">
                                            <select ng-model="activity.Concurso.CuentaContableId" ng-required="activity.Concurso.TipoVentaExternaId == 2"
                                                ng-options="item.CuentaContableId as item.NombreCuentaContable for item in cuentasNotasCredito"
                                                class="form-control-select">
                                                <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                            </select>
                                        </div>
                                        <div class="col-xs-8 col-md-9" ng-hide="activity.PuedeModificar">
                                            <input type="text" class="form-control-input" readonly ng-model="activity.Concurso.CuentaContable" />
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4 custom-check" ng-if="activity.Concurso.TipoVentaExternaId === 1">
                                    <span><%= this.GetMessage("lblImpactoA") %> </span>
                                    <label style="margin-left: 10px;">
                                        <input type="checkbox" ng-model="activity.Concurso.EsSellIn" disabled />
                                        <%= this.GetMessage("lblSellIn") %>
                                    </label>
                                    <label style="margin-left: 10px;">
                                        <input type="checkbox" ng-model="activity.Concurso.EsSellOut" disabled />
                                        <%= this.GetMessage("lblSellOut") %>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div rubro-activity="activity.Otros" titulo="<%= this.GetMessage("lblOtros") %>"
                        nombre="Otros" nota="<%= this.GetMessage("lblNotaOtros") %>" activity="activity"
                        calcular-montos="calcularMontos('Otros')" ng-show="rubroVisible(rubro.Otros)" subrubro-activity="activity.SNP">

                        <div class="divider">
                            <div style="float: right;" ng-show="activity.EstatusId >= 5 && activity.EstatusId <=7">
                                <button type="button" class="btn btn-link no-disabled" ng-click="agregarRequisicion('Otros')" 
                                    ng-hide="SinRequisiciones('Otros')">
                                    <b><%= this.GetMessage("lblAgregaReq") %></b>
                                    <i class="glyphicon glyphicon-plus"></i>
                                </button>
                            </div>
                        </div>

                        <div class="row" style="margin-top: 35px">
                            <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                <h5>
                                    <strong><%= this.GetMessage("lblDetalle") %></strong>
                                </h5>
                                <div></div>
                            </div>
                        </div>

                        <rubro-detalle rubro="activity.Otros" nombre="Otros" calcular-montos="calcularMontos('Otros')"
                            cuentas="cuentasOtros" activity="activity" superfiltro="activity.Marcas"></rubro-detalle>

                        <div class="row" style="margin-top: 35px">
                            <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                <h5>
                                    <strong><%= this.GetMessage("lblSNP") %></strong>
                                </h5>
                                <div></div>
                            </div>
                        </div>

                        <rubro-detalle rubro="activity.SNP" nombre="SNP" calcular-montos="calcularMontos('SNP')"
                            cuentas="cuentasSNP" activity="activity" superfiltro="activity.Marcas"></rubro-detalle>
                    </div>

                    <div rubro-activity="activity.Pop" titulo="<%= this.GetMessage("lblPop") %>" nombre="Pop" nota=""
                        ng-if="(activity.TipoActivityId === tipoActivity.Pop || activity.TipoActivityId === tipoActivity.General) && rubroVisible(rubro.Pop)" activity="activity">

                        <div class="divider" ng-if="activity.Pop.TipoPopId !== 1" ng-show="(!esVisibleJV)">
                        </div>
                       
                        <div style="float: right;" ng-show="(activity.EstatusId >= 5 && activity.EstatusId <=7)">
                            <button type="button" class="btn btn-link no-disabled" ng-click="confirmarPOP();" ng-if="(!activity.EsConfirmado && campoHabilitado() && ModificaPop===false)">
                                <b><%= this.GetMessage("lblConfirmar") %></b>
                                <i class="glyphicon glyphicon-ok"></i>
                            </button>
                            <button type="button" class="btn btn-link no-disabled" ng-click="agregarRequisicion('Pop')" ng-hide="SinRequisiciones('Pop')" ng-if="(esCrearModificarActivity && activity.EsConfirmado)">
                                <b><%= this.GetMessage("lblAgregaReq") %></b>
                                <i class="glyphicon glyphicon-plus"></i>
                            </button>
                        </div>

                        <div>
                            <div class="row" style="margin-top: 35px">
                                <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                    <h5>
                                        <strong><%= this.GetMessage("lblDetalle") %></strong>
                                    </h5>
                                    <div></div>
                                </div>

                                <div class="col-xs-9 col-sm-5">
                                    <div class="row">
                                        <div class="col-xs-4 col-md-3" style="margin-top: 10px; white-space: nowrap">
                                            <%= this.GetMessage("lblCuentaPuc") %>
                                        </div>

                                        <div class="col-xs-8 col-md-9" ng-show="activity.PuedeModificar">
                                            <select ng-model="activity.Pop.CuentaContableId" ng-required="activity.Pop.Detalle.length > 0"
                                                ng-options="item.CuentaContableId as item.NombreCuentaContable for item in cuentasPop"
                                                class="form-control-select">
                                                <option value=""><%= this.GetCommonMessage("lblSeleccionar") %></option>
                                            </select>
                                        </div>
                                        <div class="col-xs-8 col-md-9" ng-hide="activity.PuedeModificar">
                                            <input type="text" class="form-control-input" readonly ng-model="activity.Pop.CuentaContable" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="activity-table" style="min-width: 1337px">
                                    <thead>
                                        <tr class="text-center jsgrid-header-row">
                                            <th style="width: 32px" ng-show="activity.PuedeModificar">
                                                <button type="button" class="btn btn-link" ng-click="agregarDetalle('Pop')">
                                                    <i class="glyphicon glyphicon-plus"></i>
                                                </button>
                                            </th>
                                            <th style="width: 125px">
                                                <%= this.GetMessage("lblProductoMatrizPop") %>
                                            </th>
                                            <th style="width: 32px" ng-show="activity.EstatusId >= 5 && activity.EstatusId <=7"></th>
                                            <th style="width: 250px">
                                                <%= this.GetMessage("lblDescripcion") %>
                                            </th>
                                            <th style="width: 250px">
                                                <%= this.GetMessage("lblProveedor") %>
                                            </th>
                                            <th style="width: 80px">
                                                <%= this.GetMessage("lblCantidad") %>
                                            </th>
                                            <th style="width: 100px">
                                                <%= this.GetMessage("lblPrecioUnitario") %>
                                            </th>
                                            <th style="width: 100px">
                                                <%= this.GetMessage("lblMoneda") %>
                                            </th>
                                            <th style="width: 100px">
                                                <%= this.GetMessage("lblCostoMoneda") %>
                                            </th>
                                            <th style="width: 100px">
                                                <%= this.GetMessage("lblPrecioTotal") %>
                                            </th>
                                            <th style="width: 120px">
                                                <%= this.GetMessage("lblCodigoArticulo") %>
                                            </th>
                                            <th style="width: 30px"><%= this.GetMessage("lblActa") %></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit" ng-repeat="item in activity.Pop.Detalle" ng-if="!item.Eliminar">
                                            <th ng-show="activity.PuedeModificar">
                                                <button type="button" class="btn btn-link btn-delete" ng-click="quitarDetalle(item, 'Pop', $index)">
                                                    <i class="fa fa-remove pointer"></i>
                                                </button>
                                            </th>
                                            <th style="width: 32px" ng-show="activity.EstatusId >= 5 && activity.EstatusId <=7">
                                                <input type="checkbox" ng-click="validarReqProveedor(item,'Pop')" ng-model="item.CheckBox" ng-init="item.ItemModificado = false"
                                                    class="no-disabled" ng-show="!item.ItemModificado && !item.EnRequisicion"
                                                    ng-disabled="activity['Pop'].ReqProveedorId !== 0  && activity['Pop'].ReqProveedorId !== item.ProveedorId" />
                                            </th>
                                            <td class="va-m text-nowrap">
                                                <label class="radio-inline">
                                                    <input type="radio" ng-model="item.EsProductoMatriz" ng-value="true" required
                                                        ng-change="limpiarPop(item)">
                                                    <span class="label-color">
                                                        <%= this.GetCommonMessage("lblSi") %>
                                                    </span>
                                                </label>
                                                <label class="radio-inline">
                                                    <input type="radio" ng-model="item.EsProductoMatriz" ng-value="false" required
                                                        ng-change="limpiarPop(item)">
                                                    <span class="label-color">
                                                        <%= this.GetCommonMessage("lblNo") %>
                                                    </span>
                                                </label>
                                            </td>
                                            <td ng-if="(item.EsProductoMatriz)">
                                                <div ng-if="(campoHabilitado())">
                                                    <div ng-if="(activity.PuedeReenviar && activity.EsConfirmado==1)">
                                                         <input type="text" class="form-control-input" required ng-model="item.Articulo"
                                                        ng-disabled="true" /> 
                                                    </div>
                                                    <div ng-if="((activity.PuedeReenviar || activity.PuedeModificar)  && activity.EsConfirmado==0)">
                                                         
                                                         <select ng-model="item.MaterialId" class="form-control-select no-disabled" required
                                                            ng-options="mon.MaterialId as mon.Material for mon in matrizOptions"
                                                            ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)"
                                                                 ng-change="setMaterialCodigo(item, item)">
                                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                        </select>

                                                    </div>
                                                </div>
                                                <div ng-if="(!campoHabilitado())">
                                                    <input type="text" class="form-control-input" required ng-model="item.Articulo"
                                                     ng-disabled="true" /> 
                                                </div>
                                            </td>
                                            <td ng-if="(!item.EsProductoMatriz)">
                                                  <div ng-if="(campoHabilitado())">
                                                      <div ng-if="(item.MaterialId>0 && activity.EsConfirmado==0)">
                                                         
                                                          <select ng-model="item.MaterialId" class="form-control-select no-disabled" required
                                                            ng-options="mon.MaterialId as mon.Material for mon in matrizOptions"
                                                            ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)"
                                                                 ng-change="setMaterialCodigo(mon, item)">
                                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                        </select>

                                                      </div>
                                                      <div ng-if="(item.MaterialId==0 || item.MaterialId == undefined)">
                                                           <input type="text" class="form-control-input" required ng-model="item.Articulo"
                                                            ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)" />
                                                      </div>
                                                        <div ng-if="(item.MaterialId>0 && activity.EsConfirmado==1)">
                                                         <input type="text" class="form-control-input" required ng-model="item.Articulo"/>
                                                        </div>
                                                  </div>
                                                  <div ng-if="(!campoHabilitado())">
                                                         <input type="text" class="form-control-input" required ng-model="item.Articulo"/>
                                                </div>
                                            </td>
                                            <td ng-if="item.EsProductoMatriz">
                                                <div ng-if="(campoHabilitado())">
                                                      <div ng-if="(activity.PuedeReenviar && activity.EsConfirmado==1)">
                                                        <input type="text" class="form-control-input" required ng-model="item.Proveedor" />
                                                    </div>
                                                      <div ng-if="((activity.PuedeReenviar || activity.PuedeModificar) && activity.EsConfirmado==0)">
                                                          
                                                          <select ng-model="item.ProveedorId" class="form-control-select no-disabled" required
                                                            ng-options="proveed.ProveedorId as proveed.Proveedor for proveed in item.Proveedores"
                                                            ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1) || (item.MaterialId==0 || item.MaterialId == undefined)"
                                                                 ng-change="setPropiedadProveedor(item, item)">
                                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                        </select>

                                                    </div>
                                                </div>
                                                <div ng-if="(!campoHabilitado())">
                                                    <input type="text" class="form-control-input" required ng-model="item.Proveedor" />
                                                </div>
                                            </td>
                                            <td ng-if="!item.EsProductoMatriz">
                                                 <div ng-if="(campoHabilitado())">
                                                       <div ng-if="(item.MaterialId>0 && activity.EsConfirmado==0)">
                                                           
                                                           <select ng-model="item.ProveedorId" class="form-control-select no-disabled" required
                                                            ng-options="proveed.ProveedorId as proveed.Proveedor for proveed in item.Proveedores"
                                                            ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1) || (item.MaterialId==0 || item.MaterialId == undefined)"
                                                                 ng-change="setPropiedadProveedor(item, item)">
                                                            <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                        </select>

                                                        </div>
                                                     <div ng-if="(item.MaterialId==0 || item.MaterialId == undefined)">
                                                          <input type="text" class="form-control-input" required ng-model="item.Proveedor" ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)" />
                                                    </div>
                                                      <div ng-if="item.MaterialId>0 && activity.EsConfirmado==1">
                                                               <input type="text" class="form-control-input" required ng-model="item.Proveedor"  />
                                                      </div>
                                                 </div>
                                                 <div ng-if="(!campoHabilitado())">
                                                               <input type="text" class="form-control-input" required ng-model="item.Proveedor"  />
                                                 </div>
                                            </td>
                                            <td>
                                                 <div ng-if="(campoHabilitado())">      
                                                    <input type="text" class="form-control-input" ng-blur="calcularCantidadTotalPop(item,true)"
                                                    ng-model="item.Cantidad" ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)" money precision="0" required />
                                                </div>
                                                  <div ng-if="(!campoHabilitado())">
                                                           <input type="text" class="form-control-input" ng-blur="calcularTotalPop(item,true)"
                                                    ng-model="item.Cantidad" money precision="0" required />
                                                </div>
                                            </td>
                                            <td>
                                               <div ng-if="(campoHabilitado())">
                                                       <input type="text" class="form-control-input" ng-blur="calcularTotalPop(item,true)"
                                                    ng-model="item.Precio" ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)" money required />
                                                </div>
                                                <div ng-if="(!campoHabilitado())">
                                                        <input type="text" class="form-control-input" ng-blur="calcularTotalPop(item,true)"
                                                    ng-model="item.Precio"  money required />
                                                </div>
                                            
                                            </td>
                                            <td>
                                                <div ng-if="(campoHabilitado())">
                                                     <select ng-model="item.MonedaId" class="form-control-select no-disabled" required
                                                    ng-options="mon.MonedaId as mon.Nombre for mon in monedaCmb"
                                                    ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)"
                                                         ng-change="calcularTotalPop(item,true)">
                                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                </select>
                                                </div>
                                                <div ng-if="(!campoHabilitado())">
                                                     <select ng-model="item.MonedaId" class="form-control-select no-disabled" required
                                                    ng-options="mon.MonedaId as mon.Nombre for mon in monedaCmb" ng-disabled="(true)">
                                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                                </select>
                                                    </div>
                                            </td>
                                            <td>
                                                <div ng-if="(campoHabilitado())">
                                                      <input type="text" class="form-control-input" ng-disabled="(activity.PuedeReenviar && activity.EsConfirmado==1)" ng-model="item.CostoMoneda" ng-blur="calcularTotalPop(item,true)"  money />
                                                </div>
                                                 <div ng-if="(!campoHabilitado())">
                                                    <input type="text" class="form-control-input"  ng-model="item.CostoMoneda" ng-blur="calcularTotalPop(item,true)" money />
                                                </div>
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="item.Importe" readonly money />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="item.CodigoArticulo" readonly />
                                            </td>
                                            <td>
                                                <ex-fileupload ng-model="item.NombreArchivo" image-button="fa-search"
                                                    download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                                    options="fileOptionsPop" parameters="fileParameters" open-file="abrirDocumento(item)"
                                                    "></ex-fileupload>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style="padding-top: 15px;">
                                &nbsp;
                            </div>
                            <div class="row mb" ng-if="(activity.TipoActivityId === tipoActivity.General)">
                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblFechaLlegadaQuala") %> </span>
                                    <datepicker ng-model="activity.Pop.FechaLlegadaQuala"
                                        ng-disabled="(!activity.PuedeModificar)" 
                                        input-class="form-control-input no-disabled" format="'dd/mm/yyyy'"></datepicker>
                                </div>
                                <div class="col-sm-6 col-md-3">
                                    <span class="label-color"><%= this.GetMessage("lblFechaLlegadaDistrito") %> </span>
                                    <datepicker ng-model="activity.Pop.FechaLlegadaDistrito"
                                        ng-disabled="(!activity.PuedeModificar)" 
                                        input-class="form-control-input no-disabled" format="'dd/mm/yyyy'"></datepicker>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div rubro-activity="activity.Os" titulo="<%= this.GetMessage("lblOs") %>"
                        nombre="Os" nota="{{lblNotaOs}}" activity="activity"
                        calcular-montos="calcularMontos('Os')" ng-show="osVisible()">

                        <div class="divider">
                            <div style="float: right;">
                                  <button  type="button" class="btn btn-link no-disabled">
                                    <b><%= this.GetMessage("lblMapaEstudio") %></b>
                                    <ex-fileupload ng-model="activity.Os.NombreArchivo" image-button="fa-search"
                                        download-button="fa-paperclip" on-success="setParametrosArchivo(response, activity.Os)"
                                        options="fileOptionsOs" parameters="fileParameters"
                                        open-file="abrirDocumento(activity.Os)"></ex-fileupload>
                                </button> 
                                    &nbsp; 
                                <button ng-show="(activity.EstatusId >= 5 && activity.EstatusId <=7 && !verRequisiciones && activity.Importe != activity.Ejecutado)" type="button" class="btn btn-link no-disabled" ng-click="agregarRequisicion('Os')">
                                    <b><%= this.GetMessage("lblAgregaReq") %>  </b>
                                    <i class="glyphicon glyphicon-plus"></i>
                                </button>
                                &nbsp;
                                <button ng-if="(activity.RequisicionesActivity.length>0 && !verRequisiciones)" type="button" class="btn btn-link no-disabled" ng-click="verRequisicionesActivity()">
                                    <b><%= this.GetMessage("lblRequisiciones") %></b> 
                                </button>
                                &nbsp;
                                 <button ng-if="(activity.RequisicionesActivity.length>0 && verRequisiciones)" type="button" class="btn btn-link no-disabled" ng-click="verRequisicionesActivity()">
                                    <b><%= this.GetMessage("lblVerDetalle") %> </b> 
                                </button>
                            </div>

                        </div>

                        <div ng-if="(!verRequisiciones)" class="row" style="margin-top: 35px">
                            <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                <h5>
                                    <strong><%= this.GetMessage("lblDetalle") %></strong>
                                </h5>
                                <div></div>
                            </div>
                        </div>
                        <rubro-detalle ng-if="(!verRequisiciones)" rubro="activity.Os" nombre="Os" calcular-montos="calcularMontos('Os')"
                            cuentas="cuentasOs" activity="activity" superfiltro="activity.Marcas"></rubro-detalle>

                        <div ng-if="(verRequisiciones)">
                            <div class="row" style="margin-top: 35px">
                                <div class="col-xs-3 col-sm-3 col-md-2 subtitle">
                                    <h5>
                                        <strong>Requisiciones</strong>
                                    </h5>
                                    <div></div>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="activity-table" style="min-width: 900px">
                                    <thead>
                                        <tr class="jsgrid-header-row">
                                            <th class="col">Num Requisición
                                            </th>
                                             <th class="col">
                                               Fecha Requisición
                                            </th>
                                            <th class="col">
                                               Proveedor
                                            </th>
                                            <th class="col">Cantidad
                                            </th>
                                            <th class="col">Monto
                                            </th>
                                            <th>&nbsp;
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="table-edit" ng-repeat="item in activity.RequisicionesActivity">
                                            <td class="col">
                                                <span ng-bind="item.NumRequisicion"></span>
                                            </td>
                                             <td class="col">
                                                <span ng-bind="item.FechaRequisicion"></span>
                                             </td>
                                               <td class="col">
                                                <span ng-bind="item.ProveedorNombre"></span>
                                            </td>
                                            <td class="col" style="text-align: center">
                                                <span ng-bind="item.CantArticulos"></span>
                                            </td>
                                            <td class="col">
                                                <span>{{item.TotalCosto | currency}}</span>
                                            </td>
                                            <td>
                                                <i class="glyphicon glyphicon-eye-open" style="cursor: pointer" ng-click="verRequisicion(item)"></i>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <p>&nbsp<br />
                            </p>
                        </div>


                    </div>
                </div>

                <div ng-form="formaEvaluacion" ng-class="{'submitted': evaluacionSubmitted}" ng-show="vista.id === 2">
                    <div class="mail-box padding-form" ng-show="objetivosEvaluacion() && (activity.Evaluado || activity.PuedeEvaluar)">
                        <div ng-show="activity.Objetivos.length > 0">
                            <div class="row">
                                <div class="col-sm-12">
                                    <span class="subtitulo-color"><%= this.GetMessage("lblResultadoObjetivos") %> </span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="table-responsive">
                                        <table class="activity-table" style="min-width: 1200px">
                                            <thead>
                                                <tr class="jsgrid-header-row text-center">
                                                    <th style="width: 150px"></th>
                                                    <th style="width: 250px">
                                                        <%= this.GetMessage("lblResultadosClaveFinales") %>
                                                    </th>
                                                    <th style="width: 200px">
                                                        <%= this.GetMessage("lblIndicadorTotalCanal") %>
                                                    </th>
                                                    <th style="width: 100px">
                                                        <%= this.GetMessage("lblUm") %>
                                                    </th>
                                                    <th style="width: 100px">
                                                        <%= this.GetMessage("lblActual") %>
                                                    </th>
                                                    <th style="width: 100px">
                                                        <%= this.GetMessage("lblObjetivo") %>
                                                    </th>
                                                    <th style="width: 200px">
                                                        <%= this.GetMessage("lblHerramientaMedicion") %>
                                                    </th>
                                                    <th style="width: 120px">
                                                        <%= this.GetMessage("lblEjecutado") %>
                                                    </th>
                                                    <th style="width: 120px">
                                                        <%= this.GetMessage("lblResultado") %>
                                                    </th>
                                                    <th style="width: 50px"></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="table-edit" ng-repeat="item in activity.Objetivos">
                                                    <td>{{item.Rubro}}</td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.ResultadosClave" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.TipoIndicador" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.UnidadMedida" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Actual" readonly
                                                            money precision="0" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Objetivo" readonly
                                                            money precision="0" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.HerramientaMedicion"
                                                            readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Ejecutado" money
                                                            ng-required="item.EsPromocion || item.EsConcurso" ng-disabled="!activity.PuedeEvaluar || (!item.EsPromocion && !item.EsConcurso)" />
                                                        
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Resultado"
                                                            money required precision="0" ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td class="text-right">
                                                        <b>{{item.Resultado * 100 / item.Objetivo | number: 2}}%</b>
                                                    </td>
                                                </tr>
                                                <tr class="table-edit" ng-repeat="item in activity.Legalizacion" ng-show="activity.Legalizacion.length > 0">
                                                    <td> <%= this.GetMessage("lblEvaluacionLegalizacion") %></td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.ResultadosClave" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.TipoIndicador" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.UnidadMedida" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Actual" readonly
                                                            money precision="0" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Objetivo" readonly
                                                            money precision="0" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.HerramientaMedicion"
                                                            readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Ejecutado" money
                                                            ng-required="item.EsPromocion || item.EsConcurso" ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Resultado"
                                                            money required precision="0" ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td class="text-right">
                                                        <b>{{item.Resultado * 100 / item.Objetivo | number: 2}}%</b>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                       

                        <div ng-if="objetivosConcurso.length > 0">
                            <div class="row">
                                <div class="col-xs-6">
                                    <span class="subtitulo-color"><%= this.GetMessage("lblResultadosConcurso") %> </span>
                                </div>

                                <div class="col-xs-6" ng-if="activity.PuedeEvaluar || activity.Concurso.NombreArchivo">
                                    <span style="padding-right: 5px">
                                        <b><%= this.GetMessage("lblAnexoResultados") %> </b>
                                    </span>
                                    <ex-fileupload ng-model="activity.Concurso.NombreArchivo" image-button="fa-search"
                                        download-button="fa-paperclip" on-success="setParametrosArchivo(response, activity.Concurso)"
                                        options="fileOptionsConcurso" parameters="fileParameters"
                                        open-file="abrirDocumento(activity.Concurso)"></ex-fileupload>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="table-responsive">
                                        <table class="activity-table" style="min-width: 1410px">
                                            <thead>
                                                <tr class="jsgrid-header-row text-center">
                                                    <th style="width: 250px" ng-show="activity.Concurso.TipoFuerzaId === 2">
                                                        <%= this.GetMessage("lblObjetivo") %>
                                                    </th>
                                                    <th style="width: 200px">
                                                        <%= this.GetMessage("lblCargoQueAplica") %>
                                                    </th>
                                                    <th style="width: 120px">
                                                        <%= this.GetMessage("lblNumeroPersonas") %> 
                                                    </th>
                                                    <th style="width: 100px">
                                                        <%= this.GetMessage("lblNumeroPremios") %>
                                                    </th>
                                                    <th style="width: 100px">
                                                        <%= this.GetMessage("lblIncentivo") %>
                                                    </th>
                                                    <th style="width: 250px">
                                                        <%= this.GetMessage("lblFechaInicioFin") %>
                                                    </th>
                                                    <th style="width: 120px">
                                                        <%= this.GetMessage("lblPremio") %>
                                                    </th>
                                                    <th style="width: 120px">
                                                        <%= this.GetMessage("lblPesoPorVariable") %>
                                                    </th>
                                                    <th style="width: 150px">
                                                        <%= this.GetMessage("lblTotal") %>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="table-edit" ng-repeat="item in objetivosConcurso">
                                                    <td ng-show="activity.Concurso.TipoFuerzaId === 2">
                                                        <input type="text" class="form-control-input" ng-model="item.Descripcion" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Cargo" readonly />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input pers" ng-model="item.NumeroPersonas"
                                                            money precision="0" ng-change="validarObjetivoConcurso(item, 'NumeroPersonas')"
                                                            required ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.NumeroPremios" maxlength="6"
                                                            money precision="0" ng-change="validarObjetivoConcurso(item, 'NumeroPremios')"
                                                            required ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Incentivo"
                                                            money required readonly />
                                                    </td>
                                                    <td>
                                                        <datepicker-range ng-model="item.Fecha" required="required" input-class="form-control-input"
                                                            ng-disabled="true" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.PremioPesos"
                                                            money required ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.PesoPorVariable"
                                                            money required ng-disabled="!activity.PuedeEvaluar" />
                                                    </td>
                                                    <td>
                                                        <input type="text" class="form-control-input" ng-model="item.Total"
                                                            money required ng-disabled="true"
                                                            ng-change="validarObjetivoConcurso(item, 'Total')" />
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb" style="margin-top: 40px">
                            <div class="col-sm-12">
                                <span class="subtitulo-color"><%= this.GetMessage("lblComentarios") %> </span>
                                <textarea ng-model="activity.Comentarios" class="form-control" rows="3"
                                    required ng-disabled="!activity.PuedeEvaluar"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-show="vista.id === 3">
                    <div class="mail-box padding-form" ng-show="activity.Flujo.length > 0">
                        <div class="row">
                            <div class="col-sm-12">
                                <span class="subtitulo-color"><%= this.GetMessage("lblHistorialActivity") %> </span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="table-responsive">
                                    <table class="activity-table" style="min-width: 900px">
                                        <thead>
                                            <tr class="jsgrid-header-row">
                                                <th style="width: 25%">
                                                    <%= this.GetMessage("lblNombre") %>
                                                </th>
                                                <th style="width: 25%">
                                                    <%= this.GetMessage("lblCargo") %>
                                                </th>
                                                <th style="width: 20%">
                                                    <%= this.GetMessage("lblFecha") %>
                                                </th>
                                                <th style="width: 20%">
                                                    <%= this.GetMessage("lblTiempo") %>
                                                </th>
                                                <th style="width: 10%"></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr class="table-edit" ng-repeat="item in activity.Flujo">
                                                <td>{{item.Nombre}}</td>
                                                <td>{{item.Cargo}}</td>
                                                <td>{{item.Fecha}}</td>
                                                <td>{{item.Tiempo}}</td>
                                                <td class="text-center">
                                                    <i class="fa fa-check" ng-show="item.EstatusId === 2" style="color: green"></i>
                                                    <i class="fa fa-remove" ng-show="item.EstatusId === 3" style="color: red"></i>
                                                    <i class="fa fa-paper-plane-o" ng-show="item.EstatusId === 1" style="color: #0069af"></i>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <br />

                        <div ng-show="activity.Log.length > 0">
                            <div class="row">
                                <div class="col-xs-12">
                                    <span class="subtitulo-color"><%= this.GetMessage("lblModificaciones") %> </span>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="table-responsive">
                                        <table class="activity-table" style="min-width: 900px">
                                            <thead>
                                                <tr class="jsgrid-header-row">
                                                    <th style="width: 20%"></th>
                                                    <th style="width: 20%">
                                                        <%= this.GetMessage("lblCampo") %>
                                                    </th>
                                                    <th style="width: 20%">
                                                        <%= this.GetMessage("lblValorAnterior") %> 
                                                    </th>
                                                    <th style="width: 20%">
                                                        <%= this.GetMessage("lblNuevoValor") %>
                                                    </th>
                                                    <th class="text-center" style="width: 20%">
                                                        <%= this.GetMessage("lblFecha") %>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr class="table-edit" ng-repeat="item in activity.Log">
                                                    <td>{{item.Rubro}}</td>
                                                    <td>{{item.Descripcion}}</td>
                                                    <td>
                                                        <span ng-if="item.TipoDato !== 'decimal'">{{item.ValorAnterior}}</span>
                                                        <span ng-if="item.TipoDato === 'decimal'">{{item.ValorAnterior | number:2}}</span>
                                                    </td>
                                                    <td>
                                                        <span ng-if="item.TipoDato !== 'decimal'">{{item.ValorActual}}</span>
                                                        <span ng-if="item.TipoDato === 'decimal'">{{item.ValorActual | number:2}}</span>
                                                    </td>
                                                    <td class="text-center">{{item.Fecha}}</td>
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

            <div class="page-content" ng-show="pantallaId === pantallas.configuracionListaPrecio">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="subtitulo-color"><%= this.GetMessage("lblConfiguracionListaPromocion") %></div>
                    </div>
                    <div class="btn-tpm col-sm-6">
                        <div>
                            <div class="btn btn-top" ng-click="volverPantallaDetalle()" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                                <i class="glyphicon glyphicon-arrow-left"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-form="formaListaPrecio" ng-class="{'submitted': promocion.submitted}">
                    <div class="mail-box padding-form">
                        <div class="row mb other-filters">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblCanalAlmacen") %> </span>
                                <div class="form-group">
                                    <div class="input-group">
                                        <div class="input-group-addon pointer" ng-show="promocion.TipoAlmacenId === tipoAlmacen.ambos"
                                            ng-click="promocion.canalesExpandidos = !promocion.canalesExpandidos" style="border: none">
                                            <i class="fa" ng-class="{'fa-plus':!promocion.canalesExpandidos, 'fa-times':promocion.canalesExpandidos}"></i>
                                        </div>
                                        <input type="text" class="form-control-input" ng-model="promocion.TipoAlmacen" readonly />
                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-9 col-sm-4 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblDescuentoPrecio") %> </span>
                                <input type="text" class="form-control-input" ng-model="promocion.ImporteLista"
                                    readonly>
                            </div>

                            <div class="clearfix visible-sm" style="margin-bottom: 0"></div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblPrecio") %> </span>
                                <input type="text" class="form-control-input" ng-model="promocion.UnidadMedida" readonly />
                            </div>
                            <div class="body-filter" ng-show="promocion.canalesExpandidos">
                                <div class="row mb" style="margin: 0">
                                    <div class="col-xs-6 col-sm-3 col-md-2" ng-repeat="item in promocion.Canales">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" ng-model="item.Seleccionado" ng-disabled="!activity.PuedeModificar"
                                                    ng-change="getListaPrecios(promocion, true)">
                                                {{item.NombreCanal}}
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="table-responsive">
                                    <table class="activity-table" style="min-width: 1011px">
                                        <thead>
                                            <tr class="jsgrid-header-row text-center">
                                                <th style="width: 80px">
                                                    <%= this.GetMessage("lblNumeroLista") %>
                                                </th>
                                                <th style="width: 230px">
                                                    <%= this.GetMessage("lblNombre") %>
                                                </th>
                                                <th style="width: 90px">
                                                    <%= this.GetMessage("lblPrecioUnidad") %>
                                                </th>
                                                <th style="width: 90px">
                                                    <%= this.GetMessage("lblPrecioDisplay") %>
                                                </th>
                                                <th style="width: 90px">
                                                    <%= this.GetMessage("lblPrecioCaja") %>
                                                </th>
                                                <th style="width: 90px">
                                                    <%= this.GetMessage("lblDescuento") %>
                                                </th>
                                                <th style="width: 120px">
                                                    <%= this.GetMessage("lblPrecioPromocion") %>
                                                </th>
                                                <th style="width: 90px">
                                                    <%= this.GetMessage("lblFechaInicio") %>
                                                </th>
                                                <th style="width: 90px">
                                                    <%= this.GetMessage("lblFechaCierre") %>
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr class="table-edit" ng-repeat="item in promocion.ListaPrecios">
                                                <td class="va-m">{{item.NumeroLista}}</td>
                                                <td class="va-m">{{item.Cliente}}</td>
                                                <td class="va-m text-right">{{item.PrecioUnidad | number:2}}</td>
                                                <td class="va-m text-right">{{item.PrecioDisplay | number:2}}</td>
                                                <td class="va-m text-right">{{item.PrecioCaja | number:2}}</td>
                                                <td class="text-right va-m">
                                                {{item.Descuento | number: 2}}
                                                <td class="text-right va-m">{{item.PrecioPromocion | number: 2}}</td>
                                                <td class="va-m text-center">{{item.FechaInicioVisible}}</td>
                                                <td class="va-m text-center">{{item.FechaFinVisible}}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="page-content" ng-show="pantallaId === pantallas.configuracionAlmacen">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="subtitulo-color"><%= this.GetMessage("lblConfiguracionAlmacen") %></div>
                    </div>
                    <div class="btn-tpm col-sm-6">
                        <div>
                            <div class="btn btn-top" ng-click="guardarAlmacen()" tooltip-placement="bottom" ng-if="activity.PuedeModificar"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                                <i class="fa fa-save"></i>
                            </div>
                        </div>

                        <div>
                            <div class="btn btn-top" ng-click="volverPantallaDetalle()" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                                <i class="glyphicon glyphicon-arrow-left"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-form="formaAlmacen" ng-class="{'submitted': almacenSubmitted}">
                    <div class="mail-box padding-form">
                        <div class="row mb">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblCanalAlmacen") %> </span>
                                <input type="text" class="form-control-input" ng-model="promocion.TipoAlmacen" readonly />
                            </div>
                        </div>

                        <div class="row" style="margin: 10px 0">
                            <div class="col-xs-6 col-sm-3 col-md-2" ng-repeat="item in promocion.Almacenes">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" ng-model="item.Seleccionado" ng-disabled="!activity.PuedeModificar">
                                        {{item.Nombre}}
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="page-content" ng-show="pantallaId === pantallas.informacionPromocion">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="subtitulo-color"><%= this.GetMessage("lblInformacionAdicionalPromocion") %></div>
                    </div>
                    <div class="btn-tpm col-sm-6">
                        <div>
                            <div class="btn btn-top" ng-click="volverPantallaDetalle()" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                                <i class="glyphicon glyphicon-arrow-left"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div>
                    <div class="mail-box padding-form">
                        <div class="row mb">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblLinea") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.Linea" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblGrupo") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.Grupo" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblImpuesto") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.Impuesto" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblAlmacenPrincipal") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.AlmacenPrincipal" readonly />
                            </div>
                        </div>

                        <div class="row mb">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblTipo") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.Tipo" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblPlaneador") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.Planeador" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblCodigoBarras") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.CodigoBarras" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblEstatus") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.EstatusAdicional" readonly />
                            </div>
                        </div>

                        <div class="row mb">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblUm") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.UnidadMedida" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblUmaCajaDisplay") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.UmaCajaDisplay" readonly />
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblUmaCajaUnidad") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.UmaCajaUnidad" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblClaseImpuesto") %> </span>
                                <input type="text" class="form-control" ng-model="promocion.ClaseImpuesto" readonly />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="page-content" ng-show="pantallaId === pantallas.requisicion && (activity.EstatusId >= 5 && activity.EstatusId <=7 || activity.EstatusId == 8)">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="subtitulo-color">
                            <div ng-if="(req.esPOP)">
                                <%= this.GetMessage("lblRequisicionQAD") %>
                            </div>
                            <div ng-if="(!req.esPOP)">
                                <%= this.GetMessage("lblRequisicion") %>
                            </div>
                        </div>
                    </div>
                    <div class="btn-tpm col-sm-6">
                        <div ng-if="req.reqGenerar">
                            <div class="btn btn-top" ng-click="guardarRequisicion(formaRequisicion)" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipEnviar") %>">
                                <i class="fa fa-paper-plane-o"></i>
                            </div>
                        </div>

                        <div>
                            <div class="btn btn-top" ng-click="atrasRequisicion()" tooltip-placement="bottom"
                                uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                                <i class="glyphicon glyphicon-arrow-left"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-form="formaRequisicion" ng-class="{'submitted': requisicionSubmitted}">
                    <div class="mail-box padding-form">
                        <div class="row mb">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblNumReq") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.RequisicionId" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblNomProveedor") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.ProveedorNombre" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblNumProveedor") %> </span>
                                <select ng-model="req.ProveedorId" class="form-control-select disabled" ng-disabled="true"
                                    ng-options="proveedor.ProveedorId as proveedor.CodigoQad for proveedor in proveedorAll">
                                </select>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblUbicacion") %> </span>
                                <!--<input type="text" class="form-control-input" ng-model="req.Ubicacion" readonly  aria-multiline="true"/>!-->
                                <textarea class="form-control-input" ng-model="req.Ubicacion" style="height: 100px" ng-disabled="(!req.esPOP)"> </textarea>

                            </div>
                        </div>

                        <div class="row mb">
                            <div class="col-sm-6 col-md-3" ng-if="(!req.esPOP)">
                                <span class="label-color"><%= this.GetMessage("lblSolicitadoPor") %> </span>
                                <select ng-model="req.Solicitado" class="form-control-select no-disabled" ng-required="(!req.esPOP)" ng-disabled="req.RequisicionId !=='' "
                                    ng-options="a.UsuarioQadId as a.Usuario for a in usuarioQad">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>
                            </div>
                            <div class="col-sm-6 col-md-3" ng-if="(req.esPOP)">
                                <span class="label-color"><%= this.GetMessage("lblSolicitadoPor") %> </span>
                                <input type="text" class="form-control-input" maxlength="25" ng-model="req.SolicitadoPorPOP"  />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblUsuarioFinal") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.UsuarioFinal" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3" ng-if="req.RequisicionId ==='' && !req.esPOP">
                                <span class="label-color"><%= this.GetMessage("lblSubCuenta") %> </span>
                                <ex-autocomplete ng-model="req.SubcuentaId" options="subcuentaOptions" append-to-body
                                    width="232px" ng-required="(!req.esPOP)">
                                </ex-autocomplete>
                            </div>
                             <div class="col-sm-6 col-md-3" ng-if="req.RequisicionId ==='' && req.esPOP">
                                <span class="label-color"><%= this.GetMessage("lblCuenta") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.Cuenta" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3" ng-if="req.RequisicionId !=='' && !req.esPOP">
                                <span class="label-color"><%= this.GetMessage("lblSubCuenta") %> </span>
                                <select ng-model="req.SubcuentaId" class="form-control-select"
                                    ng-options="e.SubcuentaId as e.Subcuenta for e in subCuenta" ng-disabled="true">
                                </select>
                            </div>
                            <div class="col-sm-6 col-md-3" ng-if="(req.RequisicionId ==='' && !req.esPOP)">
                                <span class="label-color"><%= this.GetMessage("lblCentrodeCostos") %> </span>
                                <ex-autocomplete ng-model="req.CentroCosto" options="centroCostoOptions" append-to-body
                                    width="232px" required ng-disabled="req.RequisicionId !==''">
                                    </ex-autocomplete>
                            </div>
                            <div class="col-sm-6 col-md-3" ng-if="(req.RequisicionId !=='' && !req.esPOP)">
                                 <span class="label-color"><%= this.GetMessage("lblCentrodeCostos") %> </span>
                                 <select ng-model="req.CentroCosto" class="form-control-select"
                                    ng-options="e.CentroCostoId as e.CentroCosto for e in centrocos" ng-disabled="true">
                                </select>
                            </div>
                        </div>
                        <div class="row mb" ng-if="(req.esPOP)">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqMoneda") %> </span>
                                <select ng-model="req.MonedaId" class="form-control-select no-disabled" required
                                    ng-options="mon.MonedaId as mon.Nombre for mon in monedaCmb" ng-disabled="(req.RequisicionId !=='' || req.esPOP)">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblCostoMoneda") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.CostoMoneda" ng-disabled="(true)" />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqAlmacen") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.Almacen" />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblFechaQueSeRequiere") %> </span>
                                <datepicker ng-model="req.FechaRequerida" min-date="fechaActual" input-class="form-control-input no-disabled"
                                    required ng-if="req.RequisicionId ===''"></datepicker>
                                <input type="text" class="form-control-input" ng-model="req.FechaRequerida" readonly ng-if="req.RequisicionId !==''" />
                            </div>
                        </div>
                        <div class="row mb" ng-if="(!req.esPOP)">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblProyecto") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.CodigoProyecto" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblEntidad") %> </span>
                                <select ng-model="req.EmpresaId" class="form-control-select no-disabled" required
                                    ng-options="e.EmpresaId as e.Nombre for e in empresas" ng-disabled="req.RequisicionId !==''">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqMoneda") %> </span>
                                <select ng-model="req.MonedaId" class="form-control-select no-disabled" required
                                    ng-options="mon.MonedaId as mon.Nombre for mon in monedaCmb" ng-disabled="(req.RequisicionId !=='')">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqFormatoLinea") %> </span>
                                <select ng-model="req.FormatoLineaId" class="form-control-select no-disabled" required
                                    ng-options="fl.FormatoLineaId as fl.Nombre for fl  in formatoLinea" ng-disabled="req.RequisicionId !==''">                                    
                                </select>
                            </div>
                        </div>

                        <div class="row mb" ng-if="(!req.esPOP)">
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqGrupoLibro") %> </span>
                                <input type="text" class="form-control-input no-disabled" ng-model="req.GrupoLibro" required
                                    ng-disabled="req.RequisicionId !==''" />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqIdioma") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.IdiomaRequisicion" readonly />
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblReqAlmacen") %> </span>
                                <input type="text" class="form-control-input" ng-model="req.Almacen" readonly />
                            </div>
                             <div class="col-sm-6 col-md-3" ng-if="(req.esPOP)">
                                <span class="label-color"><%= this.GetMessage("lblFechaQueSeRequiere") %> </span>
                                <datepicker ng-model="req.FechaRequerida" min-date="fechaActual" input-class="form-control-input no-disabled"
                                    required ng-if="req.RequisicionId ===''"></datepicker>
                                <input type="text" class="form-control-input" ng-model="req.FechaRequerida" readonly ng-if="req.RequisicionId !==''" />
                            </div>
                        </div>
                        <div class="row mb">
                            <div class="col-sm-6 col-md-3" ng-if="(!req.esPOP)">
                                <span class="label-color"><%= this.GetMessage("lblFechaQueSeRequiere") %> </span>
                                <datepicker ng-model="req.FechaRequerida" min-date="fechaActual" input-class="form-control-input no-disabled"
                                    required ng-if="req.RequisicionId ===''"></datepicker>
                                <input type="text" class="form-control-input" ng-model="req.FechaRequerida" readonly ng-if="req.RequisicionId !==''" />
                            </div>
                            <div class="col-sm-6 col-md-3" ng-if="(!req.esPOP)">
                                <span class="label-color"><%= this.GetMessage("lblFechaEntragaEstimada") %> </span>
                                <datepicker ng-model="req.FechaEstimada" min-date="fechaActual" input-class="form-control-input no-disabled"
                                    required ng-if="req.RequisicionId ===''"></datepicker>
                                <input type="text" class="form-control-input" ng-model="req.FechaEstimada" readonly ng-if="req.RequisicionId !==''" />
                            </div>
                            <div class="col-sm-6 col-md-3">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="subtitulo-color"><%= this.GetMessage("lblReqArticulos") %></div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12">
                                <div class="table-responsive">
                                    <table class="activity-table">
                                        <thead>
                                            <tr class="jsgrid-header-row">
                                                <th style="width: 300px">
                                                    <%= this.GetMessage("lblReqArticulo")%>
                                                </th>
                                                <th style="width: 100px">
                                                    <%= this.GetMessage("lblCodigoArticulo")%>
                                                </th>
                                                <th style="width: 50px">
                                                    <%= this.GetMessage("lblReqUM")%>
                                                </th>
                                                <th class="text-center" style="width: 80px">
                                                    <%= this.GetMessage("lblReqCantidad")%>
                                                </th>
                                                <th class="text-center" style="width: 100px">
                                                    <%= this.GetMessage("lblReqCostoUnitario")%>
                                                </th>
                                                <th class="text-center" style="width: 100px">
                                                    <%= this.GetMessage("lblReqTotal")%>
                                                </th>
                                                <th style="width: 100px">
                                                    <%= this.GetMessage("lblReqObservaciones")%>
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr ng-repeat="item in SelectedItems" class="va-m">
                                                <td class="va-m">
                                                    <input type="text" class="form-control-input" ng-model="item.Articulo" readonly />
                                                </td>
                                                <td>
                                                    <!--   <ex-autocomplete ng-model="item.ArticuloId" options="articuloOptions" item="item" ng-if="osVisible()"
                                                        required append-to-body on-select="articuloUnidad(optionSelected, item);" ng-disabled="req.RequisicionId !==''"
                                                        style="width: 100px" class="table-edit">
                                                     </ex-autocomplete>-->
                                                    <input type="text" class="form-control-input" ng-model="item.CodigoArticulo" readonly />
                                                </td>
                                                <td class="va-m">
                                                    <input type="text" class="form-control-input" ng-model="item.UnidadMedida" readonly />
                                                </td>
                                                <td class="va-m text-right">{{item.Cantidad}}
                                                </td>
                                                <td class="va-m text-right">{{item.Precio | currency}}
                                                </td>
                                                <td class="va-m text-right">{{item.Importe | currency}}
                                                </td>
                                                <td class="va-m text-center">
                                                    <div ng-if="(req.RequisicionId == '')">
                                                          <button type="button" class="btn btn-link btn-lg" data-toggle="modal" id="{{item.Id}}" ng-disabled="req.RequisicionId !==''"
                                                        ng-click="guardarComentario(item)" uib-tooltip="<%= this.GetMessage("lblGuardarComentario") %>">
                                                        <i class="glyphicon glyphicon-pencil d-block"></i>
                                                        </button>
                                                    </div>
                                                    <div ng-if="(req.RequisicionId > 0)">
                                                        {{item.Observaciones}}
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <br />
                        <div class="row mb" ng-if="(!req.esPOP)">
                            <div class="col-sm-6 col-md-4">
                                <span class="label-color"><%= this.GetMessage("lblReqRutaA") %> </span>
                                <select ng-model="req.RutaA" class="form-control-select no-disabled" required
                                    ng-options="a.AprobadorId as a.Nombre for a in aprobador" ng-disabled="req.RequisicionId !==''">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>

                            </div>
                            <div class="col-sm-6 col-md-4">
                                <span class="label-color"><%= this.GetMessage("lblReqComprador") %> </span>
                                <select ng-model="req.Comprador" class="form-control-select no-disabled" required
                                    ng-options="c.CompradorId as c.Nombre for c in comprador" ng-disabled="req.RequisicionId !==''">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>
                            </div>
                        </div>
                        <div class="row mb" ng-if="(req.esPOP)">
                            <div class="col-sm-6 col-md-4">
                                <span class="label-color"><%= this.GetMessage("lblAprobador") %> </span>
                                <select ng-model="req.RutaA" class="form-control-select no-disabled" required
                                    ng-options="a.AprobadorId as a.Nombre for a in aprobador" ng-disabled="req.RequisicionId !==''">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>

                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="label-color"><%= this.GetMessage("lblRequisitor") %> </span>
                                <select ng-model="req.Solicitado" class="form-control-select no-disabled" required ng-disabled="req.RequisicionId !=='' "
                                    ng-options="a.UsuarioQadId as a.Usuario for a in usuarioQad">
                                    <option value=""><%= this.GetCommonMessage("lblSeleccionar") %> </option>
                                </select>
                            </div>
                        </div>
                        <br />
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
                                    <input type="text" ng-model="ArticuloSolo.Observaciones" class="form-control no-disabled">
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-default no-disabled" data-dismiss="modal">Cerrar</button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>


            <div class="page-content" ng-show="(pantallaId === pantallas.requisicionMedio)">
                PRUEBA
            </div>

        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/activity.js?V1<%= DateTime.Now.Millisecond %>""""></script>
</asp:Content>
