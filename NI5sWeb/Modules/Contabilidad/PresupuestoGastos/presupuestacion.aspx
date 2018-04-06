<%@ Page Title="Presupuesto de Gastos" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="presupuestacion.aspx.cs" Inherits="NI5Web.Modules.Contabilidad.presupuestacion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        
        /*#cuentasList .btn-group {margin: 2px 0; width:100%;}
        #cuentasList .btn:first-child{width:235px;}
        #cuentasList .btn:last-child{width:40px;}
        #presupuestosGral td{text-align:right;}
        #presupuestosGral thead tr{font-weight:bold;}
        #presupuestosGral tbody tr:last-child{font-weight:bold;}*/
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
    <%--<script src="//cdnjs.cloudflare.com/ajax/libs/numeral.js/1.4.5/numeral.min.js"></script>--%>
    <script src="../../../Themes/NIWeb/js/numeral.min.js"></script>
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
                            res += '<tr data-id="' + msg[i].id + '"><td>' + msg[i].nombre + '</td><td>' + numeral(arr[1]).format('0,0,0') + '</td><td>' + numeral(arr[2]).format('0,0,0') + '</td><td>' + numeral(arr[3]).format('0,0,0') + '</td><td>' + numeral(arr[4]).format('0,0,0') + '</td><td>' + numeral(arr[5]).format('0,0,0') + '</td><td>' + numeral(arr[6]).format('0,0,0') + '</td><td>' + numeral(arr[7]).format('0,0,0') + '</td><td>' + numeral(arr[8]).format('0,0,0') + '</td><td>' + numeral(arr[9]).format('0,0,0') + '</td><td>' + numeral(arr[10]).format('0,0,0') + '</td><td>' + numeral(arr[11]).format('0,0,0') + '</td><td>' + numeral(arr[12]).format('0,0,0') + '</td><td>' + numeral(tot).format('0,0,0') + '</td><td><a href="#" class="btn btn-danger"><i class="fa fa-times"></i></a></td></tr>';
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
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].ene)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].feb)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].mar)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].abr)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].may)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].jun)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].jul)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].ago)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].sep)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].oct)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].nov)).format('0,0,0') + '</td>';
                                arr[year2] += '<td>' + numeral(parseFloat(msg[i].div)).format('0,0,0') + '</td>';
                                var total = parseFloat(msg[i].ene) + parseFloat(msg[i].feb) + parseFloat(msg[i].mar) + parseFloat(msg[i].abr) + parseFloat(msg[i].may) + parseFloat(msg[i].jun) + parseFloat(msg[i].jul) + parseFloat(msg[i].ago) + parseFloat(msg[i].sep) + parseFloat(msg[i].oct) + parseFloat(msg[i].nov) + parseFloat(msg[i].dic);
                                arr[year2] += '<th>' + numeral(total).format('0,0,0') + '</th></tr>';
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
                console.info(trs);
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
                            row += '<td>$' + numeral(0).format('0,0,0') + '</td>';
                        }
                    }
                    row += '<td>' + numeral(monto).format('0,0,0') + '</td><td><a href="#" class="btn btn-danger" title="Eliminar Detalle"><i class="fa fa-times"></i></a></td></tr>';
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
            anoPre: null,
            init: function () {
                pageObj.GetAño();
              
                
                $(document).on("change", "#areas", pageObj.getConceptosContables);
                $(document).on("click", "#cuenta",pageObj.open);
               // $(document).on("click", "#cuentasList li a", pageObj.getConceptosContables);
                $(document).on("click", "#myModal .modal-footer button:eq(1)", pageObj.getDetallesParaGuardar);
                $(document).on("click", '#captura table tbody a', pageObj.delDetalle);
                $(document).on("click", "#detalle", pageObj.open);
            },

            GetAño: function () {

                niw.ajax({ action: "getAño" }, function (msg) {
                    msg = JSON.parse(msg);
                    dat = msg[0];
                    anoPre = dat.Year;
                    $('#año').val(dat.Year);
                    $('#YearTitle').text(dat.Year);
                    pageObj.getCeontrocostos();
                    niw.ajax({ action: "GetCentrosDeCostosPresupuestables" }, pageObj.bindCentrosDeCostos);
                });
            },
                  

            open: function (msg) {
                var centro = $('#areas').val();
                var descrip = $('#areas option:selected ').text().split('-')[2];
                //var cuenta = $('#presupuestosGral thead tr').val();
                var row = $(this).parents("tr");
                var id = row.data("id");
                var year = $('#YearTitle').text();
                var cen = centro + descrip;
                window.location = '/Modules/Contabilidad/PresupuestoGastos/CapturaPresupuesto.aspx?Centro=' + cen + '&Cuenta=' + id ;
                //window.open("/Modules/Contabilidad/PresupuestoGastos/CapturaPresupuesto.aspx?Centro=" +centro);
               // <a href="javascript:ventanaSecundaria('http://www.desarrolloweb.com')">
                //location.href = "javascript:ventanaSecundaria('/Modules/Contabilidad/PresupuestoGastos/CapturaPresupuesto.aspx')";
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
                var id = $('#areas').val();
                
                //$('#cuentasList li a').removeClass("btn-success");
                //$(this).addClass("btn-success");
                //mp.waitPage('show');
                niw.ajax({ action: "GetConceptosConTotalesAnuales", id: id }, pageObj.bindConceptosContables);
                pageObj.getPresupuestosMensualesGenerales();
                pageObj.getPresupuestosAnuales();
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
                //dataSrc += '<a href="/Modules/Contabilidad/PresupuestoGastos/CapturaPresupuesto.aspx?Centro=' + centro + '" class="btn btn-info" id="detalle"><span class="fa fa-pencil"></span> Captura de Presupuesto</a>';
                var sumPeriodo = 0;
                for (i = 1; i < msg.length; i++) {
                    dataSrc += '<tr data-id="' + msg[i].cuenta + '"><th id="cuenta">' + msg[i].cuenta + ' - ' + msg[i].nombre + '</th><td>$ ' + numeral(parseFloat(msg[i].real)).format('0,0,0') + '</td><td>$ ' + numeral(parseFloat(msg[i].proyeccion)).format('0,0,0') + '</td><td>$ ' + numeral(parseFloat(msg[i].periodo)).format('0,0,0') + '</td></tr>';
                    sumReal += parseFloat(msg[i].real);

                    sumProyeccion += parseFloat(msg[i].proyeccion);
                    
                    sumPeriodo += parseFloat(msg[i].periodo);
                }
                dataSrc += '<tr><th>TOTAL</th><td>$' + numeral(sumReal).format('0,0,0') + '</td><td>$' + numeral(sumProyeccion).format('0,0,0') + '</td><td>$' + numeral(sumPeriodo).format('0,0,0') + '</td><td></td></tr>';
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
                        if (amount != '0') {
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
            getCeontrocostos: function () {
                var tr = '';
                var sumReal = 0;
                var sumProyeccion = 0;
                var sumPresupuesto = 0;
                var ano = $('#YearTitle').text();
                var head = '<tr><th style="text-align:left">Depto</th><th style="text-align:left">Real ' + (parseInt(ano) - 2) + '</th><th style="text-align:left">Proyeccion' + (parseInt(ano) - 1) + '</th><th style="text-align:left">Presupuesto ' + (parseInt(ano)) + '</th></tr>';
                niw.ajax({ action: "GetCentrosCostos"}, function (msg) {
                    msg = JSON.parse(msg);
                    for (i = 0; i < msg.length; i++)  {
                        tr += '<tr><td style="text-align:left">' + msg[i].Ccto_Id + '  ' + msg[i].Descripcion + '</td><td style="text-align:left"> ' + numeral(parseFloat(msg[i].TTAnterior)).format('0,0,0') + '</td><td style="text-align:left"> ' + numeral(parseFloat(msg[i].TAnterior)).format('0,0,0') + '</td><td style="text-align:left"> ' + numeral(parseFloat(msg[i].TActual)).format('0,0,0') + '</td></tr>';
                         sumReal += parseFloat(msg[i].TTAnterior);

                         sumProyeccion += parseFloat(msg[i].TAnterior);

                         sumPresupuesto += parseFloat(msg[i].TActual);
                    }
                    tr += '<tr><th>TOTAL</th><td style="text-align:left">$' + numeral(sumReal).format('0,0,0') + '</td><td style="text-align:left">$' + numeral(sumProyeccion).format('0,0,0') + '</td><td style="text-align:left">$' + numeral(sumPresupuesto).format('0,0,0') + '</td><td></td></tr>';
                    $('#centroCostoss  thead').html(head);
                    $('#centroCostoss  tbody').html(tr);
                    pageObj.getPresupuestosMensualesGenerales();
                });
            },

            getPresupuestosAnuales: function () {
                niw.ajax({ action: "GetPresupuestosAnuales", acc: $('#areas').val() }, function (msg) {
                    msg = JSON.parse(msg);
                    if (msg.length > 0) {
                        //var centro = $('#areas').val();
                        var row = $('#cuenta').parents("tr");
                        var id = row.data("id");

                        var centro = $('#areas').val();
                        var descrip = $('#areas option:selected ').text().split('-')[2];
                        //var cuenta = $('#presupuestosGral thead tr').val();
                        //var row = $(this).parents("tr");
                        //var id = row.data("id");
                       
                        var cen = centro + descrip;

                        var head = '<a href="/Modules/Contabilidad/PresupuestoGastos/CapturaPresupuesto.aspx?Centro=' + cen +'&Cuenta='+id+'" class="btn btn-info" id="detalle"><span class="fa fa-pencil"></span> Captura de Presupuesto</a>';
                        //alert(msg[0].Real + ' - ' + parseFloat(msg[0].Real));
                        //head += '<tr><th>Real ' + (parseInt(msg[0].Year) - 2) + '</th></tr><tr><th>Proyección ' + (parseInt(msg[0].Year) - 1) + '</th></tr><tr><th>Presupuesto ' + msg[0].Year + '</th></tr><tr><th>Variación %</th></tr>';
                        var tr = '<tr><th>Real ' + (parseInt(msg[0].Year) - 2) + '</th><td>$ '+ numeral(parseFloat(msg[0].Real)).format('0,0,0') + '</td></tr><tr><th>Proyeccion ' + (parseInt(msg[0].Year) - 1) + '</th><td>$ ' + numeral(parseFloat(msg[0].Proyeccion)).format('0,0,0') + '</td></tr><tr><th>Presupuesto '+ msg[0].Year + '</th><td>$ ' + numeral(parseFloat(msg[0].Presupuesto)).format('0,0,0') + '</td></tr><tr><th>Variación %</th><td>'+ numeral(parseFloat(msg[0].Variacion)).format('0,0,0') + ' %</td></tr>';
                       
                      
                        //var tr = '';
                    } else {
                        var head = '<tr><th>Real</th><td>0</td></tr><tr><th>Proyección</th><td>0</td></tr><tr><th>Presupuesto</th><td>0</td></tr><tr><th>Variación %</th><td>0</td></tr>';
                        //var tr = '<tr></tr>';
                    }
                    $('#presupuestosAnuales  thead').html(head);
                    $('#presupuestosAnuales  tbody').html(tr);
                    //$('#presupuestosAnuales tbody').html(tr);
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
                        trs += '<tr><td>' + msg[i].Año + '</td><td>' + numeral(msg[i].Ene).format('0,0,0') + '</td><td>' + numeral(msg[i].Feb).format('0,0,0') + '</td><td>' + numeral(msg[i].Mar).format('0,0,0') + '</td><td>' + numeral(msg[i].Abr).format('0,0,0') + '</td><td>' + numeral(msg[i].May).format('0,0,0') + '</td><td>' + numeral(msg[i].Jun).format('0,0,0') + '</td><td>' + numeral(msg[i].Jul).format('0,0,0') + '</td><td>' + numeral(msg[i].Ago).format('0,0,0') + '</td><td>' + numeral(msg[i].Sep).format('0,0,0') + '</td><td>' + numeral(msg[i].Oct).format('0,0,0') + '</td><td>' + numeral(msg[i].Nov).format('0,0,0') + '</td><td>' + numeral(msg[i].Dic).format('0,0,0') + '</td><td>' + numeral(tot).format('0,0,0') + '</td></tr>';
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
        <h4 class="ano">Presupuesto de Gastos <Label id="YearTitle" ></Label></h4>
    </section>
    <div style="font-size:10px; font-family:Tahoma;">
        <div class="col-md-5 col-lg-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Centro de Costos</h3><br />
                    <select class="form-control" id="areas">
                        <option value="1-11">1-11 - DIRECCION DE OPERACIONES</option>
                        <option value="1-12">1-12 - SEGURIDAD Y ECOLOGIA</option>
                        <option value="1-13">1-13 - INVESTIGACION Y DESARROLLO</option>
                    </select><br />
                    <%--<h3 class="panel-title">Auxiliares de Cuenta</h3>--%>
                </div>
                 <div class="row" style="font-size:10px; width:480px;  font-family:Tahoma;">
        <div class="col-md-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Presupuestos Anuales</h3>
                </div>
                <div class="panel-body table-responsive">
                    <table class="table table-condensed" id="presupuestosAnuales">
                       <thead>
                           <%-- <tr><th>Real 2013</th></tr>
                            <tr><th>Proyección 2014</th></tr>
                            <tr><th>Presupuesto 2015</th></tr>
                            <tr><th>% Variación</th></tr>--%>
                        </thead>
                             <tbody>
                                <tr><td>3,127,911.00</td></tr>
                                <tr><td>3,718,295.00</td></tr>
                                <tr><td>3,621,319</td></tr>
                                <tr><td>-2.60</td></tr>
                             </tbody>
                          
                       
                    </table>
                </div>
            </div>
        </div>
    </div>
              <%--  <div class="panel-body" style="overflow-y:scroll; height:410px;">
                    <ul id="cuentasList">
                        <li>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Buscar" aria-describedby="basic-addon1" />
                                <span class="input-group-addon" id="basic-addon1"><i class="fa fa-search"></i></span>
                            </div>
                        </li>
                    </ul>
                </div>--%>
            </div>
        </div>
        <div class="col-md-7 col-lg-8" id="presupTotalAuxiliar">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Presupuesto total del Auxiliar de Cuenta</h3>
                </div>
                <div class="panel-body table-responsive" style="overflow-y:scroll; height:230px;">
                    <table  class="table table-hover" id="presupuestosGral">
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

          <div class="col-md-7 col-lg-8" id="centroCostos">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Presupuesto por Departamentos</h3>
                </div>
                <div class="panel-body table-responsive" style="overflow-y:scroll; height:230px;">
                    <table class="table table-hover" id="centroCostoss" style="text-align:justify">
                        <thead>
                            <%--<tr><th style="text-align:left">Depto</th><th style="text-align:left">Real</th><th style="text-align:left">Proyeccion</th><th style="text-align:left">Presupuesto</th></tr>--%>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
   
    <div class="row" style="font-size:10px; font-family:Tahoma;">
        <div class="col-md-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">Presupuestos Mensuales Generales</h3>
                </div>
                <div class="panel-body table-responsive" >
                    <table class="table table-striped" id="presupuestosGenerales">
                        <thead>
                            <tr><th>Año</th><th>ENE</th><th>FEB</th><th>MAR</th><th>ABR</th><th>MAY</th><th>JUN</th><th>JUL</th><th>AGO</th><th>SEP</th><th>OCT</th><th>NOV</th><th>DIC</th><th>TOTAL</th></tr>
                        </thead>
                        <tbody>
                            <tr><th>0000</th><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td></tr>
                            <tr><th>0000</th><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td></tr>
                            <tr><th>0000</th><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td><td>0,000,000</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
