<%@ Page Title="Catálogo de Promotores" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="CatalogoPromotores.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Promotores.CatalogoPromotores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /*a.list-group-item {
    height:auto;
    min-height:220px;
}
a.list-group-item.active small {
    color:#fff;
}
.stars {
    margin:20px auto 1px;    
}*/
      div.searchlist  {
                max-height: 550px;
            overflow-y: auto;
        }

       div  .ornament-column{
    float: left;
    padding: 15px;
}
div .ornament-column img{
    height: 100px;
}
        .form-field{margin:10px auto;}
         .wiz-page{display:none;}
        .wiz-active{display:block;}
        .wiz-page .nEdu{display:none;}

        #promotoresModal .left {
            border-right: solid 1px #e3e3e3;
        }

        .plzPromotor {
            display: none;
        }

        #plzAdminBlock {
            display: none;
        }

        .clear {
            clear: both;
        }

     
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
        var prm = {
            promoter: null,
            init: function () {
                $('#promotoresModal').on('show.bs.modal', prm.newPromoter);
                $('#promotoresModal').on('shown.bs.modal', prm.shownModal);
                $(document).on('click', '#prmSave', prm.savePromoterData);
                $(document).on('click', '#newPrm', prm.newPromoter);
                $(document).on('click', '#PrmList .prmEdit', prm.editPromoter);
                $(document).on('click', '#PrmList .prmDelete', prm.deletePromoter);
            },
            shownModal: function () {
                $('#prmAgencia').focus();
            },
            savePromoterData: function () {
                var ag = $('#prmAgencia').val();
                var nt = $('#prmNtrab').val();
                var nm = $('#prmNombre').val();

                if (ag == '') $('#prmAgencia').css('border-color', '#aa0000');
                else $('#prmAgencia').css('border-color', '#00aa00');
                if (nt == '') $('#prmNtrab').css('border-color', '#aa0000');
                else $('#prmNtrab').css('border-color', '#00aa00');
                if (nm == '') $('#prmNombre').css('border-color', '#aa0000');
                else $('#prmNombre').css('border-color', '#00aa00');

                if (ag != '' && nt != '' && nm != '') {
                    var type = 1;
                    var id = 0;
                    if (prm.promoter != null) {
                        type = 2;
                        id = prm.promoter;
                    }
                    niw.ajax({ action: "SavePromoter", aType: type, prmCode: nt, prmName: nm, prmAgency: ag, prmId: id }, function (msg) {
                        if (msg == '1') {
                            niw.ajax({ action: "GetPromoters" }, function (msg2) {
                                $('#PrmList').html(msg2);
                                prm.newPromoter();
                            });
                        }
                    });
                }
            },
            newPromoter: function () {
                prm.promoter = null;
                $('#prmAgencia').css('border-color', '#999').val('');
                $('#prmNtrab').css('border-color', '#999').val('');
                $('#prmNombre').css('border-color', '#999').val('');

                $('#prmAgencia').focus();
            },
            editPromoter: function () {
                var promoter = $(this).parent().parent();
                prm.promoter = promoter.data('id');

                niw.ajax({ action: "GetPromoter", id: prm.promoter }, function (msg) {
                    msg = JSON.parse(msg);
                    dat = msg[0];
                    $('#prmAgencia').css('border-color', '#999').val(dat.PromoterAgency);
                    $('#prmNtrab').css('border-color', '#999').val(dat.PromoterCode);
                    $('#prmNombre').css('border-color', '#999').val(dat.PromoterName);

                    $('#prmAgencia').focus();
                });
            },
            deletePromoter: function () {
                var promoter = $(this).parent().parent();
                prm.promoter = promoter.data('id');

                niw.ajax({ action: "DelPromoter", id: prm.promoter }, function (msg) {
                    if (msg == '1') {
                        niw.ajax({ action: "GetPromoters" }, function (msg2) {
                            $('#PrmList').html(msg2);
                            prm.newPromoter();
                        });
                    }
                });
            }
        };
        $(prm.init);
    </script>
    <script>
        var obj = {
            init: function () {
                $('#objSave').click(obj.addObjetive);
                $(document).on('click', '#objetivesModal .objDel', obj.delObjetive);
                $(document).on('click', '#objetiveField button', obj.addField);
                $(document).on('click', '#extraDataObjetivs .btn-danger', obj.delField);
            },
            addField: function () {
                var text = $('#objetiveField input').val();
                if (text != '') {
                    $('#objetiveField input').css('border-color', '#999');
                    var field = '<div class="input-group"><p class="form-control">' + text + '</p><div class="input-group-btn"><button class="btn btn-danger" type="button"><i class="fa fa-times"></i></button></div></div>';
                    $('#extraDataObjetivs').append(field);
                    $('#objetiveField input').val('');
                } else {
                    $('#objetiveField input').css('border-color', '#aa0000');
                }
            },
            delField: function () {
                var field = $(this).parent().parent();
                field.remove();
            },
            addObjetive: function () {
                var name = $('#objName').val();
                var desc = $('#extraDataObjetivs .input-group');

                if (name == '') $('#objName').css('border-color', '#aa0000'); else $('#objName').css('border-color', '#999');
                fields = '';
                if (desc.length > 0) {
                    desc.each(function (i) {
                        if (i > 0)
                            fields += ',';
                        fields += $(this).find('.form-control').text();
                    });
                }

                if (name != '' && desc != '') {
                    niw.ajax({ action: "AddObjetive", obj: name, des: fields }, function (msg) {
                        if (msg == '1') {
                            niw.ajax({ action: "GetObjetives" }, function (msg1) {
                                $('#objName').val('');
                                $('#objDesc').val('');
                                $('#extraDataObjetivs').html('');
                                $('#OjetiveList').html(msg1);
                            });
                        }
                    });
                }
            },
            delObjetive: function () {
                var obj = $(this).parent().parent();
                var id = obj.data('id');
                niw.ajax({ action: "DelObjetive", id: id }, function (msg) {
                    if (msg == '1')
                        obj.remove();
                });
            }
        };
        $(obj.init);
    </script>
    <script>
        var plz = {
            plaza: null,
            init: function () {
                //$('table.highchart').highchartTable();
                $(document).on('click', '#PlzList a.list-group-item', plz.selectPlz);
                $('#plazasModal').on('show.bs.modal', plz.showModal);
                $(document).on('click', '#plazasModal .btn-primary', plz.addPlz);
                $(document).on('change', '#plzType', plz.showPromotor);
                $(document).on("keyup", '#proSearcher', plz.searchPromotores);

                plz.selectPlz();
                //plz.searchSchools();
               // plz.searchPromotores();
            },

            
                searchSchools: function(){
                    $('#proSearcher').keyup(function (e) {
                        var kp = e.keyCode;
                        if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                            var txt = $(this).val().toUpperCase();
                            $('.searchlist').hide();
                            $('.searchlist a.list-group-item:contains(' + txt + ')').parents(".searchlist").show();
                                
                                ////, p#PlzList.searchlist:contains(' + txt + ')').parents(".searchlist").show();
                        }
                    });
                },
            searchPromotores: function () {



                var trs = $('#PlzList a.list-group-item');
                    //not('#PlzList a.list-group-item:last-child');
                //console.info(trs);
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#PlzList a.list-group-item:contains(' + str + ')').show();


            },
            showPromotor: function () {
                var val = $(this).val();
                $('.plzPromotor').hide();
                $('.plzPromotor:eq(' + (val - 1) + ')').show();

                if (val == '1')
                    $('#PlzAgencia').val ( 'PELIKAN MÉXICO S.A DE C.V ')
                else
                    $('#PlzAgencia').val ('');

            },
            showModal: function () {
                $('#plzType').val('');
                $('#plzZona').val('');
                $('#plzEncargado').val('');
                $('#plzPelPromotor').val('');
                $('#plzOutPromotor').val('');
                $('#plzJefe').val('');
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
                var jefe = $('#plzJefe').val();
                var estado = $('#plzEstado').val();
                var muni = $('#PlzMunicipio').val();
                var agencia = $('#PlzAgencia').val();
                var mail = $('#PlzEmail').val();
                var tel = $('#PlzTel').val();

                var cdgZona = $('#plzCdgZona').val();

                if (type == '') $('#plzType').css('border-color', '#aa0000'); else $('#plzType').css('border-color', '#999');
                if (zone == '') $('#plzZona').css('border-color', '#aa0000'); else $('#plzZona').css('border-color', '#999');
                if (enca == '') $('#plzEncargado').css('border-color', '#aa0000'); else $('#plzEncargado').css('border-color', '#999');
                if (prom == '') $('.plzPromotor').css('border-color', '#aa0000'); else $('.plzPromotor').css('border-color', '#999');
                if (jefe == '') $('#plzJefe').css('border-color', '#aa0000'); else $('#plzJefe').css('border-color', '#999');
                if (tipo == '') $('#plzTipo').css('border-color', '#aa0000'); else $('#plzTipo').css('border-color', '#999');
                if (estado == '') $('#plzEstado').css('border-color', '#aa0000'); else $('#plzEstado').css('border-color', '#999');
                if (muni == '') $('#PlzMunicipio').css('border-color', '#aa0000'); else $('#PlzMunicipio').css('border-color', '#999');
                if (agencia == '') $('#PlzAgencia').css('border-color', '#aa0000'); else $('#PlzAgencia').css('border-color', '#999');
                if (mail == '') $('#PlzEmail').css('border-color', '#aa0000'); else $('#PlzEmail').css('border-color', '#999');
                if (tel == '') $('#PlzTel').css('border-color', '#aa0000'); else $('#PlzTel').css('border-color', '#999');
                if (cdgZona == '') $('#plzCdgZona').css('border-color', '#aa0000'); else $('#plzCdgZona').css('border-color', '#999');


                if (type != '' && zone != '' && enca != '' && prom != '' && tipo != '' && jefe != '' && estado != '' && agencia != '' && mail != '' && tel !='' && muni != '' && cdgZona !='') {
                    mp.waitPage('show');
                    niw.ajax({ action: 'AddPlz', type: type, zone: zone, enca: enca, prom: prom, tipo: tipo, jefe: jefe, estado: estado, agencia: agencia, mail: mail, tel: tel, muni: muni, cdgZona: cdgZona }, function (msg) {
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
                $('#PlzList .active').removeClass('active');
                $(this).addClass('active');
                plz.plaza = $(this).data('id');
                var parent = $(this).parent().parent();
                parent.removeClass('col-sm-offset-4');

                dat.getPlzData($(this));
            }
        };
        $(plz.init);
    </script>
    <script>
        var dat = {
            plzId: null,
            init: function () {
                $(document).on("click", "#plzAdminBlock .del", dat.delPlz);
                $(document).on("click", "#datAddObjetive", dat.addObjetive);
                $(document).on("click", "#DatObjetivesAdded .btn-danger", dat.delObjetive);
                $(document).on("click", "#plzAdminBlock .save", dat.savePlzData);
                $(document).on("change", "#PlzObjetivs .year,#PlzObjetivs .month", dat.showObjetivesPlaces);

            },
            getPlzData: function (btn) {
                //Obtener datos generales de la plaza
                dat.plzId = btn.data('id');
                $('#datZone').val(btn.data('zone'));
                $('#encargadoData').val(btn.data('incharge'));
                $('#datTipo').val(btn.data('type'));
                $('#datemailp').val(btn.data('emailp'));
                $('#datemailc').val(btn.data('emailC'));

                var jefe = btn.data('jefe');
                $('#datJefe').val(jefe);

                var estado = btn.data('estado');
                $('#estadoData').val(estado);

                $('#DatAgencia').val(btn.data('agencia'));
                $('#DatEmail').val(btn.data('correo'));
                $('#DatTel').val(btn.data('telefono'));
                $('#DatMunicipio').val(btn.data('municipio'));
                $('#cdgZonaData').val(btn.data('zonacodigo'));
           

                var ptype = btn.data('ptype');
                $('#datType').val(ptype);
                if (ptype == 1) {
                    $('#plzOutData').hide();
                    $('#plzPelData').show().val(btn.data('promoter'));
                } else {
                    $('#plzPelData').hide();
                    $('#plzOutData').show().val(btn.data('promoter'));
                }

                //Obtener datos de objetivos de la plaza
                var y = $('#PlzObjetivs .year').data('now');
                var m = $('#PlzObjetivs .month').data('now');
                $('#PlzObjetivs .year').val(y);
                $('#PlzObjetivs .month').val(m);

                var idpromo = btn.data('promoter');
                $('#imgFoto').attr("src", "getImage.aspx?id=" + idpromo);

                niw.ajax({ action: "GetPlaceObjetives", id: dat.plzId, y: y, m: m }, function (msg) {
                    $('#DatObjetivesAdded').html(msg);
                });

                //Mostrar datos de la plaza
                $('#plzAdminBlock').show();
            },
            delPlz: function () {
                niw.ajax({ action: "DelPlace", id: plz.plaza }, function (msg) {
                    if (msg == 1) {
                        $('#plzAdminBlock').hide();
                        $('.list-group-item[data-id=' + plz.plaza + ']').remove();
                    }
                });
            },
            addObjetive: function () {
                var parent = $(this).parent().parent();
                var select = parent.find('select');
                var id = select.val();
                if (id != '') {
                    var objetive = select.find('option[value=' + id + ']').text();
                    var list = '<div class="input-group" data-id="' + id + '"><p class="form-control">' + objetive + '</p><span class="input-group-addon"><i class="fa fa-chevron-right"></i></span><input type="number" class="form-control" min="0" placeholder="Cantidad" /><div class="input-group-btn"><button class="btn btn-danger" type="button"><i class="fa fa-times"></i></button></div></div>';

                    $('#DatObjetivesAdded').append(list);
                    select.val('');
                }
            },
            delObjetive: function () {
                var parent = $(this).parent().parent();
                parent.remove();
            },
            //,
            //searchPromotores: function () {
            //    $('#promSearcher').keyup(function (e) {
            //        var kp = e.keyCode;
            //        if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
            //            var txt = $(this).val();
            //            $('.searchField').hide();
            //            $('.searchField .panel-heading:contains(' + txt + '), .searchField .panel-body h5:contains(' + txt + ')').parents(".searchField").show();
            //        }
            //    });
            //},
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


                var jefe = $('#datJefe').val();
                var estado = $('#estadoData').val();
                var muni = $('#DatMunicipio').val();
                var agencia = $('#DatAgencia').val();
                var correo = $('#DatEmail').val();
                var tel = $('#DatTel').val();

                var cdgZona = $('#cdgZonaData').val();

                objs = objs.substr(1);
                niw.ajax({ action: "UpdatePlace", id: dat.plzId, zone: $('#datZone').val(), charge: $('#encargadoData').val(), emailp: $('#datemailp').val(), emailc: $('#datemailc').val(), tipo: $('#datTipo').val(), type: $('#datType').val(), promoter: promData, y: y, m: m, objs: objs, jefe: jefe, agencia: agencia, correo: correo, tel: tel, estado: estado, muni: muni, cdgZona: cdgZona }, function (msg) {
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
    <script>
        function confirmDel() {
            var agree = confirm("¿Realmente desea eliminarlo? ");
            if (agree) return true;
            else return false;
        }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header row">
        <h1><small>Administración de Promotores</small></h1>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="list-group-item row">
                <button type="button" class="btn btn-info" data-toggle="modal" data-target="#promotoresModal" data-backdrop="false">Administrar Promotores Externos</button>
                <button type="button" class="btn btn-info" data-toggle="modal" data-target="#objetivesModal" data-backdrop="false">Administrar Objetivos</button>
                <button type="button" class="btn btn-info" data-toggle="modal" data-target="#plazasModal" data-backdrop="false">Agregar Plaza</button>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div  class="col-sm-4">
            <div  id="listPromo" class="panel panel-primary">
                <div class="panel-heading">
                      <h3 class="panel-title">Listado de Promotores</h3>
                    <%--<div class="input-group">
                 <input type="text" id="promSearcher" class="form-control" placeholder="Buscar" />
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
             </div>--%> 

                </div>
                        <div class="input-group">
                            <input type="text" id="proSearcher" class="form-control" placeholder="Buscar" />
                            <span class="input-group-addon"><i class="fa fa-search"></i></span>
                        </div>
                  
                    
                        <asp:Panel   ID="PlzList" ClientIDMode="Static" CssClass="list-group searchlist" runat="server"></asp:Panel>
                    
               
            </div>
        </div>
        <div class="col-sm-8" id="plzAdminBlock">
            <div class="row plzAdminArea">
                <div class="col-md-12 btn-group" role="group">
                    <button type="button" class="btn btn-primary save"><i class="fa fa-save"></i>Guardar Cambios</button>
                    <button type="button" class="btn btn-danger del"><i class="fa fa-trash"></i>Eliminar</button>
                </div>
                <div class="clear"></div>
            </div>
            <div class="row">
          <div class="ornament-column">
                <img src="" id="imgFoto" class="media-object  img-rounded img-responsive"/>
            </div>
    </div>
            <div class="row">

                <div class="col-md-2">
                    <div class="form-group">
                        <label for="datCdgZona">Codigo Zona</label>
                        <asp:Panel ID="DatCdgZona" ClientIDMode="Static" runat="server"></asp:Panel>
                    </div>
                    </div>

              

                 <div class="col-md-3">
                    <div class="form-group">
                        <label for="datEstado">Estado</label>
                        <asp:Panel ID="DatEstado" runat="server"></asp:Panel>
                    </div>
                </div>

                <div class="col-md-3">
                      <div class="form-group">
                          <label for="datMunicipio">Municipio</label>
                            <input type="text" id="DatMunicipio" class="form-control" placeholder="Municipio" />
                          </div>
                        </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <label for="datEncargado">Vendedor</label>
                        <asp:Panel ID="DatEncargado" ClientIDMode="Static" runat="server"></asp:Panel>
                    </div>
                </div>
                
            </div>
            <div class="row">
                <div class="col-md-2">
                    <div class="form-group">
                        <label for="datType">Tipo de Promotor</label>
                        <select class="form-control" id="datType">
                            <option value="">Tipo de Promotor</option>
                            <option value="1" selected="selected">Pelikan</option>
                            <option value="2">Externo</option>
                        </select>
                    </div>
                </div>

                <div class="col-md-3">
                      <div class="form-group">
                          <label for="datAgencia">Empresa</label>
                            <input type="text" id="DatAgencia" class="form-control" placeholder="Empresa" />
                          </div>
                        </div>

                <div class="col-md-3">
                    <div class="form-group">
                        <label for="datTipo">Tipo Plaza</label>
                        <select class="form-control" id="datTipo">
                            <option value="">Tipo de Plaza</option>
                            <option value="1" selected="selected">Escolar</option>
                            <option value="2">Punto de Venta</option>
                            <option value="3">Mixto</option>
                            <option value="4">AutoServico</option>
                        </select>
                    </div>
                </div>


               
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="DatJefe">Encargado</label>
                        <select class="form-control" id="datJefe">
                            <option value="">Encargado</option>
                            <option value="1" selected="selected" >CHRISTIAN ORTIZ RUIZ</option>
                            <option value="2">MONICA MARQUEZ TORRES</option>
                        </select>
                    </div>
                </div>
               
                  <div class="col-md-2">
                    <div class="form-group">
                        <label for="datZone">Zona</label>
                        <asp:Panel ID="DatZone" ClientIDMode="Static" runat="server"></asp:Panel>
                    </div>
                </div>

                 <div class="col-md-4">
                    <div class="form-group">
                        <label for="datPromoter">Promotor</label>
                        <asp:Panel ID="PromotorData" runat="server"></asp:Panel>
                    </div>
                </div>

                  <div class="col-md-3">
                               <div class="form-group">
                                <label for="datTelefono">Teléfono</label>
                                   
                            <input type="tel" id="DatTel" class="form-control" placeholder="Teléfono" />
                                   </div>
                        </div>
                  
                          <div class="col-md-3">
                              <div class="form-group">
                               <label for="datEmail">Correo Electrónico</label>
                            <input type="email" id="DatEmail" class="form-control" placeholder="Correo Electrónico" />
                                  </div>
                        </div>

                
                         
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
                        <hr />
                        <div class="row">
                            <div class="col-md-12">
                                <asp:Panel ID="Panel3" ClientIDMode="Static" runat="server"></asp:Panel>
                                <div class="input-group">
                                    <asp:Panel ID="Panel4" runat="server"></asp:Panel>
                                    <%--<div class="input-group-btn">
                            <button class="btn btn-success" type="button" id="">Agregar</button>
                        </div><!---%>
                                </div>
                                <!-- /input-group -->
                            </div>
                        </div>
                    </div>


                </div>
                <div id="form-objetives" class="row">
                    <div class="col-md-12">
                        <h4>Objetivos</h4>
                        <asp:Panel ID="PlzObjetivs" ClientIDMode="Static" runat="server"></asp:Panel>
                    </div>
                </div>
                <hr />
                <div class="row">
                    <div class="col-md-12">
                        <asp:Panel ID="DatObjetivesAdded" ClientIDMode="Static" runat="server"></asp:Panel>
                        <div class="input-group">
                            <asp:Panel ID="DatObjetives" runat="server"></asp:Panel>
                            <div class="input-group-btn">
                                <button class="btn btn-success" type="button" id="datAddObjetive">Agregar</button>
                            </div>
                            <!-- /btn-group -->
                        </div>
                        <!-- /input-group -->
                    </div>
                </div>

                <div class="row plzAdminArea">
                    <div class="col-md-12 btn-group" role="group">
                        <button type="button" class="btn btn-primary save"><i class="fa fa-save"></i>Guardar Cambios</button>
                        <button type="button" onclick="confirmDel()" class="btn btn-danger del"><i class="fa fa-trash"></i>Eliminar</button>
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
    <!-- Modal -->
    <div class="modal fade" id="plazasModal" tabindex="-1" role="dialog" aria-labelledby="plzModalLabel">
        <div class="modal-dialog " role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="plzModalLabel">Agregar Plaza</h4>
                </div>
                <div class="modal-body">
                      <div class="wiz-page row wiz-active" >
                    <div class="col-sm-6 form-field">
                        <select class="form-control" id="plzType">
                            <option value="">Tipo de Promotor</option>
                            <option value="1">Pelikan</option>
                            <option value="2">Externo</option>
                        </select>
                    </div>
                    <asp:Panel ID="PlzZone" CssClass="col-sm-6 form-field" runat="server"></asp:Panel>
                    <asp:Panel ID="PlzEncargado"  CssClass="col-sm-12 form-field" runat="server"></asp:Panel>
                    <asp:Panel ID="PlzPromotor"  CssClass="col-sm-12 form-field" runat="server"></asp:Panel>
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
    </div>
</asp:Content>
