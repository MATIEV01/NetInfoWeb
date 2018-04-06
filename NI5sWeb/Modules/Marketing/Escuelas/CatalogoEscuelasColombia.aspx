<%@ Page Title="Catálogo de Escuelas" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="CatalogoEscuelasColombia.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Escuelas.CatalogoEscuelas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-field{margin:10px auto;}
        .wiz-page{display:none;}
        .wiz-active{display:block;}
        .wiz-page .nEdu{display:none;}
        .searchField h5{font-weight:bold;}
        .searchField .panel-footer {text-align:right;}
        .searchField .panel-footer .listCiclos{overflow:hidden;position:relative;}
        .searchField .panel-footer .listCiclos .movible{margin-top:-100%;}

        .lists{display:none;}
        .lists .page-header{margin-top:0;}
    </style>
    <script>
        var iface = {
            init: function () {
                iface.wizNextBtn();
                iface.showCiclos();
                iface.addCiclos();
                iface.wizShowCities();
                $('#myModal').on("show.bs.modal", iface.openMyModal);
                iface.searchSchools();
                //$('.modal').modal({ backdrop: false });
            },
            openMyModal: function (e) {
                $(this).find('.wiz-active').removeClass('wiz-active');
                $(this).find('.wiz-page:eq(0)').addClass('wiz-active');
                if (e.relatedTarget.text == " Agregar Escuela") {
                    iface.resetForm($(this));
                }
            },
            searchSchools: function(){
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
                $(document).on("click",'.searchField .panel-footer .btn-group a:nth-child(1)', function () {
                    var movible = $(this).parent().next().find('.movible');
                    var mH = movible.outerHeight() + 20;
                    var mMT = movible.css('margin-top').split('p')[0];

                    if (!$(this).data('active')) {
                        $(this).data('active', true);
                        movible.animate({ "margin-top": "+=" + (mMT * -1) }, 800);
                    } else {
                        $(this).data('active', false);
                        movible.animate({ "margin-top": "-="+mH }, 800);
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
            wizSend: function(obj){
                var modal = obj.parent().parent();
                var allWiz = modal.find(".modal-body");
                var vals = allWiz.find('input, select');
                var formData = "action=CreateSchool";
                vals.each(function () {
                    var id = $(this).attr('id');
                    if (id == "escCSP" || id == "escCSPrim" || id == "escCSS" ) {
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
                $(document).on("click", ".searchField .panel-footer .btn-group a.delSchool", po.deleteSchool);
                $(document).on("click", ".searchField .panel-footer .btn-group a.modSchool", po.modSchool);
                $(document).on("click", "#newProd .btn-success", po.addProduct)
                $(document).on("keyup", "#searchProdId, #searchProd", po.searchProduct);
                $(document).on("click", "#dbProductList a", po.selectProduct);
                $(document).on("click", "#productsList .input-group .btn", po.removeProduct);
                $('#listaEscolarModal').on('show.bs.modal', po.getElSchool);
                $(document).on("click", "#accordion .panel-info .list-group a, #hCompra a", po.getSchoolList);
                $(document).on("click", "#saveStudents", po.addStudentsNumber);
                $(document).on("click", "#schoolEditModal .modal-footer .btn-primary", po.setModSchool);
            },
            getElSchool: function (event) {
                var button = $(event.relatedTarget)
                var school = button.parents('.panel');
                po.schoolSelected = school.data('id');
                po.ciclo = button.text();
                var mod = $(this);
                $('.lists').hide();
                $('#accordion .active').removeClass('active');

                mod.find('.ciclo').text(button.text());
                //Obtener Botones de nivel de estudios
                var sl = school.find('.list-group-item-text').eq(1).text();
                sl = sl.split(': ');
                sl = sl[1].split(',');

                $('#accordion .panel-info').hide();
                for (i = 0; i < sl.length; i++)
                    $('#accordion .panel-info:contains(' + sl[i] + ')').show();
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
                if (el == 'JardíndeNiños') el = 'Jardin';

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
                        if (msg[i].EducationLevel == 'Preescolar') input.eq(0).val(msg[i].SepCode);
                        if (msg[i].EducationLevel == 'Primaria') input.eq(1).val(msg[i].SepCode);
                        if (msg[i].EducationLevel == 'Secundaria') input.eq(2).val(msg[i].SepCode);
                       
                    }
                    $('#schoolEditModal').modal('show');
                });
                return false;
            },
            setModSchool: function(){
                var input = $('#schoolEditModal .modal-body input');
                var pre = input.eq(0).val();
                var pri = input.eq(1).val();
                var sec = input.eq(2).val();
                

                niw.ajax({ action: 'SetEditSchoolLevels', id: po.schoolSelected, pre: pre,  pri: pri, sec: sec }, function (msg) {
                    if (msg == 1)
                        dialogs.alert("Los cambios se han guardado satisfactoriamente", null, "Cambios Guardados", "Aceptar", "iGsuccess");
                });
            },
            deleteSchool: function () {
                mp.waitPage("show");
                var parent = $(this).parent();
                niw.ajax({ action: "DeleteSchool", schoolId: parent.data("school") }, function (msg) {
                    if(msg=="1")
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
        <h1><small>Catálogo de Escuelas</small></h1>
    </div>

    <div class="row">
        <div class="col-sm-8 col-sm-offset-2">
            <div class="list-group">
                <div class="list-group-item row">
                    <a href="#" class="btn btn-primary col-xs-12" data-toggle="modal" data-target="#myModal" data-backdrop="false"><i class="fa fa-plus"></i> Agregar Escuela</a>
                </div>
                <div class="list-group-item row">
                    <div class="input-group">
                        <input type="text" id="escSearcher" class="form-control" placeholder="Buscar" />
                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                    </div>
                </div>
                <asp:Panel ID="SchoolList" ClientIDMode="Static" CssClass="list-group-item row" runat="server"></asp:Panel>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Agregar Escuela</h4>
                </div>
                <div class="modal-body">
                    <div class="wiz-page row wiz-active" id="newDomicilio">
                        <div class="col-sm-12 form-field">
                            <input id="escNom" type="text" class="form-control" placeholder="Nombre de la Escuela" required="required" />
                        </div>
                        <div class="col-sm-12 form-field">
                            <input id="escDir" type="text" class="form-control" placeholder="Dirección" required="required" />
                        </div>
                        <asp:Panel ID="escEstado" runat="server" CssClass="col-sm-6 form-field"></asp:Panel>
                        <asp:Panel ID="escCiudad" runat="server" CssClass="col-sm-6 form-field"></asp:Panel>
                        <div class="col-sm-7 form-field">
                            <input id="escCol" type="text" class="form-control" placeholder="Colonia" required="required" />
                        </div>
                        <div class="col-sm-5 form-field">
                            <input id="escCP" type="number" class="form-control" placeholder="Código Postal" required="required" />
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="email" id="escEmail" class="form-control" placeholder="Correo Electrónico" />
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="tel" id="escTel" class="form-control" placeholder="Teléfono" />
                        </div>
                        <asp:Panel ID="PromotersList" ClientIDMode="Static" CssClass="col-sm-12 form-field" runat="server"></asp:Panel>

                        <asp:Panel ID="EstractoList" ClientIDMode="Static" CssClass="col-sm-12 form-field" runat="server"></asp:Panel>
                    </div>
                    <div class="wiz-page row" id="newEscuelas">
                        <div class="col-sm-6 form-field">
                            <select id="escCentro" class="form-control" required="required">
                                <option value="">Tipo de Escuela</option>
                                <option value="1">Pública</option>
                                <option value="2">Privada</option>
                            </select>
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="number" id="escMaestros" min="1" class="form-control" required="required" placeholder="No. Maestros" />
                        </div>
                        <div class="col-sm-12">
                            <fieldset>
                                <legend>Nivel Educativo:</legend>
                                <div class="row">
                                    <div class="col-sm-6 form-field">
                                        <label for="escCSM">Preescolar</label>
                                        <input type="text" id="escCSP" class="form-control" placeholder="Clave SEP" />
                                    </div>
                                   <%-- <div class="col-sm-6 form-field">
                                        <label for="escCSJ">Jardín de Niños</label>
                                        <br />
                                        <input type="text" id="escCSJ" class="form-control" placeholder="Clave SEP" />
                                    </div>--%>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6 form-field">
                                        <label for="escCSPrim">Primaria</label>
                                        <input type="text" id="escCSPrim" class="form-control" placeholder="Clave SEP" />
                                    </div>
                                    <div class="col-sm-6 form-field">
                                        <label for="escCSS">Secundaria</label>
                                        <input type="text" id="escCSS" class="form-control" placeholder="Clave SEP" />
                                    </div>
                                </div>
                               <%-- <div class="row">
                                    <div class="col-sm-6 form-field">
                                        <label for="escCSPrep">Preparatoria</label>
                                        <input type="text" id="escCSPrep" class="form-control" placeholder="Clave SEP" />
                                    </div>
                                </div>--%>
                            </fieldset>
                        </div>
                    </div>
                    <div class="wiz-page row" id="newCargos">
                        <div class="col-sm-12 form-field">
                            <input type="text" id="escCargosCargo" class="form-control" placeholder="Cargo o Puesto" required="required" />
                        </div>
                        <div class="col-sm-12 form-field">
                            <input type="text" id="escCargosNom" class="form-control" placeholder="Nombre" required="required" />
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="text" id="escCargosApp" class="form-control" placeholder="Apellido Paterno" />
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="text" id="escCargosApm" class="form-control" placeholder="Apellido Materno" />
                        </div>
                        <!--<div class="col-sm-6 form-field">
                            <input type="tel" id="escCargosTel" class="form-control" placeholder="Teléfono" />
                        </div>
                        <div class="col-sm-6 form-field">
                            <input type="email" id="escCargosMail" class="form-control" placeholder="Correo Electrónico" required="required" />
                        </div>-->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default"><i class="fa fa-hand-o-left"></i> Anterior</button>
                    <button type="button" class="btn btn-primary">Siguiente <i class="fa fa-hand-o-right"></i></button>
                </div>
            </div>
        </div>
    </div>
    <!-- ------------------- MODAL DE CICLOS ESCOLARES -------------------------- -->
    <div class="modal fade" id="listaEscolarModal" tabindex="-1" role="dialog" aria-labelledby="lemTitle">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="lemTitle">Lista escolar: <span class="ciclo"></span></h4>
                </div>
                <div class="modal-body">
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
                                                Preescolar
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Caminadores</a>
                                                <a href="#" class="list-group-item">Párvulos</a>
                                                <a href="#" class="list-group-item">Pre Jardín</a>
                                                <a href="#" class="list-group-item">Jardín</a>
                                                <a href="#" class="list-group-item">Transición</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingTwo">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                Primaria
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
                                            
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingThree">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                                Secundaria
                                            </a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                            <div class="list-group">
                                                <a href="#" class="list-group-item">Sexto Grado</a>
                                                <a href="#" class="list-group-item">Septimo Grado</a>
                                                <a href="#" class="list-group-item">Octavo Grado</a>
                                                <a href="#" class="list-group-item">Noveno Grado</a>
                                                <a href="#" class="list-group-item">Decimo Grado</a>
                                                <a href="#" class="list-group-item">Once Grado</a>
                                                <a href="#" class="list-group-item">Doce Grado</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                               <%-- <div class="panel panel-info">
                                    <div class="panel-heading" role="tab" id="headingFour">
                                        <h4 class="panel-title">
                                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                                Preparatoria
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
                                </div>--%>
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
                                </span>
                            </div>
                            <asp:Panel ID="dbProductList" CssClass="list-group" ClientIDMode="Static" runat="server"></asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

        <!-- ------------------- MODAL EDITAR -------------------------- -->
    <div class="modal fade" id="schoolEditModal" tabindex="-1" role="dialog" aria-labelledby="lemTitle">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="editTitle">Escuela: <span class="school"></span></h4>
                </div>
                <div class="modal-body">
                    <fieldset>
                        <legend>Nivel Educativo:</legend>
                        <div class="row">
                             <%--<div class="col-sm-6 form-field">
                                <label for="escCSM">Maternal</label>
                                <input type="text" id="edtCSM" class="form-control" placeholder="Clave SEP" />
                            </div>--%>
                            <div class="col-sm-6 form-field">
                                <label for="escCSP">Preescolar</label>
                                <br />
                                <input type="text" id="edtCSP" class="form-control" placeholder="Clave SEP" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6 form-field">
                                <label for="escCSPrim">Primaria</label>
                                <input type="text" id="edtCSPrim" class="form-control" placeholder="Clave SEP" />
                            </div>
                            <div class="col-sm-6 form-field">
                                <label for="escCSS">Secundaria</label>
                                <input type="text" id="edtCSS" class="form-control" placeholder="Clave SEP" />
                            </div>
                        </div>
                       <%-- <div class="row">
                            <div class="col-sm-6 form-field">
                                <label for="escCSPrep">Preparatoria</label>
                                <input type="text" id="edtCSPrep" class="form-control" placeholder="Clave SEP" />
                            </div>
                        </div>--%>
                    </fieldset>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary">Guardar Cambios</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
