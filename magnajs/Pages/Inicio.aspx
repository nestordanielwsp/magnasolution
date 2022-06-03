<%@ Page Title="" Language="C#" MasterPageFile="~/includes/magnajs.Master" AutoEventWireup="true" CodeBehind="Inicio.aspx.cs" Inherits="magnajs.Pages.Inicio" %>


<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div class="view dashboard" ng-controller="inicioController as vm">
        <h1>{{vm.titulo}}</h1>

        <!-- 
      <div class="summary-boxes" layout="row" layout-align="space-between center">
        <div class="summary-box summary-total">
          <div class="summary-box-main">
            <div class="summary-value">134</div>
            <div class="summary-desc">Total orders</div>
          </div>
          <div class="summary-box-footer">
            View all <i class="fa fa-arrow-circle-right"></i>
          </div>
        </div>

        <div class="summary-box summary-pending">
          <div class="summary-box-main">
            <div class="summary-value">7</div>
            <div class="summary-desc">Pending orders</div>
          </div>
          <div class="summary-box-footer">
            View all <i class="fa fa-arrow-circle-right"></i>
          </div>
        </div>

        <div class="summary-box summary-amount">
          <div class="summary-box-main">
            <div class="summary-value">23 570,00 €</div>
            <div class="summary-desc">Total sold</div>
          </div>
          <div class="summary-box-footer">
            View all <i class="fa fa-arrow-circle-right"></i>
          </div>
        </div>
      </div>
       -->
        <div id="Home" class="mail-box padding-10 wrapper border-bottom">
            <br />
            <div class="md-whiteframe-1dp">
                <h2><%= this.GetMessage("TituloGrid") %></h2>
            </div>
            <div class="content-top clearfix">
                <div class="row">
                    <div class="col-sm-6">                       
                    </div>
                    <div class="btn-tpm col-sm-6">
                        <div class="padding-7">
                            <div class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>" tooltip-placement="bottom" ng-click="vm.guardar()">
                                <i class="fa fa-save"></i>
                            </div>
                        </div>                        
                    </div>
                </div>
            </div>
            <div ui-table="vm.principal" st-fixed style="width: 100%">
                <table class="jsgrid-table" style="width: 3200px; min-width: 3200px"
                    st-table="vm.principal" st-safe-src="vm.principal_">
                    <thead>                        
                        <tr>
                            <th colspan="9"></th>
                            <th colspan="10" class="text-center" style="background-color:gainsboro;font-weight:bold;"><%= this.GetMessage("gvGeneral-TiempoObjetivo") %></th>
                            <th></th>
                            <th style="background-color:forestgreen;font-weight:bold;" class="text-center">G</th>
                            <th colspan="2" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-Completo") %></th>
                            <th></th>
                        </tr>
                        <tr>
                            <th colspan="9"></th>
                            <th class="text-center" style="background-color:gainsboro;font-weight:bold;">24H</th>
                            <th class="text-center" style="background-color:gainsboro;font-weight:bold;">7D</th>
                            <th class="text-center" style="background-color:gainsboro;font-weight:bold;" colspan="4">14D</th>
                            <th class="text-center" style="background-color:gainsboro;font-weight:bold;">34D</th>
                            <th class="text-center" style="background-color:gainsboro;font-weight:bold;" colspan="2">35D</th>
                            <th class="text-center" style="background-color:gainsboro;font-weight:bold;">40D</th>
                            <th></th>
                            <th class="text-center" style="font-weight:bold;">N/A</th>
                            <th colspan="2" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-NoAplica") %></th>
                            <th></th>
                        </tr>
                        <tr style="background-color:gainsboro;">                            
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-Item") %></th>
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-FechaInicio") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-ReportadoPor") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-QuienRespondio") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-TipoReclamo") %></th>
                            <th ui-field width="130" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-Modelo") %></th>
                            <th ui-field width="300" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-DescripcionProblema") %></th>
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral->ResponsableRespuesta") %></th>
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-ProximaFecha") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-PuntoQuiebre") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-CausaRaiz") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-AccionesCorrectivas") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-QualityFocus") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-Deteccion") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-AuditoriaCapas") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-ValidacionAcciones") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-PlanControl") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-ActualizacionHIOE") %></th>
                            <th ui-field width="70" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-LeccionesAprendidas") %></th>
                            <th ui-field width="100" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-PlanAccion") %></th>
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-FechaPropuestaCierre") %></th>
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-FechaRealCierre") %></th>
                            <th ui-field width="50" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-EstatusGlobal") %></th>
                            <th ui-field width="100" class="text-center" style="font-weight:bold;"><%= this.GetMessage("gvGeneral-Departamento") %></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="item in vm.principal">                            
                            <td st-ratio="50" class="text-center">{{item.cve}}</td>
                            <td st-ratio="50" class="text-center">{{item.fecha_creacion}}</td>
                            <td st-ratio="70" class="text-center">{{item.identifica_falla}}</td>
                            <td st-ratio="70" class="text-center">{{item.usuario_creacion}}</td>
                            <td st-ratio="70" class="text-center">{{item.nombre_alerta}}</td>
                            <td st-ratio="130" class="text-center">{{item.nombre_numero_parte}}</td>
                            <td st-ratio="300">{{item.descripcion_falla}}</td>
                            <td st-ratio="50" class="text-center">{{item.supervisor_verifico}}</td>
                            <td st-ratio="50" class="text-center">{{item.inicio_campana}}</td>
                            <td st-ratio="70" class="text-center">
                                {{item.punto_quiebre}}&nbsp;
                                        <ex-fileupload ng-model="item.punto_quiebreNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload>
                            </td>
                            <td st-ratio="70" class="text-center">{{item.causa_raiz}}&nbsp;
                                        <ex-fileupload ng-model="item.causa_raizNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload>
                            </td>
                            <td st-ratio="70" class="text-center">{{item.acciones_correctivas}}&nbsp;
                                        <ex-fileupload ng-model="item.acciones_correctivasNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload>
                            </td>
                            <td st-ratio="70" class="text-center">{{item.quality_focus}}&nbsp;
                                        <ex-fileupload ng-model="item.quality_focusNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="70" class="text-center">{{item.deteccion}}&nbsp;
                                        <ex-fileupload ng-model="item.deteccionNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="70" class="text-center">{{item.auditoria_capas}}&nbsp;
                                        <ex-fileupload ng-model="item.auditoria_capasNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="70" class="text-center">{{item.validacion_acciones}}&nbsp;
                                        <ex-fileupload ng-model="item.validacion_accionesNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="70" class="text-center">{{item.plan_control}}&nbsp;
                                        <ex-fileupload ng-model="item.plan_controlNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="70" class="text-center">{{item.actualizacion_hioe}}&nbsp;
                                        <ex-fileupload ng-model="item.actualizacion_hioeNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="70" class="text-center">{{item.lecciones_aprendidas}}&nbsp;
                                        <ex-fileupload ng-model="item.lecciones_aprendidasNuevo" image-button="fa-upload"
                                         download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                         options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                        </ex-fileupload></td>
                            <td st-ratio="100">{{item.plan_accion}}</td>
                            <td st-ratio="50" class="text-center">{{item.fecha_propuesta_cierre}}</td>
                            <td st-ratio="50" class="text-center">{{item.fecha_real_cierre}}</td>
                            <td st-ratio="50" class="text-center">{{item.estatus_global}}</td>
                            <td st-ratio="100" class="text-center">{{item.nombre_lugar_falla}}</td>                            
                        </tr>
                        <tr ng-if="informaciongral.length == 0" class="nodata-row">
                            <td colspan="24" class="text-center">
                                <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="18">
                                <div st-pagination="10" st-items-by-page="100" st-template="../templates/pagination.html"></div>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    <script type="text/javascript" src="../Scripts/pages/inicioController.js?v=1.1<%=DateTime.Now.Millisecond %>"></script>
</asp:Content>

