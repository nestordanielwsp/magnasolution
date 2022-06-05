<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FastResponse.aspx.cs" Inherits="magnajs.Pages.FastResponse" %>

<!DOCTYPE html>

<html lang="en" ng-app="app">
<head id="Head1" runat="server">
    <link href="../css/PanelCustom.css?v=1.1" rel="stylesheet" /> 
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Fast Response - Estampados Magna</title>
    <%--Librerias--%>
    <link rel="stylesheet" href="../scripts/librerias/admin/Ionicons/css/ionicons.min.css" />
    <link rel="stylesheet" href="../scripts/librerias/admin/animate.css/animate.min.css" />
    <%--<link rel="stylesheet" href="../scripts/librerias/admin/bootstrap/dist/css/bootstrap.min.css" />--%>
    <link href="../css/angular-material.min.css" rel="stylesheet" />
    <link href="../css/font-awesome.min.css" rel="stylesheet" />

    <%-- Estilos personalizados --%>

    <link rel="stylesheet" href="../css/main.css">
    <%--Librerias--%>
    <script type="text/javascript" src="../scripts/librerias/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../scripts/librerias/jquery-migrate-1.2.1.min.js"></script>
    <script type="text/javascript" src="../scripts/librerias/jquery/jquery-ui-1.9.2.custom.min.js"></script>
    <script src="../scripts/librerias/admin/jquery/dist/jquery.min.js"></script>
    <script src="../scripts/librerias/admin/jquery-ui/jquery-ui.min.js"></script>
    <script src="../scripts/librerias/admin/jquery.easing/js/jquery.easing.min.js"></script>
    <script src="../scripts/librerias/admin/jquery.easy-pie-chart/dist/jquery.easypiechart.min.js"></script>
    <script src="../scripts/librerias/jquery/jquery.widgets.js" type="text/javascript"></script>
    <script src="../scripts/librerias/jquery/jquery.alerts.js" type="text/javascript"></script>
    <script src="../scripts/utilerias/jBox.js" type="text/javascript"></script>
    <script src="../scripts/librerias/jqte/jquery-te-1.4.0.js" type="text/javascript"></script>
    <script src="../Scripts/librerias/jquery/jquery.fileupload.js"></script>
    <script src="../Scripts/librerias/jquery/jquery.iframe-transport.js"></script>
    <script src="../scripts/librerias/admin/moment/moment.min.js"></script>

    <script src="../Scripts/librerias/jquery/bootstrap.min.js"></script>
    <script src="../Scripts/librerias/jquery/bootstrap-datetimepicker.js"></script>
    <script src="../Scripts/librerias/jquery/bootstrap-datepicker.min.js"></script>
    <script src="../Scripts/librerias/jquery/bootstrap-select.min.js"></script>
    <script src="../Scripts/librerias/jquery/highcharts.js"></script>
    <script src="../Scripts/librerias/jquery/highcharts-3d.js"></script>
    <%--<script src="../Scripts/librerias/jquery/highcharts-more.js"></script>--%>
    <script src="../Scripts/librerias/jquery/locales.js"></script>

    <script src="../scripts/librerias/admin/chart.js/dist/Chart.min.js"></script>


    <script src="../Scripts/librerias/angular/angular.min.js"></script>
    <script src="../Scripts/librerias/angular/angular-material.min.js"></script>
    <script src="../Scripts/librerias/angular/angular-animate.min.js"></script>
    <script src="../Scripts/librerias/angular/angular-aria.min.js"></script>
    <script src="../Scripts/pages/appController.js"></script>
    <script src="../Scripts/pages/masterPageController.js"></script>
    <script src="../scripts/librerias/admin/angular-route/angular-route.min.js"></script>
    <script src="../scripts/librerias/admin/slimScroll/jquery.slimscroll.min.js"></script>
    <script src="../scripts/librerias/admin/angular-slimscroll/angular-slimscroll.js"></script>
    <script src="../scripts/librerias/admin/angular-smart-table/dist/smart-table.min.js"></script>
    <script src="../scripts/librerias/admin/angular-toastr/dist/angular-toastr.tpls.min.js"></script>
    <script src="../scripts/librerias/admin/angular-touch/angular-touch.min.js"></script>
    <script src="../scripts/librerias/admin/angular-ui-sortable/sortable.min.js"></script>
    <script src="../scripts/librerias/angular/angular-ui-tree.js"></script>
    <script src="../scripts/librerias/admin/leaflet/dist/leaflet-src.js"></script>
    <script src="../scripts/librerias/admin/angular-progress-button-styles/dist/angular-progress-button-styles.min.js"></script>
    <script src="../scripts/librerias/admin/angular-ui-router/release/angular-ui-router.min.js"></script>
    <script src="../scripts/librerias/admin/angular-chart.js/dist/angular-chart.min.js"></script>
    <script src="../scripts/librerias/admin/chartist/dist/chartist.min.js"></script>
    <script data-require="ui-bootstrap" src="../scripts/librerias/admin/angular-bootstrap/ui-bootstrap-tpls.min.js"></script>
    <script src="../scripts/librerias/admin/angular-animate/angular-animate.min.js"></script>
    <script src="../scripts/librerias/admin/angular-ui-select/dist/select.min.js"></script>


    <%-- Configuracion --%>
    <script src="../Scripts/configuracion/theme/theme.module.js"></script>
    <script src="../Scripts/configuracion/theme/components/components.module.js"></script>
    <script src="../Scripts/configuracion/theme/inputs/inputs.module.js"></script>
    <script src="../scripts/librerias/angular/smart-table.min.js" type="text/javascript"></script>
    <script src="../scripts/librerias/angular/underscore.js" type="text/javascript"></script>
    <script src="../scripts/librerias/angular/select.min.js" type="text/javascript"></script>
    <script src="../scripts/librerias/angular/angular-money-directive.js" type="text/javascript"></script>
    <script src="../Scripts/configuracion/customDirectives.js?v=1.1"></script>
    <script src="../Scripts/configuracion/enums.js"></script>
    <%--     <script src="../Scripts/configuracion/checkBoxTree.js"></script>--%>
    <script src="../scripts/librerias/angular/angularjs-dropdown-multiselect.js" type="text/javascript"></script>
    <script src="../scripts/librerias/angular/ng-jsgrid.js" type="text/javascript"></script>
    <script src="../Scripts/utilerias/util.js"></script>
    <script src="../scripts/librerias/angular/angular-file-upload.min.js" type="text/javascript"></script>

    <script src="../Scripts/utilerias/bind.js"></script>
    <script src="../Scripts/configuracion/utilities.js"></script>
    <script src="../Scripts/configuracion/appUtils.js"></script>
    <script src="../Scripts/utilerias/Magna.Common.js"></script>
    <script src="../Scripts/utilerias/constraints.js"></script>

    <!--<script src="../Scripts/configuracion/app.js"></script>-->

    <%-- Librerias   --%>

    <%-- Smart table --%>
    <%--<script src="../Scripts/librerias/smart-table-fixed.js"></script>--%>
    <%--<script src="../Scripts/librerias/smart-table.add.ons.js"></script>--%>

    <script src="../Scripts/configuracion/theme/theme.config.js"></script>
    <script src="../Scripts/configuracion/theme/theme.configProvider.js"></script>
    <script src="../Scripts/configuracion/theme/theme.constants.js"></script>
    <script src="../Scripts/configuracion/theme/theme.run.js"></script>
    <script src="../Scripts/configuracion/theme/theme.service.js"></script>


    <%-- Configuracion de directivas y componentes --%>
    <script src="../Scripts/configuracion/theme/directives/scrollPosition.js"></script>
    <script src="../Scripts/configuracion/theme/services/baUtil.js"></script>
    <script src="../Scripts/configuracion/theme/services/preloader.js"></script>
    <script src="../Scripts/configuracion/theme/services/fileReader.js"></script>

    <%-- Panel Lateral Y encabezado --%>
    <script src="../Scripts/configuracion/theme/components/backTop/backTop.directive.js"></script>
    <script src="../Scripts/configuracion/theme/components/baSidebar/baSidebar.directive.js"></script>
    <script src="../Scripts/configuracion/theme/components/baSidebar/baSidebar.service.js"></script>
    <script src="../Scripts/configuracion/theme/components/baSidebar/BaSidebarCtrl.js"></script>
    <script src="../Scripts/configuracion/theme/components/baSidebar/baSidebarHelpers.directive.js"></script>
    <script src="../Scripts/configuracion/theme/components/contentTop/contentTop.directive.js"></script>
    <script src="../Scripts/configuracion/theme/components/msgCenter/msgCenter.directive.js"></script>
    <script src="../Scripts/configuracion/theme/components/msgCenter/MsgCenterCtrl.js"></script>
    <script src="../Scripts/configuracion/theme/components/pageTop/pageTop.directive.js"></script>
    <script src="../Scripts/configuracion/theme/filters/image/profilePicture.js"></script>
    <script src="../Scripts/configuracion/theme/components/backTop/lib/jquery.backTop.min.js"></script>

    <script src="../Scripts/librerias/angular-switcher.min.js"></script>
    <%--<script src="../Scripts/librerias/jquery/gijgo.min.js"></script>--%>

    <link href="../Scripts/librerias/angular-multi-select/isteven-multi-select.css" rel="stylesheet" />
    <script src="../Scripts/librerias/angular-multi-select/isteven-multi-select.js"></script>

    <%-- Page Profile --%>
    <script src="../Scripts/pages/profileController.js"></script>
</head>
<body>
    <div ng-app="app">
        <div ng-controller="appController as ctrl">
            <div class="toolbar">
                <!-- TOOLBAR -->
                <md-toolbar>
                    <div class="md-toolbar-tools" style="background-color: #D9230F;">
                         <md-button class="md-icon-button" aria-label="Menu" ng-show="true" ng-click="ctrl.toggleMainMenu()">
                            <i class="fa fa-bars"></i>
                          </md-button> 

                        <h2>
                            <span class="app-name">
                                <img style="border-radius: 1.5rem;" src="../assets/pictures/avatar-s-11.jpg" alt="avatar" height="40" width="40">&nbsp;Estampados Magna
            </span>
                        </h2>

                        <span flex></span>

                        <div class="identification" layout="column">
                            <div class="name">Usuario</div> 
                        </div>

                        <md-button class="md-icon-button toolbar-icon" aria-label="Log out menu" ng-click="ctrl.toggleLogOutMenu($event)">
                            <i class="fa fa-ellipsis-v"></i>
                        </md-button>
                    </div>
                </md-toolbar>

                <!-- LOG OFF MENU -->
                <div class="log-out-menu md-whiteframe-z1" ng-class="{'visible': ctrl.logOutMenuVisible}">
                    <md-button class="md-list-item-content" aria-label="Log In"  ng-click="$scope.logIn()" ng-if="!usuarioLogeado">
                        <i class="fa fa-sign-in"></i>
                        <span class="md-inline-list-icon-label">Log In</span>
                    </md-button>
                    <md-button class="md-list-item-content" aria-label="Log Out" ng-click="ctrl.logOut()"  ng-if="usuarioLogeado">
                        <i class="fa fa-sign-out"></i>
                        <span class="md-inline-list-icon-label">Log out</span>
                    </md-button>
                </div>

                <!-- LEFT SIDE MENU -->
                <section layout="row" flex>
                    <md-sidenav class="md-sidenav-left md-whiteframe-z2" md-component-id="menu-left">
                        <md-toolbar></md-toolbar>

                        <md-content class="md-padding side-menu">
                            <div class="menu-item" layout="row" layout-align="start center" ng-repeat="view in ctrl.views" ng-class="{'separator': view.separator, 'selected': ctrl.currentView === view.label}" ng-click="ctrl.changeView(view.label)">
                                <i class="fa {{view.icon}} icon-all-requests"></i>
                                <span>{{view.label}}</span>
                            </div>
                        </md-content>
                    </md-sidenav>
                </section>
            </div>
            <form id="form1" runat="server" ng-controller="appController as root">
                <asp:ScriptManager ID="smm" runat="server" EnablePartialRendering="true">
                </asp:ScriptManager>
                <div ui-view autoscroll="true" autoscroll-body-top>
                    
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

                </div>
            </form> 
        </div>
          
    </div>
</body>
</html>
