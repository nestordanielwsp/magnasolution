<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="Sincronizador.aspx.cs" Inherits="CYP.Pages.Sincronizador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="sincronizador">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-8">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="label-filter"><%= this.GetMessage("lblFiltrarPor") %></label>
                            </div>

                            <div class="clearfix visible-sm visible-xs pt-5"></div>

                            <div class="col-md-10">
                                <input type="text" class="form-control" ng-model="filtro.Descripcion" key-enter="getSincronizadores()"
                                    placeholder="Búsqueda rápida por (<%= this.GetMessage("lblDato") %>)">
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="sincronizadores" st-fixed style="width: 100%">
                    <table class="jsgrid-table" style="min-width: 800px">
                        <thead>
                            <tr>
                                <th ui-field width="15">
                                    <%= this.GetMessage("lblDato") %>
                                </th>
                                <th ui-field width="15">
                                    <%= this.GetMessage("lblMenuQad") %>
                                </th>
                                <th class="text-center" ui-field width="10">
                                    <%= this.GetMessage("lblFrecuencia") %>
                                </th>
                                <th ui-field width="15" class="text-center">
                                    <%= this.GetMessage("lblUltimaEjecucion") %>
                                </th>
                                <th ui-field width="30">
                                    <%= this.GetMessage("lblResultado") %>
                                </th>
                                <th ui-field width="20"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr ng-repeat="item in sincronizadores">
                                <td st-ratio="15">{{item.Descripcion}}</td>
                                <td st-ratio="15">{{item.NombreArchivo}}</td>
                                <td st-ratio="10" class="text-right">{{item.FrecuenciaHoras}}</td>
                                <td st-ratio="15" class="text-center">{{item.UltimaEjecucion}}</td>
                                <td st-ratio="30">{{item.Resultado}}</td>
                                <td st-ratio="20">
                                    <button type="button" class="btn btn-link" ng-click="ejecutar(item)">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnEjecutar") %>
                                    </button>
                                    <button type="button" class="btn btn-link" ng-click="abrirLog(item)">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnDetalle") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="sincronizadores.length == 0" class="nodata-row">
                                <td colspan="6" class="text-center">
                                    <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                </td>
                            </tr>
                        </tbody>

                        <tfoot>
                            <tr>
                                <td colspan="6">
                                    <div st-pagination="5" st-items-by-page="50" st-template="../templates/pagination.html"></div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <ui-modal modal="modal" data-backdrop="static">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">
                            <%= this.GetMessage("lblDetalle")  %>
                        </h4>
                    </div>
                    <div class="modal-body" ng-form="editForm">
                        <div ng-show="logErrores.length === 0">
                            <label><%= this.GetMessage("msgSinIncidencias")  %></label>
                        </div>
                        
                        <table class="table table-condensed table-striped table-hover table-fixed" ng-show="logErrores.length > 0">
                           <thead>
                               <tr>
                                   <th style="width: 80%">
                                       <%= this.GetMessage("lblDescripcion") %>
                                   </th>  
                                   <th class="text-center" style="width: 20%">
                                       <%= this.GetMessage("lblFecha") %>
                                   </th>                                                     
                               </tr>
                           </thead>
                           <tbody style="max-height: 350px">
                               <tr ng-repeat="item in logErrores">                                      
                                   <td style="width: 80%">
                                       {{item.Descripcion}}                                                             
                                   </td>
                                   <td class="text-center" style="width: 20%">
                                       {{item.Fecha}}                                                             
                                   </td>
                               </tr>
                           </tbody>
                        </table>                                                                                                            
                    </div>

                    <div class="modal-footer text-right blue-button">                       
                        <button type="button" class="btn btn-default" data-dismiss="modal">
                            <%= this.GetMessage("btnCerrar")  %>
                        </button>                                     
                    </div>
                </div>
            </div>
        </ui-modal>

        <ui-modal modal="modaltipocambio" data-backdrop="static">
            <div class="modal-dialog modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">
                           
                        </h4>
                    </div>
                    <div class="modal-body" ng-form="form" ng-class="{'submitted': !isValid}">
                        <div class="row">
                              <div class="col-sm-12">
                                <span class="label-color"><%= this.GetMessage("lblTipoCambio") %> </span>
                                <input type="text" class="form-control-input" required money ng-model="itemsincronizar.TipoCambio"  />
                              </div>
                        </div>                                                                                                                               
                    </div>
                    <div class="modal-footer text-right blue-button">  
                         <button type="button" class="btn btn-primary" ng-click="ejecutarmodal()" >
                            <%= this.GetMessage("btnEjecutar")  %>
                        </button>  
                        <button type="button" class="btn btn-default" data-dismiss="modal">
                            <%= this.GetMessage("btnCerrar")  %>
                        </button>                                     
                    </div>
                </div>
            </div>
        </ui-modal>
    </div>

    <script type="text/javascript" src="../scripts/pages/sincronizador.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>
