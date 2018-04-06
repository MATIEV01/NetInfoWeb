<%@ Page Title="Reporte de Productos" Language="C#" AutoEventWireup="true" MasterPageFile="~/Themes/NIWeb/NI5.Master" CodeBehind="ProductsReport.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Escuelas.Reports.ProductsReport" %>

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
            
            selectDate: function () {
                var date = new Date();
                $('#selRegion').val();
                
            },
            getReport: function () {
                var region = $('#selRegion').val();
                

                niw.ajax({ action: 'GetReport', region: region }, iface.ReportGetted);
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row print-hidden">
        <div class="col-sm-3">
            <select class="form-control" id="selRegion">
                <option value="">Seleccionar la Region</option>
                <option value="Centro">Centro</option>
                <option value="Norte">Norte</option>
                <option value="Occidente">Occidente</option>
                <option value="Sureste">Sureste</option>
            </select>
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
