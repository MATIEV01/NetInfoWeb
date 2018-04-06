<%@ Page Title="Administrar Usuarios" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="adminUsers.aspx.cs" Inherits="NI5sWeb.Modules.Contabilidad.adminUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .addBtn, #UsersNoPermitted, #permissionsList, #areasList {
            margin-top: 15px;
        }

            #areasList a {
                width: 40px;
            }

        .permissions-left {
            background-color: #F5F5F5;
            border-right: solid 1px #cfcfcf;
            padding-top: 15px;
            padding-bottom: 15px;
            min-height: 100%;
        }

        .permissions-right h5 {
            margin: 10px 0;
            font-weight: bold;
        }

        .permissions-right .input-group a {
            width: 40px;
        }

        #areasList .form-control, #permisos .form-control {
            font-size: .6em;
        }
    </style>
    <script>
        var iface = {
            init: function () {
                $(document).on("keyup", "#searchAllUsers", iface.searchAllUsers);
                $(document).on("keyup", '#searchAllowedUsers', iface.searchUsersAllowed);
                $(document).on("keyup", "#searchAreas", iface.searchAreas);
                $(document).on("keyup", "#searchPermissions", iface.searchPermissions);
            },
            searchAllUsers: function (e) {
                var kp = e.keyCode;
                if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                    var sf = $('#UsersNoPermitted .searchField');
                    sf.hide();
                    sf.find(".sf-userId:contains(" + $(this).val() + "), .sf-userName:contains(" + $(this).val().toUpperCase() + ")").parents(".searchField").show();
                }
            },
            searchUsersAllowed: function (e) {
                var kp = e.keyCode;
                if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                    var sf = $('.usersBox .searchField');
                    sf.hide();
                    sf.find(".sf-userId:contains(" + $(this).val() + "), .sf-userName:contains(" + $(this).val().toUpperCase() + ")").parents(".searchField").show();
                }
            },
            searchAreas: function (e) {
                var kp = e.keyCode;
                if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                    var sf = $('#areasList .searchField');
                    sf.hide();
                    sf.find(".sf-centerId:contains(" + $(this).val() + "), .sf-centerName:contains(" + $(this).val().toUpperCase() + ")").parents(".searchField").show();
                }
            },
            searchPermissions: function (e) {
                var kp = e.keyCode;
                if (kp != 16 && kp != 17 && kp != 18 && kp != 91 && kp != 93 && kp != 13) {
                    var sf = $('#permissionsList .searchField');
                    sf.hide();
                    sf.find(".sf-centerId:contains(" + $(this).val() + "), .sf-centerName:contains(" + $(this).val().toUpperCase() + ")").parents(".searchField").show();
                }
            },
        };
        $(iface.init);
    </script>
    <script>
        var po = {
            permUsrId: null,

            init: function () {
                po.bindUsers();
                $(document).on("click", '.usersBox a:nth-child(2)', po.deleteUser);
                $(document).on("click", '#UsersNoPermitted .searchField a', po.addUser);
                $('#permissionUsersModal').on('show.bs.modal', po.onPermissionModalShow);
                //$('#permissionUsersModal').on('show.bs.modal', po.check);
                $(document).on("click", '#areasList .searchField a.btn-success', po.addCostCenters);
                $(document).on("click", '#cuentasList .searchField a.btn-success', po.setPermissions);
                $(document).on("click", '#CuentaAList .searchField a.btn-danger', po.deletecuenta);
                $(document).on("click", '#permissionsList .searchField a.btn-danger, #areasList .searchField a.btn-danger', po.delCostCenters);
                $(document).on("click", '#permissionsList .searchField .sf-centerName', po.getAllAccounts);
                $(document).on("click", '#permissionUsersModal .permissions-right .searchField a', po.setPermissions);
                $(document).on("click", '.nav-tabs a[href="#cuentas"]', po.bindCuentas);
                $(document).on("click", '.nav-tabs a[href="#cuentasAsig"]', po.bindCuentasAsig);
               
                $('#dtExpiracion').change(po.updateFechaExpiracion);
             


                $(document).on('change', '#CuentaAList .checkbox', function () {
                    var user = po.permUsrId;
                    var select = false;
                    var value = $(this).val();
                    var check = $(this);
                    var mensage = '';
                    if ($(this).is(':checked')) {
                        select = true;

                        mensage = '¿Esta seguro de asignarle permisos a la cuenta:' + $(this).val() + '?';
                    } else {
                        mensage = '¿Esta seguro de quitarle permisos a la cuenta:' + $(this).val() + '?';
                        //select = false;
                    }

                    dialogs.confirm(mensage, function (evt) {
                        if (!evt.target.classList.contains('cancel-btn')) {
                            //var tr = $(this).parents('tr');

                            niw.ajax({ action: "updateSelect", user: user, value: value, select: select });
                        }
                        else {
                            if (select) {

                                check.prop("checked", false);
                            }
                            else {

                                check.prop("checked", true);
                            }
                        }
                    }, "¿Está seguro...?", "Si", "No", "iGquestion");

                });
            },


            bindUsers: function () {
                niw.ajax({ action: "bindCostCenters" }, po.usersGett);
             
            },
            usersGett: function (msg) {
                $('#UsersBox').html(msg);
            },

            updateFechaExpiracion : function()
            {
                var dtFecha = $("#dtExpiracion").val();
                var user = po.permUsrId;

                dialogs.confirm("¿Esta seguro de modificar la fecha expericacion?", function (evt) {
                    if (!evt.target.classList.contains('cancel-btn')) {
                        //var tr = $(this).parents('tr');

                        niw.ajax({ action: "UpdateFecha", dtFecha: dtFecha, user: user }, po.bindUsers);
                        
                    }
                }, "¿Está seguro...?", "Si", "No", "iGquestion");

                
            },


            deleteUser: function () {
                var parent = $(this).parent().parent();
                dialogs.confirm("¿Esta seguro que desea quitar el acceso al usuario?", function (e) {
                    if (!e.target.classList.contains('cancel-btn')) {
                        var usrId = parent.data('user');
                        mp.waitPage("show");
                        niw.ajax({ action: "DeleteUser", usr: usrId }, function (msg) {
                            if (msg == "1") {
                                var list = "<div class=\"input-group searchField\" data-user=\"" + parent.data("user") + "\">";
                                list += "<span class=\"input-group-addon sf-userId\">" + parent.find(".input-group-addon").text() + "</span>";
                                list += "<p class=\"form-control sf-userName\">" + parent.find(".form-control").text() + "</p>";
                                list += "<span class=\"input-group-btn\">";
                                list += "<a href=\"#\" class=\"btn btn-success\"><i class=\"fa fa-check\"></i></a>";
                                list += "</span>";
                                list += "</div>";
                                $('#UsersNoPermitted').append(list);
                                parent.remove();
                                mp.waitPage("hide");
                            }
                        });
                    }
                }, "Eliminar Usuario", "Si", "No");
            },



            addUser: function () {
                var parent = $(this).parents('.searchField');
                mp.waitPage("show");
                niw.ajax({ action: "AddUser", usrId: parent.data('user') }, function (msg) {
                    if (msg == "1") {
                        //dialogs.alert("El usuario se ha agregado satisfactoriamente", null, "Usuario Agregado", "Aceptar", "iGsuccess");
                        var list = "<div style=\"font-family:Tahoma; font-size:9px;\"class=\"input-group searchField\" data-user=\"" + parent.data("user") + "\">";
                        list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon sf-userId\">" + parent.find(".input-group-addon").text() + "</span>";
                        list += "<p style=\"font-family:Tahoma; font-size:9px;\"class=\"form-control sf-userName\">" + parent.find(".form-control").text() + "</p>";
                        list += "<span class=\"input-group-btn\">";
                        list += "<a href=\"#\" class=\"btn btn-info\" data-toggle=\"modal\" data-target=\"#permissionUsersModal\">Permisos</a>";
                        list += "<a href=\"#\" class=\"btn btn-danger\"><i class=\"fa fa-trash\"></i></a>";
                        list += "</span>";
                        list += "</div>";
                        $(".usersBox").append(list);
                        parent.remove();
                    }
                    location.reload();
                    mp.waitPage("hide");
                });
            },

            bindCuentas: function () {

                niw.ajax({
                    action: "BindCuentas", user: po.permUsrId
                }, po.CuentasGetted);
            },
            CuentasGetted: function (msg) {
                $('#cuentasList').html(msg);
            },

            bindCuentasAsig: function () {

                niw.ajax({
                    action: "getUserCuentas", user: po.permUsrId
                }, po.CuentasAGetted);
            },
            CuentasAGetted: function (msg) {
                $('#CuentaAList').html(msg);
            },


            onPermissionModalShow: function (e) {
                var parent = $(e.relatedTarget).parent().parent();
                $(this).find(".permissions-right").html('');
                po.permUsrId = parent.data('user');
                po.showCostCentersAllowed();
                $(this).find('.searchField').show();
            },
            showCostCentersAllowed: function () {
                mp.waitPage("show");
                $('#areasList .searchField .btn').removeClass('btn-danger').addClass('btn-success');
                $('#areasList .searchField .btn i').removeClass('fa-times').addClass('fa-plus');
                niw.ajax({ action: 'GetUserPermissions', usr: po.permUsrId }, function (msg) {
                    msg = JSON.parse(msg);
                    if (msg.length > 0) {
                    var dt = msg[0].FechaExp;

                   
                        $("#dtExpiracion").val(dt);

                        //Recorrer el JSON
                        var rows = '';
                        for (i = 0; i < msg.length; i++) {
                            var id = msg[i].Centro;
                            var des = msg[i].Descripcion;
                            rows += '<div class="input-group searchField" data-user="' + id + '"><span class="input-group-addon sf-centerId">' + id + '</span>';
                            rows += '<p  class="form-control sf-centerName">' + des + '</p>';
                            rows += '<span class="input-group-btn"><a href="#" class="btn btn-danger"><i class="fa fa-times"></i></a></span></div>';
                            $('#areasList .searchField').each(function () {
                                if ($(this).data('id') == id) {
                                    $(this).find('.btn').removeClass('btn-success').addClass('btn-danger');
                                    $(this).find('.btn i').removeClass('fa-plus').addClass('fa-times');
                                }
                            });
                        }
                        $('#permissionsList').html(rows);
                        mp.waitPage("hide");

                       
                    }
                    else
                        mp.waitPage("hide");
                }
                    , function () {
                    mp.waitPage("hide");
                });
            },
            addCostCenters: function () {
                mp.waitPage("show");
                var parent = $(this).parent().parent();
                var btn = $(this);
                var id = parent.data('id');
                var CCto = $('#centro').val();
                niw.ajax({ action: "addPermission", id: id, usr: po.permUsrId }, function (msg) {
                    if (msg == 1) {
                        btn.removeClass("btn-success").addClass('btn-danger');
                        btn.find('i').removeClass('fa-plus').addClass("fa-times");
                        $('#permissionsList').append(parent.clone());
                    }
                    mp.waitPage("hide");
                }, function () {
                    mp.waitPage("hide");
                });
            },
            delCostCenters: function () {
                mp.waitPage("show");
                var parent = $(this).parent().parent();
                var btn = $(this);
                var id = parent.data('id') || parent.data('user');
                niw.ajax({ action: "delPermission", id: id, usr: po.permUsrId }, function (msg) {
                    if (msg == 1) {
                        $("#areasList .searchField[data-id=" + id + "] a.btn").removeClass("btn-danger").addClass('btn-success');
                        $("#areasList .searchField[data-id=" + id + "] a.btn").find('i').removeClass('fa-times').addClass("fa-plus");
                        $('#permissionsList .searchField[data-user=' + id + '], #permissionsList .searchField[data-id=' + id + ']').remove();
                        $('#permissionUsersModal .permissions-right').html('');
                    }
                    mp.waitPage("hide");
                }, function () {
                    mp.waitPage("hide");
                });
            },
            getAllAccounts: function () {
                mp.waitPage("show");
                var parent = $(this).parent();
                var id = parent.data("user") || parent.data("id");
                var name = $(this).text();
                niw.ajax({ action: "getAllAccounts", usr: po.permUsrId, id: id }, function (msg) {
                    msg = JSON.parse(msg);
                    var list = '<h5>' + name + '</h5>';
                    for (i = 0; i < msg.length; i++) {
                        list += '<div class="input-group searchField" data-id="' + msg[i].MasterAccount + '">';
                        list += '<span class="input-group-addon sf-userId">' + msg[i].MasterAccount + '</span>';
                        list += '<p class="form-control sf-userName">' + msg[i].GLAccountGroupDescription + '</p>';
                        //Hacer Left Join con los permisos y si viene distinto de nulo en vez de pencil será un ojo
                        var btn = 'btn-primary';
                        var ico = 'fa-pencil';
                        if (msg[i].ReadOnly == '1') { btn = 'btn-info'; ico = 'fa-eye'; }
                        list += '<span class="input-group-btn"><a href="#" class="btn ' + btn + '"><i class="fa ' + ico + '"></i></a></span></div>';
                    }
                    $('#permissionUsersModal .permissions-right').html(list);
                    mp.waitPage("hide");
                }, function () {
                    mp.waitPage("hide");
                })
            },

            setPermissions: function () {
                var parent = $(this).parent().parent();
                var id = parent.data('id');

                niw.ajax({ action: "readOnly", usr: po.permUsrId, id: id });
            }
            ,
            deletecuenta: function () {
                var parent = $(this).parent().parent();
                var id = parent.data("id");
                dialogs.confirm("¿Está seguro que desea eliminar la cuenta?", function (evt) {
                    if (!evt.target.classList.contains('cancel-btn')) {


                        niw.ajax({ action: "readWrite", usr: po.permUsrId, id: id });
                    }
                }, "¿Está seguro...?", "Si", "No");


            }

        };
        $(po.init);
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="page-header">
        <h2>Administrar Usuarios<br />
            <small>Usuarios para Presupuestos de Gastos</small></h2>
    </div>
    <div class="row">
        <div class="col-sm-10 col-sm-offset-1" style="height: 400px; overflow-y: scroll;">
            <div class="input-group input-group-lg">
                <input type="text" class="form-control" placeholder="Buscar" id="searchAllowedUsers" />
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
            </div>
            <a href="#" class="btn btn-primary addBtn" data-toggle="modal" data-target="#addUserModal"><i class="fa fa-plus"></i>Agregar Usuario</a>

            <asp:Panel ID="UsersBox" runat="server" ClientIDMode="Static" CssClass="usersBox"></asp:Panel>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Agregar Usuario</h4>
                </div>
                <div class="modal-body">
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" placeholder="Buscar Usuario" id="searchAllUsers" />
                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                    </div>
                    <asp:Panel ID="UsersNoPermitted" ClientIDMode="Static" runat="server"></asp:Panel>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="permissionUsersModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" style="font-family: Tahoma; font-size: 11px; height: 900px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Permisos a presupuestar</h4>

                </div>
                <div class="modal-body row">
                    <div class="col-sm-12 permissions-left">
                        <div class="input-group" id="datesContainer">
                            <span style="background-color:#337ab7; color:#fff; " class="input-group-addon">Fecha Expiración</span>
                            <input type="date" style="width:200px" class="form-control" id="dtExpiracion" />
                        </div>
                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active"><a href="#permisos" aria-controls="permisos" role="tab" data-toggle="tab">Centros de Costos Asignados</a></li>
                            <li role="presentation"><a href="#cuentasAsig" aria-controls="cuentasAsig" role="tab" data-toggle="tab">Cuentas Asignadas</a></li>
                            <li role="presentation"><a href="#areas" aria-controls="areas" role="tab" data-toggle="tab">Centros de Costos</a></li>
                            <li role="presentation"><a href="#cuentas" aria-controls="cuentas" role="tab" data-toggle="tab">Cuentas Existentes</a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane active" id="permisos">
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="Buscar Permisos" id="searchPermissions" />
                                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                </div>
                                <div id="permissionsList" style="font-family: Tahoma; font-size: 16px;"></div>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="cuentasAsig">
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="Buscar Cuentas" id="searchCuentasAsig" />
                                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                </div>
                                <asp:Panel ID="CuentaAList" ClientIDMode="Static" runat="server"></asp:Panel>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="areas">
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="Buscar Áreas" id="searchAreas" />
                                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                </div>
                                <asp:Panel ID="areasList" ClientIDMode="Static" runat="server"></asp:Panel>
                            </div>
                            <div role="tabpanel" class="tab-pane" id="cuentas">
                                <div class="input-group input-group-sm">
                                    <input type="text" class="form-control" placeholder="Buscar Cuentas" id="searchCuentas" />
                                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                                </div>
                                <asp:Panel ID="cuentasList" ClientIDMode="Static" runat="server"></asp:Panel>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8 permissions-right">
                        <h5>INFORMATICA</h5>
                        <div class="input-group searchField" data-user="1-45">
                            <span class="input-group-addon sf-userId">1-45-00000-00000</span>
                            <p class="form-control sf-userName">Informática</p>
                            <p class="form-control sf-userDate"></p>
                            <span class="input-group-btn">
                                <a href="#" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
                            </span>
                        </div>
                        <div class="input-group searchField" data-user="1-45">
                            <span class="input-group-addon sf-userId">1-45-00000-00000</span>
                            <p class="form-control sf-userName">Informática</p>
                            <p class="form-control sf-userDate"></p>
                            <span class="input-group-btn">
                                <a href="#" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
                            </span>
                        </div>
                        <div class="input-group searchField" data-user="1-45">
                            <span class="input-group-addon sf-userId">1-45-00000-00000</span>
                            <p class="form-control sf-userName">Informática</p>
                            <p class="form-control sf-userDate"></p>
                            <span class="input-group-btn">
                                <a href="#" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
                            </span>
                        </div>
                        <div class="input-group searchField" data-user="1-45">
                            <span class="input-group-addon sf-userId">1-45-00000-00000</span>
                            <p class="form-control sf-userName">Informática</p>
                            <p class="form-control sf-userDate"></p>
                            <span class="input-group-btn">
                                <a href="#" class="btn btn-info"><i class="fa fa-eye"></i></a>
                            </span>
                        </div>
                        <div class="input-group searchField" data-user="1-45">
                            <span class="input-group-addon sf-userId">1-45-00000-00000</span>
                            <p class="form-control sf-userName">Informática</p>
                            <p class="form-control sf-userDate"></p>
                            <span class="input-group-btn">
                                <a href="#" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
                            </span>
                        </div>
                        <div class="input-group searchField" data-user="1-45">
                            <span class="input-group-addon sf-userId">1-45-00000-00000</span>
                            <p class="form-control sf-userName">Informática</p>
                            <p class="form-control sf-userDate"></p>
                            <span class="input-group-btn">
                                <a href="#" class="btn btn-primary"><i class="fa fa-pencil"></i></a>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="cerrar" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
