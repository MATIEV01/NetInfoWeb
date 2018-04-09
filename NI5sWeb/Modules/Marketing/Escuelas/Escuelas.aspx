<%@ Page Title="" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="Escuelas.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Escuelas.Escuelas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
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

        div.searchlist {
            max-height: 550px;
            overflow-y: auto;
        }

        div .ornament-column {
            float: left;
            padding: 15px;
        }

        /*.listCiclos{overflow:hidden;position:relative;}*/
        .listCiclos .movible {
            max-height: 500px;
            overflow-y: auto;
        }
    </style>
    <script>
        var iface = {
            init: function () {
                //iface.wizNextBtn();
                //iface.showCiclos();
                //iface.addCiclos();
                //iface.wizShowCities();
                //$('#myModal').on("show.bs.modal", iface.openMyModal);
                //iface.searchSchools();
                //$('.modal').modal({ backdrop: false });
            },
            openMyModal: function (e) {
                $(this).find('.wiz-active').removeClass('wiz-active');
                $(this).find('.wiz-page:eq(0)').addClass('wiz-active');
                if (e.relatedTarget.text == " Agregar Escuela") {
                    iface.resetForm($(this));
                }
            },
            searchSchools: function () {
                $('#escSearcher').keyup(function (e) {
                    var kp = e.keyCode;
                    if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                        var txt = $(this).val();
                        $('.searchField').hide();
                        $('.searchField .panel-heading:contains(' + txt + '), .searchField .panel-body h5:contains(' + txt + ')').parents(".searchField").show();
                    }
                });
            },
            //Modal de wizard del formulario de escuelas
            wizNextBtn: function () {
                $('#myModal .modal-footer .btn-primary').click(function () {
                    var ret = true;
                    $('.wiz-active .form-control').each(function () {
                        var val = $(this).val();
                        var parent = $(this).parent();
                        if (val == '' && $(this).attr('required') == 'required') {
                            parent.removeClass('has-success').addClass('has-error');
                            ret = false;
                        } else
                            parent.removeClass('has-error').addClass('has-success');
                    });
                    if (ret) {
                        var actv = $('.wiz-active');
                        var nxt = actv.next();
                        if (nxt.index() == ($('.wiz-page').length - 1))
                            $('#myModal .modal-footer .btn-primary').html('Agregar <i class="fa fa-save"></i>');
                        if (nxt.index() > 0)
                            $('#myModal .modal-footer .btn-default').show();
                        if (nxt.length > 0) {
                            actv.removeClass('wiz-active');
                            nxt.addClass('wiz-active');
                        } else {
                            var $btn = $('#myModal .modal-footer .btn-primary').button('loading');
                            mp.waitPage('show');
                            iface.wizSend($(this));
                        }
                    }
                });
            },
            showCiclos: function () {
                $(document).on("click", '.searchField .panel-footer .btn-group a:nth-child(1)', function () {
                    var movible = $(this).parent().next().find('.movible');
                    var mH = movible.outerHeight() + 20;
                    var mMT = movible.css('margin-top').split('p')[0];

                    if (!$(this).data('active')) {
                        $(this).data('active', true);
                        movible.animate({ "margin-top": "+=" + (mMT * -1) }, 800);
                    } else {
                        $(this).data('active', false);
                        movible.animate({ "margin-top": "-=" + mH }, 800);
                    }
                    return false;
                });
            },
            addCiclos: function () {
                $(document).on('click', '.searchField .panel-footer .movible .addCicloBtn', function () {
                    var lc = $(this).parent().parent().find('.listContent');
                    var ffs = lc.find('.form-field');
                    var cicle = '2015-2016';
                    if (ffs.length > 0) {
                        ff = ffs.eq(ffs.length - 1).text();
                        cicle = ff.split('-')[1];
                        cicle = cicle + '-' + (parseInt(cicle) + 1);
                    }
                    lc.append('<div class="form-field"><a href="#" class="btn btn-default form-control" data-toggle="modal" data-target="#listaEscolarModal" data-backdrop="false">' + cicle + '</a></div>');
                    return false;
                });
            },
            wizShowCities: function () {
                $('#escEst').change(function () {
                    $('#escCiu option').hide();
                    $('#escCiu').val('');
                    if ($(this).val() == 9)
                        $('#escCiu .ciuAll').text('Delegación');
                    else
                        $('#escCiu .ciuAll').text('Ciudad');
                    $('#escCiu .ciuAll, #escCiu .ciu' + $(this).val()).show();
                });
            },
            resetForm: function (obj) {
                var parent = obj.find('.modal-body input, .modal-body select').parent();
                obj.find('.modal-body input, .modal-body select').val('');
                obj.find('.modal-body input:checked').removeAttr("checked");
                obj.find('.modal-footer .btn-primary').html('Siguiente <i class="fa fa-hand-o-right"></i>');
                obj.find('.modal-footer .btn-default').hide();
                parent.removeClass('has-error').removeClass('has-success');
            },
            wizSend: function (obj) {
                var modal = obj.parent().parent();
                var allWiz = modal.find(".modal-body");
                var vals = allWiz.find('input, select');
                var formData = "action=CreateSchool";
                vals.each(function () {
                    var id = $(this).attr('id');
                    if (id == "escCSM" || id == "escCSJ" || id == "escCSPrim" || id == "escCSS" || id == "escCSPrep") {
                        if ($(this).val() != '')
                            formData += "&nivel=" + id.substr(3) + "|" + $(this).val();
                    } else {
                        formData += "&" + id + "=" + $(this).val();
                    }
                });

                niw.ajax(formData, function (msg) {
                    if (msg == "1") {
                        dialogs.alert("Se ha agregado la Escuela Satisfactoriamente", function () {
                            niw.ajax({ action: "ShowAllSchools" }, function (msg) {
                                $('#SchoolList').html(msg);
                            });
                        }, "Escuela Agregada", "Aceptar", "iGsuccess");
                        $('#myModal').modal("hide");
                    }
                    mp.waitPage("hide");
                    $('#myModal .modal-footer .btn-primary').button('reset');
                }, function () {
                    mp.waitPage("hide");
                    $('#myModal .modal-footer .btn-primary').button('reset');
                });
            },
        }
        $(iface.init);
    </script>
    <script>
        var po = {
            schoolSelected: null,
            ciclo: null,

            init: function () {

                $(document).on("change", "#estadoPnl", po.GetDelegacionPnl);
                $(document).on("change", "#delegacionPnl", po.GetEscuelas);
                $(document).on('click', '#PlzList a.list-group-item', po.selectPlz);
                $(document).on("keyup", '#proSearcher', po.searchEscuelas);
                $(document).on("click", "#plzAdminBlock .new", po.limpiarCampos);
                $(document).on('click', '#pnllistclicos .movible .addCicloBtn', po.addCiclos);
                $(document).on('click', '#pnllistclicos .movible .btn', po.getElSchool);
                $(document).on("click", "#accordion .panel-info .list-group a, #hCompra a", po.getSchoolList);


                //$(document).on("click", ".searchField .panel-footer .btn-group a.delSchool", po.deleteSchool);
                //$(document).on("click", ".searchField .panel-footer .btn-group a.modSchool", po.modSchool);
                $(document).on("click", "#newProd .btn-success", po.addProduct)
                $(document).on("click", "#newProd .btn-danger", po.borrarSelectProduct)

                $(document).on("keyup", "#searchProdId, #searchProd", po.searchProduct);
                $(document).on("click", "#dbProductList a", po.selectProduct);
                $(document).on("click", "#productsList .input-group .btn", po.removeProduct);
                //$('#listaEscolarModal').on('show.bs.modal', po.getElSchool);
                //$(document).on("click", "#accordion .panel-info .list-group a, #hCompra a", po.getSchoolList);
                $(document).on("click", "#saveStudents", po.addStudentsNumber);
                //$(document).on("click", "#schoolEditModal .modal-footer .btn-primary", po.setModSchool);
            },

            GetDelegacionPnl: function () {
                mp.waitPage("show");
                po.limpiarCampos();
                $('#PlzList').html('');
                var est = $('#estadoPnl').val();

                niw.ajax({ action: "GetDelegacionPnl", idEst: est }, function (msg) {
                    $('#delegacionPnl').html(msg);
                    $('#datDelegacion').html(msg);
                });

                niw.ajax({ action: "GetZona", idEst: est }, function (msg) {
                    $('#DatZona').html(msg);
                });

                mp.waitPage("hide");
            },
            GetEscuelas: function () {

                mp.waitPage("show");
                $("#plzAdminBlock .save").attr("disabled", true);
                $("#plzAdminBlock .del").attr("disabled", true);
                po.limpiarCampos();
                $('#PlzList').html('');
                var est = $('#estadoPnl').val();
                var del = $('#delegacionPnl').val();
                niw.ajax({ action: "GetEscuelas", idEst: est, idDel: del }, function (msg) {

                    $('#PlzList').html(msg);

                    if (msg != '')
                        $("#plzAdminBlock .new").attr("disabled", false);
                    else
                        $("#plzAdminBlock .new").attr("disabled", true);

                    mp.waitPage("hide");
                });
              
            },

            selectPlz: function () {
                $("#plzAdminBlock .save").attr("disabled", false);
                $("#plzAdminBlock .del").attr("disabled", false);
                $('#PlzList .active').removeClass('active');
                $(this).addClass('active');
                // plz.plaza = $(this).data('id');
                var parent = $(this).parent().parent();
                parent.removeClass('col-sm-offset-4');

                po.getEscData($(this));
            },
            searchEscuelas: function () {



                var trs = $('#PlzList a.list-group-item');
                //not('#PlzList a.list-group-item:last-child');
                //console.info(trs);
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#PlzList a.list-group-item:contains(' + str + ')').show();


            },

            getEscData: function (btn) {
                //Obtener datos generales de la plaza
                var cct = btn.data('id');

                po.schoolSelected = cct;

                $('#DatNombre').val(btn.data('nombre'));
                $('#DatCCT').val(cct);
                $('#DatIncorporacion').val(btn.data('periodo'));
                $('#DatZona').val(btn.data('zona'));
                $('#datTEducativo').val(btn.data('tipoedu'));
                $('#datNEducativo').val(btn.data('nivel'));
                $('#datTurno').val(btn.data('turno'));
                $('#datControl').val(btn.data('control'));
                $('#datAmbito').val(btn.data('ambito'));
                $('#datClasificacion').val(btn.data('clasificacion'));
                $('#DatTDocentes').val(btn.data('tdocentes'));
                $('#DatTAlumnos').val(btn.data('talumnos'));
                $('#DatCalle').val(btn.data('calle'));
                $('#DatEntreCalles').val(btn.data('entrecalles'));
                $('#DatNumero').val(btn.data('num'));
                $('#DatCP').val(btn.data('cp'));
                $('#datDelegacion').val(btn.data('claved'));
                $('#DatColonia').val(btn.data('colonia'));

                $('#DatContacto1').val(btn.data('contacto1'));
                $('#DatCargo1').val(btn.data('cargo1'));
                $('#DatEmail1').val(btn.data('email1'));

                $('#DatContacto2').val(btn.data('contacto2'));
                $('#DatCargo2').val(btn.data('cargo2'));
                $('#DatEmail2').val(btn.data('email2'))

                $('#DatTelefono').val(btn.data('telefono'));
                $('#DatLada').val(btn.data('lada'));
                $('#DatExt').val(btn.data('extension'))
                $('#DatWeb').val(btn.data('website'))

                $('#datClasificacionKit').val(btn.data('ckit'))
                $('#datKit').val(btn.data('ekit'))
                $('#DatNota').val(btn.data('nota'))
                $('#DatFolio').val(btn.data('folio'))
                $('#datPEP').val(btn.data('pep'))


                //  var del = $('#delegacionPnl').val();
                niw.ajax({ action: "GetCliclos", cct: cct }, function (msg) {

                    $('#pnllistclicos').html(msg);

                    //if (msg != '')
                    //    $("#plzAdminBlock .new").attr("disabled", false);
                    //else
                    //    $("#plzAdminBlock .new").attr("disabled", true);
                });


                $("#listaEscolarModal").hide();

                //$('#accordion .panel-info').hide();
                ////for (i = 0; i < sl.length; i++)
                //$('#accordion .panel-info:contains(' + btn.data('nivel') + ')').show();

                //po.getElSchool();

                //$('#encargadoData').val(btn.data('incharge'));
                //$('#datTipo').val(btn.data('type'));
                //$('#datemailp').val(btn.data('emailp'));
                //$('#datemailc').val(btn.data('emailC'));

                //var jefe = btn.data('jefe');
                //$('#datJefe').val(jefe);

                //var estado = btn.data('estado');
                //$('#estadoData').val(estado);

                //$('#DatAgencia').val(btn.data('agencia'));
                //$('#DatEmail').val(btn.data('correo'));
                //$('#DatTel').val(btn.data('telefono'));
                //$('#DatMunicipio').val(btn.data('municipio'));
                //$('#cdgZonaData').val(btn.data('zonacodigo'));


                //var ptype = btn.data('ptype');
                //$('#datType').val(ptype);
                //if (ptype == 1) {
                //    $('#plzOutData').hide();
                //    $('#plzPelData').show().val(btn.data('promoter'));
                //} else {
                //    $('#plzPelData').hide();
                //    $('#plzOutData').show().val(btn.data('promoter'));
                //}

                ////Obtener datos de objetivos de la plaza
                //var y = $('#PlzObjetivs .year').data('now');
                //var m = $('#PlzObjetivs .month').data('now');
                //$('#PlzObjetivs .year').val(y);
                //$('#PlzObjetivs .month').val(m);

                //var idpromo = btn.data('promoter');
                //$('#imgFoto').attr("src", "getImage.aspx?id=" + idpromo);

                //niw.ajax({ action: "GetPlaceObjetives", id: dat.plzId, y: y, m: m }, function (msg) {
                //    $('#DatObjetivesAdded').html(msg);
                //});

                ////Mostrar datos de la plaza
                //$('#plzAdminBlock').show();
            },

            limpiarCampos: function () {
                $('#DatNombre').val('');
                $('#DatCCT').val('');
                $('#DatIncorporacion').val('');
                $('#DatZona').val('');
                $('#datTEducativo').val('EDUCACIÓN BÁSICA');
                $('#datNEducativo').val('PREESCOLAR');
                $('#datTurno').val('MATUTINO');
                $('#datControl').val('PRIVADO');
                $('#datAmbito').val('URBANA');
                $('#datClasificacion').val('');
                $('#DatTDocentes').val('');
                $('#DatTAlumnos').val('');
                $('#DatCalle').val('');
                $('#DatEntreCalles').val('');
                $('#DatNumero').val('');
                $('#DatCP').val('');
                $('#datDelegacion').val('');
                $('#DatColonia').val('');
                $('#DatContacto1').val('');
                $('#DatCargo1').val('');
                $('#DatEmail1').val('');

                $('#DatContacto2').val('');
                $('#DatCargo2').val('');
                $('#DatEmail2').val('')

                $('#DatTelefono').val('');
                $('#DatLada').val('');
                $('#DatExt').val('')
                $('#DatWeb').val('')

                $('#datClasificacionKit').val('A')
                $('#datKit').val('False')
                $('#DatNota').val('')
                $('#DatFolio').val('')
                $('#datPEP').val('False')

            },
            addCiclos: function () {
                var lc = $(this).parent().parent().find('.listContent');
                var ffs = lc.find('.form-field');
                var cicle = '2015-2016';
                if (ffs.length > 0) {
                    ff = ffs.eq(ffs.length - 1).text();
                    cicle = ff.split('-')[1];
                    cicle = cicle + '-' + (parseInt(cicle) + 1);
                }

                //lc.append('<div class="form-field"><a href="#" class="btn btn-default form-control" data-toggle="modal" data-target="#listaEscolarModal" data-backdrop="false">' + cicle + '</a></div>');
                lc.append('<div class="form-field"><a href="#" class="btn btn-default form-control"  data-backdrop="false">' + cicle + '</a></div>');
            },





            getElSchool: function () {
                //var button = (event.relatedTarget)
                //var school = $(this).parents('.panel');
                //po.schoolSelected = school.data('id');
                $("#listaEscolarModal").show();

                var school = $('#PlzList .active');
                var nivel = school.data("nivel");
               // po.schoolSelected = school.data("id");
                po.ciclo = $(this).text();
               // var mod = $(this);
                $('.lists').hide();
                $('#accordion .active').removeClass('active');

                $('#listaEscolarModal .panel-heading .ciclo').text(po.ciclo);
                //Obtener Botones de nivel de estudios
                //var sl = school.find('.list-group-item-text').eq(1).text();
                //sl = sl.split(': ');
                //sl = sl[1].split(',');

                $('#accordion .panel-info').hide();
                //for (i = 0; i < sl.length; i++)
                $('#accordion .panel-info:contains(' + nivel + ')').show();
            },
            getSchoolList: function () {
                if ($(this).data('id') == "compra") {
                    var el = $(this).data('id');
                    var grade = -1;
                } else {
                    var el = $(this).parents('.panel-info').find('.panel-heading').text().replace(/ /g, '').replace(/\n/g, '');
                    var grade = $(this).index();
                }
                $('#accordion .active').removeClass('active');
                $(this).addClass('active');
                grade = parseInt(grade) + 1;
                if (el == 'PREESCOLAR') el = 'Jardin';

                var schoolList = $('#productsList');
                schoolList.data('school', po.schoolSelected);
                schoolList.data('el', el);
                schoolList.data('grade', grade);

                niw.ajax({ action: "GetStudentsNumber", sc: po.schoolSelected, lvl: el, gr: grade, ci: po.ciclo }, function (obj) {
                    obj = JSON.parse(obj);
                    if (obj.n > 0) {
                        $('#saveStudents').parent().parent().find('input:eq(0)').val(obj.n);
                        $('#saveStudents').parent().parent().find('input:eq(1)').val(obj.f);
                    } else {
                        $('#saveStudents').parent().parent().find('input:eq(0)').val('');
                    }

                  //  $('#productsList').html('');

                    niw.ajax({ action: "ShowSchoolProducts", id: po.schoolSelected, el: el, grade: grade, ciclo: po.ciclo }, function (msg) {
                        $('#productsList').html(msg);
                        $('.lists').show();
                        if (el == "compra")
                            $('.lists .page-header').hide();
                        else
                            $('.lists .page-header').show();
                    });
                });
            },
            modSchool: function () {
                var schoolEl = $(this).parent().parent().parent();
                var school = schoolEl.find('.panel-heading').text();
                po.schoolSelected = schoolEl.data('id');
                $('#editTitle .school').text(school);
                niw.ajax({ action: 'GetEditSchoolLevels', id: po.schoolSelected }, function (msg) {
                    msg = JSON.parse(msg);
                    var input = $('#schoolEditModal .modal-body input');
                    for (i = 0; i < msg.length; i++) {
                        if (msg[i].EducationLevel == 'Maternal') input.eq(0).val(msg[i].SepCode);
                        if (msg[i].EducationLevel == 'Jardin') input.eq(1).val(msg[i].SepCode);
                        if (msg[i].EducationLevel == 'Primaria') input.eq(2).val(msg[i].SepCode);
                        if (msg[i].EducationLevel == 'Secundaria') input.eq(3).val(msg[i].SepCode);
                        if (msg[i].EducationLevel == 'Preparatoria') input.eq(4).val(msg[i].SepCode);
                    }
                    $('#schoolEditModal').modal('show');
                });
                return false;
            },
            setModSchool: function () {
                var input = $('#schoolEditModal .modal-body input');
                var mat = input.eq(0).val();
                var jar = input.eq(1).val();
                var pri = input.eq(2).val();
                var sec = input.eq(3).val();
                var pre = input.eq(4).val();

                niw.ajax({ action: 'SetEditSchoolLevels', id: po.schoolSelected, mat: mat, jar: jar, pri: pri, sec: sec, pre: pre }, function (msg) {
                    if (msg == 1)
                        dialogs.alert("Los cambios se han guardado satisfactoriamente", null, "Cambios Guardados", "Aceptar", "iGsuccess");
                });
            },
            deleteSchool: function () {
                mp.waitPage("show");
                var parent = $(this).parent();
                niw.ajax({ action: "DeleteSchool", schoolId: parent.data("school") }, function (msg) {
                    if (msg == "1")
                        parent.parents(".searchField").remove();
                    mp.waitPage("hide");
                }, function () {
                    mp.waitPage("hide");
                });
                return false;
            },
            searchProduct: function () {
                if ($(this).attr('id') == "searchProdId") var c = 1;
                else var c = 2;
                var s = $(this).val().toUpperCase();
                if (s != '') {
                    niw.ajax({ action: "GetSearch", case: c, search: s }, function (msg) {
                        $('#dbProductList').html(msg);
                    });
                } else {
                    $('#dbProductList').html('');
                }
            },
            selectProduct: function () {
                var prodText = $(this).text();
                var prod = prodText.split(' ');
                var npi = $('#newProd input');//newproductsinputs
                npi.eq(0).val(prod[0]);
                npi.eq(1).val(prodText.substr(prod[0].length));
                npi.eq(2).val(1);
                npi.eq(2).data('um', $(this).data('um'));
                npi.eq(2).focus();
                $('#dbProductList').html('');
            },
            addStudentsNumber: function () {
                var num = $(this).parent().parent().find('input:eq(0)').val();
                var fol = $(this).parent().parent().find('input:eq(1)').val();
                if (num != '') {
                    var schoolList = $('#productsList');
                    var school = schoolList.data('school');
                    var el = schoolList.data('el');
                    var grade = schoolList.data('grade');

                    niw.ajax({ action: "AddStudentsNumber", sc: school, lvl: el, gr: grade, no: num, ci: po.ciclo, fo: fol }, function (msg) {
                        if (msg == '1')
                            dialogs.alert("Número de Alumnos Guardado Satisfactoriamente", null, "Número Guardado", "Aceptar", "iGsuccess");
                    });
                }

            },
            addProduct: function () {
                var inputs = $('#newProd input');
                var prodId = inputs.eq(0).val();
                var amount = inputs.eq(2).val();
                var schoolList = $('#productsList');
                var school = schoolList.data('school');
                var el = schoolList.data('el');
                var grade = schoolList.data('grade');

                if (prodId != '' && amount != '' && inputs.eq(1).val() != '') {
                    niw.ajax({ action: "AddProduct", prod: prodId, school: school, el: el, grade: grade, amount: amount, ciclo: po.ciclo }, function (msg) {
                        schoolList.append(msg);
                        var npi = $('#newProd input');
                        npi.eq(0).val('');
                        npi.eq(1).val('');
                        npi.eq(2).val('');
                        npi.eq(2).data('um', '');
                        npi.eq(0).focus();
                    });
                }
            },
            borrarSelectProduct : function()
            {
                var npi = $('#newProd input');//newproductsinputs
                npi.eq(0).val("");
                npi.eq(1).val("");
                npi.eq(2).val('');
                npi.eq(2).data('um', '');
                npi.eq(0).focus();
            }
            ,
            removeProduct: function () {
                var id = $(this).data('id');
                var obj = $(this);
                niw.ajax({ action: "RemoveProduct", id: id }, function (msg) {
                    if (msg == '1')
                        obj.parent().parent().remove();
                    else
                        dialogs.alert("Hubo un error al tratar de eliminar, intente de nuevo más tarde", null, "Error al Eliminar", "Aceptar", "iGdanger");
                });
            }
        };
        $(po.init);
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header row">
        <h1><small>Administración de Escuelas</small></h1>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="list-group-item row">
                <asp:Panel ID="PnlEstado" ClientIDMode="Static" CssClass="input-group" runat="server">
                </asp:Panel>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-4">
            <div id="listPromo" class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Listado de Escuelas</h3>
                    <%--<div class="input-group">
                 <input type="text" id="promSearcher" class="form-control" placeholder="Buscar" />
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
             </div>--%>
                </div>
                <div class="input-group">
                    <input type="text" id="proSearcher" class="form-control" placeholder="Buscar" />
                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                </div>


                <asp:Panel ID="PlzList" ClientIDMode="Static" CssClass="list-group searchlist" runat="server"></asp:Panel>


            </div>
        </div>

        <div class="col-sm-8" id="plzAdminBlock">
            <div class="row plzAdminArea">
                <div class="col-md-12 btn-group" role="group">
                    <button type="button" class="btn btn-success new" disabled="disabled"><i class="fa fa-archive"></i>Agregar Nueva Escuela</button>
                    <button type="button" class="btn btn-primary save" disabled="disabled"><i class="fa fa-save"></i>Guardar Cambios</button>
                    <button type="button" class="btn btn-danger del" disabled="disabled"><i class="fa fa-trash"></i>Eliminar</button>
                </div>
                <div class="clear"></div>
            </div>

            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#menu1">Datos Generales</a></li>
                <li><a data-toggle="tab" href="#menu2">Dirección</a></li>
                <li><a data-toggle="tab" href="#menu3">Contactos</a></li>
                <li><a data-toggle="tab" href="#menu4">Listas Escolares</a></li>
            </ul>
            <div class="tab-content">

                <div id="menu1" class="tab-pane fade in active">
                    <h3></h3>
                    <div class="col-md-12">




                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datNombre">Nombre</label>
                                <input type="text" id="DatNombre" class="form-control" placeholder="Nombre" required="required" />
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datCCT">CCT</label>
                                <input type="text" id="DatCCT" class="form-control" placeholder="CCT" required="required">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datFolio">Folio</label>
                                <input type="text" id="DatFolio" class="form-control" placeholder="Folio" />
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datType">Incorporado PEP</label>
                                <select class="form-control" id="datPEP">
                                    <option value="">Incorporado PEP</option>
                                    <option value="True">SI</option>
                                    <option value="False" selected="selected">NO</option>
                                </select>
                            </div>
                        </div>

                    </div>
                    <div class="col-md-12">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datType">Tipo Educativo</label>
                                <select class="form-control" id="datTEducativo" required="required">
                                    <option value="">Tipo Educativo</option>
                                    <option value="EDUCACIÓN BÁSICA">EDUCACIÓN BÁSICA</option>
                                    <option value="EDUCACIÓN MEDIA">EDUCACIÓN MEDIA</option>
                                    <option value="EDUCACIÓN SUPERIOR">EDUCACIÓN SUPERIOR</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datType">Nivel Educativo</label>
                                <select class="form-control" id="datNEducativo" required="required">
                                    <option value="">Nivel Educativo</option>
                                    <option value="PREESCOLAR">PREESCOLAR</option>
                                    <option value="PRIMARIA">PRIMARIA</option>
                                    <option value="SECUNDARIA">SECUNDARIA</option>
                                    <option value="BACHILLERATO">BACHILLERATO</option>
                                    <option value="UNIVERSIDAD">UNIVERSIDAD</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datType">Turno</label>
                                <select class="form-control" id="datTurno">
                                    <option value="">Turno</option>
                                    <option value="MATUTINO">MATUTINO</option>
                                    <option value="VESPERTINO">VESPERTINO</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datType">Ambito</label>
                                <select class="form-control" id="datAmbito">
                                    <option value="">Ambito</option>
                                    <option value="URBANA">URBANA</option>
                                    <option value="RURAL">RURAL</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datType">Control</label>
                                <select class="form-control" id="datControl">
                                    <option value="">Control</option>
                                    <option value="PRIVADO">PRIVADO</option>
                                    <option value="PUBLICO">PÚBLICO</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datIncorp">Incorporación</label>
                                <input type="text" id="DatIncorporacion" class="form-control" placeholder="Incorporación" required="required" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datZona">Zona Promocional</label>
                                <select class="form-control" id="DatZona" required="required">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datDocente">Total Docentes</label>
                                <input type="number" id="DatTDocentes" class="form-control" placeholder="Total Docentes" />
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datAlumnos">Total Alumnos</label>
                                <input type="number" id="DatTAlumnos" class="form-control" placeholder="Total Alumnos" required="required" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="datType">Clasificación</label>
                                <select class="form-control" id="datClasificacion">
                                    <option value="">Clasificación</option>
                                    <option value="A">A (0-100 ALUMNOS)</option>
                                    <option value="AA">AA (101-400 ALUMNOS)</option>
                                    <option value="AAA">AAA (MAS DE 400 ALUMNOS)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-12">


                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datClaK">Clasificación Kit Escolar</label>
                                <select class="form-control" id="datClasificacionKit">
                                    <option value="">Clasificación Kit Escolar</option>
                                    <option value="A" selected="selected">A</option>
                                    <option value="AA">AA </option>
                                    <option value="AAA">AAA </option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datKitE">Entrega Kit Escolar</label>
                                <select class="form-control" id="datKit">
                                    <option value="">Entrega Kit Escolar</option>
                                    <option value="True">SI</option>
                                    <option value="False" selected="selected">NO</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="datNot">Nota</label>
                                <input type="text" id="DatNota" class="form-control" placeholder="Nota" />
                            </div>
                        </div>
                    </div>
                </div>
                <div id="menu2" class="tab-pane fade in">
                    <h3></h3>
                    <div class="col-md-12">




                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datCalle">Calle</label>
                                <input type="text" id="DatCalle" class="form-control" placeholder="Calle" />
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datEntreCa">Entre Calles</label>
                                <input type="text" id="DatEntreCalles" class="form-control" placeholder="Entre Calles" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datNumero">Numero</label>
                                <input type="Number" id="DatNumero" class="form-control" placeholder="Numero" />
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datColonia">Colonia</label>
                                <input type="text" id="DatColonia" class="form-control" placeholder="Colonia" />
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datDel">Delegación</label>
                                <select class="form-control" id="datDelegacion">
                                </select>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datCP">Codigo Postal</label>
                                <input type="Number" id="DatCP" class="form-control" placeholder="Codigo Postal" />
                            </div>
                        </div>

                    </div>
                </div>
                <div id="menu3" class="tab-pane fade in">
                    <h3></h3>
                    <div class="col-md-12">




                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datContracto1">Contacto 1</label>
                                <input type="text" id="DatContacto1" class="form-control" placeholder="Contacto 1" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datCargo1">Cargo</label>
                                <input type="text" id="DatCargo1" class="form-control" placeholder="Cargo" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datEmail1">Email</label>
                                <input type="text" id="DatEmail1" class="form-control" placeholder="Email" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datContacto2">Contacto 2</label>
                                <input type="text" id="DatContacto2" class="form-control" placeholder="Contacto 2" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datCargo2">Cargo </label>
                                <input type="text" id="DatCargo2" class="form-control" placeholder="Cargo" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="datEmail2">Email</label>
                                <input type="text" id="DatEmail2" class="form-control" placeholder="Email" />
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datLada">Lada</label>
                                <input type="text" id="DatLada" class="form-control" placeholder="Lada" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="datTel">Telefono</label>
                                <input type="text" id="DatTelefono" class="form-control" placeholder="Extesion" />
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label for="datExt">Extesion</label>
                                <input type="text" id="DatExt" class="form-control" placeholder="Extesion" />
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="form-group">
                                <label for="datWeb">Web Site</label>
                                <input type="text" id="DatWeb" class="form-control" placeholder="Web Site" />
                            </div>
                        </div>
                    </div>
                </div>
                <div id="menu4" class="tab-pane fade in">
                    <h3></h3>

                    <div class="col-sm-3">
                        <div id="Ciclos" class="panel panel-success">
                            <div class="panel-heading">
                                <h3 class="panel-title">Cliclos Escolares</h3>
                                <%--<div class="input-group">
                 <input type="text" id="promSearcher" class="form-control" placeholder="Buscar" />
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
             </div>--%>
                            </div>
                            <%--   <div class="input-group">
                    <input type="text" id="proSearcher" class="form-control" placeholder="Buscar" />
                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                </div>--%>


                            <asp:Panel ID="pnllistclicos" ClientIDMode="Static" runat="server"></asp:Panel>


                        </div>
                    </div>

                    <div  class="col-sm-9" id="listaEscolarModal"  aria-labelledby="lemTitle">
       
      
                <div class="panel-heading">
                    <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>--%>
                    <h4 class="modal-title" id="lemTitle">Lista escolar: <span class="ciclo"></span></h4>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="panel panel-info">
                                <div class="panel-heading" role="tab" id="hCompra">
                                    <h4 class="panel-title">
                                        <a role="button" href="#" data-id="compra">
                                            Lista de Compra
                                        </a>
                                    </h4>
                                    
                                </div>
                            </div>
                            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                  <%--<div class="panel panel-info">
                                        <div class="panel-heading" role="tab" id="headingZero">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseZero" aria-expanded="false" aria-controls="collapseZero">
                                                Maternal
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseZero" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingZero">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Primer Grado</a>
                                                <a href="#" class="list-group-item">Segundo Grado</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>--%>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                                                PREESCOLAR
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Primer Grado</a>
                                                <a href="#" class="list-group-item">Segundo Grado</a>
                                                <a href="#" class="list-group-item">Tercer Grado</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingTwo">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                PRIMARIA
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Primer Grado</a>
                                                <a href="#" class="list-group-item">Segundo Grado</a>
                                                <a href="#" class="list-group-item">Tercer Grado</a>
                                                <a href="#" class="list-group-item">Cuarto Grado</a>
                                                <a href="#" class="list-group-item">Quinto Grado</a>
                                                <a href="#" class="list-group-item">Sexto Grado</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingThree">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                SECUNDARIA
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Primer Grado</a>
                                                <a href="#" class="list-group-item">Segundo Grado</a>
                                                <a href="#" class="list-group-item">Tercer Grado</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingFour">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                                BACHILLERATO
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseFour" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Primer Grado</a>
                                                <a href="#" class="list-group-item">Segundo Grado</a>
                                                <a href="#" class="list-group-item">Tercer Grado</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-9 lists">
                            <div class="page-header">
                                <div class="input-group">
                                    <input type="number" class="form-control" min="1" placeholder="Número de Alumnos" />
                                    <input type="text" class="form-control" placeholder="Folio" />
                                    <span class="input-group-btn">
                                        <button class="btn btn-success" id="saveStudents" type="button">Guardar</button>
                                    </span>
                                </div>
                            </div>
                            <div id="productsList"></div>
                            <div class="input-group" id="newProd">
                                <span class="input-group-addon"><input type="text" id="searchProdId" style="width:5em;" /></span>
                                <input type="text" id="searchProd" class="form-control" />
                                <span class="input-group-addon"><input type="number" style="width:3em;" min="0" /></span>
                                <span class="input-group-btn">
                                    <button class="btn btn-success" type="button"><i class="fa fa-check"></i></button>
                                    <button class="btn btn-danger" type="button"><i class="fa fa-remove"></i></button>
                                </span>
                            </div>
                            <asp:Panel ID="dbProductList" CssClass="list-group" ClientIDMode="Static" runat="server"></asp:Panel>
                        </div>
                    </div>
                </div>
         
      
    </div>




                </div>

            </div>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="promotoresModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Administrar Promotores Externos</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <asp:Panel ID="PrmList" ClientIDMode="Static" CssClass="col-md-5 left" runat="server"></asp:Panel>
                        <div class="col-md-7 right">
                            <div class="form-group">
                                <input type="text" id="prmAgencia" class="form-control" placeholder="Nombre de la Agencia" />
                            </div>
                            <div class="row">
                                <div class="col-md-3 form-group">
                                    <input type="text" id="prmNtrab" class="form-control" placeholder="Número de Trabajador" />
                                </div>
                                <div class="col-md-9 form-group">
                                    <input type="text" id="prmNombre" class="form-control" placeholder="Nombre del Promotor" />
                                </div>
                            </div>
                            <div class="form-group">
                                <button id="prmSave" class="form-control btn btn-primary" type="button">Guardar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" id="newPrm"><i class="fa fa-plus"></i>Nuevo Promotor</button>
                </div>
            </div>
        </div>
    </div>
    <%--    <!-- Modal -->
    <div class="modal fade" id="plazasModal" tabindex="-1" role="dialog" aria-labelledby="plzModalLabel">
        <div class="modal-dialog " role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="plzModalLabel">Agregar Plaza</h4>
                </div>
                <div class="modal-body">
                    <div class="wiz-page row wiz-active">
                        <div class="col-sm-6 form-field">
                            <select class="form-control" id="plzType">
                                <option value="">Tipo de Promotor</option>
                                <option value="1">Pelikan</option>
                                <option value="2">Externo</option>
                            </select>
                        </div>
                        <asp:Panel ID="PlzZone" CssClass="col-sm-6 form-field" runat="server"></asp:Panel>
                        <asp:Panel ID="PlzEncargado" CssClass="col-sm-12 form-field" runat="server"></asp:Panel>
                        <asp:Panel ID="PlzPromotor" CssClass="col-sm-12 form-field" runat="server"></asp:Panel>
                        <div class="col-sm-6 form-field">
                            <select class="form-control" id="plzJefe">
                                <option value="">Encargado</option>
                                <option value="1">CHRISTIAN ORTIZ RUIZ</option>
                                <option value="2">MONICA MARQUEZ TORRES</option>
                            </select>
                        </div>
                        <div class="col-sm-6 form-field">
                            <select class="form-control" id="plzTipo">
                                <option value="">Tipo de Plaza</option>
                                <option value="1">Escolar</option>
                                <option value="2">Punto de Venta</option>
                                <option value="3">Mixto</option>
                                <option value="4">AutoServico</option>
                            </select>
                        </div>

                        <asp:Panel ID="PlzEstado" runat="server" CssClass="col-sm-6 form-field"></asp:Panel>

                        <div class="col-sm-6 form-field">
                            <input type="text" id="PlzMunicipio" class="form-control" placeholder="Municipio" />
                        </div>


                        <div class="col-sm-6 form-field">
                            <input type="text" id="PlzAgencia" class="form-control" placeholder="Empresa" />

                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="tel" id="PlzTel" class="form-control" placeholder="Teléfono" />
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="email" id="PlzEmail" class="form-control" placeholder="Correo Electrónico" />

                        </div>

                        <asp:Panel ID="PlzZonaCodigo" runat="server" CssClass="col-sm-6 form-field"></asp:Panel>
                    </div>




                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary">Agregar</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="objetivesModal" tabindex="-1" role="dialog" aria-labelledby="objetivesLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="objetivesLabel">Administrar Objetivos</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <asp:Panel ID="OjetiveList" ClientIDMode="Static" CssClass="col-md-5 left" runat="server"></asp:Panel>
                        <div class="col-md-7 right">
                            <div class="form-group">
                                <input type="text" id="objName" class="form-control" placeholder="Objetivo" />
                            </div>
                            <div class="form-group">
                                <div id="extraDataObjetivs">
                                </div>
                                <div class="input-group" id="objetiveField">
                                    <input type="text" class="form-control" placeholder="Campo de Información" />
                                    <div class="input-group-btn">
                                        <button class="btn btn-success" type="button">Agregar</button>
                                    </div>
                                    <!-- /btn-group -->
                                </div>
                                <!-- /input-group -->
                            </div>
                            <div class="form-group">
                                <button id="objSave" class="form-control btn btn-primary" type="button">Guardar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>--%>
</asp:Content>

