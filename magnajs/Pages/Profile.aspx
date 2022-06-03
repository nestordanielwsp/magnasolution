<%@ Page Title="" Language="C#" MasterPageFile="~/includes/magnajs.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="magnajs.Pages.Profile" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="profileController as vm" ng-form="vm.form" ng-class="{'submitted': !vm.isValid}">
        <div class="mail-box padding-10">
            <div class="mail-body">
                <div class="ibox-content">
                    <div id="Filters" class="padding-form">

                        <div ba-panel ba-panel-class="profile-page">
                            <div class="panel-content">
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
                                        <div class="col-md-4">
                                            <div class="form-group  clearfix">
                                                <span class="label-color"><%= this.GetMessage("Usuario") %></span>
                                                <input type="text" class="form-control" ng-model="vm.usuario.Usuario" ng-disabled="vm.usuario.UsuarioId && vm.usuario.UsuarioId!=0" required>
                                            </div>
                                            <div class="form-group  clearfix">
                                                <div class="label-color"><%= this.GetMessage("RecibeNotificaciones") %></div>
                                                <switcher ng-model="vm.usuario.RecibeNotificaciones" true-label="Si" false-label="No"></switcher>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group  clearfix">
                                                <span class="label-color"><%= this.GetMessage("NombreUsuario") %> </span>
                                                <input type="text" class="form-control form-control-input" ng-model="vm.usuario.NombreUsuario" required />
                                            </div>

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

                                        <div class="col-md-4">
                                            <%--   <div class="form-group  clearfix">
                                                 <span class="label-color"><%= this.GetMessage("Correo") %></span>
                                                    <input type="text" class="form-control form-control-input" ng-model="vm.usuario.Correo" required valid-email>
                                                </div>--%>
                                            <div class="form-group  clearfix" ng-if="vm.usuario.FechaUltimoAcceso">
                                                <span class="label-color"><%= this.GetMessage("FechaUltimoAcceso") %></span>
                                                <input type="text" class="form-control" ng-model="vm.usuario.FechaUltimoAcceso" ng-disabled="vm.usuario.UsuarioId && vm.usuario.UsuarioId!=0 && " required>
                                            </div>

                                        </div>
                                    </div>

                                    <h3 class="with-line subtitulo-color"><%= this.GetMessage("CambiarContrasena") %></h3>

                                    <div class="row">
                                        <%--   <div class="col-md-4">
                                                <div class="form-group  clearfix">
                                                    <span class="label-color"><%= this.GetMessage("Password") %></span>
                                                    <input type="password" class="form-control">
                                                </div>
                                            </div>--%>
                                        <div class="col-md-4">
                                            <div class="form-group  clearfix">
                                                <span class="label-color"><%= this.GetMessage("NuevoPassword") %></span>
                                                <input type="password" class="form-control" ng-model="vm.usuario.NuevoPassword">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group  clearfix">
                                                <span class="label-color"><%= this.GetMessage("ConfirmarNuevoPassword") %></span>
                                                <input type="password" class="form-control" ng-model="vm.usuario.NuevoPasswordValidacion">
                                            </div>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-primary btn-with-icon save-profile" ng-click="vm.guardar()">
                                        <i class="ion-android-checkmark-circle"></i><%= this.GetMessage("Actualizar") %>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="../scripts/pages/profileController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>

