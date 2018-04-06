<%@ Page Title="Reporte Escolar" Language="C#" AutoEventWireup="true" CodeBehind="ReporteGeneral.aspx.cs" MasterPageFile="~/Themes/NIWeb/NI5.Master" Inherits="NI5sWeb.Modules.Marketing.Escuelas.Reports.ReporteGeneral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #signs{display:none;}
        @media print {
            #ReportPanel table{
                font-size: 6pt;
            }
            #signs {margin-top:100px;display:block;}
            #signs p{
                text-align:center;
                padding: 2px 15px;
                border-top: solid 1px #000;
            }
            .print-hidden{display:none;}
        }
    </style>

    <script>
        var iface = {
            init: function () {
                
                
                $('#selSend').click(iface.getReport);
                $('#btn-print').click(iface.printReport);
            },
            
            //selectDate: function () {
            //    var date = new Date();
            //    $('#selRegion').val();
                
            //},
            //$(document).ready(function() {
            //    $("#List").change(function() {
            //        alert($(this).val());
            //    });
            //})
         
        
            getReport: function () {
                //var lista = $("List").val();
                //alert(lista);
                mp.waitPage('show')
                niw.ajax({ action: 'GetReport' }, iface.ReportGetted);
                mp.waitPage('hide')
            },
            ReportGetted: function(msg){
                $('#ReportPanel').html(msg);
            },
            printReport: function () {
                window.print();
            }
        };

      $(iface.init);
    </script>
  <script type="text/javascript">
      function ShowSelected() {
          /* Para obtener el valor */
          var cod = document.getElementById("List").value;
          alert(cod);

          /* Para obtener el texto */
          var combo = document.getElementById("List");
          var selected = combo.options[combo.selectedIndex].text;
          alert(selected);
      }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row print-hidden">
        <div class="col-sm-3">
            <asp:DropDownList class="form-control  dropdown-toggle" Width="250" id="List" runat="server"></asp:DropDownList>
    
        </div>
        
        <div class="col-sm-3">
            <button type="button" class="form-control btn btn-success" id="selSend">Generar Reporte</button>
        </div>
        <div class="col-sm-3">
            <button type="button" class="form-control btn btn-primary fa fa-print" id="btn-print">Imprimir</button>
        </div>
    </div>
    <div id="printArea">
        <asp:Panel ID="ReportPanel" ClientIDMode="Static" runat="server"></asp:Panel>

        <div class="row" id="signs">
            <div class="col-xs-4">
                <p>Gerente de Mercadotecnia</p>
            </div>
            <div class="col-xs-4">
                <p>Director Comercial</p>
            </div>
            <div class="col-xs-4">
                <p>Gerente de Recursos Humanos</p>
            </div>
        </div>
    </div>
</asp:Content>

