<%@ Page Title="Análisis de Presupuestos" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="analisisPresupuesto.aspx.cs" Inherits="NI5sWeb.Modules.Contabilidad.PresupuestoGastos.analisisPresupuesto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #presupuestosAnuales td{font-size: .8em;}
        #presupuestosAnuales td:nth-child(1),#presupuestosAnuales td:nth-child(3),#presupuestosAnuales td:nth-child(4),#presupuestosAnuales td:nth-child(5),#presupuestosAnuales td:nth-child(6){text-align:right;}
        .presupuestosGenerales td{font-size: .8em;}
        .presupuestosGenerales th{font-size: .8em;}
        .presupuestosGenerales th.title{text-align:center;font-weight:100;}
        .presupuestosGenerales th span{font-weight:600;}
        .presupuestosGenerales td{text-align:right;}
        #detalles .modal-body table tbody tr td:nth-child(2n) input{text-align:right;}
    </style>
    <script src="//cdnjs.cloudflare.com/ajax/libs/numeral.js/1.4.5/numeral.min.js"></script>
    <script>
        var iface = {
            dtl: null,
            init: function () {
                $(document).on("click", '.presupuestosGenerales td', iface.selectCellMonth);
            },
            selectCellMonth: function () {
                var parent = $(this).parent();
                var table = parent.parent().parent();
                var tit = table.find('thead tr:eq(0) th').text();
                if (parent.index() == 0 && $(this).index() < 13) {
                    iface.dtl = $(this);
                    $('#detalles .titTxt').text(tit);
                    $('#detalles').modal("show");
                }
            }
        };
        $(iface.init);

        //Functionality
        var po = {
            init: function () {
                $(document).on("click", '#presupuestosAnuales td', po.showCenterData);
                $('#detalles').on('show.bs.modal', po.getDetails);
                $(document).on("click", "#saveNewBudget", po.sendNewBudget)
            },
            showCenterData: function () {
                var parent = $(this).parent();
                var ccId = parent.find("td:eq(0)").text();
                mp.waitPage("show");
                niw.ajax({ action: 'GetCenterData', ccId: ccId }, function (msg) {
                    $('#BudgetsData').html(msg);
                    mp.waitPage("hide");
                    window.location.href = '#BudgetsData';
                }, function () {
                    mp.waitPage("hide");
                });
            },
            getDetails: function (evt) {
                mp.waitPage("show");
                var dtl = iface.dtl;
                var parent = dtl.parent();
                var y = parent.find("th").text();
                var tableHead = parent.parent().parent().find("thead");
                var tr1 = tableHead.find("tr:eq(0)");
                var tr2 = tableHead.find("tr:eq(1)");
                var acc = tr1.find("th span").text();
                var m = po.convertMonth(tr2.find("th:eq(" + (dtl.index()) + ")").text());
                niw.ajax({ action: "GetBudgetMonthDetails", acc: acc, y: y, m: m }, function (msg) {
                    if (msg != "0") {
                        msg = JSON.parse(msg);
                        var tr = '';
                        for (i = 0; i < msg.length; i++) {
                            tr += '<tr><td>' + msg[i].Detail + '</td><td><input type="text" class="form-control" data-id="' + msg[i].DetailId + '" data-amount="' + msg[i].Amount + '" value="' + msg[i].Amount + '"/></td></tr>';
                        }
                    } else {
                        var tr = '<tr><td><input type="text" placeholder="Nuevo Detalle" /></td><td><input type="text" placeholder="0.00" /></td></tr>';
                    }
                    $('#detalles .modal-body table tbody').html(tr);
                    mp.waitPage("hide");
                });
            },
            convertMonth: function (m) {
                switch (m) {
                    case "ENE": return 1; break;
                    case "FEB": return 2; break;
                    case "MAR": return 3; break;
                    case "ABR": return 4; break;
                    case "MAY": return 5; break;
                    case "JUN": return 6; break;
                    case "JUL": return 7; break;
                    case "AGO": return 8; break;
                    case "SEP": return 9; break;
                    case "OCT": return 10; break;
                    case "NOV": return 11; break;
                    case "DIC": return 12; break;
                }
            },
            sendNewBudget: function () {
                mp.waitPage("show");
                var trs = $("#detalles .modal-body table tbody tr");
                var jsonSender = "";
                var sum = 0.00;
                var i = 0;
                trs.each(function () {
                    var input = $(this).find('input');
                    var val = input.val();
                    sum = parseFloat(sum) + parseFloat(val);
                    if (input.data("amount") != val) {
                        if (i > 0)
                            jsonSender += ',';
                        var id = input.data('id');
                        jsonSender += id + ';' + val;
                        i++;
                    }
                });
                if (jsonSender != "") {
                    niw.ajax({ action: "ChangeBudget", dat: jsonSender }, function (msg) {
                        if (msg == "1") {
                            dialogs.alert("Se han guardado los cambios satifactoriamente.", null, "Cambio Realizado", "Aceptar", "iGsuccess");
                            iface.dtl.text(numeral(sum).format('0,0,0.00'));//change month value
                            //Change total value
                            var tr = iface.dtl.parent();
                            var sumt = 0.00;
                            tr.find('td').each(function (j) {
                                if (j != 12) {
                                    var v = $(this).text().replace(/,/, "");
                                    sumt = parseFloat(sumt) + parseFloat(v);
                                }
                            });
                            tr.find("td:eq(12)").text(numeral(sumt).format('0,0,0.00'));
                            $('#detalles').modal("hide");
                        } else {
                            dialogs.alert("No se pudieron realizar los cambios completos. Por favor, verifique los datos e intente de nuevo.", null, "Cambio NO Realizado", "Aceptar", "iGdanger");
                        }

                        mp.waitPage("hide");
                    }, function () {
                        mp.waitPage("hide");
                    });
                } else {
                    mp.waitPage("hide");
                }
            }
        };
        $(po.init);
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h2>Análisis de Presupuestos<br /><small>Administrar los Presupuestos de Gastos</small></h2>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Gastos Anuales</h3>
                </div>
                <asp:Panel ID="presupuestosAnualesPanel" ClientIDMode="Static" CssClass="panel-body table-responsive" runat="server"></asp:Panel>
            </div>
        </div>
    </div>
    <div class="row">
        <asp:Panel ID="BudgetsData" ClientIDMode="Static" CssClass="col-md-12" runat="server"></asp:Panel>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="detalles" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">DETALLES <span class="titTxt"></span></h4>
                </div>
                <div class="modal-body">
                    <table class="table table-hover">
                        <thead>
                            <tr><th>Detalle</th><th>Presupuesto</th></tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                    <a href="#" class="btn btn-success"><i class="fa fa-plus"></i> Agregar Detalle</a>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary" id="saveNewBudget">Guardar Cambios</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
