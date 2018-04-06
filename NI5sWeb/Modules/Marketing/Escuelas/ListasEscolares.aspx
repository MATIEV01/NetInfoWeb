<%@ Page Title="Listas Escolares" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="ListasEscolares.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Escuelas.ListasEscolares" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        
       
        #cuentasList {list-style:none;margin:0;padding:0;}
        #cuentasList li{margin:5px 0;}
        table td{font-size:1em;}
        .content2{margin-top:15px;}
        #cuentasList a{display:block;}

        .input-group{width:100%;}

        #myModal .modal-body {max-height: 300px; overflow-y:auto;}
        #myModal2 .modal-body .row{margin-bottom: 10px;}
        #captura .btn{width:100%;}
        #myModal .modal-body h5{margin: 0;padding:5px 0;font-weight:bold;text-align:center;box-sizing:border-box;}
        table td {text-align:right;}
        table thead th {text-align:right;}
        table thead th.auxiliarConcepto{text-align:left;}
        #comparativa table tr th:last-child{text-align:right;}
    </style>
    <script src="//cdnjs.cloudflare.com/ajax/libs/numeral.js/1.4.5/numeral.min.js"></script>
    <script>
        $(function () {
            $('#myModal').on('show.bs.modal', function (event) {
                var button = $(event.relatedTarget); // Button that triggered the modal
                var name = button.parents('tr').find('th').text();
                var year = $('#presupuestosGral thead th:eq(3)').text();
                var cuenta = button.parents('tr').data('id');
                var depto = cuenta.substring(0,4);

                var modal = $(this);
                modal.find('.modal-title').text('Presupuesto ' + year + ' : ' + name);
                modal.find('.modal-body .depto').text("Centro de Costo: "+depto);
                modal.find('.modal-body .cuenta').text("Cuenta Contable: " + cuenta);

                mp.waitPage("show");
                niw.ajax({ action: "GetDetallesDePresupuestoPorConcepto", id: cuenta, year: year }, function (msg) {
                    if (msg != '0') {
                        msg = JSON.parse(msg);
                        var res = '';
                        for (i = 0; i < msg.length; i++) {
                            var arr = [];
                            var tot = 0;
                            for (j = 0; j < msg[i].montos.length; j++) {
                                arr[msg[i].montos[j].mes] = msg[i].montos[j].monto;
                                tot = tot + parseFloat(msg[i].montos[j].monto);
                            }
                            res += '<tr data-id="' + msg[i].id + '"><td>' + msg[i].nombre + '</td><td>' + numeral(arr[1]).format('0,0,0.00') + '</td><td>' + numeral(arr[2]).format('0,0,0.00') + '</td><td>' + numeral(arr[3]).format('0,0,0.00') + '</td><td>' + numeral(arr[4]).format('0,0,0.00') + '</td><td>' + numeral(arr[5]).format('0,0,0.00') + '</td><td>' + numeral(arr[6]).format('0,0,0.00') + '</td><td>' + numeral(arr[7]).format('0,0,0.00') + '</td><td>' + numeral(arr[8]).format('0,0,0.00') + '</td><td>' + numeral(arr[9]).format('0,0,0.00') + '</td><td>' + numeral(arr[10]).format('0,0,0.00') + '</td><td>' + numeral(arr[11]).format('0,0,0.00') + '</td><td>' + numeral(arr[12]).format('0,0,0.00') + '</td><td>' + numeral(tot).format('0,0,0.00') + '</td><td><a href="#" class="btn btn-danger"><i class="fa fa-times"></i></a></td></tr>';
                        }
                        $('#captura table tbody').html(res);
                    } else {
                        $('#captura table tbody').html('');
                    }

                    niw.ajax({ action: "GetPresupuestosMensualesPorCuenta", acc: cuenta }, function (msg) {
                        msg = JSON.parse(msg);
                        if (msg.length > 0) {
                            var arr = [];
                            for (i = 0; i < msg.length; i++) {
                                var year2 = msg[i].year;
                                arr[year2] = '<tr><th>' + year2 + '</th>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].ene)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].feb)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].mar)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].abr)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].may)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].jun)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].jul)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].ago)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].sep)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].oct)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].nov)).format('0,0,0.00') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].div)).format('0,0,0.00') + '</td>';
                                var total = parseFloat(msg[i].ene) + parseFloat(msg[i].feb) + parseFloat(msg[i].mar) + parseFloat(msg[i].abr) + parseFloat(msg[i].may) + parseFloat(msg[i].jun) + parseFloat(msg[i].jul) + parseFloat(msg[i].ago) + parseFloat(msg[i].sep) + parseFloat(msg[i].oct) + parseFloat(msg[i].nov) + parseFloat(msg[i].dic);
                                arr[year2] += '<th>' + numeral(total).format('0,0,0.00') + '</th></tr>';
                            }
                            year = parseInt(year);
                            var tr = '';
                            for(i = year; i > (year - 3); i--){
                                if (arr[i] != undefined)
                                    tr += arr[i];
                                else {
                                    tr += '<tr><th>' + i + '</th>';
                                    for (j = 0; j < 12; j++)
                                        tr += '<td>0.00</td>';
                                    tr += '<th>0.00</th></tr>'
                                }
                            }
                            $('#comparativa table tbody').html(tr);
                        } else {
                            year = parseInt(year);
                            var tr = '<tr><th>' + (year) + '</th><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><th>0.00</th></tr>';
                            var tr = '<tr><th>' + (year - 1) + '</th><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><th>0.00</th></tr>';
                            var tr = '<tr><th>' + (year - 2) + '</th><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><th>0.00</th></tr>';
                        }
                        mp.waitPage('hide');
                    });
                });
            });
            $(document).on("keyup", '#cuentasList input:eq(0)', function () {
                $('#cuentasList .searchField').hide();
                var str = $(this).val().toUpperCase();
                $("#cuentasList .searchField:contains(" + str + ")").show();
            });
            $(document).on("keyup", '#presupuestosGral thead input', function () {
                var trs = $('#presupuestosGral tbody tr').not('#presupuestosGral tbody tr:last-child');
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#presupuestosGral tbody tr:contains(' + str + ')').show();
            });
            $('#myModal2').on('show.bs.modal', function (event) {
                $(this).find('input').val('');
                $(this).find('select').val('');
            });
            $('#myModal2 .modal-footer button:eq(1)').click(function () {
                var mBody = $(this).parents('.modal').find('.modal-body');
                var concepto = mBody.find('input:eq(0)').val();
                var monto = mBody.find('input:eq(1)').val();
                var months = $('#myModal2 .meses input:checked');
                var tr = [];
                months.each(function (e) {
                    var m = parseInt(parseInt($(this).parent().index()) / 2) + 1;
                    var amount = $(this).parent().find('span').text();
                    tr[m] = amount;
                });
                var row = '<tr class="nr"><td>' + concepto + '</td>';
                if (tr.length > 0) {
                    for (i = 1; i <= 12; i++) {
                        if (tr[i] != undefined) {
                            row += '<td>' + tr[i] + '</td>';
                        } else {
                            row += '<td>$' + numeral(0).format('0,0,0.00') + '</td>';
                        }
                    }
                    row += '<td>' + numeral(monto).format('0,0,0.00') + '</td><td><a href="#" class="btn btn-danger" title="Eliminar Detalle"><i class="fa fa-times"></i></a></td></tr>';
                    $('#captura table tbody').append(row);
                    $(this).parents('.modal').modal('hide');
                } else {
                    dialogs.alert('Todos los campos son requeridos.', null, "Faltan Datos", "Aceptar", "iGwarning");
                }
            });
        });
    </script>
    <script>
        var pageObj = {
            init: function () {
                niw.ajax({ action: "GetCentrosDeCostosPresupuestables" }, pageObj.bindCentrosDeCostos);
                $(document).on("change", "#areas", pageObj.getAuxiliaresDeCuenta);
                $(document).on("click", "#cuentasList li a", pageObj.getConceptosContables);
                $(document).on("click", "#myModal .modal-footer button:eq(1)", pageObj.getDetallesParaGuardar);
                $(document).on("click", '#captura table tbody a', pageObj.delDetalle);
            },
            bindCentrosDeCostos: function (msg) {
                msg = JSON.parse(msg);
                var opcs = '';
                for (i = 0; i < msg.length;i++)
                    opcs += '<option value="' + msg[i].Centro + '">' + msg[i].Centro + ' - ' + msg[i].Descripcion + '</option>';
                $('#areas').html(opcs).change();
            },
            getAuxiliaresDeCuenta: function () {
                var id = $(this).val();
                niw.ajax({ action: "GetAuxiliaresDeCuenta", id: id }, pageObj.bindAuxiliaresDeCuenta);
            },
            bindAuxiliaresDeCuenta: function (msg) {
                msg = JSON.parse(msg);
                var cuentas = $('#cuentasList');
                cuentas.find('.searchField').remove();
                var lis = '';
                for (i = 0; i < msg.length; i++)
                    lis += '<li class="searchField"><a href="#presupTotalAuxiliar" class="btn btn-default" data-area="' + $('#areas').val() + '" data-concepto="' + msg[i].Auxiliar + '" data-auxiliar="' + msg[i].Descripcion + '">' + msg[i].Descripcion + '</a></li>';
                cuentas.html(cuentas.html() + lis);
                pageObj.getPresupuestosAnuales();
            },
            getConceptosContables: function () {
                var id = $(this).data('area');
                var co = $(this).data('concepto');
                $('#cuentasList li a').removeClass("btn-success");
                $(this).addClass("btn-success");
                mp.waitPage('show');
                niw.ajax({ action: "GetConceptosConTotalesAnuales", id: id, concepto: co }, pageObj.bindConceptosContables);
            },
            bindConceptosContables: function (msg) {
                msg = JSON.parse(msg);
                var dataSrc = '';
                var sumReal = 0;
                var sumProyeccion = 0;
                $('#presupuestosGral thead th:eq(0)').text("Concepto");
                $('#presupuestosGral thead th:eq(1)').text(msg[0].real);
                $('#presupuestosGral thead th:eq(2)').text(msg[0].proyeccion);
                $('#presupuestosGral thead th:eq(3)').text(msg[0].periodo);
                var sumPeriodo = 0;
                for (i = 1; i < msg.length; i++) {
                    dataSrc += '<tr data-id="' + msg[i].cuenta + '"><th>' + msg[i].cuenta + ' - ' + msg[i].nombre + '</th><td>$ ' + numeral(parseFloat(msg[i].real)).format('0,0,0.00') + '</td><td>$ ' + numeral(parseFloat(msg[i].proyeccion)).format('0,0,0.00') + '</td><td>$ ' + numeral(parseFloat(msg[i].periodo)).format('0,0,0.00') + '</td><td><a href="#" class="btn btn-info" data-toggle="modal" data-target="#myModal"><span class="fa fa-pencil"></span> Detalles</a></td></tr>';
                    sumReal += parseFloat(msg[i].real);

                    sumProyeccion += parseFloat(msg[i].proyeccion);
                    
                    sumPeriodo += parseFloat(msg[i].periodo);
                }
                dataSrc += '<tr><th>TOTAL</th><td>$' + numeral(sumReal).format('0,0,0.00') + '</td><td>$' + numeral(sumProyeccion).format('0,0,0.00') + '</td><td>$' + numeral(sumPeriodo).format('0,0,0.00') + '</td><td></td></tr>';
                $('#presupuestosGral tbody').html(dataSrc);
                mp.waitPage('hide');
            },
            getDetallesParaGuardar: function () {
                //Obtener los nuevos registros
                var sender = '';
                $('#captura table tr.nr').each(function () {
                    //Cabecera del detalle
                    var byear = $('#presupuestosGral thead th:eq(3)').text();
                    var dname = $(this).find('td:eq(0)').text();
                    var fsacc = $('#myModal .modal-body .cuenta').text().substring(17);
                    //var total = $(this).find('td:eq(13)').text();
                    sender += '|' + byear + ';' + dname + ';' + fsacc + ';' + 0 + '¬';
                    var sender2 = '';
                    //detalles por mes
                    for (i = 1; i < 13; i++) {
                        var amount = parseFloat(($(this).find('td:eq(' + i + ')').text()).substring(1));
                        if (amount != '0.00') {
                            sender2 += '>' + i + ';' + amount;
                        }
                    }
                    sender += sender2.substring(1);
                });
                //alert(sender);
                var t = $('#captura table');
                if (t.data('dels') != undefined) {
                    niw.ajax({ action: "DelDetallesDePresupuestoPorConcepto", cadena: t.data('dels') }, function (msg) {
                        if (msg == 1) {
                            if ($('#captura table tr.nr').length > 0)
                                niw.ajax({ action: "SetDetallesDePresupuestoPorConcepto", cadena: sender.substring(1) }, pageObj.saveDetalles);
                            else {
                                var cuenta = $('#myModal .modal-body .cuenta').text().substring(16);
                                var co = cuenta.substring(0, 11);
                                $('#cuentasList a[data-concepto = ' + co + ']').click();
                            }
                        } else {
                            dialogs.alert('Hubo un error al eliminar algun detalle, por favor intente de nuevo', null, "Error", "Aceptar", "iGdanger");
                        }
                    });
                } else {
                    if ($('#captura table tr.nr').length > 0)
                        niw.ajax({ action: "SetDetallesDePresupuestoPorConcepto", cadena: sender.substring(1) }, pageObj.saveDetalles);
                }
            },
            delDetalle: function () {
                var tr = $(this).parents('tr');
                var id = tr.data('id');
                if(id != undefined){
                    var t = $('#captura table');
                    if (t.data('dels') == undefined)
                        t.data('dels', id);
                    else
                        t.data('dels', t.data('dels') + ',' + id);
                }
                tr.remove();
            },
            saveDetalles: function (msg) {
                if (msg == 1)
                    dialogs.alert("El detalle del presupuesto se ha guardado satisfactoriamente", function () {
                        var cuenta = $('#myModal .modal-body .cuenta').text().substring(16);
                        var co = cuenta.substring(0, 11);
                        $('#cuentasList a[data-concepto = ' + co + ']').click();
                    }, "Correcto", "Aceptar", "iGsuccess");
                else
                    dialogs.alert("Lo sentimos, hubo un error al guardar el detalle. Intente de nuevo.", null, "Error", "Aceptar", "iGdanger");
            },
            getPresupuestosAnuales: function () {
                niw.ajax({ action: "GetPresupuestosAnuales", acc: $('#areas').val() }, function (msg) {
                    msg = JSON.parse(msg);
                    if (msg.length > 0) {
                        alert(msg[0].Real + ' - ' + parseFloat(msg[0].Real));
                        var head = '<tr><th>Real ' + (parseInt(msg[0].Year) - 2) + '</th><th>Proyección ' + (parseInt(msg[0].Year) - 1) + '</th><th>Presupuesto ' + msg[0].Year + '</th><th>Variación %</th></tr>';
                        var tr = '<tr><td>$ ' + numeral(parseFloat(msg[0].Real)).format('0,0,0.00') + '</td><td>$ ' + numeral(parseFloat(msg[0].Proyeccion)).format('0,0,0.00') + '</td><td>$ ' + numeral(parseFloat(msg[0].Presupuesto)).format('0,0,0.00') + '</td><td>' + numeral(parseFloat(msg[0].Variacion)).format('0,0,0.00') + ' %</td></tr>';
                    } else {
                        var head = '<tr><th>Real</th><th>Proyección</th><th>Presupuesto</th><th>Variación %</th></tr>';
                        var tr = '<tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>';
                    }
                    $('#presupuestosAnuales thead').html(head);
                    $('#presupuestosAnuales tbody').html(tr);
                    pageObj.getPresupuestosMensualesGenerales();
                });
            },
            getPresupuestosMensualesGenerales: function(){
                niw.ajax({ action: "GetPresupuestosMensualesGenerales", acc: $('#areas').val() }, function (msg) {
                    msg = JSON.parse(msg);
                    var trs = '';
                    for (i = 0; i < msg.length; i++) {
                        if (msg[i].Año == '') msg[i].Año = 0;
                        if (msg[i].Ene == '') msg[i].Ene = 0;
                        if (msg[i].Feb == '') msg[i].Feb = 0;
                        if (msg[i].Mar == '') msg[i].Mar = 0;
                        if (msg[i].Abr == '') msg[i].Abr = 0;
                        if (msg[i].May == '') msg[i].May = 0;
                        if (msg[i].Jun == '') msg[i].Jun = 0;
                        if (msg[i].Jul == '') msg[i].Jul = 0;
                        if (msg[i].Ago == '') msg[i].Ago = 0;
                        if (msg[i].Sep == '') msg[i].Sep = 0;
                        if (msg[i].Oct == '') msg[i].Oct = 0;
                        if (msg[i].Nov == '') msg[i].Nov = 0;
                        if (msg[i].Dic == '') msg[i].Dic = 0;
                        var tot = parseFloat(msg[i].Ene) + parseFloat(msg[i].Feb) + parseFloat(msg[i].Mar) + parseFloat(msg[i].Abr) + parseFloat(msg[i].May) + parseFloat(msg[i].Jun) + parseFloat(msg[i].Jul) + parseFloat(msg[i].Ago) + parseFloat(msg[i].Sep) + parseFloat(msg[i].Oct) + parseFloat(msg[i].Nov) + parseFloat(msg[i].Dic);
                        trs += '<tr><td>' + msg[i].Año + '</td><td>' + numeral(msg[i].Ene).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Feb).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Mar).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Abr).format('0,0,0.00') + '</td><td>' + numeral(msg[i].May).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Jun).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Jul).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Ago).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Sep).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Oct).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Nov).format('0,0,0.00') + '</td><td>' + numeral(msg[i].Dic).format('0,0,0.00') + '</td><td>' + numeral(tot).format('0,0,0.00') + '</td></tr>';
                    }
                    $('#presupuestosGenerales tbody').html(trs);
                });
            }
        };
        $(pageObj.init);
    </script>
    <script>
        //nuevos código agregados
        var newCode = {
            init: function () {
                $(document).on('change', '#mDesde', newCode.meses);
                $(document).on('change', '#mHasta', newCode.meses);
                $(document).on('click', '#myModal2 .meses input', newCode.quitMonth);
            },
            meses: function () {
                var d = parseInt($('#mDesde').val());
                var h = parseInt($('#mHasta').val());

                if (d != '' && h != '') {
                    $('#myModal2 .meses input').prop('checked', false);
                    $('#myModal2 .meses span').text('');
                    var divisor = (h - d) + 1;
                    dividendo = parseInt($('#myModal2 input[placeholder=Monto]').val());
                    for (i = d; i <= h; i++) {
                        $('#myModal2 .meses label:eq(' + (i - 1) + ')').find('input').prop('checked', true);
                        $('#myModal2 .meses label:eq(' + (i - 1) + ')').find('span').text('$ ' + numeral((dividendo / divisor)).format('0,0,0.00'));

                    }
                }
            },
            quitMonth: function () {
                //if (!$(this).is(':checked')) {
                    var d = parseInt($('#mDesde').val());
                    var h = parseInt($('#mHasta').val());

                    $('#myModal2 .meses label span').text('');

                    var divisor = $('#myModal2 .meses input:checked').length;
                    dividendo = parseInt($('#myModal2 input[placeholder=Monto]').val());

                    $('#myModal2 .meses input:checked').each(function (e) {
                        $(this).parent().find('span').text('$ ' + (dividendo / divisor));
                    });
                //}
            }
        };
        $(newCode.init);
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="header">
        <h4>Precios de Listas Escolares <asp:Label ID="YearTitle" runat="server" Text=""></asp:Label></h4>
    </section>
    <div class="row content2">
        <div class="col-md-5 col-lg-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Promotor</h3><br />
                    <select class="form-control" id="areas">
                    </select><br />
                    <h3 class="panel-title">Escuelas</h3>
                </div>
                <div class="panel-body">
                    <ul id="cuentasList">
                        <li>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Buscar" aria-describedby="basic-addon1" />
                                <span class="input-group-addon" id="basic-addon1"><i class="fa fa-search"></i></span>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-7 col-lg-8" id="presupTotalAuxiliar">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Presupuesto total del Auxiliar de Cuenta</h3>
                </div>
                <div class="panel-body table-responsive">
                    <table class="table table-hover" id="presupuestosGral">
                        <thead>
                            <tr>
                                <td colspan="5">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="Buscar" />
                                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                    </div>
                                </td>
                            </tr>
                            <tr><th class="auxiliarConcepto">Seleccione Un Auxiliar de Cuenta</th><th></th><th></th><th></th><th></th></tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
   
    
    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                </div>
                <div class="modal-body">
                    <div class="row"><div class="col-md-6 depto"></div><div class="col-md-6 cuenta"></div></div>
                    <div>
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active"><a href="#captura" aria-controls="captura" role="tab" data-toggle="tab">Captura de Presupuesto</a></li>
                            <li role="presentation"><a href="#comparativa" aria-controls="comparativa" role="tab" data-toggle="tab">Comparativa Anual</a></li>
                            <li role="presentation"><a href="#movimientos" aria-controls="movimientos" role="tab" data-toggle="tab">Detalle de Movimientos</a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane active" id="captura">
                                <div class="row">
                                    <h5>Conceptos Presupuestados</h5>
                                    <div class="col-md-12">
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr><th></th><th>ENE</th><th>FEB</th><th>MAR</th><th>ABR</th><th>MAY</th><th>JUN</th><th>JUL</th><th>AGO</th><th>SEP</th><th>OCT</th><th>NOV</th><th>DIC</th><th>TOTALES</th><td></td></tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                            </table>
                                        </div><br />
                                        <a href="#" class="btn btn-info" data-toggle="modal" data-target="#myModal2"><span class="fa fa-plus"></span> Añadir Detalle</a>
                                    </div>
                                </div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="comparativa">
                                <div class="row">
                                    <div class="col-md-12">
                                        <h5>Comparativa Anual</h5>
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead><tr><th></th><th>ENE</th><th>FEB</th><th>MAR</th><th>ABR</th><th>MAY</th><th>JUN</th><th>JUL</th><th>AGO</th><th>SEP</th><th>OCT</th><th>NOV</th><th>DIC</th><th>TOTALES</th></tr></thead>
                                                <tbody>
                                                    <tr><th>2014</th><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><th>0.00</th></tr>
                                                    <tr><th>2015</th><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><th>0.00</th></tr>
                                                    <tr><th>2016</th><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><td>0.00</td><th>0.00</th></tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="movimientos">
                                <div class="row">
                                    <div class="col-md-12">
                                        <h5>Comparativa Anual</h5>
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr><th>Periodo</th><th>Póliza</th><th>Sec.</th><th>Origen</th><th>Descrpción</th><th>Total</th></tr>
                                                </thead>
                                                <tbody>
                                                    <tr><th>1</th><td>121951</td><td>$ <span>0,000,000.00</span></td><td>30</td><td>APID</td><td>PS2212 44 DEUTSCHE BANK ME*</td><td>724.70</td></tr>
                                                    <tr><th>1</th><td>121951</td><td>$ <span>0,000,000.00</span></td><td>30</td><td>APID</td><td>PS2212 44 DEUTSCHE BANK ME*</td><td>724.70</td></tr>
                                                    <tr><th>1</th><td>121951</td><td>$ <span>0,000,000.00</span></td><td>30</td><td>APID</td><td>PS2212 44 DEUTSCHE BANK ME*</td><td>724.70</td></tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    
                    
                    <div class=""></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary">Guardar Presupuesto</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal 2 -->
    <div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-sm" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Agregar Concepto</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">
                            <input type="text" class="form-control" id="mDetalle" placeholder="Detalle" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="input-group">
                                <span class="input-group-addon">$</span>
                                <input type="text" class="form-control" aria-label="Amount" placeholder="Monto" />
                                <span class="input-group-addon">.00</span>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            Distribuido:
                        </div>
                    </div>

                    <div class="row">
                        <div class="meses col-xs-12">
                            <label><input type="checkbox" /> Enero <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Febrero <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Marzo <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Abril <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Mayo <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Junio <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Julio <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Agosto <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Septiembre <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Octubre <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Noviembre <span>$ 00.00</span></label><br />
                            <label><input type="checkbox" /> Diciembre <span>$ 00.00</span></label><br />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary">Agregar Concepto</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

