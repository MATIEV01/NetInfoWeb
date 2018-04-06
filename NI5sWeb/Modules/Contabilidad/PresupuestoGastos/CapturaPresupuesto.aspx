<%@ Page Title="Captura Presupuesto" Language="C#" AutoEventWireup="true" MasterPageFile="~/Themes/NIWeb/NI5.Master" CodeBehind="CapturaPresupuesto.aspx.cs" Inherits="NI5sWeb.Modules.Contabilidad.PresupuestoGastos.CapturaPresupuesto" %>

<%@ PreviousPageType VirtualPath="~/Modules/Contabilidad/PresupuestoGastos/presupuestacion.aspx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #cuentasList {
            list-style: none;
            margin: 0;
            padding: 0;
        }

            #cuentasList li {
                margin: 5px 0;
            }

        table td {
            font-size: 1em;
        }

        .content2 {
            margin-top: 15px;
        }

        #cuentasList a {
            display: block;
        }

        .input-group {
            width: 100%;
        }

        /*#myModal .modal-body {
            max-height: 300px;
            overflow-y: auto;
        }*/

        #myModal2 .modal-body .row {
            margin-bottom: 10px;
        }

        #myModal2 .modal-body {
            max-height: 300px;
            overflow-y: auto;
        }

        /*#captura .btn {
            width: 100%;
        }*/

        /*#myModal .modal-body h5 {
            margin: 0;
            padding: 5px 0;
            font-weight: bold;
            text-align: center;
            box-sizing: border-box;
        }*/

        table td {
            text-align: right;
        }

        table thead th {
            text-align: right;
        }

            table thead th.auxiliarConcepto {
                text-align: left;
            }

        #comparativa table tr th:last-child {
            text-align: right;
        }
    </style>
    <%--<script src="//cdnjs.cloudflare.com/ajax/libs/numeral.js/1.4.5/numeral.min.js"></script>--%>
    <script src="../../../Themes/NIWeb/js/numeral.min.js"></script>
    <script>
    
        $(function () {

         

            $(document).on("keyup", '#buscar', function () {
                var trs = $('#areas option').not('#areas option:last-child');
                //console.info(trs);
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#areas option:contains(' + str + ')').show();
            });



            $(document).on("keyup", '#cuentasList input:eq(0)', function () {
                $('#cuentasList .searchField').hide();
                var str = $(this).val().toUpperCase();
                $("#cuentasList .searchField:contains(" + str + ")").show();
            });
            $(document).on("keyup", '#captura thead input', function () {
                var trs = $('#captura tbody tr').not('#captura tbody tr:last-child');
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#captura tbody tr:contains(' + str + ')').show();
            });
            $('#myModal2').on('show.bs.modal', function (event) {
                $(this).find('input').val('');
                $(this).find('select').val('');

                //$('#mDetalle').focus();
            });

            $(document).on('keydown', '#myModal2 .modal-body input', function (e) {

                var mBody = $(this).parents('.modal').find('.modal-body');
                if (e.keyCode == 13) {

                    var field = $(this);

                    var idx = parseInt($("input").index(field));

                    var input = mBody.find('input:eq(' + idx + ')');

                    if (input != undefined) {
                        input.focus();
                        input.select();
                        e.preventDefault();
                    }

                    return false;
                }

            });


            $('#myModal2').on('shown.bs.modal', function () {
                $('#mDetalle').focus();
            });

            var inputQuantity = [];
            $(function () {
                $(".validNumber").each(function (i) {
                    inputQuantity[i] = this.defaultValue;
                    $(this).data("idx", i); // save this field's index to access later
                });
                $(".validNumber").on("keyup", function (e) {
                    var $field = $(this),
                        val = this.value,
                        $thisIndex = parseInt($field.data("idx"), 10); // retrieve the index
                    //        window.console && console.log($field.is(":invalid"));
                    //  $field.is(":invalid") is for Safari, it must be the last to not error in IE8
                    if (this.validity && this.validity.badInput || isNaN(val) || $field.is(":invalid")) {
                        this.value = inputQuantity[$thisIndex];
                        return;
                    }
                    if (val.length > Number($field.attr("maxlength"))) {
                        val = val.slice(0, 2);
                        $field.val(val);
                    }
                    inputQuantity[$thisIndex] = val;
                });
            });

            var getMeses = function (inicio, fin) {
                var salida = '';
                fin = parseInt(fin) + 1;
                for (i = inicio; i < fin; i++) {
                    salida = salida + i + ',';
                }
                salida = salida.substring(0, salida.length - 1);
                return salida;
            }

            var patern = /^[0-9]+$/;
            //var patern1 = /^[-][0-9]+$/;
            ////var paternDetalle = /^[1-9A-Za-z][:space:]+$/;
            ////var paternDetalle = /^[a-zA-Z ]+$/;
            //$(".validamonto").on('paste, keyup', function (e) {
            //    var $self = $(this);
            //    if ($self.val().match(patern1)) {
            //        console.info('es correcta')
            //    } else {
            //        console.info("incorecto!!!");
            //        $(this).val('');
            //        setTimeout(function () {
            //            $("#itemDiv").remove();
            //        }, 3000);
            //        //var auxDiv = $("<div id='itemDiv'> Solo es permitido números</div>");
                    
                   
            //    }
            //});

            $(".validNumber").on('paste, keyup', function (e) {
                var $self = $(this);
                if ($self.val().match(patern)) {
                    console.info('es correcta')
                } else {
                    console.info("incorecto!!!");
                    $(this).val('');
                    setTimeout(function () {
                        $("#itemDiv").remove();
                    }, 3000);
                    //var auxDiv = $("<div id='itemDiv'> Solo es permitido números</div>");
                    auxDiv.css({ 'color': 'red', });
                    $('.meses').append(auxDiv);
                }
            });

            $('#EditModal .modal-body input').keypress(function (event) {

                if (event.keyCode == 13 || event.keyCode == 9)
                {
                    var input = $('#EditModal .modal-body input');
                    var concepto = $('#concepto').val();
                    var ene = parseFloat(input.eq(0).val());
                    var feb = parseFloat(input.eq(1).val());
                    var mar = parseFloat(input.eq(2).val());
                    var abr = parseFloat(input.eq(3).val());
                    var may = parseFloat(input.eq(4).val());
                    var jun = parseFloat(input.eq(5).val());
                    var jul = parseFloat(input.eq(6).val());
                    var ago = parseFloat(input.eq(7).val());
                    var sep = parseFloat(input.eq(8).val());
                    var oct = parseFloat(input.eq(9).val());
                    var nov = parseFloat(input.eq(10).val());
                    var dic = parseFloat(input.eq(11).val());
                    var total = ene + feb + mar + abr + may + jun + jul + ago + sep + oct + nov + dic;

                    input.eq(12).val(total);
                }
                

            });

            $('#myModal2 .modal-footer button:eq(0)').click(function (event) {
                event.preventDefault();
                $(".validNumber").each(function (index, item) {
                    if ($(item).val() != "") {
                        $(this).css('border', '');
                    } else {
                        $(this).css({ 'border': 'solid red 1px' });

                    }
                });


                var mBody = $(this).parents('.modal').find('.modal-body');
                var concepto = mBody.find('input:eq(0)').val();
                var monto = mBody.find('input:eq(1)').val();
                var months1 = $('#mDesde').val();//modificacion
                var months2 = $('#mHasta').val();//modificacion

                if (concepto != "" && monto != " " && months1 != " " && months2 != " " && monto != 0) {

                    if (parseInt(months1) <= parseInt(months2)) {

                        var a = getMeses(months1, months2);

                        var months = a.split(',');
                        console.info(months);
                        var tr = [];
                        var divisor = (months2 - months1) + 1;
                        dividendo = parseInt($('#myModal2 input[placeholder=Monto]').val());

                        $('#myModal2 .meses input').each(function (e) {
                            $(this).parent().find('span').text('$ ' + (dividendo / divisor));

                        });

                        var Total = parseInt(dividendo / divisor) * divisor;

                        var yea = document.getElementById("conceptos").rows.length;
                        var fila = $("<tr class='nr' id='fila" + yea + "'><td>" + yea + "</td><td  style='word-wrap: break-word;min-width: 160px;max-width: 160px; text-align :left; '>" + concepto + "</td>" +
                            "<td  class='mes' id='f" + yea + "Mes1'> 0 </td><td class='mes' id='f" + yea + "Mes2'> 0 </td><td class='mes' id='f" + yea + "Mes3'> 0 </td><td class='mes' id='f" + yea + "Mes4'> 0 </td><td class='mes' id='f" + yea + "Mes5'> 0 </td><td class='mes' id='f" + yea + "Mes6'> 0 </td>" +
                            "<td class='mes' id='f" + yea + "Mes7'> 0 </td><td class='mes' id='f" + yea + "Mes8'> 0 </td><td class='mes' id='f" + yea + "Mes9'> 0 </td><td class='mes' id='f" + yea + "Mes10'> 0 </td><td class='mes' id='f" + yea + "Mes11'> 0 </td><td class='mes' id='f" + yea + "Mes12'> 0 </td>" +
                             "<td id='monto'>" + numeral(Total).format('0,0,0') + "</td><td class='eliminar' ><a href='#' class='btn btn-danger' title='Eliminar Detalle'><i class='fa fa-times'></i></a></td></tr>");

                        console.info(months.length);
                        if (months.length > 0) {
                            for (var monthsLengh = 0; monthsLengh < months.length; monthsLengh++) {
                                $(fila).find('#f' + yea + 'Mes' + months[monthsLengh]).html(numeral((dividendo / divisor)).format('0,0,0'));//css('border', 'solid red');
                                console.info(months[monthsLengh]);

                            }
                            $('#captura table tbody').append(fila);
                            $(this).parents('.modal').modal('hide');
                            $(this).parent().find('span').text('0.0');
                            pageObj.setTotalPresupuestado();
                           


                        } else {
                            dialogs.alert('Todos los campos son requeridos.', null, "Faltan Datos", "Aceptar", "iGwarning");
                        }
                    }
                    else {
                        dialogs.alert('El Mes Desde no debe ser Mayor al Mes Hasta', null, "Distribucion Incorrecta", "Aceptar", "iGwarning");
                    }
                }

                else {
                    dialogs.alert('Todos los campos son requeridos.', null, "Faltan Datos", "Aceptar", "iGwarning");
                }
            });
        });
    </script>


    <script>
        var pageObj = {
            LineaSelected: null,
            TrSeleccionado : null,
            Cuenta: null,
            anoPre:null,
            init: function () {
                pageObj.GetAño();
                
           
                

                niw.ajax({ action: "GetCentrosDeCostosPresupuestables" }, pageObj.bindCentrosDeCostos);
                //$(document).on("click", "#areas", pageObj.getconcepto);
                $("#areas").click(function () {
                    mp.waitPage('show');
                    //document.body.style.cursor = 'wait';
                    //document.getElementById('areas').style.cursor = 'wait';
                    pageObj.getconcepto();
                    

                });

                //$("#areas").on("click", pageObj.getconceptoPresupuestado);
                $(document).on("click", "#myModal .modal-footer button:eq(0)", pageObj.getDetallesParaGuardar);
                $(document).on("click", "#AgregaConcepto", pageObj.getDetallesParaGuardar);
                $(document).on("click", '#captura table tbody td.eliminar', pageObj.delConsepto);
                $(document).on("click", '#captura table tbody td.mes', pageObj.modMes);
                $(document).on("click", '#captura table tbody td.nr', pageObj.modMes);
                $(document).on("click", "#EditModal .modal-footer .btn-primary", pageObj.setModMes);
                $(document).on("keyup", "#EditModal .modal-body tr.input", pageObj.setTotalPresupuestadoModalEdit);

            },


            getmovimientos:function()
            
                {
                    niw.ajax({ action: "GetMovimientos", acc:$('#areas option:selected').text() }, pageObj.MovimientosGetted);
                 
                },
            


            modMes: function () {
                //var linea = $('#captura tbody tr').find("td").eq(0).html();
                pageObj.limpiar();
                var tr = $(this).parents('tr');
                var linea = tr.find("td").eq(0).html();
                var consepto = tr.find("td").eq(1).html();
                $('#concepto').val(consepto);
                var input = $('#EditModal .modal-body input');
                var mes1 = tr.find("td").eq(2).html();
                
                input.eq(0).val((tr.find("td").eq(2).html().replace(/,/g, '')));
                input.eq(1).val((tr.find("td").eq(3).html().replace(/,/g, '')));
                input.eq(2).val((tr.find("td").eq(4).html().replace(/,/g, '')));
                input.eq(3).val((tr.find("td").eq(5).html().replace(/,/g, '')));
                input.eq(4).val((tr.find("td").eq(6).html().replace(/,/g, '')));
                input.eq(5).val((tr.find("td").eq(7).html().replace(/,/g, '')));
                input.eq(6).val((tr.find("td").eq(8).html().replace(/,/g, '')));
                input.eq(7).val((tr.find("td").eq(9).html().replace(/,/g, '')));
                input.eq(8).val((tr.find("td").eq(10).html().replace(/,/g, '')));
                input.eq(9).val((tr.find("td").eq(11).html().replace(/,/g, '')));
                input.eq(10).val((tr.find("td").eq(12).html().replace(/,/g, '')));
                input.eq(11).val((tr.find("td").eq(13).html().replace(/,/g, '')));
                input.eq(12).val((tr.find("td").eq(14).html().replace(/,/g, '')));
                $('#EditModal').modal('show');

                var Total = 0;

                for (var i = 0; i < 12; i++) {
                    Total = Total + input.eq(i).val();
                }

                tr.find("td").eq(2).val(numeral(parseFloat(input.eq(0).val())).format("0,0,0"));
                pageObj.TrSeleccionado = linea;

            },


            limpiar: function () {
                var input = $('#EditModal .modal-body input');
                input.eq(0).val('');
                input.eq(1).val('');
                input.eq(2).val('');
                input.eq(3).val('');
                input.eq(4).val('');
                input.eq(5).val('');
                input.eq(6).val('');
                input.eq(7).val('');
                input.eq(8).val('');
                input.eq(9).val('');
                input.eq(10).val('');
                input.eq(11).val('');
            },

            setModMes: function () {

                var tr = $('#captura tbody').find("tr").eq(pageObj.TrSeleccionado);

                var tr2 = $('#captura tbody').parents('tr').eq(pageObj.TrSeleccionado);

                var tableRow = $("#captura td[text = '" + pageObj.TrSeleccionado + "']").parent('tr');

                var tableRow2 = $("td").filter(function () {
                    return $(this).text() == pageObj.TrSeleccionado;
                }).closest("tr");
        

                var input = $('#EditModal .modal-body input');
                var concepto = $('#concepto').val();
                var ene = parseFloat(input.eq(0).val());
                var feb = parseFloat(input.eq(1).val());
                var mar = parseFloat(input.eq(2).val());
                var abr = parseFloat(input.eq(3).val());
                var may = parseFloat(input.eq(4).val());
                var jun = parseFloat(input.eq(5).val());
                var jul = parseFloat(input.eq(6).val());
                var ago = parseFloat(input.eq(7).val());
                var sep = parseFloat(input.eq(8).val());
                var oct = parseFloat(input.eq(9).val());
                var nov = parseFloat(input.eq(10).val());
                var dic = parseFloat(input.eq(11).val());
                var total = ene + feb + mar + abr + may + jun + jul + ago + sep + oct + nov + dic;


                tableRow2.addClass("nr");
                tableRow2.find("td").eq(1).text(concepto);
                tableRow2.find("td").eq(2).text(numeral(ene).format("0,0,0"));
                tableRow2.find("td").eq(3).text(numeral(feb).format("0,0,0"));
                tableRow2.find("td").eq(4).text(numeral(mar).format("0,0,0"));
                tableRow2.find("td").eq(5).text(numeral(abr).format("0,0,0"));
                tableRow2.find("td").eq(6).text(numeral(may).format("0,0,0"));
                tableRow2.find("td").eq(7).text(numeral(jun).format("0,0,0"));
                tableRow2.find("td").eq(8).text(numeral(jul).format("0,0,0"));
                tableRow2.find("td").eq(9).text(numeral(ago).format("0,0,0"));
                tableRow2.find("td").eq(10).text(numeral(sep).format("0,0,0"));
                tableRow2.find("td").eq(11).text(numeral(oct).format("0,0,0"));
                tableRow2.find("td").eq(12).text(numeral(nov).format("0,0,0"));
                tableRow2.find("td").eq(13).text(numeral(dic).format("0,0,0"));
                tableRow2.find("td").eq(14).text(numeral(total).format("0,0,0"));

                pageObj.setTotalPresupuestado();

                pageObj.getDetallesParaGuardar();
            },


              

            getPresupuesto: function () {

                niw.ajax({ action: "GetPresupuestosMensualesPorCuenta", acc: $('#areas option:selected').text() }, function (msg) {
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
                        for (i = year; i > (year - 3) ; i--) {
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
            }
        ,

            bindCentrosDeCostos: function (msg) {
                msg = JSON.parse(msg);
                var opcs = '';
                for (i = 0; i < msg.length; i++)

                    if(msg[i].Tipo == "False")
                        opcs += '<option style="background-color: #bce8f1;  margin: 5px 0;" value="' + msg[i].Codigo + '">' + msg[i].Codigo + '  ' + msg[i].Descripcion + '</option>';
                    else
                        opcs += '<option style="margin: 5px 0;" value="' + msg[i].Codigo + '">' + msg[i].Codigo + '  ' + msg[i].Descripcion + '</option>';
                    
                $('#Guardar').attr("disabled", true);
                $('#Añadir').attr("disabled", true);
                $('#Añadir').attr('data-target', '#testModal2');
                $('#areas').html(opcs);
            },


            GetAño: function () {
                
                niw.ajax({ action: "getAño" }, function (msg) {
                   
                    msg = JSON.parse(msg);
                    dat = msg[0];
                    anoPre = dat.Year;
                    $('#año').val(anoPre);
                    $('#titulo').text(anoPre);
                    $('#Real').text(parseInt(anoPre) - 2);
                    $('#Proyeccion').text(parseInt(anoPre) - 1);
                    $('#Presupuesto').text(anoPre);
                    
                    pageObj.getconcepto();
                    
                   

                });
            },
            getconcepto: function () {
                
                niw.ajax({ action: "GetPresupuestosMensualesGenerales", acc: $('#areas option:selected').text(), ano: pageObj.anoPre }, pageObj.ComparativaGetted);
              
            },
            ComparativaGetted: function (msg) {
                $('#comparativa tbody').html(msg);
                pageObj.getmovimientos();
            },


            MovimientosGetted: function (msg) {
                $('#movimientos tbody').html(msg);
                pageObj.getconceptoPresupuestado();
            },

            getconceptoPresupuestado: function () {
                
                niw.ajax({ action: "GetConseptosPresupuestados", acc: $('#areas option:selected').text(), ano: pageObj.anoPre }, pageObj.ConseptosPresupuestadosGetted);
                
            },
            ConseptosPresupuestadosGetted: function (msg) {

                var arr = msg.split('|');

                pageObj.Cuenta=arr[0];

                var option = $("#areas option").filter(function () {
                    return $(this).val() == pageObj.Cuenta;
                }).closest("option");


                option.attr('selected', 'selected')

                $('#captura tbody').html(arr[2]);
                ///var td = $('#captura table td.mesbloqueado').parent('tr');;

                if (arr[1] == "False") {
                    $('#Guardar').attr("disabled", true);
                    $('#Añadir').attr("disabled", true);
                    $('#Añadir').attr('data-target', '#testModal2');
                    //$("#modal").tabs({ disabled: true });
                   
                }
                else {
                    $('#Guardar').attr("disabled", false);
                    $('#Añadir').attr("disabled", false);
                    $('#Añadir').attr('data-target', '#myModal2');

                }

                pageObj.setTotalPresupuestado();
                mp.waitPage('hide');
            },

            delConsepto: function () {
               
                var tr = $(this).parents('tr');
                var consepto = tr.find("td").eq(1).html();
                dialogs.confirm("¿Está seguro que desea eliminar el concepto : " + consepto + "?", function (evt) {
                    if (!evt.target.classList.contains('cancel-btn')) {
                        //var tr = $(this).parents('tr');
                       
                        var linea = tr.find("td").eq(0).html();
                        //var linea=$("#captura table tbody td.linea").parents().text();
                        niw.ajax({ action: "DelConsepto", acc: $('#areas option:selected').text(), linea: linea, ano: pageObj.anoPre }, pageObj.conceptoDeleted);
                        
                        var id = tr.data('id');
                        if (id != undefined) {
                            var t = $('#captura table');
                            if (t.data('dels') == undefined)
                                t.data('dels', id);
                            else
                                t.data('dels', t.data('dels') + ',' + id);
                        }
                        tr.remove();

                        
                        
                    }
                },"¿Está seguro...?", "Si", "No", "iGquestion");         


            },

            conceptoDeleted: function (msg) {
                if (msg == '1') {
                    dialogs.alert("Concepto eliminado correctamente", null, "Eliminado", "Aceptar", "iGsuccess");
                    pageObj.getconcepto();
                    pageObj.getconceptoPresupuestado();
                    pageObj.setTotalPresupuestado();
                }
                else
                    dialogs.alert("Hubo un error al eliminar el concepto", null, "Error en la Base de Datos", "Aceptar", "iGdanger");
            },

            getDetallesParaGuardar: function () {
                //Obtener los nuevos registros
                var anoPresupuesto = pageObj.anoPre;
                var sender = '';
                $('#captura table tr.nr').each(function () {
                    //Cabecera del detalle

                    var months1 = $('#mDesde').val();
                    var months2 = $('#mHasta').val();
                    var line = $(this).find('td:eq(0)').text();//$('#captura thead th:eq(3)').text();
                    var dname = $(this).find('td:eq(1)').text();
                    var fsacc = $('#areas option:selected').text().substring(0,17);//$('#myModal .modal-body .cuenta').text().substring(17);
                    var total = $(this).find('td:eq(14)').text();
                    var enero = $(this).find('td:eq(2)').text(); //enero
                    var febrero = $(this).find('td:eq(3)').text(); //febrero
                    var marzo = $(this).find('td:eq(4)').text(); //marzo
                    var abril = $(this).find('td:eq(5)').text(); //abril
                    var mayo = $(this).find('td:eq(6)').text(); //mayo
                    var junio = $(this).find('td:eq(7)').text(); //junio
                    var julio = $(this).find('td:eq(8)').text(); //julio
                    var agosto = $(this).find('td:eq(9)').text(); //agosto
                    var eseptiembre = $(this).find('td:eq(10)').text(); //sep
                    var octubre = $(this).find('td:eq(11)').text(); //oct
                    var noviembre = $(this).find('td:eq(12)').text(); //nov
                    var diciembre = $(this).find('td:eq(13)').text(); //dic
                    sender += '|' + line + ';' + dname + ';' + fsacc + ';' + total + ';' + months1 + ';' + months2 + ';' + enero + ';' + febrero + ';' + marzo + ';' + abril + ';' + mayo + ';' + junio + ';' + julio + ';' + agosto + ';' + eseptiembre + ';' + octubre + ';' + noviembre + ';' + diciembre + ';' + 0 + '¬';


                });

               
                //alert(sender);
                var t = $('#captura table');
                if (t.data('dels') != undefined) {
                    niw.ajax({ action: "DelDetallesDePresupuestoPorConcepto", cadena: t.data('dels') }, function (msg) {
                        if (msg == 1) {
                            if ($('#captura table tr.nr').length > 0)
                                niw.ajax({ action: "SetDetallesDePresupuestoPorConcepto", cadena: sender.substring(1), anoPresupuesto: anoPresupuesto }, pageObj.saveDetalles);

                            else {
                                var cuenta = $('#myModal .modal-body .cuenta').text().substring(16);
                                var co = cuenta.substring(0, 11);
                                $('#cuentasList a[data-concepto = ' + co + ']').click();
                            }
                        } else {
                            dialogs.alert('Hubo un error al eliminar algun detalle, por favor intente de nuevo', null, "Error", "Aceptar", "iGdanger");
                        }

                    });
                }
                else {
                    if ($('#captura table tr.nr').length > 0)
                        niw.ajax({ action: "SetDetallesDePresupuestoPorConcepto", cadena: sender.substring(1) }, pageObj.saveDetalles);

                }
                pageObj.getconcepto();
                pageObj.getconceptoPresupuestado();
                pageObj.setTotalPresupuestado();
            },

            setTotalPresupuestado: function () {
                //Obtener los nuevos registros
                var sender = '';
                var totalPre = 0;
                $('#captura tbody tr').each(function () {
                    //Cabecera del detalle
                
                    var total = $(this).find('td').eq(14).html().replace(/,/g,'');

                    totalPre = totalPre + parseInt(total);
                   

                });

                $("#TotalPre").text("TOTAL PRESUPUESTADO: $"+numeral(totalPre).format('0,0,0'));

            },

            setTotalPresupuestadoModalEdit: function (e) {

                
                if (e.keyCode == 13) {

                    var input = $('#EditModal .modal-body input');
                    var concepto = $('#concepto').val();
                    var ene = parseFloat(input.eq(0).val());
                    var feb = parseFloat(input.eq(1).val());
                    var mar = parseFloat(input.eq(2).val());
                    var abr = parseFloat(input.eq(3).val());
                    var may = parseFloat(input.eq(4).val());
                    var jun = parseFloat(input.eq(5).val());
                    var jul = parseFloat(input.eq(6).val());
                    var ago = parseFloat(input.eq(7).val());
                    var sep = parseFloat(input.eq(8).val());
                    var oct = parseFloat(input.eq(9).val());
                    var nov = parseFloat(input.eq(10).val());
                    var dic = parseFloat(input.eq(11).val());
                    var total = ene + feb + mar + abr + may + jun + jul + ago + sep + oct + nov + dic;

                    input.eq(12).val(total);
                }


            },

            delDetalle: function () {
                var tr = $(this).parents('tr');
                var consepto = tr.find("td").eq(1).html();
                dialogs.confirm("¿Está seguro que desea eliminar el concepto : " + consepto + "?", function (evt) {
                    if (!evt.target.classList.contains('cancel-btn')) {
                        //var tr = $(this).parents('tr');
                        var id = tr.data('id');
                        if (id != undefined) {
                            var t = $('#captura table');
                            if (t.data('dels') == undefined)
                                t.data('dels', id);
                            else
                                t.data('dels', t.data('dels') + ',' + id);
                        }
                        tr.remove();
                        pageObj.getconcepto();
                        pageObj.conceptoDeleted("1");
                        
                    }
                },"¿Está seguro...?", "Si", "No", "iGquestion");              
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

        };
        $(pageObj.init);
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="header">
        <h4>Captura de Presupuesto del año:
            <label id="titulo"></label>
            <%--<asp:Label ID="YearTitle" runat="server" Text="2016"></asp:Label></h4>--%>
    </section>
    <div id="myModal" role="document">
        <div class="row content2" style="font-family: Tahoma; font-size: 10px;">
            <div class="col-md-5 col-lg-4">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title" style="font-size:12px">Cuentas de Cetro de Costos:
                            <asp:Label Font-Size="12px"  ForeColor="White" ID="desccentro" runat="server" Text="Contabilidad"></asp:Label></h3>
                        <br />
                        <div class="input-group" >
                                        <input  id="buscar" type="text" class="form-control" placeholder="Buscar" />
                                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                    </div>
                        <select  multiple  class="form-control" id="areas" style="height:250px; font-size: 15px; font-family: Tahoma">
                        </select><br />
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="panel panel-info" style="height: 300px; overflow-y: scroll;">
               

                        <div class="panel-heading">
                            <h3 class="panel-title">Conceptos Presupuestados</h3>
                        </div>
                        <div class="col-md-12" id="captura">
                            <div class=" panel-body table-responsive">
                                <table id="conceptos" class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>LN.</th>
                                            <th>CONCEPTO</th>
                                            <th>ENE</th>
                                            <th>FEB</th>
                                            <th>MAR</th>
                                            <th>ABR</th>
                                            <th>MAY</th>
                                            <th>JUN</th>
                                            <th>JUL</th>
                                            <th>AGO</th>
                                            <th>SEP</th>
                                            <th>OCT</th>
                                            <th>NOV</th>
                                            <th>DIC</th>
                                            <th>TOTALES</th>
                                            <td></td>
                                        </tr>

                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                          
                </div>
                 <div id="desactivado" class="modal-footer" style="margin-right: 10px">
                                
                    <a id="Añadir" href="#" class="btn btn-info" data-toggle="modal" data-target="#myModal2" ><span class="fa fa-plus"></span>Añadir Concepto de Presupuesto</a>
                  <%--  <button type="button" class="btn btn-primary" id="Guardar" >Guardar Presupuesto</button>--%>
                    <label id="TotalPre" style="text-align:right; font-size:15px;" class="label label-default"  placeholder="Total"/>
                      
                     
                    </div>
                    
                </div>
                </div>
           
                
            
        </div>


    <div class="row content2" style="font-family: Tahoma; font-size: 10px;">
        <div class="col-md-6">
            <div class="panel panel-info" style="height: 490px; overflow-y: scroll;">
                <div class="panel-heading">
                    <h3 class="panel-title">Comparativo Anual</h3>
                </div>

                <div class="panel-body table-responsive">
                    <table class="table table-striped" id="comparativa">
                        <thead>
                            <tr>
                                <th>Mes</th>
                                <th>Año
                                    <Label id="Real"></Label>
                                    Real</th>
                                <th>Año
                                    <Label id="Proyeccion" ></Label>
                                    Proyección</th>
                                <th>Año
                                    <Label id="Presupuesto"></Label>
                                    Presupuesto</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>

                </div>

            </div>
        </div>
        <div class="col-md-6">
            <div class="panel panel-info" style="height: 490px; overflow-y: scroll;">
                <div class="panel-heading">
                    <h5 class="panel-title">Detalle de movimientos ejercicio actual</h5>
                </div>
                <div class="panel-body table-responsive">
                    <table class="table table-striped" id="movimientos">
                        <thead>
                            <tr>
                                <th>Periodo</th>
                                <th>Póliza</th>
                                <th>Sec.</th>
                                <th>Origen</th>
                                <th>Descrpción</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>

    <!-- Modal 2 -->
    <div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Agregar Concepto</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-12">
                            <input type="text" class="form-control detalle" id="mDetalle" placeholder="Detalle" autofocus="autofocus" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="input-group">
                                <span class="input-group-addon">$</span>
                                <input type="number" class="form-control" aria-label="Amount" style="width: 200px" placeholder="Monto" />

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

                            <label>Desde</label><input type="number" max="12" min="1" maxlength="2" class="form-control validNumber" id="mDesde" style="width: 200px" /><br />
                            <label>Hasta</label><input type="number" max="12" min="1" maxlength="2" class="form-control validNumber" id="mHasta" style="width: 200px" /><br />

                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="AgregaConcepto" class="btn btn-primary">Agregar Concepto</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Editar -->
    <div class="modal fade" id="EditModal" tabindex="-1" role="dialog" aria-labelledby="lemTitle">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content pull-right" style="width:1240px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="panel-title" id="editTitle"></h4>
                </div>
                 <div class="col-md-12">
                     <table>
                         <tr><th>Concepto</th><td style="width:600px;"><input type="text" style="font-size:10px;" id="concepto" class="form-control" /></td></tr>
                     </table>
                 </div>
                <br /><br /><br />

                <div class="modal-body">
                    <div class="col-sm-4 form-field list-inline" aria-disabled="true">

                        <table>
                        
                         
                         
                         <tr>
                         <th>Ene</th><th>Feb</th><th>Mar</th><th>Abr</th><th>May</th><th>Jun</th><th>Jul</th><th>Ago</th><th>Sep</th><th>Oct</th><th>Nov</th><th>Dic</th> <th>Total</th> 
                         </tr>
                             <tr>
                        <td><input type="number" id="edtene" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtfeb" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtmar" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtabr" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtmay" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtjun" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtjul" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtago" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtsep" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtoct" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtnov" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="number" id="edtdic" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        <td><input type="text" id="total" style="width:90px; font-size:10px;" font-family:Tahoma;" class="form-control" placeholder="Monto" /></td>
                        </tr>
                      </table>
                    </div>
                </div>
                <br /><br /><br /><br />
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Guarda Presupuesto</button>
                </div>
            </div>
        </div>
    </div>
</label>
</asp:Content>


