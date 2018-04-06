<%@ Page Title="" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="Cursos.aspx.cs" Inherits="NI5sWeb.Modules.RH.Cursos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<%--    <script src="../../../Themes/NIWeb/js/numeral.min.js"></script>--%>
    <style>
         #datEvaluacion{display:none;}
         #addEvaluacion{display:none;}
        .form-field {
            margin: 10px auto;
        }

        .wiz-page {
            display: none;
        }

        .wiz-active {
            display: block;
        }

        .wiz-page .nEdu {
            display: none;
        }

        .searchField h5 {
            font-weight: bold;
        }

        .searchField .panel-footer {
            text-align: right;
        }

            .searchField .panel-footer .listCiclos {
                overflow: hidden;
                position: relative;
            }

                .searchField .panel-footer .listCiclos .movible {
                    margin-top: -100%;
                }

        .lists {
            display: none;
        }

            .lists .page-header {
                margin-top: 0;
            }

        </style>
    <script src="/Themes/NIWeb/js/pdfobject.js"> </script>
    <script>
        var crs = {
            plaza: null,
            idCrs: null,
            idC: null,
            fileSelected: new Array(),
            arrayRes : [],
            init: function () {
               // $('.form-group').on('click','input[type=radio]',function() {
                //$('table.highchart').highchartTable();
                $(document).on('click', '#CursList a.list-group-item', crs.selectPlz);
                $(document).on("click", '#evaluacion input[type=radio]', crs.selectRes);
                //$('#plazasModal').on('show.bs.modal', plz.showModal);
                //$(document).on('click', '#plazasModal .btn-primary', plz.addPlz);
                //$(document).on('change', '#plzType', plz.showPromotor);
                $(document).on('click', '#plzDocumentos a.list-group-item', crs.getDocumento);
                $(document).on("click", "#datEvaluacion", crs.showEvaluacion);
                $(document).on("click", "#addEvaluacion .save", crs.saveEvaluacion);
                //$('#PlzDocumentos a.list-group-item').click(crs.getReciboNomina);
            },
            getDocumento: function () {
                // po.monthSelected = $(this).data('file');
                $('#plzDocumentos .list-group-item.active').removeClass('active');
                $(this).addClass('active');

                crs.fileSelected = $(this).data('filename');

                //niw.ajax({ action: 'print', imprimir: imprimir }, function (msg) {
                var params = {
                    url: 'getPdf.aspx?' + crs.fileSelected,
                    // pdfOpenParams: { statusbar: 1, view: '' }
                    pdfOpenParams: { toolbar: 0, view: 'FitV', pagemode: 'thumbs' }

                };

                document.getElementById('MainContent_PrintSection').style.height = '520px';
                var myPDF = new PDFObject(params).embed('MainContent_PrintSection');

                $('#MainContent_PrintSection').show();
                $('#addEvaluacion').hide();

                //});
                //var imprimir = $("#imprimir").val();
                //if (po.monthSelected != null) {
                //    dialogs.confirm("Al imprimir se mostrará una vista previa en el monitor.\n¿Está seguro que desea mostrar el recibo de nómina para imprimir?", function (e) {
                //        if (!e.target.classList.contains('cancel-btn')) {
                //            niw.ajax({ action: 'print', imprimir: imprimir }, function (msg) {
                //                var params = {
                //                    url: 'resources/getPdf.aspx?' + po.monthSelected,
                //                    pdfOpenParams: { statusbar: 0, view: 'FitV' }
                //                    //pdfOpenParams: {view: 'FitV', pagemode: 'thumbs'}

                //                };

                //                document.getElementById('MainContent_PrintSection').style.height = '520px';
                //                var myPDF = new PDFObject(params).embed('MainContent_PrintSection');



                //            });
                //        }
                //    }, "Imprimir", "Si", "No", "print");
                //} else {
                //    dialogs.alert("Es necesario seleccionar un mes, Intente de Nuevo", null, "Enviar Correo Electrónico", "Aceptar", "iGwarning");
                //}


            },            
            showEvaluacion: function () {

                    $('#MainContent_PrintSection').hide();

                    niw.ajax({ action: "GetEvaluacion", id: crs.idCrs }, function (msg) {

                        if (msg != '')
                            $('#addEvaluacion').show();
                        else
                            $('#addEvaluacion').hide();

                        $('#evaluacion tbody').html(msg);
                    });

                    $('#datEvaluacion').hide();
                    $('#plzDocumentos').hide();

                    var pend = $('#CursList .active').data("pendiente");

                    //$('#CursList .active').data('pendiente','NO');
                    //var parent = $(this).parent().parent();
                    //var select = parent.find('select');
                    //var id = select.val();
                    //if (id != '') {
                    //    var objetive = select.find('option[value=' + id + ']').text();
                    //    var list = '<div class="input-group" data-id="' + id + '"><p class="form-control">' + objetive + '</p><span class="input-group-addon"><i class="fa fa-chevron-right"></i></span><input type="number" class="form-control" min="0" placeholder="Cantidad" /><div class="input-group-btn"><button class="btn btn-danger" type="button"><i class="fa fa-times"></i></button></div></div>';

                    //    $('#DatObjetivesAdded').append(list);
                    //    select.val('');
                    //}
            },
            saveEvaluacion: function () {
                //var arrayRes = crs.arrayRes;

                niw.ajax({ action: "SaveEvaluacion", id: crs.idCrs, idC: crs.idC, arrayRes: crs.arrayRes }, function (msg) {

                    if (msg == '0') {
                        dialogs.alert("Faltan Preguntas por Contestar, Termine la Evaluacion.", null, "Advertencia", "Aceptar", "iGdanger");
                    }
                    else
                    {
                        $('#datResult').val(msg);
                        $('#addEvaluacion').hide();

                        crs.arrayRes = [];

                        $('#CursList .active').data("pendiente") == 'NO';
                        $('#CursList .active').data("result") == $('#datResult').val();
                       

                        dialogs.alert("Datos guardados correctamente", null, "Transacción Existosa", "Aceptar", "iGsuccess");

                        
                       niw.ajax({ action: 'getCursos' } , function (msg)
                       {
                           $('#CursList').html(msg);
                       });
                       // niw.ajax({ action: 'getCursos'})
                        //location.reload(true)
                    }
                });

            }

            ,
            selectRes: function () {
                var valR = $(this).val();

                var array = crs.arrayRes.toString();

                var arr = array.split(',')

                if (array.length > 0)
                {
                   
                    
                    for (var i = 0; i < arr.length; i++) {

                        var item = arr[i].split("-")[0];

                        if (item == valR.split("-")[0])
                        {
                            var pos = crs.arrayRes.indexOf(arr[i]);
                            crs.arrayRes.splice(pos, 1);
                            break;
                        }

                    }

                }


               crs.arrayRes.push(valR);
            }
            ,
            showPromotor: function () {
                var val = $(this).val();
                $('.plzPromotor').hide();
                $('.plzPromotor:eq(' + (val - 1) + ')').show();
            },
            showModal: function () {
                $('#plzType').val('');
                $('#plzZona').val('');
                $('#plzEncargado').val('');
                $('#plzPelPromotor').val('');
                $('#plzOutPromotor').val('');
                $('#plzTipo').val('');
                $('.plzPromotor').hide();
            },
            addPlz: function () {
                var type = $('#plzType').val();
                var zone = $('#plzZona').val();
                var enca = $('#plzEncargado').val();
                var prom = $('#plzPelPromotor').val();

                if (prom == '') prom = $('#plzOutPromotor').val();
                var tipo = $('#plzTipo').val();

                if (type == '') $('#plzType').css('border-color', '#aa0000'); else $('#plzType').css('border-color', '#999');
                if (zone == '') $('#plzZona').css('border-color', '#aa0000'); else $('#plzZona').css('border-color', '#999');
                if (enca == '') $('#plzEncargado').css('border-color', '#aa0000'); else $('#plzEncargado').css('border-color', '#999');
                if (prom == '') $('.plzPromotor').css('border-color', '#aa0000'); else $('.plzPromotor').css('border-color', '#999');
                if (tipo == '') $('#plzTipo').css('border-color', '#aa0000'); else $('#plzTipo').css('border-color', '#999');

                if (type != '' && zone != '' && enca != '' && prom != '' && tipo != '') {
                    mp.waitPage('show');
                    niw.ajax({ action: 'AddPlz', type: type, zone: zone, enca: enca, prom: prom, tipo: tipo }, function (msg) {
                        if (msg != '0') {
                            $('#PlzList').html(msg);
                            $('#plazasModal').modal('hide');
                        }

                        mp.waitPage('hide');
                    }, function () {
                        mp.waitPage('hide');
                    });
                }
            },
            selectPlz: function () {
                $('#CursList .active').removeClass('active');
                $(this).addClass('active');

                var btn = $(this);

                crs.idCrs = $(this).data('id');
                crs.idC = $(this).data('idc');
                var parent = $(this).parent().parent();
                // parent.removeClass('col-sm-offset-4');

                //dat.getPlzData($(this));

                var Nombre = btn.data('nombre');
                var pendiente = btn.data('pendiente');
                var date = btn.data('fecha');

                $('#datNombre').val(Nombre);
                $('#datDescripcion').val(btn.data('descripcion'));
                $('#datResponsable').val(btn.data('responsable'));
                $('#datFecha').val(btn.data('fecha'));
                $('#datResult').val(btn.data('result'));

                $('#addEvaluacion').hide();
                $('#MainContent_PrintSection').hide();
                niw.ajax({ action: "GetDocumentos", id: crs.idCrs }, function (msg) {
                    $('#plzDocumentos').html(msg);
                    $('#plzDocumentos').show();
                    if (msg == '') {
                       // $('#MainContent_PrintSection').hide();
                        $('#datEvaluacion').hide();
                    }
                    else {

                       // $('#MainContent_PrintSection').show();

                        var x = new Date();
                        var fecha = date.split("/");
                        x.setFullYear(fecha[2], fecha[1] - 1, fecha[0]);
                        var today = new Date();

                       


                            if (pendiente == 'SI') {
                                $('#datEvaluacion').show();

                                if (today > x )
                                    $('#datEvaluacion').hide();
                            }
                            else
                                $('#datEvaluacion').hide();

                    }

                });
            }
        };
        $(crs.init);
    </script>

    <script>
        var dat = {
            plzId: null,
            init: function () {
                $(document).on("click", "#plzAdminBlock .del", dat.delPlz);
                //$(document).on("click", "#datEvaluacion", dat.showEvaluacion);
                $(document).on("click", "#DatObjetivesAdded .btn-danger", dat.delObjetive);
                $(document).on("click", "#plzAdminBlock .save", dat.savePlzData);
                $(document).on("change", "#PlzObjetivs .year,#PlzObjetivs .month", dat.showObjetivesPlaces);

            },
            getPlzData: function (btn) {
                //Obtener datos generales de la plaza
                dat.plzId = btn.data('id');

                var Nombre = btn.data('nombre');

                $('#datNombre').val(Nombre);
                $('#datDescripcion').val(btn.data('descripcion'));
                $('#datResponsable').val(btn.data('responsable'));
                $('#datFecha').val(btn.data('fecha'));
                // $('#encargadoData').val(btn.data('incharge'));
                //$('#datTipo').val(btn.data('type'));
                //$('#datemailp').val(btn.data('emailp'));
                //$('#datemailc').val(btn.data('emailC'));
                //var ptype = btn.data('ptype');
                //$('#datType').val(ptype);
                //if (ptype == 1) {
                //    $('#plzOutData').hide();
                //    $('#plzPelData').show().val(btn.data('promoter'));
                //} else {
                //    $('#plzPelData').hide();
                //    $('#plzOutData').show().val(btn.data('promoter'));
                //}

                //    //Obtener datos de objetivos de la plaza
                //var y = $('#PlzObjetivs .year').data('now');
                //var m = $('#PlzObjetivs .month').data('now');
                //$('#PlzObjetivs .year').val(y);
                //$('#PlzObjetivs .month').val(m);

                //niw.ajax({ action: "GetPlaceObjetives", id: dat.plzId, y: y, m: m }, function (msg) {
                //    $('#DatObjetivesAdded').html(msg);
                //});

                //    //Mostrar datos de la plaza
                //$('#plzAdminBlock').show();

            },
            delPlz: function () {
                niw.ajax({ action: "DelPlace", id: plz.plaza }, function (msg) {
                    if (msg == 1) {
                        $('#plzAdminBlock').hide();
                        $('.list-group-item[data-id=' + plz.plaza + ']').remove();
                    }
                });
            },
            showEvaluacion: function () {

                $('#MainContent_PrintSection').hide();

                niw.ajax({ action: "getEvaluacion", id: plz.plaza }, function (msg) {
                    if (msg == 1) {
                        $('#plzAdminBlock').hide();
                        $('.list-group-item[data-id=' + plz.plaza + ']').remove();
                    }
                });

                //var parent = $(this).parent().parent();
                //var select = parent.find('select');
                //var id = select.val();
                //if (id != '') {
                //    var objetive = select.find('option[value=' + id + ']').text();
                //    var list = '<div class="input-group" data-id="' + id + '"><p class="form-control">' + objetive + '</p><span class="input-group-addon"><i class="fa fa-chevron-right"></i></span><input type="number" class="form-control" min="0" placeholder="Cantidad" /><div class="input-group-btn"><button class="btn btn-danger" type="button"><i class="fa fa-times"></i></button></div></div>';

                //    $('#DatObjetivesAdded').append(list);
                //    select.val('');
                //}
            },
            delObjetive: function () {
                var parent = $(this).parent().parent();
                parent.remove();
            },
            searchPromotores: function () {
                $('#promSearcher').keyup(function (e) {
                    var kp = e.keyCode;
                    if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                        var txt = $(this).val();
                        $('.searchField').hide();
                        $('.searchField .panel-heading:contains(' + txt + '), .searchField .panel-body h5:contains(' + txt + ')').parents(".searchField").show();
                    }
                });
            },
            savePlzData: function () {
                //salvar datos generales de la plaza
                if ($('#datType').val() == 1)
                    var promData = $('#plzPelData').val();
                else
                    var promData = $('#plzOutData').val();
                var y = $('#PlzObjetivs .year').val();
                var m = $('#PlzObjetivs .month').val();
                var objs = '';
                $('#DatObjetivesAdded .input-group').each(function (i) {
                    if ($(this).find('input').val() != '' && $(this).find('input').val() != 0)
                        objs += ',' + $(this).data('id') + ':' + $(this).find('input').val();
                });
                objs = objs.substr(1);
                niw.ajax({ action: "UpdatePlace", id: dat.plzId, zone: $('#datZone').val(), charge: $('#encargadoData').val(), emailp: $('#datemailp').val(), emailc: $('#datemailc').val(), tipo: $('#datTipo').val(), type: $('#datType').val(), promoter: promData, y: y, m: m, objs: objs }, function (msg) {
                    if (msg == '1') {
                        dialogs.alert("Datos guardados correctamente", null, "Transacción Existosa", "Aceptar", "iGsuccess");
                    }
                });
            },
            showObjetivesPlaces: function () {
                var y = $('#PlzObjetivs .year').val();
                var m = $('#PlzObjetivs .month').val();
                niw.ajax({ action: "GetPlaceObjetives", id: dat.plzId, y: y, m: m }, function (msg) {
                    $('#DatObjetivesAdded').html(msg);
                });
            }
        };
        $(dat.init);
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header row">
        <h1><small>Cursos Online</small></h1>
    </div>
    <div class="row">



        <div class="col-sm-3">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Listado de Cursos Pendientes</h3>

                    <%--<div class="input-group">
                 <input type="text" id="promSearcher" class="form-control" placeholder="Buscar" />
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
             </div>--%>
                </div>
                <div class="panel-body">
                    <asp:Panel ID="CursList" ClientIDMode="Static" CssClass="list-group" runat="server"></asp:Panel>
                </div>
            </div>
        </div>
        <div class="col-sm-8" id="plzAdminBlock">
            <div class="row plzAdminArea">
                <div class="col-md-12 btn-group" role="group">

                    <%--   <button type="button" class="btn btn-primary save"><i class="fa fa-save"></i> Guardar Cambios</button>
                    <button type="button" class="btn btn-danger del"><i class="fa fa-trash"></i> Eliminar</button>--%>
                </div>
                <div class="clear"></div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label>Nombre</label>

                        <%--<asp:Panel ID="panel1" ClientIDMode="Static" runat="server">--%>
                        <input id="datNombre" type="text" class="form-control" readonly />
                        <%-- </asp:Panel>--%>
                    </div>
                </div>
                <div class="col-md-7">
                    <div class="form-group">
                        <label for="datDescripcion">Descripción</label>
                        <%--<asp:Panel ID="DatDescripcion" ClientIDMode="Static" runat="server">

                        </asp:Panel>--%>

                        <input id="datDescripcion" type="text" class="form-control" readonly />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="datResponsable">Responsable</label>
                        <input id="datResponsable" type="text" class="form-control" readonly />
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label for="datTipo">Fecha Expiración </label>
                        <input id="datFecha" type="text" class="form-control" readonly />
                    </div>
                </div>

                <div class="col-md-2">
                    <div class="form-group">
                        <label for="datResult">Resultado Evaluación </label>
                        <input id="datResult" aria-label="Amount" style="border-color : steelblue" type="number" class="form-control" readonly />
                    </div>
                </div>
            </div>
            <div class="row">
                <%--<div class="col-md-3">
                    <div class="form-group">
                        <label for="datType">Tipo de Promotor</label>
                        <select class="form-control" id="datType">
                            <option value="">Tipo de Promotor</option>
                            <option value="1" selected="selected">Pelikan</option>
                            <option value="2">Externo</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="form-group">
                        <label for="datPromoter">Promotor</label>
                        <asp:Panel ID="PromotorData" runat="server"></asp:Panel>
                    </div>
                </div>--%>
                <div class="modal-header">
                    <%--<h4 class="modal-title" id="CorreosLabel">Informacion Adicional</h4>--%>
                    <div class="col-md-7 right">
                        <%--  </div>
                       <div class="form-group">
                           <input type="text" id="correop" class="form-control" placeholder="Correo Personal" />
                            <asp:Panel ID="EmailData" runat="server"></asp:Panel>
                       </div>
                </div>--%>

                        <%--     <div class="col-md-7 right">
                       <div class="form-group">
                           <input type="text" id="correoc" class="form-control" placeholder="Correo Coorporativo" />
                            <asp:Panel ID="EmailData1" runat="server"></asp:Panel>
                       </div>
                </div>--%>
                        <%--        <div class="col-md-7 right">
                       <div class="form-group">
                           <input type="text" id="tel1" class="form-control" placeholder="Telefono 1" />
                            <asp:Panel ID="Panel1" runat="server"></asp:Panel>
                       </div>
               </div>--%>


                        <%--<div class="col-md-7 right">
                       <div class="form-group">
                           <input type="text" id="tel2" class="form-control" placeholder="Telefono 2" />
                            <asp:Panel ID="Panel2" runat="server"></asp:Panel>
                       </div>--%>

                        <%-- <div class="row">
                            <div class="col-md-12">
                                <asp:Panel ID="Panel3" ClientIDMode="Static" runat="server"></asp:Panel>
                                <div class="input-group">
                                    <asp:Panel ID="Panel4" runat="server"></asp:Panel>
                                    <%--<div class="input-group-btn">
                            <button class="btn btn-success" type="button" id="">Agregar</button>
                        </div><
                                </div>
                                <!-- /input-group -->
                            </div>
                        </div>--%>
                    </div>


                </div>
                <div id="form-objetives" class="row">
                    <div class="col-md-12">
                        <h4>Documentación - Leer</h4>
                        <div class="panel-body">
                            <asp:Panel ID="plzDocumentos" ClientIDMode="Static" CssClass="list-group" runat="server">
                            </asp:Panel>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                    <div id="MainContent_PrintSection">




                    </div>
                        </div>
                    <%--<asp:Panel ID="GeneratedTableYears" ClientIDMode="Static" runat="server"></asp:Panel>--%>
                </div>

                <hr />
                <div class="row">
                    <div class="col-md-12">
                        <asp:Panel ID="DatObjetivesAdded" ClientIDMode="Static" runat="server"></asp:Panel>
                        <div class="input-group">
                            <asp:Panel ID="DatObjetives" runat="server"></asp:Panel>
                            <div class="input-group-btn">
                                <button class="btn btn-success" type="button" id="datEvaluacion">Iniciar Evaluación</button>
                                <hr />
                            </div>
                            <!-- /btn-group -->
                        </div>
                        <!-- /input-group -->
                    </div>
                </div>

                <div class="row" id="addEvaluacion">
                    <div class="col-md-12">
                    <div class="panel panel-info" style="height: 350px; overflow-y: scroll;">
                     <div class="panel-heading">
                            <h3 class="panel-title">Evaluación</h3>
                        </div>
                    <div class="col-md-7" id="evaluacion">
                        <div class="panel-body table-responsive">

                            <table class="table table-striped" id="preguntas">
                                
                               
                                <tbody>
                                    
                                </tbody>
                            </table>

                        

                        </div>
                    </div>
                    <div class="col-md-12 btn-group" role="group">
                        <button type="button" class="btn btn-primary save"><i class="fa fa-save"></i>Guardar Evaluación</button>
                        <%--<button type="button" onclick="confirmDel()" class="btn btn-danger del"><i class="fa fa-trash"></i>Eliminar</button>--%>
                    </div>

                </div>
                        </div>
                    </div>
            </div>
        </div>
    </div>
</asp:Content>

