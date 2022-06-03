<%@ Page Title="" Language="C#" MasterPageFile="~/includes/magnajs.Master" AutoEventWireup="true" CodeBehind="Ayuda.aspx.cs" Inherits="magnajs.Pages.Ayuda" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="main" runat="server">

    <div class="ng-cloak" ng-controller="SelectpickerPanelCtrl as selectpickerVm">
  
         <searchable-multiselect display-attr="name"
			  selected-items="user.languages" all-items="allLanguages"
			  add-item="addLanguageToUser(item,user)" remove-item="removeLanguageFromUser(item,user)" >
	    </searchable-multiselect>

        <isteven-multi-select    
    input-model="modernBrowsers"    
    output-model="outputBrowsers"
    button-label="icon name"
    item-label="icon name maker"
    tick-property="ticked"
>
</isteven-multi-select>

    </div>

  <script type="text/javascript" src="../scripts/pages/ayudaController.js?v=1.1.<%= DateTime.Now.Millisecond %>"></script>-

</asp:Content>
