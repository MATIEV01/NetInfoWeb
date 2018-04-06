<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Themes/NIWeb/NI5.Master"  CodeBehind="PresupuestodeGatos.aspx.cs" Inherits="NI5sWeb.Modules.Contabilidad.PresupuestoGastos.ReportePresupuestodeGatos" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<script>
        var dat = {
            placeId: null,
            init: function () {
                $(document).on("change", "#selR", dat.Select);
            },
           
            Select: function () {
                var idItem = $(this).val();
                niw.ajax({ action: "Datos", idItem: idItem);
               
            }
      
        $(dat.init);
 </script>
 </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row print-hidden">
         <div class=" col-sm-1 col-lg-offset-1">
          <%--  <asp:DropDownList ID="DropDownList1" CssClass=" dropdown-toggle" runat="server" Width="250px">
                        <asp:ListItem Selected="True" Value="0">Selecciona un Reporte</asp:ListItem>
                        <asp:ListItem Value="1">Direcciones</asp:ListItem>
                        <asp:ListItem Value="2">Departamentos</asp:ListItem>
                        <asp:ListItem Value="3">Compañia</asp:ListItem>
                        
             </asp:DropDownList>--%>
                     <select class="form-control" id="selR">
                        <option value="">Seleccionar  un Reporte</option>
                        <option value="1">Direcciones</option>
                        <option value="2">Departamentos</option>
                        <option value="3">Compañia</option>
                    </select>


                    <div  class=" col-sm-1 col-md-1 col-lg-1" >
                    <th style="border-right:solid 1px #999;">Periodo:</th> 
                    <input id="Periodo"  name="Periodo"  type="text" />
                              
                    <th style="border-right:solid 1px #999;">Desde Direccion:</th> 
                    <input id="DDireccion"  name="DDireccion"  type="text" />
                    <button type="button" class=" btn btn-group" id="DirP"></button>

                     <th style="border-right:solid 1px #999;">Hasta Direccion:</th> 
                     <input id="HDireccion"  name="HDireccion"  type="text" />
                     <button type="button" class=" btn btn-group" id="DirU"></button>

                      <th style="border-right:solid 1px #999;">Desde Departamento:</th> 
                      <input id="DDepartamento"  name="DDepartamento"  type="text" />
                      <button type="button" class=" btn btn-group" id="DepP"></button>

                     <th style="border-right:solid 1px #999;">Hasta Departamento:</th> 
                    <input id="HDepartamento"  name="HDepartamento"  type="text" />
                    <button type="button" class=" btn btn-group" id="DepU"></button>

              <div class="col-sm-3 panel-heading">
                  <button type="button" class=" btn btn-success" id="selSend">Generar Reporte</button>
                  <div class="clear"></div>
              </div>
            </div> 
         </div>    
       
    </div>
    
</asp:Content>




