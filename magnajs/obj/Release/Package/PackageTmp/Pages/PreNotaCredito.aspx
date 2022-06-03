<%@ Page Title="" Language="C#" MasterPageFile="~/includes/CYP.Master" AutoEventWireup="true" CodeBehind="PreNotaCredito.aspx.cs" Inherits="CYP.Pages.PreNotaCredito" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="preNotaCreditoController">
        <div class="content-top">
            <h1 class="al-title"><%= this.GetMessage("Titulo") %></h1>
        </div>

        <div class="page-content" ng-hide="esDetalle">
            <div class="filter mail-box filtros">
                <div class="row p-5">
                    <div class="col-md-7">
                        <div class="row">
                            <div class="col-sm-6 col-md-4">
                                <label style="margin-bottom: 0"><%= this.GetMessage("lblFolio") %></label>
                                <input type="text" class="custom-input" ng-model="filtro.Folio" key-enter="getNotasCredito()"
                                    style="margin-right: 12px">
                            </div>

                            <div class="col-sm-6 col-md-5">
                                <label style="margin-bottom: 0"><%= this.GetMessage("lblFecha") %></label>
                                <datepicker-range ng-model="filtro.Fecha" required="required" input-class="custom-input" />
                            </div>                            
                        </div>
                    </div>

                    <div class="clearfix visible-xs">
                        <br />
                    </div>

                    <div class="col-md-5 text-right">
                        
                        <button type="button" class="btn btn-link" ng-click="getNotasCredito()">
                            <div class="glyphicon glyphicon-search d-block"></div>
                            <%= this.GetMessage("btnBuscar") %>
                        </button>
                        <button type="button" class="btn btn-link" ng-click="agregar()" ng-if="!agregarOculto">
                            <i class="glyphicon glyphicon-plus d-block"></i>
                            <%= this.GetMessage("btnAgregar") %>
                        </button>
                        
                    </div>
                </div>
            </div>
            <div id="Home" class="mail-box padding-10 wrapper border-bottom">
                <div ui-table="notasdeCredito" st-fixed style="width: 100%" ng-show="esAprobadorMasivo">
                    <table class="jsgrid-table" style="width: 2600px; min-width: 2600px"
                        st-table="notasdeCredito" st-safe-src="notasdeCredito_">
                        <thead>
                            <tr>
                                <th ui-field width="8" class="text-center">
                                    <input id="aprobar" type="checkbox" ng-model="esAprobarTodos" ng-change="aprobarTodos()" />
                                    <label for="aprobar"><%= this.GetMessage("lblAprobar") %></label>
                                </th>
                                <th ui-field width="8"><%= this.GetMessage("gvNotaCredito-Folio") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-QAD") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-CodigoCliente") %></th>
                                <th ui-field width="20"><%= this.GetMessage("gvNotaCredito-NombreCliente") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreTipoNotaCredito") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-Marcas") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreCanal") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-TipoActivity") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-Justificacion") %></th>
                                <th class="text-center" ui-field width="10"><%= this.GetMessage("gvNotaCredito-Subtotal") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-Monto") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreSolicitante") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreAprobador") %></th>
                                <th ui-field width="7"><%= this.GetMessage("gvNotaCredito-Fecha") %></th>
                                <th ui-field width="7"><%= this.GetMessage("gvNotaCredito-FechaAprobacion") %></th>
                                <th ui-field width="8"><%= this.GetMessage("gvNotaCredito-Estatus") %></th>
                                <th ui-field width="8"><%= this.GetMessage("gvNotaCredito-TieneAjuste") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-MontoAjuste") %></th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="item in notasdeCredito">
                                <td st-ratio="8" class="text-center">
                                    <input type="checkbox" ng-model="item.PorAprobar" ng-change="checkSiEsAprobarTodo()"
                                        ng-show="item.MostrarAprobar" />
                                </td>
                                <td st-ratio="8">{{item.Folio}}</td>
                                <td st-ratio="15">{{item.QAD}}</td>
                                <td st-ratio="10">{{item.CodigoCliente}}</td>
                                <td st-ratio="20">{{item.NombreCliente}}</td>
                                <td st-ratio="15">{{item.NombreTipoNotaCredito}}</td>
                                <td st-ratio="15">{{item.Marcas}}</td>
                                <td st-ratio="15">{{item.NombreCanal}}</td>
                                <td st-ratio="10">{{item.TipoActivity}}</td>
                                <td st-ratio="15">{{item.Justificacion}}</td>
                                <td class="text-right" st-ratio="10">{{item.Subtotal | currency}}</td>
                                <td class="text-right" st-ratio="10">{{item.Monto | currency}}</td>
                                <td st-ratio="15">{{item.NombreSolicitante}}</td>
                                <td st-ratio="15">{{item.NombreAprobador}}</td>
                                <td st-ratio="7">{{item.Fecha}}</td>
                                <td st-ratio="7">{{item.FechaAprobacion}}</td>
                                <td st-ratio="8">{{item.Estatus}}</td>
                                <td class="text-center" st-ratio="8">{{item.TieneAjuste_txt}}</td>
                                <td class="text-center" st-ratio="10">{{item.TotalAjuste_AJUSTE | currency}}</td>
                                <td st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="verNota(item)"
                                        style="padding: 0">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="notasdeCredito.length == 0" class="nodata-row">
                                <td colspan="18" class="text-center">
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

                <div ui-table="notasdeCredito" st-fixed style="width: 100%" ng-hide="esAprobadorMasivo">
                    <table class="jsgrid-table" style="width: 2600px; min-width: 2600px"
                        st-table="notasdeCredito" st-safe-src="notasdeCredito_">
                        <thead>
                            <tr>                                
                                <th ui-field width="12"><%= this.GetMessage("gvNotaCredito-Folio") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-QAD") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-CodigoCliente") %></th>
                                <th ui-field width="20"><%= this.GetMessage("gvNotaCredito-NombreCliente") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-CuentaContable") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreTipoNotaCredito") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-Marcas") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreCanal") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-TipoActivity") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-Justificacion") %></th>
                                <th class="text-center" ui-field width="10"><%= this.GetMessage("gvNotaCredito-Subtotal") %></th>
                                <th class="text-center" ui-field width="10"><%= this.GetMessage("gvNotaCredito-Monto") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreSolicitante") %></th>
                                <th ui-field width="15"><%= this.GetMessage("gvNotaCredito-NombreAprobador") %></th>
                                <th ui-field width="7"><%= this.GetMessage("gvNotaCredito-Fecha") %></th>
                                <th ui-field width="7"><%= this.GetMessage("gvNotaCredito-FechaAprobacion") %></th>
                                <th ui-field width="12"><%= this.GetMessage("gvNotaCredito-Estatus") %></th>
                                <th ui-field width="8"><%= this.GetMessage("gvNotaCredito-TieneAjuste") %></th>
                                <th ui-field width="10"><%= this.GetMessage("gvNotaCredito-MontoAjuste") %></th>
                                <th ui-field width="5"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="item in notasdeCredito">                                
                                <td st-ratio="12">{{item.Folio}}</td>
                                <td st-ratio="15">{{item.QAD}}</td>
                                <td st-ratio="10">{{item.CodigoCliente}}</td>
                                <td st-ratio="20">{{item.NombreCliente}}</td>
                                <td st-ratio="10">{{item.CuentaContable}}</td>
                                <td st-ratio="15">{{item.NombreTipoNotaCredito}}</td>
                                <td st-ratio="15">{{item.Marcas}}</td>
                                <td st-ratio="15">{{item.NombreCanal}}</td>
                                <td st-ratio="10">{{item.TipoActivity}}</td>
                                <td st-ratio="15">{{item.Justificacion}}</td>
                                <td class="text-right" st-ratio="10">{{item.Subtotal | currency}}</td>
                                <td class="text-right" st-ratio="10">{{item.Monto | currency}}</td>
                                <td st-ratio="15">{{item.NombreSolicitante}}</td>
                                <td st-ratio="15">{{item.NombreAprobador}}</td>
                                <td st-ratio="7">{{item.Fecha}}</td>
                                <td st-ratio="7">{{item.FechaAprobacion}}</td>
                                <td st-ratio="12">{{item.Estatus}}</td>
                                <td class="text-center" st-ratio="8">{{item.TieneAjuste_txt}}</td>
                                <td class="text-center" st-ratio="10">{{item.TotalAjuste_AJUSTE | currency}}</td>
                                <td st-ratio="5">
                                    <button type="button" class="btn btn-link" ng-click="verNota(item)"
                                        style="padding: 0">
                                        <i class="icon-eye-open"></i><%= this.GetMessage("btnVer") %>
                                    </button>
                                </td>
                            </tr>
                            <tr ng-if="notasdeCredito.length == 0" class="nodata-row">
                                <td colspan="17" class="text-center">
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
        </div>

        <div class="page-content" ng-show="esDetalle" form="form">
            <div class="row">
                <div class="col-sm-6">
                    <div class="subtitulo-color"><%= this.GetMessage("TituloDetalle") %></div>
                </div>
                <div class="btn-tpm col-sm-6">
                    <div>
                        <div ng-click="guardaryenviarNota()" tooltip-placement="bottom"
                             class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardaryEnviar") %>">
                            <i class="fa fa-paper-plane-o"></i>
                        </div>
                    </div>
                     <div>
                        <div ng-click="guardarNota()" tooltip-placement="bottom" 
                             class="btn btn-top" uib-tooltip="<%= this.GetCommonMessage("lblTooltipGuardar") %>">
                            <i class="fa fa-save"></i>
                        </div>
                    </div>
                    <div>
                        <div class="btn btn-top" ng-click="esDetalle=false" tooltip-placement="bottom"
                            uib-tooltip="<%= this.GetCommonMessage("lblTooltipRegresar") %>">
                            <i class="glyphicon glyphicon-arrow-left"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div ng-form="forma" ng-class="{'submitted': submitted}">
                

                <div class="mail-box">
                    <div class="padding-form">

                        <div class="row mb">
                            <div class="col-md-4 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblTipoNC") %> </span>
                                <select class="form-control form-control-select" ng-model="notaCredito.TipoNotaCreditoId"
                                    ng-options="item.TipoNotaCreditoId as item.NombreTipoNotaCredito for item in tipoNotas"
                                    ng-change="mostrarForma()" required ng-if="!notaCredito.NotaCreditoId">
                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                </select>
                                <input type="text" ng-model="notaCredito.NombreTipoNotaCredito"
                                    class="form-control-input" readonly ng-if="notaCredito.NotaCreditoId" />
                            </div>

                            <div class="col-md-4 col-sm-6">
                                <span class="label-color"><%= this.GetMessage("lblEstatus") %> </span>
                                <input type="text" class="form-control-input readonly" ng-model="notaCredito.Estatus" readonly="readonly" />
                            </div>
                        </div>

                        <div class="row" ng-show="notaCredito.TipoNotaCreditoId">
                            <div ng-class="notaCredito.esExtraContractual && !notaCredito.EsSolicitante? 'col-sm-9': 'col-sm-12'">
                                <div class="row mb">
                                    <div class="col-sm-8" ng-if="!notaCredito.NotaCreditoId">
                                        <span class="label-color"><%= this.GetMessage("lblCliente") %> </span>
                                        <ex-autocomplete ng-model="notaCredito.ClienteId" options="clienteOptions"
                                            on-select="setValorCampos(optionSelected)" item="notaCredito" required
                                            parameters="notaCredito" />
                                    </div>

                                    <div class="col-sm-8" ng-if="notaCredito.NotaCreditoId">
                                        <span class="label-color"><%= this.GetMessage("lblCliente") %> </span>
                                        <input type="text" class="form-control-input" ng-model="notaCredito.Cliente"
                                            readonly="readonly" />
                                    </div>

                                    <div class="col-sm-4">
                                        <span class="label-color"><%= this.GetMessage("lblSolicitanteVendedor") %> </span>
                                        <input type="text" class="form-control-input readonly" ng-model="notaCredito.NombreVendedor"
                                            readonly="readonly" />
                                    </div>
                                </div>

                                <div class="row mb">
                                    <div class="col-sm-8">
                                        <span class="label-color"><%= this.GetMessage("lblCobrarA") %> </span>
                                        <input type="text" class="form-control-input readonly" ng-model="notaCredito.NombreCobrarA"
                                            readonly="readonly" />
                                    </div>

                                    <div class="col-sm-4" ng-if="notaCredito.esContractual">
                                        <span class="label-color"><%= this.GetMessage("lblTipo") %> </span>
                                        <select class="form-control form-control-select" ng-model="notaCredito.TipoDescuentoId"
                                            ng-options="item.TipoDescuentoId as item.NombreTipoDescuento for item in notaCredito.TipoDescuentos"
                                            ng-change="verTipoDescuento()" required ng-hide="notaCredito.NotaCreditoId">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                        <input type="text" class="form-control-input" ng-model="notaCredito.NombreTipoDescuento"
                                            readonly="readonly" ng-show="notaCredito.NotaCreditoId" />
                                    </div>

                                    <div class="col-sm-4" ng-if="notaCredito.esApv">
                                        <span class="label-color"><%= this.GetMessage("lblCuentaContable") %> </span>
                                        <select class="form-control form-control-select" ng-model="notaCredito.CuentaContableId" required
                                            ng-options="item.CuentaContableId as item.NombreCuentaContable for item in cuenasContables"
                                            ng-disabled="notaCredito.NotaCreditoId">
                                            <option value=""><%= this.GetMessage("lblSelect") %></option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row mb" ng-if="!notaCredito.esDevolucion">                                      
                                        <div class="col-sm-6">
                                            <span class="label-color"><%= this.GetMessage("lblJustificacion") %></span>
                                             <input type="text" ng-model="notaCredito.Justificacion" class="form-control-input" maxlength="{{justificacion.Numero}}" required ng-disabled="notaCredito.NotaCreditoId"/>
                                        </div>
                                        <div class="col-sm-6" ng-if="justificacion.esUsuarioAnalista">
                                            <span class="label-color"><%= this.GetMessage("lblOrdenCompra") %></span>
                                            <input type="text" ng-model="notaCredito.OrdenCompra" class="form-control-input" ng-required="esVendedor" ng-disabled="notaCredito.NotaCreditoId"/>
                                        </div>

                                        <div class="col-sm-6" ng-if="justificacion.esUsuarioAnalista">
                                            <span class="label-color"><%= this.GetMessage("lblDescripcionDetallada") %></span>
                                            <input type="text" ng-model="notaCredito.DescripcionDetallada" class="form-control-input" ng-required="esVendedor" ng-disabled="notaCredito.NotaCreditoId"/>
                                        </div>
                                        

                                        <div class="col-sm-6" ng-if="justificacion.esUsuarioAnalista">
                                            <span class="label-color"><%= this.GetMessage("lblLibroDiario") %></span>
                                            <select class="form-control-select" ng-model="notaCredito.LibroDiario"  ng-change="changeLibroDiario()"
                                                ng-options="libro.Id as libro.Nombre for libro in LibrosDiario"  required ng-disabled="notaCredito.NotaCreditoId">
                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                            </select>
                                        </div>
                                    <div class="col-sm-6" ng-if="justificacion.esUsuarioAnalista">
                                            <span class="label-color"><%= this.GetMessage("lblCuentaIva") %></span>
                                            <select class="form-control-select" ng-model="notaCredito.Cuenta" ng-required="notaCredito.AplicaIva esVendedor" ng-disabled="notaCredito.NotaCreditoId"
                                                ng-options="cuenta.Id as cuenta.Nombre for cuenta in CuentasIva" >
                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                            </select>
                                        </div>
                                        <div class="col-sm-6" ng-if="justificacion.esUsuarioAnalista">
                                            <span class="label-color"><%= this.GetMessage("lblComentarios") %></span>
                                            <input type="text" ng-model="notaCredito.ComentariosLibro" class="form-control-input" ng-disabled="notaCredito.NotaCreditoId"/>
                                        </div>
                                        <div class="col-sm-2" ng-if="justificacion.esUsuarioAnalista">
                                            <span class="label-color"><%= this.GetMessage("lblFechaConciliacion") %></span>
                                            <datepicker id="fechaConciliacion" ng-model="notaCredito.FechaConciliacion" no-disabled
                                                datepicker-options="datepickerOptions"></datepicker>
                                        </div>
                                        <div class="col-sm-10"></div>
                                     
                                    <div class="col-sm-4 col-md-3 col-lg-2" ng-if="notaCredito.esContractual && notaCredito.EsPorcentaje">
                                        <div class="label-color"><%= this.GetMessage("lblAplicaIvaRetencion") %> </div>
                                        <switcher ng-model="notaCredito.EsAplicaIVARetencion" true-label="Si" false-label="No" 
                                                  ng-change="aplicarIvaRetencion()" ng-disabled="notaCredito.NotaCreditoId"></switcher>
                                    </div>
                                    <div class="col-sm-8" ng-if="notaCredito.esContractual && notaCredito.EsPorcentaje">
                                        <div class="label-color"><%= this.GetMessage("lblTipoIva") %> </div>
                                        <switcher ng-model="notaCredito.EsAplicaIVAFrontera" true-label="<%= this.GetMessage("lblAplicaTipoIvaFrontera") %>" 
                                                  false-label="<%= this.GetMessage("lblAplicaTipoIvaCentro") %>" 
                                                  ng-change="cambiarTipoIVA()" ng-disabled="notaCredito.NotaCreditoId"></switcher>
                                    </div>
                                </div>                              

                                <div ng-if="!notaCredito.AutocalculadoPorFacturas && !notaCredito.esExtraContractual">
                                    <div class="row mb">
                                        <div class="col-sm-4" ng-if="habilitarMarca()">
                                            <span class="label-color"><%= this.GetMessage("lblMarca") %> </span>
                                            <div class="width-auto" selected-model="notaCredito.Marcas"
                                                 options="marcas" extra-settings="marcasOptions"
                                                 translation-texts="translateTextMultiSelect"
                                                 ng-dropdown-multiselect="" events="multiselectEventos">
                                            </div>
                                        </div>

                                        <div class="col-sm-4" ng-if="notaCredito.EsCambiarMonto">
                                            <span class="label-color"><%= this.GetMessage("lblMontoInicial") %> </span>
                                            <input type="text" class="form-control form-control-input readonly" ng-model="notaCredito.MontoInicial"
                                                   money readonly="readonly" />
                                        </div>

                                        <div class="col-sm-4" ng-if="notaCredito.EsCambiarMonto">
                                            <span class="label-color"><%= this.GetMessage("lblMultiplicarPor") %> </span>
                                            <input type="text" class="form-control form-control-input" ng-model="notaCredito.MultiplicarPor"
                                                   required money ng-change="calcularMonto()" ng-disabled="noEditable()" />
                                        </div>
                                    </div>
                                    
                                    <div class="row mb">
                                        <div class="col-sm-4" ng-if="!notaCredito.EsAplicaIVARetencion">
                                            <span class="label-color"><%= this.GetMessage("lblMonto") %> </span>
                                            <input type="text" class="form-control form-control-input readonly" ng-model="notaCredito.Monto"
                                                   required money precision="4" readonly="readonly" />
                                        </div>

                                        <div class="col-sm-4" ng-if="notaCredito.EsAplicaIVARetencion">
                                            <span class="label-color"><%= this.GetMessage("lblMonto") %> </span>
                                            <input type="text" class="form-control form-control-input readonly" ng-model="notaCredito.TotalConRetencionIVA"
                                                   required money precision="4" readonly="readonly" />
                                        </div>

                                        <div class="col-sm-4" ng-show="notaCredito.esApv">
                                            <span class="label-color"><%= this.GetMessage("lblAplicaIva") %> </span>
                                            <br />
                                            <switcher ng-model="notaCredito.EsIvaGeneral" true-label="<%= this.GetMessage("lblSi") %>"
                                                      false-label="<%= this.GetMessage("lblNo") %>" ng-change="aplicarIvaMarcas()"
                                                      ng-disabled="noEditable()"></switcher>
                                        </div>
                                        
                                        <div class="col-sm-4 col-md-3 col-lg-2" ng-if="notaCredito.esContractual">
                                            <div class="label-color"><%= this.GetMessage("lblAplicaIvaRetencion") %> </div>
                                            <switcher ng-model="notaCredito.EsAplicaIVARetencion" true-label="Si" false-label="No" 
                                                      ng-change="aplicarIvaRetencion()" ng-disabled="notaCredito.NotaCreditoId"></switcher>
                                        </div>

                                        <div class="col-sm-4 col-md-3 col-lg-2" ng-if="notaCredito.esContractual">
                                            <div class="label-color"><%= this.GetMessage("lblTipoIva") %> </div>
                                            <switcher ng-model="notaCredito.EsAplicaIVAFrontera" true-label="<%= this.GetMessage("lblAplicaTipoIvaFrontera") %>" 
                                                      false-label="<%= this.GetMessage("lblAplicaTipoIvaCentro") %>" ng-change="cambiarTipoIVA()"
                                                      ng-disabled="notaCredito.NotaCreditoId"></switcher>
                                        </div>
                                    </div>                                   
                                </div>

                                <div class="row" ng-show="notaCredito.esDevolucion">
                                    <br />
                                    <div class="col-sm-12">
                                        <span class="label-color"><%= this.GetMessage("lblDireccion") %> </span>
                                    </div>
                                    <div class="col-sm-12">
                                        {{notaCredito.Direccion}}
                                    </div>
                                </div>

                                <div ng-show="notaCredito.esExtraContractual">
                                    <div class="row mb">
                                        <div class="col-md-3 col-sm-3">
                                            <span class="label-color"><%= this.GetMessage("lblActivity") %> </span>
                                            <select class="form-control form-control-select" ng-model="notaCredito.DescuentoExtracontractualId"
                                                ng-options="item.DescuentoId as item.Nombre for item in extracontractuales"
                                                ng-change="verTipoActividad()" ng-required="notaCredito.esExtraContractual"
                                                ng-if="!notaCredito.NotaCreditoId">
                                                <option value=""><%= this.GetMessage("lblSelect") %></option>
                                            </select>
                                            <input type="text" class="form-control-input" ng-model="notaCredito.NombreActivity"
                                                readonly="readonly" ng-if="notaCredito.NotaCreditoId" />
                                        </div>

                                        <div class="col-md-3 col-sm-3">
                                            <span class="label-color"><%= this.GetMessage("lblCanal") %> </span>
                                            <input type="text" class="form-control-input readonly" ng-model="notaCredito.NombreCanal"
                                                readonly="readonly" />
                                        </div>

                                        <div class="col-md-2 col-sm-2">
                                            <span class="label-color"><%= this.GetMessage("lblImpactoA") %> </span>                                            
                                            <label>
                                                <select class="form-control form-control-select" ng-model="notaCredito.TipoApoyoId"
                                                    ng-options="item.TipoApoyoId as item.NombreTipoApoyo for item in tipoapoyo"
                                                    ng-change="getTipoApoyoEvidencia(notaCredito.TipoApoyoId)" ng-required="notaCredito.esExtraContractual || notaCredito.esApv || notaCredito.esDevolucion"
                                                    ng-if="!notaCredito.NotaCreditoId">
                                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                </select>
                                            </label>    
                                            <input type="text" ng-model="notaCredito.NombreTipoApoyo"
                                                    class="form-control-input" readonly ng-if="notaCredito.NotaCreditoId" />                                     
                                        </div>

                                        <div class="col-md-2 col-sm-2">
                                            <span class="label-color"><%= this.GetMessage("lblAplicaIva") %> </span>
                                            <br />
                                            <switcher ng-model="notaCredito.EsIvaGeneral" true-label="<%= this.GetMessage("lblSi") %>"
                                                false-label="<%= this.GetMessage("lblNo") %>" ng-change="aplicarIvaMarcas()" ng-if="!notaCredito.EsPorcentaje"
                                                ng-disabled="noEditable()" ng-disabled="notaCredito.NotaCreditoId"></switcher>
                                        </div>

                                        <div class="col-md-2 col-sm-2">
                                            <div class="label-color"><%= this.GetMessage("lblTipoIva") %> </div>
                                            <switcher ng-model="notaCredito.EsAplicaIVAFrontera" true-label="<%= this.GetMessage("lblAplicaTipoIvaFrontera") %>"  ng-if="!notaCredito.EsPorcentaje"
                                                      false-label="<%= this.GetMessage("lblAplicaTipoIvaCentro") %>" ng-change="cambiarTipoIVA()"></switcher>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <span class="label-color"><%= this.GetMessage("lblEstrategia") %> </span>
                                            <textarea ng-model="notaCredito.Estrategia" class="form-control readonly"
                                                rows="2" readonly="readonly">                                    
                                            </textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-sm-3" ng-show="notaCredito.esExtraContractual && !notaCredito.EsSolicitante">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <span class="label-color"><%= this.GetMessage("lblMontoAurotizado") %> </span>
                                        <input type="text" class="form-control-input readonly" ng-model="notaCredito.MontoAutorizado"
                                            readonly="readonly" money />
                                    </div>
                                </div>
                                <br />

                                <div class="row">
                                    <div class="col-sm-12">
                                        <span class="label-color"><%= this.GetMessage("lblMontoEnAutorizacion") %> </span>
                                        <input type="text" class="form-control-input readonly" ng-model="notaCredito.MontoEnAutorizacion"
                                            readonly="readonly" money />
                                    </div>
                                </div>
                                <br />

                                <div class="row">
                                    <div class="col-sm-12">
                                        <span class="label-color"><%= this.GetMessage("lblBalance") %> </span>
                                        <input type="text" class="form-control-input readonly" ng-model="notaCredito.Balance"
                                            readonly="readonly" min="-9999999" money />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <br />
                </div>


                <!--

                    <div class="row" ng-hide="notaCredito.esExtraContractual">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblPorcentaje") %>  </span>
                            <input type="text" class="form-control-input text-right readonly" ng-value="notaCredito.MontoPorcentaje"
                                readonly="readonly" />
                        </div>

                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblMontoCalculadoNc") %>  </span>
                            <input type="text" class="form-control-input readonly" ng-model="notaCredito.Monto"
                                readonly="readonly" money min="-99999999" />
                        </div>

                        <div class="col-sm-4"  ng-if="!notaCredito.esAplicaProntoPago && notaCredito.esAplicaProntoPagoExcepcion && notaCredito.esTipoDescuentoProntoPago"> 
                             <button type="button" class="btn btn-success" ng-click="AplicaProntoPagoExcepcion()">
                                  <%= this.GetMessage("lblTooltipExcepcionProntoPago") %>
                             </button>
                        </div>

                        <div class="col-sm-4"  ng-if="notaCredito.esAplicaProntoPago && notaCredito.esAplicaProntoPagoExcepcion && notaCredito.esTipoDescuentoProntoPago">
                            <span class="label-color"><%= this.GetMessage("lblJustificacionProntoPago") %></span>
                                <input type="text" ng-model="notaCredito.JustificacionProntoPago" class="form-control-input" maxlength="500" ng-required="esVendedor" ng-disabled="notaCredito.NotaCreditoId"/>
                        </div>
                    </div>

                    <div class="row" ng-if="notaCredito.esExtraContractual">
                        <div class="col-sm-4">
                            <span class="label-color"><%= this.GetMessage("lblMonto") %> </span>
                            <input type="text" class="form-control-input" ng-model="notaCredito.Monto"
                                money required ng-change="calcularBalance()" readonly="readonly" />
                        </div>
                    </div>
                     

                -->

                    <br />
                </div>

               

                <div class="mail-box padding-form" ng-if="notaCredito.esDevolucion">
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="subtitulo-color"><%= this.GetMessage("lblProductos") %> </span>
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <table class="table table-bordered table-condensed table-striped table-hover white-space"
                                    style="width: 1700px; max-width: 1700px">
                                    <thead>
                                        <tr>
                                            <th rowspan="3" ng-if="!notaCredito.NotaCreditoId">
                                                <button type="button" class="btn btn-link" ng-click="agregarProducto()">
                                                    <i class="glyphicon glyphicon-plus"></i>
                                                </button>
                                            </th>
                                            <th rowspan="3" class="va-m" style="width: 120px">
                                                <%= this.GetMessage("lblCodigoProducto") %>
                                            </th>
                                            <th rowspan="3" class="va-m" style="width: 200px">
                                                <%= this.GetMessage("lblProducto") %>
                                            </th>
                                            <th rowspan="3" class="va-m" style="width: 150px">
                                                <%= this.GetMessage("lblCostoConIva") %>
                                            </th>
                                            <th rowspan="3" class="va-m" style="width: 100px">
                                                <%= this.GetMessage("lblPiezasPorCaja") %>
                                            </th>
                                            <th colspan="9" class="text-center">
                                                <%= this.GetMessage("lblInformacionDevolucion") %>
                                            </th>
                                            <th rowspan="3">
                                                <%= this.GetMessage("lblMontoDevolucionIva") %>
                                            </th>
                                        </tr>

                                        <tr>
                                            <th colspan="2" style="width: 100px">
                                                <%= this.GetMessage("lblEstadoProducto") %>
                                            </th>
                                            <th rowspan="2" class="text-center va-m" style="width: 150px">
                                                <%= this.GetMessage("lblCausalDevolucion") %>
                                            </th>
                                            <th colspan="4" class="text-center">
                                                <%= this.GetMessage("lblCantidadSolicitada") %>
                                            </th>
                                            <th colspan="2" class="text-center">
                                                <%= this.GetMessage("lblCantidadRecibida") %>
                                            </th>
                                        </tr>

                                        <tr>
                                            <th class="text-center"><%= this.GetMessage("lblAveriado") %></th>
                                            <th class="text-center"><%= this.GetMessage("lblDisponible") %></th>
                                            <th style="width: 100px"><%= this.GetMessage("lblCaja") %></th>
                                            <th style="width: 150px">$ <%= this.GetMessage("lblCaja") %></th>
                                            <th style="width: 100px"><%= this.GetMessage("lblUnidad") %></th>
                                            <th style="width: 100px">$ <%= this.GetMessage("lblUnidad") %></th>
                                            <th style="width: 100px"><%= this.GetMessage("lblCaja") %></th>
                                            <th style="width: 100px"><%= this.GetMessage("lblUnidad") %></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr ng-repeat="item in notaCredito.ProductosDevolucion">
                                            <td ng-if="!notaCredito.NotaCreditoId">
                                                <button type="button" class="btn btn-link" ng-click="quitarProducto($index)"
                                                    style="color: red">
                                                    <i class="glyphicon glyphicon-trash"></i>
                                                </button>
                                            </td>
                                            <td ng-if="!notaCredito.NotaCreditoId">
                                                <ex-autocomplete ng-model="item.ProductoId" options="productoOptions"
                                                    item="item" required append-to-body width="120px"
                                                    on-select="setValorProducto(optionSelected, item)"/>
                                            </td>
                                            <td ng-if="notaCredito.NotaCreditoId">{{item.ProductoId}}
                                            </td>
                                            <td>{{item.NombreProducto}}
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="item.CostoConInva"
                                                    required money ng-change="calcularDevolucion(item)"
                                                    ng-disabled="notaCredito.NotaCreditoId" />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="item.PiezasCaja"
                                                    required money precision="0" ng-change="calcularDevolucion(item)"
                                                    ng-disabled="notaCredito.NotaCreditoId" />
                                            </td>
                                            <td class="text-center va-m">
                                                <input type="radio" ng-model="item.EsDisponible" value="0" ng-change="getCausales(item)"
                                                    ng-disabled="noEditable()" />
                                            </td>
                                            <td class="text-center va-m">
                                                <input type="radio" ng-model="item.EsDisponible" value="1" ng-change="getCausales(item)"
                                                    ng-disabled="noEditable()" />
                                            </td>
                                            <td>
                                                <select class="form-control-select" ng-model="item.CausalDevolucionId"
                                                    ng-options="causal.CausalDevolucionId as causal.NombreCausal for causal in item.causalesDevolucion"
                                                    required ng-if="!noEditable()">
                                                    <option value=""><%= this.GetMessage("lblSelect") %></option>
                                                </select>
                                                <span ng-if="noEditable()">{{item.NombreCausal}}</span>
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="item.TotalCajas"
                                                    money precision="0" ng-change="calcularDevolucion(item)"
                                                    ng-disabled="noEditable()" />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input readonly" ng-model="item.MontoCajas"
                                                    readonly="readonly" money />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input" ng-model="item.TotalUnidades"
                                                    money precision="0" ng-change="calcularDevolucion(item)"
                                                    ng-disabled="noEditable()" />
                                            </td>
                                            <td>
                                                <input type="text" class="form-control-input readonly" ng-model="item.MontoUnidades"
                                                    readonly="readonly" money />
                                            </td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <input type="text" class="form-control-input readonly" ng-model="item.MontoDevolucion"
                                                    required readonly="readonly" money />
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td class="text-right" colspan="{{notaCredito.NotaCreditoId? 13:14}}">
                                                <b><%= this.GetMessage("lblTotalDevolucion") %></b>
                                            </td>
                                            <td class="text-right">{{notaCredito.Monto | currency}}</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                    <br />
                </div>

                <div class="mail-box padding-10 wrapper border-bottom" ng-show="notaCredito.esExtraContractual || notaCredito.esApv || notaCredito.esDevolucion">                                      
                    <div ui-table="tipoApoyoEvidencia"  st-fixed style="width: 100%">
                        <table class="jsgrid-table"
                            st-table="tipoApoyoEvidencia" st-safe-src="tipoApoyoEvidencia_">
                            <thead>
                                <tr style="color:black;">
                                    <th ui-field st-ratio="30" style="text-align: center" ><%= this.GetMessage("lblEvidencias") %></th>                                   
                                    <th ui-field st-ratio="25" style="text-align: center"><%= this.GetMessage("lblArchivoActual") %></th>
                                    <th ui-field st-ratio="15" style="text-align: center"><%= this.GetMessage("lblRequerido") %></th>
                                    <th ui-field st-ratio="15" style="text-align: center"><%= this.GetMessage("lblCargarEvidencia") %></th>
                                    <th ui-field st-ratio="15" style="text-align: center"><%= this.GetMessage("lblDescargarPlantilla") %></th>                                    
                                </tr>                             
                            </thead>
                            <tbody>
                                <tr  ng-repeat="item in tipoApoyoEvidencia" style="color:black;">
                                    <td st-ratio="30">{{item.NombreEvidencia}}</td>                                   
                                    <td st-ratio="25">{{item.NombreArchivoActual}}</td>
                                    <td st-ratio="15" align="center">
                                        <input type="checkbox" ng-model="item.Requerido" ng-disabled ="item.Requerido" />
                                    </td>
                                    <td st-ratio="15"  align="center" >
                                            <ex-fileupload ng-model="item.NombreArchivoNuevo" image-button="fa-upload"
                                                download-button="fa-paperclip" on-success="setParametrosArchivo(response, item)"
                                                options="fileOptionsDetalle" parameters="fileParameters" open-file="openDocumento(item)">
                                            </ex-fileupload>                           
                                    </td>  
                                    <td st-ratio="15" align="center">
                                        <button type="button" class="btn btn-link" ng-click="abrirDocumento(item)">
                                            <i class="fa fa-download d-block"></i>                                               
                                        </button>   
                                    </td>                                 
                                </tr>                               
                                <tr ng-if="tipoApoyoEvidencia.length == 0" class="nodata-row">
                                    <td colspan="5" class="text-center">
                                        <%=  this.GetCommonMessage("msgGridSinInformacion") %>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <br />
                    <div class="row">
                        <div class="col-sm-12">
                            <span class="label-color"><%= this.GetMessage("lblComentarios") %> </span>   
                            <textarea ng-model="notaCredito.ComentarioArchivos" class="form-control no-disabled" rows="2" maxlength="1000">                                    
                                        </textarea>
                            <br />
                            <br />
                        </div>
                        
                    </div>                
                </div>
            <br /><br />
        </div>
        
    </div>
    
    <script type="text/javascript" src="../scripts/pages/preNotaCreditoController.js?V1<%= DateTime.Now.Millisecond %>"""></script>
</asp:Content>


