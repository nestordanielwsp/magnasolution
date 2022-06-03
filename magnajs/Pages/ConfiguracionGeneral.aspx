<%@ Page Title="" Language="C#" MasterPageFile="~/includes/magnajs.Master" AutoEventWireup="true" CodeBehind="ConfiguracionGeneral.aspx.cs" Inherits="magnajs.Pages.ConfiguracionGeneral" %>

<asp:Content ID="Head1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
    <div ng-controller="configuracionGeneralController as vm">
        <div class="content-top clearfix">
            <h1 class="al-title" ng-bind="vm.titulo"></h1>
            <div class="div-top-butons">
                <div class="padding-7">
                    <div class="btn btn-top " ng-click="vm.guardar()">
                        <i class="fa fa-save"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-content">

            <div ng-form="vm.form" ng-class="{'submitted': !vm.isValid}">
                <div class="mail-box padding-10">
                    <div class="mail-body">
                        <div class="ibox-content">
                            <div id="Filters" class="padding-form">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("LibroDiario") %> </span>
                                    </div>
                                </div>

                                <div class="row pt-10">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ClaveNotasCreditoFiscal") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.configuracionGeneral.ClaveNotasCreditoFiscal" required />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ClaveNotasCreditoNoFiscal") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.configuracionGeneral.ClaveNotasCreditoNoFiscal" required />
                                    </div>
                                </div>

                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("CuentasContablesFiscales") %> </span>
                                    </div>
                                </div>

                                <div class="row pt-10">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ClaveIvaFiscal") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.ClaveIvaFiscal" required money maxlength="6" />
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CuentaIvaFiscal") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.CuentaIvaFiscal" required />
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CuentaIvaNoFiscal") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.CuentaIvaNoFiscal" required />
                                    </div>
                                </div>

                                <div class="row pt-10">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ClaveIvaRetencion") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.ClaveIvaRetencion" required money maxlength="6" />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CuentaIvaRetencion") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.CuentaIvaRetencion" required />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ClaveIvaFrontera") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.ClaveIvaFrontera" required money maxlength="6" />
                                    </div>
                                </div>


                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("CuentasContablesGastos") %> </span>
                                    </div>
                                </div>

                                <div class="row pt-10">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("CuentaActividades") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.configuracionGeneral.CuentaActividades"
                                            required />
                                    </div>
                                </div>

                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("ObjetivosIndicadoresCartera") %> </span>
                                    </div>
                                </div>
                                <div class="row pt-10">
                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ObjetivoContabilidad") %> </span>
                                        <input type="text" class="form-control form-control-input" ng-model="vm.configuracionGeneral.ObjetivoContabilidad"
                                            required numbers-only />
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("ObjetivoCartera") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.ObjetivoCartera" required="required" money />
                                    </div>

                                    <div class="col-sm-3">
                                        <span class="label-color"><%= this.GetMessage("PorcentajeRecaudoCartera") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.PorcentajeRecaudoCartera"
                                            class="form-control-input" money maxlength="6" required="required" />
                                    </div>
                                </div>

                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("CamposCargaCim") %> </span>
                                    </div>
                                </div>

                                <div class="row mb pt-10">
                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("TipoFactura") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.TipoFactura" required />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("ExcluirImpuesto") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.ExcluirImpuesto" required />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("ClaseImpuesto") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.ClaseImpuesto"
                                            class="form-control-input" required />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("TerminosCredito") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.TerminosCredito"
                                            class="form-control-input" required />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("SeparadorCarga") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.SeparadorCargaCim"
                                            class="form-control-input" required maxlength="1" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("TipoImpuesto") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.TipoImpuesto"
                                            class="form-control-input" required />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("ClaseImpuestoFrontera") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.ClaseImpuestoFrontera"
                                            class="form-control-input" required />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("TipoImpuestoFrontera") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.TipoImpuestoFrontera"
                                            class="form-control-input" required />
                                    </div>
                                </div>

                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("lblCamposCargaCimRequisicion") %> </span>
                                    </div>
                                </div>

                                <div class="row mb pt-10">
                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblEntidad") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.Entidad" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblSubcuenta") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.Subcuenta" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblCentroCosto") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.CentroCosto"
                                            class="form-control-input" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblAlmacen") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.Almacen"
                                            class="form-control-input" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblDiasCierrePresupuesto") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.DiasCierrePresupuesto"
                                            class="form-control-input" only-numbers maxlength="9" />
                                    </div>
                                </div>
                                
                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("lblInformacionAdicionalPromocion") %> </span>
                                    </div>
                                </div>

                                <div class="row mb pt-10">
                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblPrefijoPromocion") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.PrefijoPromocion" maxlength="5" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblGrupo") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.PromoGrupo" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblImpuesto") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.PromoImpuesto"
                                            class="form-control-input" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblTipo") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.PromoTipo"
                                            class="form-control-input" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblEstatus") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.PromoEstatus"
                                            class="form-control-input" maxlength="20" />
                                    </div>

                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblAlmacenPromocionArmada") %> </span>
                                        <input type="text" ng-model="vm.configuracionGeneral.AlmacenPromocionArmada"
                                            class="form-control-input" maxlength="20" />
                                    </div>
                                </div>
                                
                                <div class="row pt-15">
                                    <div class="col-sm-12">
                                        <span class="subtitulo-color"><%= this.GetMessage("lblParametros") %> </span>
                                    </div>
                                </div>

                                <div class="row mb pt-10">
                                    <div class="col-sm-4 col-md-3">
                                        <span class="label-color"><%= this.GetMessage("lblTopeDiasProntoPago") %> </span>
                                        <input type="text" class="form-control form-control-input"
                                            ng-model="vm.configuracionGeneral.TopeDiasProntoPago" maxlength="2"   required numbers-only/>
                                    </div>

                                    <div class="col-sm-4 col-md-2">

                                    </div>
                                      <div class="col-sm-4 col-md-1">

                                    </div>
                                    <div class="col-sm-4 col-md-6">
                                        
                                    </div> 
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript" src="../scripts/pages/configuracionGeneralController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>
</asp:Content>

