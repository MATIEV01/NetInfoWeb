<%@ Page Title="Análisis de Objetivos" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="AnalisisObjetivos.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Promotores.AnalisisObjetivos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .table td{text-align:center;}
        .table  th{text-align:center;}
        .table input{text-align:right}
        #placeObjetive{display:none;}
        .weekend{background-color:#0094ff;color:#fff;font-weight:bold;}
    </style>
    <script>
        var places = {
            init: function () {
                $(document).on('click', '#PlacesList .list-group-item', places.selectPlace);
            },
            selectPlace: function(){
                var place = $(this);
                place.parent().find('.active').removeClass('active');
                place.addClass('active');
                
                dat.placeId = place.data('id');
                dat.bindYears();
                dat.fillData();
                $('#placeObjetive').show();
            }
        }
        $(places.init);
    </script>
    <script>
        var dat = {
            placeId: null,
            init: function () {
                //$(document).on("click", "#placeObjetive .table td", dat.showDetails);
                $(document).on("change", "#DatePanel .year, #DatePanel .month", dat.fillData);
            },
            bindYears: function(){
                var panel = $('#DatePanel');
                var ynow = parseInt(panel.data("year"));
                var mnow = parseInt(panel.data("month"));
                var sel = "";
                for (i = ynow; i >= 2015; i--) {
                    sel += '<option value="'+i+'">'+i+'</option>';
                }
                panel.find('.year').html(sel);
                panel.find('.month').val(mnow);
            },
            showDetails: function () {
                var cell = $(this);
                var dayS = parseInt(cell.parent().find('th').text());
                var monS = parseInt($('#placeObjetive .month').val());
                var date = dayS;
                if (dayS < 10)
                    date = '0' + dayS;
                if (monS < 10)
                    date += '/0' + monS;
                else
                    date += '/' + monS;
                date += '/' + $('#placeObjetive .year').val();

                alert(date);
            },
            fillData: function(){
                var m = $('#placeObjetive .month').val();
                var y = $('#placeObjetive .year').val();
                niw.ajax({ action: "GetObjetiveDoneData", id: dat.placeId, m: m, y: y }, function (msg) {
                    $('#objetivesDataTable').html(msg);
                });
            }
        };
        $(dat.init);
    </script>
    <script>
        var objDone = {
            init: function () {
                $('#objetivesModal').on('show.bs.modal', objDone.openModal);
                $(document).on('change', '#ObjetivesList select', objDone.getFields);
                $(document).on('click', '#addDone', objDone.addNewDone);
                $(document).on('click', '#objetivesModal .modal-footer .btn-primary', objDone.saveNewDone);
                $(document).on('click', '#objetivesList button.del', objDone.deleteDone);
                $(document).on("keyup", '#proSearcher', objDone.searchPromotores);
                //$(document).on('click', '#addArchivo',objDone.saveNewDone)
            },
            searchPromotores: function () {

                var trs = $('#PlacesList a.list-group-item');
                //console.info(trs);
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#PlacesList a.list-group-item:contains(' + str + ')').show();
            },
            openModal: function () {
                var m = $('#DatePanel .month').val();
                var y = $('#DatePanel .year').val();
                niw.ajax({ action: "GetObjetivesPlaces", id: dat.placeId, m: m, y: y }, function (msg) {
                    niw.ajax({ action: "GetObjetivesDone", id: dat.placeId, m: m, y: y }, function (msg2) {
                        $('#objetivesList').html(msg2);
                        $("#ObjetivesList").html(msg);
                        $('#dayDone').val('');
                        $('#objetiveFields').html('');
                        $('#objetiveStaticFields input').val('');
                    });
                });
            },
            getFields: function () {
                var objId = $(this).val();
                var fields = $(this).find("option[value=" + objId + "]").data('desc');
                fields = fields.split(',');
                fieldsList = "";
                for (i = 0; i < fields.length; i++)
                    fieldsList += '<div class="input-group"><span class="input-group-addon">'+fields[i]+':</span><input type="text" class="form-control" /></div>';
                $('#objetiveFields').html(fieldsList);
            },
            addNewDone: function () {
                $("#ObjetivesList select").val('');
                $('#dayDone').val('');
                $('#objetiveFields').html('');
                $('#objetiveStaticFields input').val('');
            },
            deleteDone: function () {
                var id = $(this).parent().parent().data('id');
                niw.ajax({ action: "DeleteObjetiveDone", id: id }, function (msg) {
                    if (msg == '1') {
                        var m = $('#DatePanel .month').val();
                        var y = $('#DatePanel .year').val();
                        niw.ajax({ action: "GetObjetivesDone", id: dat.placeId, m: m, y: y }, function (msg2) {
                            $('#objetivesList').html(msg2);
                        });
                    }
                });
            },
            saveNewDone: function () {
                var d = $('#dayDone').val();
                var obj = $('#ObjetivesList select').val();
                if(d == '') $('#dayDone').css('border-color','#aa0000'); else $('#dayDone').css('border-color','#999');
                if(obj == '') $('#ObjetivesList select').css('border-color','#aa0000'); else $('#ObjetivesList select').css('border-color','#999');
                if(d != '' && obj != ''){
                    d = parseInt(d);
                    if(d < 10) d = '0' + d;
                    var m = $('#DatePanel .month').val();
                    if(m < 10) m = '0' + m;
                    var y = $('#DatePanel .year').val();
                    var date = m+'/'+d+'/'+y;
                
                    var cli = $('#objetiveStaticFields input:eq(0)').val();
                    var con = $('#objetiveStaticFields input:eq(1)').val();
                    var car = $('#objetiveStaticFields input:eq(2)').val();
                    var archivo = $('#objetiveStaticFields input:eq(3)').val();
                  
                   

                    var fields = "";
                    $('#objetiveFields input').each(function () {
                        var field = $(this).val();
                        fields += "," + field;
                    });
                    fields = fields.substring(1);
                    
                        niw.ajax({ action: "AddObjetivesDone", pl: dat.placeId, obj: obj, date: date, cli: cli, con: con, car: car, desc: fields}, function (msg) {
                        if (msg == '1') {
                            niw.ajax({ action: "GetObjetivesDone", id: dat.placeId, m: m, y: y }, function (msg2) {
                                $('#objetivesList').html(msg2);
                                objDone.addNewDone();
                             //   niw.ajax({ action: "CargaArchivo", archivo:archivo }, function (msg) {
                             //});
                            });

                        }
                    });
                }

            }
        };
        $(objDone.init);
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">

       

         <div   class="col-sm-3">
            <div class="panel panel-primary">
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
                  
                    
                        
                 <asp:Panel ID="PlacesList" ClientIDMode="Static" CssClass=" list-group" runat="server"></asp:Panel>
                    
               
            </div>
        </div>


        <div class="col-md-9" id="placeObjetive">
            <asp:Panel ID="DatePanel" ClientIDMode="Static" CssClass="input-group" runat="server">
                <span class="input-group-addon">Año:</span>
                <select class="form-control year">
                </select>
                <span class="input-group-addon">Mes:</span>
                <select class="form-control month">
                    <option value="1">Enero</option>
                    <option value="2">Febrero</option>
                    <option value="3">Marzo</option>
                    <option value="4">Abril</option>
                    <option value="5">Mayo</option>
                    <option value="6">Junio</option>
                    <option value="7">Julio</option>
                    <option value="8">Agosto</option>
                    <option value="9">Septiembre</option>
                    <option value="10">Octubre</option>
                    <option value="11">Noviembre</option>
                    <option value="12">Diciembre</option>
                </select>
                <span class="input-group-btn">
                    <a href="#" class="btn btn-info" data-toggle="modal" data-target="#objetivesModal" data-backdrop="false"><i class="fa fa-plus"></i> Agregar Objetivos Cumplidos</a>
                </span>
            </asp:Panel>
            <table id="objetivesDataTable" class="table table-condensed table-hover">
            </table>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="objetivesModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Objetivos Realizados</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div id="objetivesList"></div>
                            <button type="button" id="addDone" class="btn btn-success form-control"><i class="fa fa-plus"></i> Agregar Cumplimiento</button>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-addon">Día:</span>
                                <input type="number" id="dayDone" class="form-control" placeholder="0" min="1" max="31" />
                            </div>
                            <div class="input-group">
                                <span class="input-group-addon">Objetivo:</span>
                                <asp:Panel ID="ObjetivesList" ClientIDMode="Static" runat="server"></asp:Panel>
                            </div>
                            <hr />
                            <div id="objetiveStaticFields">
                                <div class="input-group">
                                    <span class="input-group-addon">Cliente:</span>
                                    <input type="text" class="form-control" />
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon">Contacto:</span>
                                    <input type="text" class="form-control" />
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon">Cargo:</span>
                                    <input type="text" class="form-control" />
                                </div>
                                <div class="input-group">
                                <span class="input-group-addon">Puntual:</span>
                                    <select class="form-control" id="Select1" runat="server">
                                        <option value="1">si</option>
                                        <option value="0">no</option>
                                    </select>
                                    </div>
                                <%--<div>
                                   <input class="form-control" type="file" id=File1 name=File1 runat="server" />
                                   <button type="button" runat="server" id="addArchivo" value="Upload" class="btn btn-success form-control"><i class="fa fa-plus"></i>Carga Archivo</button>
                                </div>--%>
                            </div>
                            <div id="objetiveFields"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-primary">Guardar</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>