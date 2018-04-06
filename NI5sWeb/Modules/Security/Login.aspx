<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="NI5sWeb.Modules.Account.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Acceso | Net-Info Web 1.0</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        body, html {
            width: 100%;
            height: 100%;
            background-color: #d1d1d1;
            margin:0;
            padding:0;
            box-sizing:border-box;
        }
        #loginBox{
            position:absolute;
            top: 50%;
            width:100%;
            background-color: #fff;
            padding: 25px 15px;
            margin-top: -145px;
            box-sizing:border-box;
        }
        /*color:#005aaa;*/
        #loginBox header {position:relative;}
        #loginBox header img {float: left;}
        #loginBox header img::after {content: "";display: table;clear: both;}
        #loginBox header h1{float:left;margin:10px 5px;font-family:Tahoma;color:#004996;font-size:1.1em;}
        #loginBox header h1:after {content: "";display: table;clear: both;}
        .clear {clear:both;}

        #loginBox input{width:100%;margin:10px 0;padding:5px;box-sizing:border-box;font-family:Tahoma;}
        #loginBox input[type=submit]{border:none;background-color:#004696;color:#fff;padding:15px;}

        @media handheld, only screen and (min-width: 401px) {
            #loginBox{
            width:320px;
            left: 50%;
            margin-left: -160px;
        }
        }
    </style>
</head>
<body>
    <form id="LoginForm" runat="server">
    <div id="loginBox">
        <header>
            <img src="/Themes/NIWeb/img/backMiniLogo.png" />
            <h1>Acceso a Net-Info Web</h1>
            <div class="clear"></div>
        </header>
        <asp:TextBox ID="Name" runat="server" placeholder="Nombre de Usuario" required></asp:TextBox>
        <asp:TextBox ID="Pass" runat="server" placeholder="Contraseña" type="password" required></asp:TextBox>
        <asp:Button ID="Enter" runat="server" Text="Acceder" OnClick="Enter_Click" />
    </div>
    </form>
</body>
</html>
