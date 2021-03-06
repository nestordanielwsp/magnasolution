<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Evidencias.aspx.cs" Inherits="CYP.Pages.Evidencias" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="evidenciasController as vm">
        <div class="content-top clearfix">
            <div class="row">
                <div class="col-sm-6">
                    <h1 class="al-title" ng-bind="vm.titulo"></h1>
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
                                    <label class="label-filter"><%= this.GetCommonMessage("lblFiltrarPor") %></label>
                                </div>

                                <div class="clearfix visible-sm visible-xs pt-5"></div>

                                <div class="col-md-4 col-lg-5">
                                   <div class="form-group">   
                                        <select
                                            class="form-control form-control-select" ng-change="vm.consultar()"
                                            ng-model="vm.filtro.TipoEvidenciaId" required
                                            ng-options="item.TipoEvidenciaId as item.NombreTipoEvidencia for item in vm.tipoEvidencias">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-4 col-lg-5">
                                    <input type="text" class="form-control" ng-model="filtro.NombreCausal" key-enter=" vm.consultar()"
                                        placeholder="<%= this.GetMessage("NombreEvidencia") %>">
                                </div>
                            </div>
                        </div>
                        <div class="clearfix visible-xs">
                            <br />
                        </div>
                        <div class="col-md-4 text-right">
                            <button type="button" class="btn btn-link" ng-click=" vm.consultar()">
                                <div class="glyphicon glyphicon-search d-block"></div>
                                <%= this.GetCommonMessage("btnBuscar") %>
                            </button>
                            <button type="button" class="btn btn-link" ng-click="agregar()" ng-if="esCrearModificarActivity">
                                <div class="glyphicon glyphicon-plus d-block"></div>
                                <%= this.GetCommonMessage("btnNuevo") %>
                            </button>
                        </div>
                    </div>
                </div>

                <div id="Home">
                    <div class="wrapper border-bottom">
                        <div class="mail-box padding-10">
                            <div class="mail-body">
                                <div class="ibox-content">
                                    <div ui-table="vm.tipoApoyo" st-fixed style="width: 100%">
                                        <table class="jsgrid-table" style="min-width: 1000px"
                                            st-table="vm.tipoApoyo" st-safe-src="vm.tipoApoyo_">
                                            <thead>
                                                <tr>
                                                    <th ui-field width="30"><%= this.GetMessage("TipoApoyo") %></th>
                                                    <th ui-field width="60"><%= this.GetMessage("NombreEvidencia") %></th>
                                                    <th ui-field width="10"><%= this.GetMessage("Ver") %></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr ng-repeat="item in vm.tipoApoyo">
                                                    <td st-ratio="30" ng-bind="item.NombreTipoEvidencia"></td>
                                                    <td st-ratio="60" ng-bind="item.NombreTipoApoyo"></td>
                                                    <td st-ratio="10">
                                                        <button type="button" class="btn btn-link" ng-click="openModalNotas(item)">
                                                            <%= this.GetCommonMessage("btnVer") %>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr ng-if="vm.tipoApoyo.length == 0" class="nodata-row">
                                                    <td colspan="3" class="text-center">
                                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
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
        </div>
        <ui-modal modal="modalNotas">
            <div class="modal-dialog modal-lg" form="modalForm" style="width:1200px;">
              <div class="modal-content" ng-form="CausalDevolucionForma">
                <div class="modal-header">
                    <h4 style="color:#0069af;font-weight:600;opacity:.9;" class="al-title">{{tituloModal}}</h4>
                </div>

                <div class="modal-body" ng-class="{'submitted': submitted}" style="overflow:hidden">
                    <div class="row mb">
                        <div class="col-sm-3">                            
                            <h5 style="color:#0069af;font-weight:600;opacity:.9;" class="al-title">{{tituloDetalle}}</h5>
                        </div>
                    </div>
                    <div class="row mb">
                        <div class="col-sm-3">
                            <span style="color:#0069af"><%= this.GetMessage("TipoApoyo") %></span>
                        </div>
                    </div>
                    <div class="row mb">
                        <div class="col-sm-8">
                            <input type="text" ng-model="evidencia.NombreTipoEvidencia" class="control-label" style="width:500px" disabled />
                        </div>
                    </div>
                    <div class="row mb">
                        <div class="col-sm-3">
                            <span style="color:#0069af"><%= this.GetMessage("NombreEvidencia") %></span>
                        </div>
                    </div>
                    <div class="row mb">
                        <div class="col-sm-8">
                            <input type="text" ng-model="evidencia.NombreTipoApoyo" class="control-label" style="width:300px" disabled />
                        </div>
                    </div>                                   
                    <div class="row mb">
                        <div class="col-sm-3">
                            <h5 style="color:#0069af;font-weight:600;opacity:.9;" class="al-title">{{tituloEvidencias}}</h5>
                        </div>
                    </div>   
                    <div class="row mb">
                        <div class="col-sm-1"></div>
                        <div class="col-sm-10">
                            <div ui-table="vm.tipoApoyoEvidencia" st-fixed style="width: 100%;background-color:white;">
                                <table class="jsgrid-table"
                                    st-table="vm.tipoApoyoEvidencia" st-safe-src="vm.tipoApoyoEvidencia_">
                                    <thead>
                                        <tr style="background-color:white;">
                                            <th  style="background-color:white;"></th>
                                            <th ng-repeat="item in vm.tipoApoyoEvidencia"  style="background-color:white;"  ui-field width="30" ng-bind="item.NombreEvidencia"></th>                                          
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td width="30">Requerido:</td>
                                            <td ng-repeat="item in vm.tipoApoyoEvidencia" width="30" align="center">
                                                <input type="checkbox" ng-model="item.Requerido" ng-disabled ="item.Requerido" />
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td width="30">Plantilla:</td>
                                            <td ng-repeat="item in vm.tipoApoyoEvidencia" width="30"  align="center">
                                                  <ex-fileupload ng-model="item.NombreArchivo" image-button="fa-upload"
                                                     download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                                     options="fileOptionsDetalle" parameters="fileParameters" open-file="abrirDocumento(item)">
                                                  </ex-fileupload>                           
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td width="30">Archivo:</td>
                                            <td ng-repeat="item in vm.tipoApoyoEvidencia" width="30" align="center">
                                                 {{item.NombreArchivo}}
                                            </td>                                      
                                        </tr>
                                        <tr ng-if="vm.tipoApoyoEvidencia.length == 0" class="nodata-row">
                                            <td colspan="3" class="text-center">
                                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>     
                    </div>
                </div>

                <div class="modal-footer">                
                  <button type="button" class="btn btn-success" ng-click="guardar(CausalDevolucionForma)">
                      <%= this.GetCommonMessage("lblTooltipGuardar") %>
                  </button>
                  <button type="button" class="btn btn-default no-disabled" data-dismiss="modal">
                       <%= this.GetMessage("lblCerrar") %>
                  </button>
                </div>
              </div>
            </div>
        </ui-modal>


    </div>
    <script type="text/javascript" src="../scripts/pages/evidenciasController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>


