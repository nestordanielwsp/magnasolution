<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Usuario.aspx.cs" Inherits="CYP.Pages.Usuario" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="usuarioController as vm">
        <div class="content-top clearfix">
            <div class="row">
                <div class="col-sm-6">
                    <h1 class="al-title" ng-bind="vm.titulo"></h1>
                </div>
                <div class="btn-tpm col-sm-6" ng-if="vm.viewDetail">
                    <div class="padding-7">
                        <div class="btn btn-top " ng-click="vm.viewDetail && vm.guardar()" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" tooltip-placement="bottom" ng-disabled="!vm.viewDetail">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div class="padding-7">
                        <div class="btn btn-top" ng-click="vm.actualizar();vm.viewDetail=false" uib-tooltip="<%= this.GetCommonMessage("LblTooltipRegresar") %>" tooltip-placement="bottom" ng-disabled="!vm.viewDetail">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-content">
            <div ng-if="!vm.viewDetail">
                <div class="filter mail-box filtros">
                    <div class="row p-5">
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-2">
                                    <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                                </div>

                                <div class="clearfix visible-sm visible-xs pt-5"></div>

                                <div class="col-md-10">
                                    <input type="text" class="form-control" ng-model="vm.filtro.NombreUsuario" key-enter="vm.actualizar()"
                                        placeholder="Busqueda rápida por (<%= this.GetMessage("Usuario") %> / <%= this.GetMessage("PerfilFuncional") %>)">
                                </div>
                            </div>
                        </div>

                        <div class="clearfix visible-xs">
                            <br />
                        </div>

                        <div class="col-md-4 text-right">
                            <button type="button" class="btn btn-link" ng-click="vm.openFilterAdvance=!vm.openFilterAdvance;vm.clearFiltros()">
                                <div class="glyphicon glyphicon-filter d-block"></div>
                                Filtros
                            </button>
                            <button type="button" class="btn btn-link" ng-click="vm.actualizar()">
                                <div class="glyphicon glyphicon-search d-block"></div>
                                Buscar
                            </button>
                            <button type="button" class="btn btn-link" ng-click="vm.agregar()">
                                <div class="glyphicon glyphicon-plus d-block"></div>
                                Agregar
                            </button>
                            <button type="button" class="btn btn-link itemEnd" ng-click="vm.descargar()">
                                <div class="glyphicon glyphicon-download-alt d-block"></div>
                                Excel
                            </button>
                        </div>
                    </div>
                </div>

                <div class="mail-box filtros-avanzados" ng-if="vm.openFilterAdvance">
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("NombreUsuario") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NombreUsuario"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("NumUsuario") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.NumeroUsuario"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Usuario") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.Usuario"
                                        key-enter="vm.actualizar()">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Perfil") %> </label>
                                <select
                                    class="form-control form-control-select"
                                    ng-model="vm.filtro.PerfilId" ng-change="vm.actualizar()"
                                    ng-options="item.PerfilId as item.NombrePerfil for item in vm.perfiles">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                            </div>
                        </div>
                        <%--  <div class="col-sm-4">
                            <div class="form-group">
                                <label><%= this.GetMessage("Correo") %></label>
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Buscar.." ng-model="vm.filtro.Correo">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
                                </div>
                            </div>
                        </div>--%>
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.vendedores" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 800px"
                                            st-table="vm.vendedores" st-safe-src="vm.vendedores_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="30"><%= this.GetMessage("NombreUsuario") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("NumUsuario") %></th>
                                                    <th ui-field width="20"><%= this.GetMessage("Usuario") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("PerfilFuncional") %></th>
                                                    <th ui-field width="15"><%= this.GetMessage("Perfil") %></th>
                                                    <%--<th ui-field width="20"><%= this.GetMessage("Correo") %></th>--%>
                                                    <th ui-field width="5"></th>
                                                </tr>

                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.usuarios">
                                                    <td st-ratio="30" ng-bind="item.NombreUsuario"></td>
                                                    <td st-ratio="10" ng-bind="item.NumeroUsuario"></td>
                                                    <td st-ratio="20" ng-bind="item.Usuario"></td>
                                                    <td st-ratio="20" ng-bind="item.NombrePerfilFuncional"></td>
                                                    <td st-ratio="15" ng-bind="item.NombrePerfil"></td>
                                                    <%--<td st-ratio="20" ng-bind="item.Correo"></td>--%>
                                                    <td st-ratio="5">
                                                        <button type="button" class="btn btn-link" ng-click="vm.Editar(item)">
                                                            <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.usuarios.length == 0" class="nodata-row">
                                                    <td colspan="6" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                                    </td>
                                                </tr>
                                            </tbody>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="6">
                                                        <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
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

            <div ng-if="vm.viewDetail" ng-form="vm.form" ng-class="{'submitted': !vm.isValid}">
                <div class="mail-box padding-10">
                    <div class="mail-body">
                        <div class="ibox-content">
                            <div id="Filters" class="padding-form">

                                <div ba-panel ba-panel-class="profile-page">
                                    <div class="panel-content">
                                        <%--  <div class="progress-info">Tu Perfil esta  70% Completo</div>
                                        <div class="progress">
                                            <div class="progress-bar progress-bar-primary progress-bar-striped active" role="progressbar"
                                                aria-valuenow="70" aria-valuemin="0" aria-valuemax="100" style="width: 70%">
                                            </div>
                                        </div>--%>

                                        <h3 class="with-line subtitulo-color"><%= this.GetMessage("InformacionGeneral") %></h3>
                                        <div class="row">
                                            <div class="col-md-12" style="margin-bottom: 30px;">
                                                <div class="form-group clearfix divimageProfile">
                                                    <div class="label-color"><%= this.GetMessage("Imagen") %> </div>

                                                    <div style="display: inline-block">
                                                        <div class="userpic">
                                                            <div class="userpic-wrapper">
                                                                <img src="{{ vm.usuario.Blob || vm.usuario.PathImg }}">
                                                            </div>
                                                            <i class="ion-ios-close-outline" ng-click="vm.removePicture()"></i>
                                                            <%--<a href class="change-userpic" ng-click="vm.uploadPicture()"><%= this.GetMessage("CambiarImagen") %></a>--%>
                                                            <%--<input type="file" ng-show="false" id="uploadFile" >--%>
                                                            <upload-custom
                                                                url="../Handlers/MassiveConfirmation.ashx"
                                                                sesion-name="MassiveConfirmation"
                                                                add="massiveConfirmationAdd(e,data)"
                                                                done="massiveConfirmationUploaded(e,data)"
                                                                start="massiveConfirmationUploadStart()"
                                                                ng-model="vm.Imagen"
                                                                btn-name="Cambiar imagen perfil"
                                                                accept-file-types=".gif|.jpg|.jpeg|.png">
                                                            </upload-custom>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("Usuario") %></span>
                                                        <input type="text" class="form-control" ng-model="vm.usuario.Correo" ng-disabled="vm.usuario.UsuarioId && vm.usuario.UsuarioId!=0" placeholder="usuario@correo.com" required valid-email>
                                                    </div>
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("NombreUsuario") %> </span>
                                                        <input type="text" class="form-control form-control-input" ng-model="vm.usuario.NombreUsuario" required />
                                                    </div>
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <div class="label-color"><%= this.GetMessage("RecibeNotificaciones") %></div>
                                                        <switcher ng-model="vm.usuario.RecibeNotificaciones" true-label="Si" false-label="No"></switcher>
                                                    </div>
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix" ng-if="vm.usuario.UsuarioId">
                                                        <span class="label-color"><%= this.GetMessage("FechaUltimoAcceso") %></span>
                                                        <input type="text" class="form-control" ng-model="vm.usuario.FechaUltimoAcceso" ng-disabled="vm.usuario.UsuarioId && vm.usuario.UsuarioId!=0">
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <span class="label-color"><%= this.GetMessage("PerfilFuncional") %></span>
                                                    <select class="form-control form-control-select" ng-model="vm.usuario.PerfilFuncionalId"
                                                        ng-options="item.PerfilId as item.Nombre for item in vm.perfilesFuncional"
                                                        ng-change="vm.VerEsVendedor()" required>
                                                        <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                    </select>
                                                </div>

                                                <div class="col-md-3" ng-if="vm.usuario.EsVendedor">
                                                    <span class="label-color"><%= this.GetMessage("Vendedor") %> </span>
                                                    <ex-autocomplete ng-model="vm.usuario.VendedorId" options="vm.vendedorOptions"
                                                        item="vm.usuario" required />
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("Perfil") %></span>
                                                        <select
                                                            class="form-control form-control-select"
                                                            ng-model="vm.usuario.PerfilId" required
                                                            ng-options="item.PerfilId as item.NombrePerfil for item in vm.perfiles">
                                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <div class="label-color"><%= this.GetMessage("Active") %></div>
                                                        <switcher ng-model="vm.usuario.Active" true-label="Si" false-label="No"></switcher>
                                                    </div>
                                                </div>

                                                <div class="col-md-3" ng-show="vm.usuario.EsAnalista">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("IdAnalista") %> </span>
                                                        <input type="text" class="form-control form-control-input" ng-model="vm.usuario.UsuarioId"
                                                            readonly />
                                                    </div>
                                                </div>
                                            </div>

                                            <br />
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <span class="label-color"><%= this.GetMessage("Area") %></span>
                                                    <select class="form-control form-control-select" ng-model="vm.usuario.AreaId"
                                                        ng-options="item.AreaId as item.Nombre for item in vm.areas">
                                                        <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                    </select>
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <div class="label-color"><%= this.GetMessage("AutorizadorActivity") %></div>
                                                        <switcher ng-model="vm.usuario.AutorizadorActivity"
                                                            true-label="Si" false-label="No"></switcher>
                                                    </div>
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <div class="label-color"><%= this.GetMessage("AutorizadorModificacion") %></div>
                                                        <switcher ng-model="vm.usuario.AutorizadorModificacion"
                                                            true-label="Si" false-label="No"></switcher>
                                                    </div>
                                                </div>
                                            </div>

                                            <br />
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                        <div class="label-color"><%= this.GetMessage("LiderProceso") %></div>
                                                        <switcher ng-model="vm.usuario.LiderProceso" ng-change="vm.usuario.RubroId = null"
                                                            true-label="Si" false-label="No"></switcher>
                                                    </div>
                                                </div>

                                                <div class="col-md-3" ng-if="vm.usuario.LiderProceso">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("Rubro") %></span>
                                                        <select
                                                            class="form-control form-control-select"
                                                            ng-model="vm.usuario.RubroId" required
                                                            ng-options="item.RubroId as item.Nombre for item in vm.rubros">
                                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="form-group  clearfix">
                                                      <span class="label-color"><%= this.GetMessage("lblUsuarioQad") %></span>
                                                        <select class="form-control form-control-select" ng-model="vm.usuario.UsuarioQadId"
                                                            ng-options="item.UsuarioQadId as item.Usuario for item in vm.usuarioQad">
                                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-sm-3">
                                                    <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                                                    <div class="width-auto" selected-model="usuario.Marcas" options="marcas" extra-settings="marcasOptions"
                                                        translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="" events="multiselectEventos">
                                                    </div>
                                                </div>
                                               <div class="col-sm-3">
                                                    <span class="label-color"><%= this.GetMessage("lblCanal") %> </span>
                                                    <div class="width-auto" selected-model="usuario.Canales" options="canalesVisual" extra-settings="canalesOptions"
                                                        translation-texts="translateTextMultiSelect" ng-dropdown-multiselect="" events="multiselectEventosCanal">
                                                    </div>
                                                </div>
                                            </div>
                                            <br />
                                            <div class="subtitulo-color"><%= this.GetMessage("Tareas") %></div>

                                            <div class="row" style="margin: 0">
                                                <div class="col-xs-6 col-sm-4 col-md-3" ng-repeat="item in vm.usuario.TareasPendientes">
                                                    <div class="checkbox">
                                                        <label>
                                                            <input type="checkbox" ng-model="item.Seleccionado">
                                                            {{item.Nombre}}
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>

                                            <br />
                                            <h3 class="with-line subtitulo-color"><%= this.GetMessage("CambiarContrasena") %></h3>

                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("NuevoPassword") %></span>
                                                        <input type="password" class="form-control" ng-model="vm.usuario.NuevoPassword" ng-required="!vm.usuario.UsuarioId">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group  clearfix">
                                                        <span class="label-color"><%= this.GetMessage("ConfirmarNuevoPassword") %></span>
                                                        <input type="password" class="form-control" ng-model="vm.usuario.NuevoPasswordValidacion" ng-required="!vm.usuario.UsuarioId">
                                                    </div>
                                                </div>
                                            </div>
                                            <button type="button" class="btn btn-primary btn-with-icon save-profile" ng-click="vm.guardar()">
                                                <i class="ion-android-checkmark-circle"></i>{{vm.usuario.UsuarioId!=0?'<%= this.GetMessage("Actualizar") %>':'<%= this.GetMessage("Agregar") %>'}}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="../scripts/pages/usuarioController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>

