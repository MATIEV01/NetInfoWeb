<%@ Page Title="Reporte de Objetivos " Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="ObjetivesReportA.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Promotores.Reports.ObjetivesReportA" %>
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

        table th {
            text-align:center;
        }
    </style>

  
    <script>
        var iface = {
            init: function () {
                iface.bindYears();
                iface.selectDate();
                $('#selSend').click(iface.getReport);
                //$('#btn-print').click(iface.printReport);
            },
            bindYears: function () {
                var date = new Date();
                var res = '<option value="">Seleccionar Año</option>';
                for (i = 2015; i <= date.getFullYear() ; i++)
                    res += '<option value="' + i + '">' + i + '</option>';
                $('#selYear').html(res);
            },
            selectDate: function () {
                var date = new Date();
                $('#selMonth').val(date.getMonth()+1);
                $('#selYear').val(date.getFullYear());
            },
            getReport: function () {
                var month = $('#selMonth').val();
                var year = $('#selYear').val();

                niw.ajax({ action: 'GetReport', month: month, year: year }, iface.ReportGetted);
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
            <select class="form-control" id="selMonth">
                <option value="">Seleccionar el Mes</option>
                <option value="1">Enero</option><option value="2">Febrero</option><option value="3">Marzo</option>
                <option value="4">Abril</option><option value="5">Mayo</option><option value="6">Junio</option>
                <option value="7">Julio</option><option value="8">Agosto</option><option value="9">Septiembre</option>
                <option value="10">Octubre</option><option value="11">Noviembre</option><option value="12">Diciembre</option>
            </select>
        </div>
        <div class="col-sm-3">
            <select class="form-control" id="selYear"></select>
        </div>
        <div class="col-sm-3">
            <button type="button" class="form-control btn btn-success" id="selSend">Generar Reporte</button>
        </div>
        <div class="col-sm-3">
            <button onclick="jQuery.print('#ReportPanel')" type="button" class="form-control btn btn-primary fa fa-print" id="btn-print">Imprimir</button>
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