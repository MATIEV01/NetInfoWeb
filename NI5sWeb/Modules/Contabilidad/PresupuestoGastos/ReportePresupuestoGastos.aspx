<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportePresupuestoGastos.aspx.cs" Inherits="NI5sWeb.Modules.Contabilidad.PresupuestoGastos.ReportePresupuestoGastos" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <CR:CrystalReportViewer ID="PG"  runat="server" AutoDataBind="true" />
   
    </form>
</body>
</html>
