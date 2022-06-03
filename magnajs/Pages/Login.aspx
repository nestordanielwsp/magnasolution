<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="magnajs.Pages.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Magna</title>
    <link href="../css/login/font-face-login.css" rel="stylesheet" />
    <link href="../css/login/font-awesome.min.css" rel="stylesheet" />
    <link href="../css/login/normalize.min.css" rel="stylesheet" />
    <link href="../css/login/login.css" rel="stylesheet" />
    <script type="text/javascript" src="../scripts/librerias/login/jquery.js"></script>

</head>
<body>
    <div class="wrapper">
        <form id="Form1" runat="server" class="login">
            <div class="page-form"> 
                <div class="col-lg-12">
                    <div class="col-lg-4 text-center">
                        <div style="text-align: center" class="divLogo">
                            <img alt="" src="../images/logoLogin.png" />
                        </div>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                    <div class="col-lg-4">
                        <div class="body-content">
                            <div class="title-trade">
                                <h2><b>Trade Promotion Management</b></h2>
                            </div>
                            <input id="txtUsuario" runat="server" type="text" class="form-control" placeholder="Usuario" autofocus  />
                            <i class="fa fa-user"></i>
                            <input id="txtPassword" runat="server" type="password" class="form-control" placeholder="Contraseña" />
                            <i class="fa fa-key"></i>
                            <div class="form-group">
                                <button type="submit" class="btn btn-dark btn-outlined" onclick="IniciarSession();">
                                    ENTRAR
                                </button>
                            </div>
                            <div class="error">
                                <asp:Label ID="lblError" runat="server"></asp:Label>
                            </div>
                        </div>

                    </div>
                    <div class="col-lg-4">
                        &nbsp;
                    </div>
                </div>
                <div class="containerHeader">
                    &nbsp; 
                </div>
            </div>
            <div class="nonecell">
                <asp:Button Style="display: none;" ID="btnLogin" runat="server" Text="btnExport"
                    OnClick="btnLogin_Click" />
            </div>
        </form>
    </div>
    <script type="text/javascript">
        function IniciarSession() {
            click = new Object();
            setTimeout(Entrar, 1);
        }
        var click;
        $('form').keypress(function (e) {
            var code = e.keyCode || e.which;
            if (code === 13) {
                e.preventDefault();
                if (click) {
                    clearTimeout(click);
                    setTimeout(Deshabilita, 5000);
                }
                else {
                    click = new Object();
                    setTimeout(Entrar, 1);
                }
                return false;
            }
        })

        function Deshabilita() {
            click = null;
        }

        function Entrar() {
            document.getElementById('btnLogin').click();
        }

    </script>
</body>
</html>
