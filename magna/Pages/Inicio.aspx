<%@ Page Title="" Language="C#" MasterPageFile="~/includes/magna.Master" AutoEventWireup="true" CodeBehind="Inicio.aspx.cs" Inherits="CYP.Pages.Inicio" %>


<asp:Content ID="Content1" ContentPlaceHolderID="main" runat="server">
     <div class="view dashboard" ng-controller="inicio as vm">
      <h1><%= this.GetMessage("Titulo") %></h1>

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

      <div class="md-whiteframe-1dp">
        <h2>Announcements</h2>      
      </div>
    </div>

    <script type="text/javascript" src="../Scripts/pages/inicioController.js?v=1.1<%=DateTime.Now.Millisecond %>"></script>
</asp:Content>

