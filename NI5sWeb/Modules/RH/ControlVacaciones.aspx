<%@ Page Title="" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="ControlVacaciones.aspx.cs" Inherits="NI5sWeb.Modules.RH.ControlVacaciones" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304" Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

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
    </style>
    <script>
        var emp = {
            folio: null,
            row: null,
            documentPrint: null,
            init: function () {
                //$('table.highchart').highchartTable();
                $("#Nuevo").attr("disabled", true);
                $("#print").attr("disabled", true);
                //$("#Cerrar").hide();
                $(document).on("keyup", '#buscar', emp.searchEmpleado);
                $(document).on("click", "#empleados", emp.selectEmpleado)
                $(document).on("click", "#print", emp.printFormato)
                $(document).on("change", 'input[type="date"]', emp.getDias);
                $(document).on("click", "#save", emp.setNewFormato);
                $(document).on("click", '#folios tr', emp.selectRow);
                //},
                //selectRow: function () {
                //    var parent = $(this).parent();
                //    var table = parent.parent().parent();
                //    var tit = table.find('thead tr:eq(0) th').text();
                //    if (parent.index() == 0 && $(this).index() < 13) {
                //        iface.dtl = $(this);
                //        $('#detalles .titTxt').text(tit);
                //        $('#detalles').modal("show");
                //    }
                //$(document).on("click", "#folios tr ", emp.selectRow);
                //plz.selectPlz();
                //plz.searchSchools();
                // plz.searchPromotores();

                //$(document).ready(function () {
                //    $('#vacaciones').DataTable({
                //        select: true
                //    });
                //});



                //var $table = $('#folios');

                //$(function () {
                //    $table.on('click-row.bs.table', function (e, row, $element) {
                //        $('.success').removeClass('success');
                //        $($element).addClass('success');
                //    });



                //    //$('#plazasModal').click(function () {
                //    //    alert('Selected name: ' + getSelectedRow().folio);
                //    //});
                //});

                //function getSelectedRow() {
                //    var index = $table.find('tr.success').data('index');
                //    return $table.bootstrapTable('getData')[index];
                //}

                //$('#folios').on('click-row.bs.table', function (e, row, $element) {

                //    var row_num = parseInt($(this).parent().index()) + 1;

                //    var row_num = $(this).closest('tr').index();

                //    var row_num = $(this).closest('td').parent()[0].text;

                //    alert(row_num);

                //});

            },
            setNewFormato: function () {
                var from = $("#fromDate").val();
                var to = $("#toDate").val();
                var coment = $("#coment").val();
                var dias = $("#dias").val();
                var noemp = $('#empleados option:selected').data("noemp");

                if(from!='' && to!= '' && coment != '' && noemp !='')
                {
                    niw.ajax({ action: "setNewFormato", from: from, to: to, coment: coment, dias: dias, noemp: noemp }, function (msg) {
                        if(msg=='1')
                        {
                            dialogs.alert("Datos guardados correctamente", null, "Transacción Existosa", "Aceptar", "iGsuccess");
                            
                        }
                        else
                        {
                            dialogs.alert("Ocurrio un error", null, "Error", "Aceptar", "iGdanger");
                        }

                    })
                }

                emp.selectEmpleado();

                $('#agregarModal').hide();

            }
            ,
            getDias : function()
            {
                var from = $("#fromDate").val();               
                var control = $(this).attr("id");

                if (control == "fromDate")
                    $("#toDate").val(from);

                var to = $("#toDate").val();

                niw.ajax({ action: "getDias", from:from, to: to }, function (msg) {
                     $("#dias").val(msg);
                });
                
            }
            ,
            selectRow: function () {

                if (emp.row != null) {
                    $(emp.row).css("background-color", "#f9f9f9");

                }

                $(this).css("background-color", "#a2d4ed");
                var text = $(this).find('td').eq(0).text();

                emp.folio = text;

                emp.row = $(this);

                $('#MainContent_PrintSection').hide();

                $("#print").attr("disabled", false);
                //var noemp = $('#empleados option:selected').data("noemp");

                //niw.ajax({ action: "getFormato", noemp: noemp, folio: emp.folio }, function (msg) {

                //    var params = {
                //        url: 'Reporte\\getFormato.aspx?name=' + msg,
                //        // pdfOpenParams: { statusbar: 1, view: '' }
                //        pdfOpenParams: { toolbar: 0, view: 'FitV', pagemode: 'thumbs' }

                //    };

                //    document.getElementById('MainContent_PrintSection').style.height = '520px';
                //    var myPDF = new PDFObject(params).embed('MainContent_PrintSection');

                //    $('#MainContent_PrintSection').show();

                //});

            },
            printFormato: function () {

                var noemp = $('#empleados option:selected').data("noemp");



                niw.ajax({ action: "getFormato", noemp: noemp, folio: emp.folio, documentAnterior: emp.documentPrint }, function (msg) {

                    emp.documentPrint = msg;

                    var params = {
                        url: 'Reporte\\getFormato.aspx?name=' + msg,
                        // pdfOpenParams: { statusbar: 1, view: '' }
                        pdfOpenParams: { toolbar: 1, view: 'FitV', pagemode: 'thumbs' }

                    };

                    document.getElementById('MainContent_PrintSection').style.height = '720px';
                    var myPDF = new PDFObject(params).embed('MainContent_PrintSection');

                    $('#MainContent_PrintSection').show();

                });



                // niw.ajax({ action: "getVacacionesStatus", noemp: noemp, folio: emp.folio });
            }
            //,
            //showModal: function () {
            //    alert('Selected name: ' + getSelectedRow().folio);
            //},
            //getSelectedRow: function () {
            //    var index = $table.find('tr.success').data('index');
            //    return $table.bootstrapTable('getData')[index];
            //}
            ,
            searchEmpleado: function () {



                var trs = $('#listEmpleados option');
                //not('#PlzList a.list-group-item:last-child');
                //console.info(trs);
                trs.hide();
                var str = $(this).val().toUpperCase();
                $('#listEmpleados option:contains(' + str + ')').show();


            },
            selectEmpleado: function () {

                var noemp = $('#empleados option:selected').data("noemp");
                $("span[id$='numEmpleado']").text(noemp);

                var nombre = $('#empleados option:selected').data("nombre");
                $("span[id$='nombre']").text(nombre);

                var puesto = $('#empleados option:selected').data("puesto");
                $("span[id$='puesto']").text(puesto);

                var depa = $('#empleados option:selected').data("depa");
                $("span[id$='departamento']").text(depa);

                var fecha = $('#empleados option:selected').data("fecha");
                $("span[id$='fechaIngreso']").text(fecha);


                niw.ajax({ action: "getVacacionesStatus", noemp: noemp }, function (msg) {

                    var arr = msg.split("|");

                    $('#VacTable').html(arr[0]);

                    $("span[id='AvailableDays']").text(arr[1]);

                    if (parseInt(arr[1]) > 0) {
                        $("span[id='AvailableDays']").addClass("label-primary");
                    }
                    else
                        $("span[id='AvailableDays']").addClass("label-danger");
                });

                if (typeof noemp == 'undefined') {
                    $("#Nuevo").attr("disabled", true);
                    // $("#print").attr("disabled", true);
                }
                else {
                    $("#Nuevo").attr("disabled", false);
                    //  $("#print").attr("disabled", false);
                }

            }
        };
        $(emp.init);
    </script>
    <script src="/Themes/NIWeb/js/pdfobject.js"> </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header row">
        <h1>Control Vacaciones</h1>
    </div>

    <div>

        <div class="col-md-5 col-lg-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Listado de Empleados</h3>
                    <br />
                    <div class="input-group">
                        <input id="buscar" type="text" class="form-control" placeholder="Buscar" />
                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                    </div>
                    <%--<select  multiple  class="form-control" id="empleados" style="height:550px; font-size: 15px; font-family: Tahoma">
                        </select><br />--%>
                    <asp:Panel ID="listEmpleados" ClientIDMode="Static" CssClass="list-group searchlist" runat="server"></asp:Panel>
                </div>
            </div>
        </div>


        <div id="EmployeeData" class="col-md-8">
            <div class="col-xs-3">
                <label for="lblNoEmpl">Num. Empleado:</label>
                <div>
                    <asp:Label ID="numEmpleado" runat="server" Text=""> </asp:Label>
                </div>

            </div>

            <div class="col-xs-5">
                <label for="lblNom">Nombre Empleado:</label>
                <div>
                    <asp:Label ID="nombre" runat="server" Text=""> </asp:Label>
                </div>

            </div>

            <div class="col-xs-4">
                <label for="lblDepa">Departamento:</label>
                <div>
                    <asp:Label ID="departamento" runat="server" Text=""> </asp:Label>
                </div>
            </div>
            <div class="col-xs-3">
                <label for="lblPuesto">Puesto:</label>
                <div>
                    <asp:Label ID="puesto" runat="server" Text=""> </asp:Label>
                </div>
            </div>

            <div class="col-xs-9">

                <label for="lblFechaIn">Fecha de Ingreso:</label>
                <div>
                    <asp:Label ID="fechaIngreso" runat="server" Text=""> </asp:Label>
                </div>

            </div>

            <div class="col-md-12 panel panel-info">
                <div class="panel-heading">
                    <h3>Tabla de vacaciones por año <small>Vacaciones Disponibles:</small>
                        <asp:Label ID="AvailableDays" ClientIDMode="Static" CssClass="label" runat="server" Text="0"></asp:Label></h3>
                </div>
                <asp:Panel ID="VacTable" ClientIDMode="Static" CssClass="panel-body" runat="server"></asp:Panel>
            </div>

            <div class="col-md-12">
                <div class="list-group-item row">
                    <button id="Nuevo" type="button" class="btn btn-info" data-toggle="modal" data-target="#agregarModal" data-backdrop="false">Crear Nuevo Formato</button>
                    <button id="print" type="button" class="btn btn-primary" data-toggle="modal" data-target="#imprimirModal" data-backdrop="false">Imprimir Formato</button>
                </div>

                <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" AutoDataBind="true" />
            </div>

            <div class="row">


                <div class="col-md-12">
                    <div id="MainContent_PrintSection">
                    </div>
                </div>
                <%--<asp:Panel ID="GeneratedTableYears" ClientIDMode="Static" runat="server"></asp:Panel>--%>
            </div>

        </div>

        <div class="modal fade" id="agregarModal" tabindex="-1" role="dialog" aria-labelledby="agregarModalLabel">
            <div class="modal-dialog " role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="agregarModalLabel">Crear Nuevo Formato Vacaciones</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group" id="datesContainer">
                                        <span class="input-group-addon">Desde:</span>
                                        <input type="date" style="width:160px" class="form-control" id="fromDate" />
                                        <span class="input-group-addon">Hasta:</span>
                                        <input type="date" style="width:160px" class="form-control" id="toDate" />

                                         <span class="input-group-addon">Dias:</span>
                                        <input type="text" realonly style="background-color:maroon; color:white;  width:50px" class="form-control" id="dias" />

                                    </div>
                                </div>
                            </div>

                             <div class="col-md-12">
                                <div class="form-group">
                                    <label for="datComent">Comentario:</label>
                            <textarea class="form-control" rows="5" id="coment"></textarea>

                                </div>
                            </div>
                        </div>
                    </div>

                     <div class="modal-footer">
                    <button id="save" type="button" class="btn btn-success" ><i class="fa fa-plus"></i>Guardar</button>
                </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
