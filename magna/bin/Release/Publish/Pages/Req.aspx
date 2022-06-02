<%@ Page Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Req.aspx.cs" Inherits="CYP.Pages.Req" %>

 
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server"> 
    <div class="page-content">
        <div ng-controller="RequisicionController as req">
            <div ng-show="(req.esConsulta)">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <h3 class="subtitulo">Solicitudes</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <p>&nbsp;</p>
                    </div>
                </div>
                <div id="Tabs" class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <ul id="myTab" class="nav nav-tabs ul-edit">
                            <li class="active">
                                <a href="#" id="tab1" ng-click="req.BuscarReq()" data-toggle="tab">
                                    <%= this.GetMessage("lblMisRequisiciones") %>
                                </a>
                            </li>
                            <li ng-show="(req.UsuarioInfo.PerfilAutorizadorCompras)">
                                <a href="#" id="tab2" ng-click="req.MisReqPorCotizar()" data-toggle="tab">
                                    <%= this.GetMessage("lblPorCotizar") %>
                                    &nbsp;
                                                <span class="fa-stack fa-2x" ng-show="(req.porCotizarMark)">
                                                    <i class="fa fa-bookmark fa-stack-2x"></i>
                                                    <strong class="fa-stack-1x calendar-text">{{req.porCotizar}}</strong>
                                                </span>
                                </a></li>
                            <li ng-show="(req.UsuarioInfo.PerfilAutorizadorCompras)">
                                <a href="#" id="tab3" ng-click="req.MisReqPorConvertir()" data-toggle="tab">
                                    <%= this.GetMessage("lblPorConvertirAOC") %>
                                    &nbsp;
                                                <span class="fa-stack fa-2x" ng-show="(req.porConvertirOCMark)">
                                                    <i class="fa fa-bookmark fa-stack-2x"></i>
                                                    <strong class="fa-stack-1x calendar-text">{{req.porConvertirOC}}</strong>
                                                </span>
                                </a></li>
                            <li ng-show="(req.UsuarioInfo.PerfilAutorizador)">
                                <a href="#" id="tab4" ng-click="req.MisReqPorAutorizar()" data-toggle="tab">
                                    <%= this.GetMessage("lblPorAutorizar") %>
                                      &nbsp;
                                                <span class="fa-stack fa-2x" ng-show="(req.porAutorizarMark)">
                                                    <i class="fa fa-bookmark fa-stack-2x"></i>
                                                    <strong class="fa-stack-1x calendar-text">{{req.porAutorizar}}</strong>
                                                </span>
                                </a>
                            </li>

                        </ul>
                    </div>
                </div>
                <div class="row">
                    &nbsp;
                </div>
                <div ng-form="req.FilterForm">
                    <div class="mail-box">
                        <div class="mail-body-filter">
                            <div class="ibox-content">
                                <div id="Filters" class="padding-form">
                                    <div class="row">
                                        <div>
                                            <div class="col-lg-9">
                                                <div class="col-lg-1 col-md-1 col-sm-1">
                                                    <div>
                                                        <span class="subtitulo"><%= this.GetMessage("lblRequisicion") %> </span>
                                                    </div>

                                                    <input type="text" class="form-control" numbers-only ng-model="req.filter.Folio" maxlength="10" key-enter="req.getRequisicion()" />

                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2">
                                                    <div>
                                                        <span class="subtitulo"><%= this.GetMessage("lblFecha") %> </span>
                                                    </div>
                                                    <div class="input-group">
                                                        <datepicker ng-model="req.fecha" is-required="{{req.filter.FechaFinal!=undefined && req.filter.FechaFinal!=''}}" format="'dd/mm/yyyy'"></datepicker>
                                                        <span class="input-group-addon">
                                                            <i class="glyphicon glyphicon-calendar"></i>
                                                        </span>

                                                    </div>
                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2">
                                                    <div>
                                                        &nbsp;
                                                    </div>
                                                    <div class="input-group">
                                                        <div class="input-group">
                                                            <datepicker ng-model="req.filter.FechaFinal" is-required="{{req.filter.FechaInicial!=undefined && req.filter.FechaInicial!=''}}"></datepicker>
                                                            <span class="input-group-addon">
                                                                <i class="glyphicon glyphicon-calendar"></i>
                                                            </span>

                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2">
                                                    <div>
                                                        <span class="subtitulo"><%= this.GetMessage("lblTipoCompra") %> </span>
                                                    </div>

                                                    <select class="form-control" key-enter="req.getRequisicion()"
                                                        ng-model="req.filter.TipoCompraID"
                                                        ng-options="TC.TipoCompraID as TC.NombreTipoCompra for TC in req.ListaTiposCompra">
                                                        <option value=""><%= this.GetMessage("lblAll") %></option>
                                                    </select>

                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2">
                                                    <div>
                                                        <span class="subtitulo"><%= this.GetMessage("lblSucursal") %> </span>
                                                    </div>

                                                    <select class="form-control" key-enter="req.getRequisicion()"
                                                        ng-model="req.filter.SucursalID"
                                                        ng-options="Sucursal.SucursalID as Sucursal.NombreSucursal for Sucursal in req.ListaSucursal">
                                                        <option value=""><%= this.GetMessage("lblAllF") %></option>
                                                    </select>

                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2" ng-if="req.edit.TipoCompraID==2">
                                                    <div>
                                                        <span class="subtitulo"><%= this.GetMessage("lblAlmacen") %> </span>
                                                    </div>

                                                    <select class="form-control"
                                                        ng-model="req.filter.AlmacenID"
                                                        ng-options="Almacen.AlmacenID as Almacen.NombreAlmacen for Almacen in req.ListaAlmacen">
                                                        <option value=""><%= this.GetMessage("lblAllF") %></option>
                                                    </select>

                                                </div>
                                                <div class="col-lg-2 col-md-2 col-sm-2">
                                                    <div>
                                                        <span class="subtitulo"><%= this.GetMessage("lblEstatus") %> </span>
                                                    </div>

                                                    <select selectpicker key-enter="req.getRequisicion()" multiple data-select-all-text='<%= this.GetMessage("lblSelectAll") %>' data-deselect-all-text='<%= this.GetMessage("lblDeselectAll") %>'
                                                        multiple data-actions-box="true" data-none-selected-text='<%= this.GetMessage("lblAll") %>' data-collection-name="req.ListaEstatusRequisicion"
                                                        ng-model="req.filter.EstatusRequisicionID"
                                                        ng-options="ER.EstatusRequisicionID as ER.NombreEstatusRequisicion for ER in req.ListaEstatusRequisicion">
                                                    </select>

                                                </div>
                                            </div>
                                            <div>
                                                <div class="pull-right">
                                                    <div class="btn-success mail-body-filter-td-rd cursor" ng-click="req.BuscarReq()">
                                                        &nbsp;<i class="glyphicon glyphicon-search icon-5x cursor"></i> &nbsp;
                                                    </div>
                                                </div>
                                                <div class="pull-right">
                                                    <div id="btnFilter" class="btn-danger mail-body-filter-td cursor">
                                                        &nbsp;
                                                            <i class="glyphicon glyphicon-filter icon-5x"></i>&nbsp;
                                                    </div>
                                                </div>
                                                <div class="pull-right">
                                                    <div id="Div1" class="btn-info mail-body-filter-td cursor" ng-click="req.export()">
                                                        &nbsp;
                                                            <i class="glyphicon glyphicon-download icon-5x"></i>&nbsp;
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row" style="display: none; background-color: white; border: 1px solid #999; width: 280px" id="divFiltros">
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12">
                                                <div>
                                                    <span><%= this.GetMessage("lblProveedor") %> </span>
                                                </div>

                                             <%--   <ui-select ng-model="req.filter.Proveedor" theme="bootstrap" required
                                                    reset-search-input="false" style="width: 100%">
                                                                               <ui-select-match allow-clear="true" placeholder="<%= this.GetMessage("lblIngresarProveedor") %>">
                                                                                    {{ $select.selected.NombreProveedor || $select.selected}}
                                                                                </ui-select-match>
                                                        
                                                                                <ui-select-choices  repeat="Proveedor in req.ListaProveedor | filter: $select.search" 
                                                                                    refresh="req.getProveedorCmb($select.search)" refresh-delay="400" minimum-Input-Length="1">
                                                                                    <b><div ng-bind-html="Proveedor.NombreProveedor | highlight: $select.search"></div> </b>                                                                                  
                                                                                </ui-select-choices>
                                                              
                                                                            </ui-select>--%>

                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12">
                                                <div>
                                                    <span><%= this.GetMessage("lblEmpresa") %> </span>
                                                </div>

                                                <select selectpicker key-enter="req.getRequisicion()" multiple data-select-all-text='<%= this.GetMessage("lblSelectAllF") %>' data-deselect-all-text='<%= this.GetMessage("lblDeselectAllF") %>'
                                                    multiple data-actions-box="true" data-none-selected-text='<%= this.GetMessage("lblAllF") %>' data-collection-name="req.ListaEmpresa"
                                                    ng-model="req.filter.EmpresaID" required
                                                    ng-options="E.EmpresaID as E.NombreEmpresa for E in req.ListaEmpresa">
                                                </select>


                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12 col-md-12 col-sm-12">
                                                <div>
                                                    <span><%= this.GetMessage("lblTipoCompra") %> </span>
                                                </div>

                                                <select selectpicker key-enter="req.getRequisicion()" multiple data-select-all-text='<%= this.GetMessage("lblSelectAllF") %>' data-deselect-all-text='<%= this.GetMessage("lblDeselectAllF") %>'
                                                    multiple data-actions-box="true" data-none-selected-text='<%= this.GetMessage("lblAllF") %>' data-collection-name="req.ListaTipoCompra"
                                                    ng-model="req.filter.TipoCompraID" required
                                                    ng-options="TC.TipoCompraID as TC.NombreTipoCompra for TC in req.ListaTipoCompra">
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mail-box">
                        <div class="mail-body">
                            <div class="ibox-content">
                                <div id="MisRequisiciones" class="padding-form">
                                    <div class="row" ng-class="{'submitted': !req.isValid}">
                                        <div class="col-lg-12 col-md-12 col-sm-12">
                                            <table class="table table-condensed table-striped table-hover table-fixed col-md-12"
                                                st-table="req.ListaRequisicion" st-safe-src="req.ListaRequisicionAux">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 10%">
                                                            <%= this.GetMessage("gvRequisicion-Folio") %>
                                                        </th>
                                                        <th style="width: 13%">
                                                            <%= this.GetMessage("gvRequisicion-Fecha") %>
                                                        </th>
                                                        <th style="width: 20%">
                                                            <%= this.GetMessage("gvRequisicion-Sucursal") %>
                                                        </th>
                                                        <th style="width: 17%">
                                                            <%= this.GetMessage("gvRequisicion-TipoCompra") %>
                                                        </th>
                                                        <th style="width: 20%">
                                                            <%= this.GetMessage("gvRequisicion-Estatus") %>
                                                        </th>
                                                        <th style="width: 20%; text-align: right;">
                                                            <button type="button" class="btn btn-link" ng-click="req.AgregarRequisicion()">
                                                                <i class="glyphicon glyphicon-plus"></i><span>&nbsp;</span><span><%= this.GetMessage("lblNuevo") %></span>
                                                            </button>

                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody style="max-height: 350px">
                                                    <tr ng-repeat="item in req.ListaRequisicion">

                                                        <td style="width: 10%;">{{ item.Folio }}
                                                        </td>

                                                        <td style="width: 13%;">{{ item.FechaRequisicion }}
                                                        </td>
                                                        <td style="width: 20%">{{ item.NombreSucursal}}
                                                        </td>
                                                        <td style="width: 17%">{{ item.NombreTipoCompra}}
                                                        </td>
                                                        <td style="width: 20%">{{ item.NombreEstatusRequisicion}}
                                                        </td>
                                                        <td style="width: 20%; text-align: right;">
                                                            <button type="button" class="btn btn-link" ng-click="req.EditarReq(item)">
                                                                <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                            </button>

                                                        </td>
                                                    </tr>
                                                    <tr ng-if="req.ListaRequisicion.length == 0 || req.ListaRequisicion == null" class="nodata-row">
                                                        <td colspan="3" style="text-align: center;">
                                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="5" class="text-right" style="padding-bottom: 0">
                                                            <div st-pagination="5" st-items-by-page="30" st-template="../templates/pagination.html"></div>
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
                </div>
            </div>
            <div ng-show="(!req.esConsulta)">
                <div ng-form="req.Form" ng-class="{'submitted': !req.isValid}">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="col-md-8">
                                <h3 class="subtitulo"><%= this.GetMessage("lblRequisiciones") %></h3>
                            </div>
                            <div class="col-md-4" ng-show="(req.form.EstatusRequisicionID > 1)">
                                <h5 class="subtitulo"><span ng-bind="req.form.NombreEstatusRequisicion"></span></h5>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="col-md-12">
                                <table cellpadding="0" cellspacing="0" border="0" class="col-md-12">
                                    <tr>
                                        <td width="70%">&nbsp;
                                        </td>
                                        <td>
                                            <button id="Button3" type="button" class="btn btn-large btn-custom" ng-click=" req.RegresarListado()">
                                                <%= this.GetMessage("lblRegresarListado")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 1 || (req.form.EstatusRequisicionID == 3 && req.UsuarioInfo.PerfilAutorizadorCompras))">
                                            <button id="btnBack" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaCancelar()">
                                                <%= this.GetMessage("btnCancel")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 0 || req.form.EstatusRequisicionID == 1)">
                                            <button id="Button1" type="button" class="btn btn-large btn-custom" ng-click="req.GuardarReq()">
                                                <%= this.GetMessage("btnSave")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 0 || req.form.EstatusRequisicionID == 1)">
                                            <button id="Button2" type="button" class="btn btn-large btn-custom" ng-click=" req.SolicitarReq()">
                                                <%= this.GetMessage("btnSolicitar")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 2 && req.UsuarioInfo.PerfilAutorizador)">
                                            <button id="Button4" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaAutorizar()">
                                                <%= this.GetMessage("btnAutorizar")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 2 && req.UsuarioInfo.PerfilAutorizador)">
                                            <button id="Button5" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaRechazar()">
                                                <%= this.GetMessage("btnRechazar")  %>
                                            </button>
                                        </td>

                                        <td ng-show="(req.form.EstatusRequisicionID == 3 && req.UsuarioInfo.PerfilAutorizadorCompras)">
                                            <button id="Button6" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaEnviaAutorizar()">
                                                <%= this.GetMessage("btnEnviarAutorizacion")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 3 && req.UsuarioInfo.PerfilAutorizadorCompras)">
                                            <button id="Button7" type="button" class="btn btn-large btn-custom" ng-click=" req.GuardarPorCotizar()">
                                                <%= this.GetMessage("btnSave")  %>
                                            </button>
                                        </td>

                                        <td ng-show="(req.form.EstatusRequisicionID == 4 && req.UsuarioInfo.PerfilAutorizador)">
                                            <button id="Button8" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaAutorizarOC()">
                                                <%= this.GetMessage("btnAutorizar")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 4 && req.UsuarioInfo.PerfilAutorizador)">
                                            <button id="Button9" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaRechazarOC()">
                                                <%= this.GetMessage("btnRechazar")  %>
                                            </button>
                                        </td>
                                        <td ng-show="(req.form.EstatusRequisicionID == 5 && req.UsuarioInfo.PerfilAutorizadorCompras)">
                                            <button id="Button10" type="button" class="btn btn-large btn-custom" ng-click=" req.confirmaConvertirOC()">
                                                <%= this.GetMessage("btnConvertirOC")  %>
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="mail-box">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div class="row paddingTop-7">
                                        <div class="col-sm-12">
                                            <span class="subtitulo-color"><%= this.GetMessage("lblDatosGenerales") %> </span>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-2">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblFecha") %></b></span>
                                            <div>{{req.form.FechaRequisicion}}</div>
                                        </div>

                                        <div class="col-sm-2">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblFolio") %></b></span>
                                            &nbsp;
                                                    <div>{{req.form.Folio}}</div>
                                        </div>
                                        <div class="col-sm-2">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblSolicitante") %></b></span>
                                            <div>{{req.form.NombreUsuario}}</div>
                                        </div>
                                        <div class="col-sm-3">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblJefeInmediato") %></b></span>
                                            <div>{{req.form.NombreJefeInmediato}}</div>

                                        </div>

                                        <div class="col-sm-3">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblRazonSocial") %></b></span>

                                            <select ng-disabled="(req.esDisabled)"
                                                class="form-control-select"
                                                ng-model="req.form.EmpresaID" required
                                                ng-options="E.EmpresaID as E.NombreEmpresa for E in req.ListaEmpresa">
                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                            </select>
                                            <div ng-if="req.form.ReadOnly">{{req.form.Folio}}</div>
                                        </div>
                                    </div>
                                    <div class="row linebreak">
                                        <div class="col-sm-12">
                                            &nbsp;
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-2">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblClasificacion") %></b></span>

                                            <select ng-disabled="(req.esDisabled)"
                                                class="form-control-select"
                                                ng-model="req.form.ClasificacionID" required
                                                ng-options="C.ClasificacionID as C.NombreClasificacion for C in req.ListaClasificacion">
                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                            </select>
                                            <div ng-if="req.form.ReadOnly">{{req.form.NombreClasificacion}}</div>
                                        </div>
                                        <div class="col-sm-2">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblTipoCompra") %></b></span>

                                            <select ng-disabled="(req.esDisabled)" ng-change="req.changeTipoCompra()"
                                                class="form-control-select"
                                                ng-model="req.form.TipoCompraID" required
                                                ng-options="TC.TipoCompraID as TC.NombreTipoCompra for TC in req.ListaTiposCompra">
                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                            </select>
                                            <div ng-if="req.form.ReadOnly">{{req.form.NombreTipoCompra}}</div>
                                        </div>
                                        <div class="col-sm-2">
                                            <div>
                                                <span class="subtitulo"><%= this.GetMessage("lblSucursal") %> </span>
                                            </div>
                                            <input type="hidden" id="hfSucursalId" ng-model="req.form.SucursalID" />
                                            <div>{{req.form.NombreSucursal}}</div>
                                        </div>
                                        <div class="col-sm-2" ng-show="req.form.TipoCompraID==2">
                                            <div>
                                                <span class="subtitulo"><%= this.GetMessage("lblAlmacen") %> </span>
                                            </div>
                                            <div>{{req.form.NombreAlmacen}}</div>
                                        </div>
                                        <div class="col-sm-2">
                                            <div>
                                                <span class="subtitulo"><%= this.GetMessage("lblDepartamento") %> </span>
                                            </div>
                                            <div>{{req.form.NombreDepartamento}}</div>
                                        </div>
                                        <div class="col-sm-2" ng-show="(req.form.ObligarNumEconomico || req.form.NumEconomico != '')">
                                            <span class="subtitulo"><%= this.GetMessage("lblNumEconomico") %></span>
                                            <input ng-disabled="(req.esDisabled)" type="text" ng-if="!req.form.ReadOnly" alpahnumeric 
                                                ng-model="req.form.NumEconomico" maxlength="10" ng-required="(req.form.ObligarNumEconomico)" class="form-control-input" />
                                            <div ng-if="req.form.ReadOnly">{{req.form.NumEconomico}}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mail-box">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div class="row paddingTop-7">
                                        <div class="col-sm-12">
                                            <span class="subtitulo-color"><%= this.GetMessage("lblProductos") %> </span>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <span class="subtitulo"><b><%= this.GetMessage("lblDescripcionRequerimiento") %></b></span>
                                            <input ng-disabled="(req.esDisabled)" type="text" ng-model="req.form.Descripcion" class="form-control-input" required />
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 col-sm-12">
                                            <table id="tblProducto" class="table table-condensed table-striped table-hover table-fixed col-md-12"
                                                st-table="req.ListaReqProducto" st-safe-src="req.ListaReqProductoAux">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 15%">
                                                            <%= this.GetMessage("gvProducto-Producto") %>
                                                        </th>
                                                        <th style="width: 5%">
                                                            <%= this.GetMessage("gvProducto-Cantidad") %>
                                                        </th>
                                                        <th style="width: 15%">
                                                            <%= this.GetMessage("gvProducto-Descripcion") %>
                                                        </th>
                                                        <th style="width: 5%">
                                                            <%= this.GetMessage("gvProducto-Precio-Est") %>
                                                        </th>
                                                         <th style="width: 5%" ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                            <%= this.GetMessage("gvProducto-Precio") %>
                                                        </th>
                                                        <th style="width: 5%">
                                                            <%= this.GetMessage("gvProducto-Moneda") %>
                                                        </th>
                                                        <th style="width: 15%">
                                                            <%= this.GetMessage("gvProducto-Anexo") %>
                                                        </th>
                                                        <th style="width: 10%; text-align: center;" ng-show="(req.form.TipoCompraID==3)">
                                                            <button ng-show="(req.form.TipoCompraID==3 && req.form.EstatusRequisicionID>=2)" 
                                                                type="button" class="btn btn-link" ng-click="req.ResumenAlmacen()">
                                                                <span><%= this.GetMessage("lblVerResumen") %></span>
                                                            </button>
                                                        </th>
                                                        <th style="width: 5%; text-align: right;">
                                                            <button type="button" class="btn btn-link" ng-show="(!req.esDisabledProducto)" ng-click="req.AgregarProducto()">
                                                                <i class="glyphicon glyphicon-plus"></i><span>&nbsp;</span><span><%= this.GetMessage("lblNuevo") %></span>
                                                            </button>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody style="max-height: 350px">
                                                    <tr ng-repeat="item in req.ListaReqProducto  | filter:{Active: true}">
                                                        <td style="width: 15%;">
                                                            <div style="position: absolute; width: 13%">
                                                              <%--  <ui-select ng-model="item.Producto" theme="bootstrap" required
                                                                    ng-change="req.CambiaProducto(item)"
                                                                    ng-disabled="(req.esDisabledProducto)"
                                                                    reset-search-input="false" style="width: 100%">
                                                                           <ui-select-match allow-clear="true" placeholder="<%= this.GetMessage("lblIngresarProducto") %>">
                                                                                {{ $select.selected.NombreProducto || $select.selected}}
                                                                            </ui-select-match>
                                                                            <ui-select-choices  repeat="P in req.ListaProducto | filter: $select.search" 
                                                                                refresh="req.BuscarProducto($select.search)" refresh-delay="400" minimum-Input-Length="1">
                                                                                <b><div ng-bind-html="P.NombreProducto | highlight: $select.search"></div> </b>                                                                                  
                                                                            </ui-select-choices>
                                                              
                                                                        </ui-select>--%>
                                                            </div>
                                                        </td>

                                                        <td style="width: 5%;">
                                                            <input type="text" ng-disabled="(req.esDisabledProducto)" ng-model="item.Cantidad" required class="form-control" maxlength="4"
                                                                numbers-only style="text-align: right" ng-change="req.CambiaProducto(item)" />
                                                        </td>

                                                        <td style="width: 15%;">

                                                            <input type="text" ng-disabled="(req.esDisabledProducto)" ng-model="item.Descripcion" required class="form-control" maxlength="80" alphanumeric
                                                                ng-change="req.CambiaProducto(item)" />
                                                        </td>

                                                        <td style="width: 5%;">
                                                            <input type="text" ng-disabled="(req.esDisabledProducto)" ng-model="item.Precio" required style="text-align: right" class="form-control"
                                                                maxlength="13" decimal-only ng-change="req.changeProducto(item)" />
                                                        </td>

                                                         <td style="width: 5%;" ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                            <input ng-required="(req.esRequiredAutorizacion)" type="text" ng-disabled="(!req.esDisabledProducto)" ng-model="item.PrecioUnitario" 
                                                                class="form-control" money
                                                                maxlength="13" ng-change="req.changeProducto(item)" />
                                                        </td>

                                                        <td style="width: 5%;">
                                                            <select ng-disabled="(req.esDisabledProducto)" 
                                                                class="form-control" ng-change="req.changeProducto(item)"
                                                                ng-model="item.MonedaID" required id="selMoneda"
                                                                ng-options="M.MonedaID as M.Abreviatura for M in req.ListaMoneda">
                                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                            </select>
                                                        </td>

                                                        <td style="width: 15%;">
                                                            <div class="input-group">
                                                                <input type="text" class="form-control" ng-model="item.file" readonly />
                                                                <span class="input-group-addon">
                                                                    <i ng-show="(req.form.EstatusRequisicionID == 0 || req.form.EstatusRequisicionID == 1)" class="fa fa-paperclip cursor"
                                                                        ng-click="req.BuscarAdjunto('inputFile')">
                                                                        <input id="inputFile" type="file" name="txtRequisicionNombreAnexo" ng-model="item.file"
                                                                            title="<%= this.GetMessage("lblFindFile") %>"
                                                                            alt="Requisicion_Producto" data-file="item.file" class="form-control nonecell" />
                                                                    </i>
                                                                    &nbsp;
                                                                        <i ng-show="(req.form.EstatusRequisicionID > 0 && item.NombreAnexo!='')" class="fa fa-download cursor"
                                                                            ng-click="req.AbrirAnexo(item,1)"></i>
                                                                </span>
                                                            </div>
                                                        </td>
                                                        <td style="width: 10%; text-align: center" ng-show="(req.form.TipoCompraID==3)">
                                                            <button type="button" class="btn btn-link" ng-click="req.Distribuir(item,$index)">
                                                                <span><%= this.GetMessage("lblDistribuir") %></span>
                                                            </button>
                                                        </td>

                                                        <td style="width: 5%; text-align: right;">
                                                            <button ng-show="(!req.esDisabledProducto)" type="button" class="btn btn-link" ng-click="req.EliminarProducto(item,$index)">
                                                                <i class="icon-remove"></i>{{ requisicion.deleteText }}
                                                            </button>

                                                        </td>
                                                    </tr>
                                                    <tr ng-if="req.ListaReqProducto.length == 0 || req.ListaReqProducto == null" class="nodata-row">
                                                        <td colspan="3" style="text-align: center;">
                                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="5" class="text-right" style="padding-bottom: 0">
                                                            <div st-pagination="5" st-items-by-page="30" st-template="../templates/pagination.html"></div>
                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mail-box">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div class="row paddingTop-7">
                                        <div class="col-sm-12">
                                            <span class="subtitulo-color"><%= this.GetMessage("lblProveedores") %> </span>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 col-sm-12">
                                            <table id="tblProveedor" class="table table-condensed table-striped table-hover table-fixed col-md-12" st-table="req.ListaReqProveedor" st-safe-src="req.ListaReqProveedorAux">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 25%">
                                                            <%= this.GetMessage("gvProveedor-NombreProveedor") %>
                                                        </th>
                                                        <th style="width: 25%">
                                                            <div ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                                <%= this.GetMessage("gvProveedor-Cotizaciones") %>
                                                            </div>
                                                        </th>
                                                        <th style="width: 10%">
                                                            <div ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                                <%= this.GetMessage("gvProveedor-Precio") %>
                                                            </div>
                                                        </th>
                                                        <th style="width: 9%; text-align: center">
                                                            <div ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                                <%= this.GetMessage("gvProveedor-Moneda") %>
                                                            </div>
                                                        </th>
                                                        <th style="width: 13%; text-align: center">
                                                            <div ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                                <%= this.GetMessage("gvProveedor-Ganador") %>
                                                            </div>
                                                        </th>

                                                        <th style="width: 18%; text-align: right;">
                                                            <button type="button" style="display: none" class="btn btn-link" ng-click="req.export()">
                                                                <i class="icon-save"></i><span>&nbsp;</span><span><%= this.GetMessage("lblExport") %></span>
                                                            </button>
                                                            <button type="button" class="btn btn-link"  ng-show="(!req.esDisabledAlta)" ng-click="req.AgregarProveedor()">
                                                                <i class="glyphicon glyphicon-plus"></i><span>&nbsp;</span><span><%= this.GetMessage("lblNuevo") %></span>
                                                            </button>

                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody style="max-height: 350px">
                                                    <tr ng-repeat="item in req.ListaReqProveedor">
                                                        <td style="width: 25%;">
                                                            <div style="position: absolute; width: 23%">
                                                                <div class="input-group">
                                                                  <%--  <ui-select ng-show="(item.EsProveedor)" ng-model="item.Proveedor"
                                                                        ng-disabled="(req.esDisabledProveedor)" theme="bootstrap"
                                                                        ng-required="(item.EsProveedor)" ng-change="req.CambiaProveedor(item)"
                                                                        reset-search-input="false" style="width: 100%">
                                                                           <ui-select-match allow-clear="true" placeholder="<%= this.GetMessage("lblIngresarProveedor") %>">
                                                                                {{ $select.selected.NombreProveedor || $select.selected}}
                                                                            </ui-select-match>
                                                        
                                                                            <ui-select-choices  repeat="Proveedor in req.ListaProveedor | filter: $select.search" 
                                                                                refresh="req.getProveedorCmb($select.search)" refresh-delay="400" minimum-Input-Length="1">
                                                                                <b><div ng-bind-html="Proveedor.NombreProveedor | highlight: $select.search"></div> </b>                                                                                  
                                                                            </ui-select-choices>
                                                              
                                                                        </ui-select>--%>
                                                                    <input ng-disabled="(req.esDisabledProveedor)"
                                                                        ng-show="(!item.EsProveedor)" ng-required="(!item.EsProveedor)"
                                                                        type="text" ng-model="item.NombreProveedorOtro" class="form-control" placeholder="<%= this.GetMessage("lblCapturarProveedor") %>" />

                                                                    <span class="input-group-addon">
                                                                        <i ng-disabled="(req.esDisabledProveedor)"
                                                                            ng-show="(item.EsProveedor)"
                                                                            class="fa fa-pencil cursor"
                                                                            ng-click="req.ConProveedor(item)"></i>
                                                                        &nbsp;
                                                                                <i
                                                                                    ng-disabled="(req.esDisabledProveedor)"
                                                                                    ng-show="(!item.EsProveedor)"
                                                                                    class="fa fa-database cursor"
                                                                                    ng-click="req.SinProveedor(item)"></i>
                                                                    </span>
                                                                </div>

                                                            </div>
                                                        </td>
                                                        <td style="width: 25%;">
                                                            <div ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))" class="input-group" style="width: 100%">
                                                                <div class="input-group">
                                                                    <input type="text" class="form-control" ng-model="item.file" readonly ng-required="(req.esRequiredAutorizacion)" />
                                                                    <span class="input-group-addon">
                                                                        <i class="fa fa-paperclip cursor" 
                                                                            ng-click="req.BuscarAdjunto('inputFileProv' + $index)">
                                                                            <input id="inputFileProv{{$index}}" type="file" name="txtRequisicionNombreAnexo" ng- model="item.file"
                                                                             alt="Requisicion_Proveedor" data-file="item.file" class="form-control nonecell" />
                                                                        </i>
                                                                        &nbsp;   
                                                                        <i ng-show="(req.form.EstatusRequisicionID >= 3 && item.NombreAnexo!='')" class="fa fa-download cursor" 
                                                                            ng-click="req.AbrirAnexo(item,2)"></i>
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td style="width: 10%; text-align: right" ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                            <input ng-disabled="(req.esDisabledProveedor)"
                                                                type="text" ng-model="item.Precio" ng-change="req.CambiaProveedor(item)" decimal-only class="form-control" required
                                                               ng-required="(req.esRequiredProveedor)"  />
                                                            <span ng-if="requisicion.proveedor.ReadOnly">{{item.PrecioStr}}</span>
                                                        </td>
                                                        <td style="width: 9%; text-align: center" ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                            <select ng-change="req.CambiaProveedor(item)" ng-disabled="(req.esDisabledProveedor)"
                                                                class="form-control"
                                                                ng-model="item.MonedaID" required  ng-required="(req.esRequiredProveedor)" 
                                                                ng-options="M.MonedaID as M.Abreviatura for M in req.ListaMoneda">
                                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                            </select>
                                                            <span ng-if="requisicion.proveedor.ReadOnly">{{item.Abreviatura}}</span>
                                                        </td>
                                                        <td style="width: 13%; text-align: center" ng-show="(req.form.EstatusRequisicionID >= 3 && (req.UsuarioInfo.PerfilAutorizadorCompras || req.UsuarioInfo.PerfilAutorizador))">
                                                            <input type="radio"
                                                                ng-checked="(item.Ganador == 1)"
                                                                ng-change="req.CambiaGanador(item)" name="Ganador" ng-model="item.Ganador">
                                                        </td>
                                                        <td style="width: 18%; text-align: right;">
                                                            <button type="button" class="btn btn-link" ng-disabled="(req.esDisabledProveedor)" ng-click="req.confirmaEliminarProveedor(item)">
                                                                <i class="icon-remove"></i>{{ requisicion.deleteText }}
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr ng-if="req.ListaReqProveedor.length == 0 || req.ListaReqProveedor == null" class="nodata-row">
                                                        <td colspan="3" style="text-align: center;">
                                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="5" class="text-right" style="padding-bottom: 0">
                                                            <div st-pagination="5" st-items-by-page="30" st-template="../templates/pagination.html"></div>
                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                    <br />
                                </div>
                            </div>
                        </div>
                        <div class="mail-box" ng-show="(req.form.EstatusRequisicionID > 1)">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div class="row paddingTop-7">
                                        <div class="col-sm-12">
                                            <span class="subtitulo-color"><%= this.GetMessage("lblAUtorizaciones") %> </span>
                                        </div>
                                    </div>
                                    <br />
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 col-sm-12">
                                            <table id="tblAutorizacion" class="table table-condensed table-striped table-hover table-fixed"
                                                st-table="req.ListaAutorizaciones" st-safe-src="req.ListaAutorizacionesAux">
                                                <thead>
                                                    <tr>
                                                        <th style="width: 20%">
                                                            <%= this.GetMessage("gvAutorizacion-NombrePerfil") %>
                                                        </th>
                                                        <th style="width: 20%">
                                                            <%= this.GetMessage("gvAutorizacion-FechaAutorizacion") %>
                                                        </th>
                                                        <th style="width: 40%">
                                                            <%= this.GetMessage("gvAutorizacion-NombreUsuario") %>
                                                        </th>

                                                        <th style="width: 20%; text-align: right;"></th>
                                                    </tr>
                                                </thead>
                                                <tbody style="max-height: 350px">
                                                    <tr ng-repeat="item in req.ListaAutorizaciones">
                                                        <td style="width: 20%;">{{item.NombrePerfil}}
                                                        </td>
                                                        <td style="width: 20%;">{{item.FechaAutorizacion}}
                                                        </td>
                                                        <td style="width: 40%;">{{item.NombreUsuario}}
                                                        </td>
                                                        <td style="width: 20%; text-align: right;"></td>
                                                    </tr>
                                                    <tr ng-if="req.ListaAutorizaciones.length == 0 || req.ListaAutorizaciones == null" class="nodata-row">
                                                        <td colspan="3" style="text-align: center;">
                                                            <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="5" class="text-right" style="padding-bottom: 0">
                                                            <div st-pagination="5" st-items-by-page="30" st-template="../templates/pagination.html"></div>
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
                </div>

                <div class="modal fade " id="modalDistribuir" role="dialog">
                    <div class="modal-dialog  modal-lgx">
                        <!-- Modal content-->
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" ng-click="req.DistribuidorCerrar()"><span aria-hidden="true">&times;</span></button>
                                <h4 class="modal-title" id="titleCatalogo"><%= this.GetMessage("lblDistribucionSucursal") %></h4>
                                <br />
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-sm-3">
                                        <div><span class="subtitulo"><%= this.GetMessage("lblProducto") %></span></div>
                                        <span ng-bind="req.distribuir.NombreProducto"></span>
                                    </div>
                                    <div class="col-sm-3">
                                        <div><span class="subtitulo"><%= this.GetMessage("lblTipoConsumo") %></span></div>
                                        <span ng-bind="req.distribuir.NombreTipoConsumo"></span>
                                    </div>
                                    <div class="col-sm-3">
                                        <div><span class="subtitulo"><%= this.GetMessage("lblCantidad") %></span></div>
                                        <span ng-bind="req.distribuir.Cantidad"> </span>
                                    </div>

                                    <div class="col-sm-3">
                                        <div><span class="subtitulo"><%= this.GetMessage("lblPorDistribuir") %></span></div>
                                        <span ng-bind="req.distribuir.PorDistribuir"></span>
                                    </div>
                                </div>
                                <div class="row paddingTop-7">
                                    <div class="col-sm-12">
                                        &nbsp;
                                    </div>
                                </div>
                                <div class="row paddingTop-7">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"> <%= this.GetMessage("lblSucursales") %></span> 
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12">
                                        <table id="tblAlmacen" class="table table-condensed table-striped table-hover table-fixed col-md-12" 
                                        st-table="req.ListaDistribuir" st-safe-src="req.ListaDistribuirAux">
                                            <thead>
                                                <tr>
                                                    <th style="width: 30%">
                                                        <%= this.GetMessage("gvAlmacen-NombreAlmacen") %>
                                                    </th>
                                                    <th style="width: 20%">
                                                        <%= this.GetMessage("gvAlmacen-Inventario") %>
                                                    </th>
                                                    <th style="width: 20%">
                                                        <%= this.GetMessage("gvAlmacen-Cantidad") %>
                                                    </th>
                                                    <th style="width: 20%; text-align: right;"></th>
                                                </tr>
                                            </thead>
                                            <tbody style="max-height: 350px">
                                                <tr ng-repeat="item in req.ListaDistribuir">
                                                    <td style="width: 30%;">{{ item.Sucursal }}
                                                    </td>
                                                    <td style="width: 20%;">{{item.Inventario}}
                                                    </td>
                                                    <td style="width: 20%;">
                                                        <input type="text" ng-model="item.CantidadOrdenar" ng-change="req.CambiarDistribucion(item)" 
                                                            numbers-only type="text" class="form-control-input textCenter" maxlength="3" />
                                                    </td>
                                                    <td style="width: 20%; text-align: right;"></td>
                                                </tr>
                                                <tr ng-if="req.ListaDistribuir.length == 0 || req.ListaDistribuir == null" class="nodata-row">
                                                    <td colspan="3" style="text-align: center;">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="5" class="text-right" style="padding-bottom: 0">
                                                        <div st-pagination="5" st-items-by-page="30" st-template="../templates/pagination.html"></div>
                                                    </td>
                                                </tr>
                                            </tfoot>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer text-right">
                                <button id="btnBackAlmacen" type="button" class="btn btn-large btn-custom" ng-click="req.DistribuidorCerrar()">
                                    <%= this.GetMessage("btnCancel")  %>
                                </button>
                                <button type="button" class="btn btn-large btn-success" ng-click="req.GuardarDistribucion()">
                                    <%= this.GetMessage("btnSave")  %>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> 
 <script type="text/javascript" src="../scripts/pages/Req.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
