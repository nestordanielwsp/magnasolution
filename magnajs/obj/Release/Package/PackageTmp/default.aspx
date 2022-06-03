<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="CYP._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 90%; margin:20px; font-size: 18px; color: #04a">
            El sitio <b>TPM</b> ha cambiado de lugar, puede dar click en el siguiente enlace:
            <a href="https://quala-tpm.azurewebsites.net">https://quala-tpm.azurewebsites.net</a>, 
            o en unos momentos sera redirigido.
        </div>
    </form>
</body>

<script type="text/javascript">    
    location.href = 'https://quala-tpm.azurewebsites.net';
</script>
</html>
