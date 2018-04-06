<%@ Page Title="" Language="C#" MasterPageFile="~/Themes/NIWeb/NI5.Master" AutoEventWireup="true" CodeBehind="NetInfoPermissions.aspx.cs" Inherits="NI5sWeb.Modules.Security.NetInfoPermissions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        #NetInfoUsersList .searchableh{display:none;}
        
    </style>
    <script>
        var iface = {
            init: function () {
                $('#userSearch').keyup(iface.search);
                $(document).on("click", "#NetInfoUsersList .searchable", iface.userSelected);
                $(document).on("click", "#PermissionsList .btn-default", iface.setPermission);
                $(document).on("click", "#PermissionsList .btn-primary", iface.delPermission);
            },
            search: function () {
                var val = $(this).val().toUpperCase();
                //alert(val);
                iface.userUnselected();
                $('#NetInfoUsersList .searchable').removeClass('searchable').addClass("searchableh");
                if(val != '')
                    $('#NetInfoUsersList .searchableh:contains(' + val + ')').removeClass("searchableh").addClass("searchable");
            },
            userSelected: function () {
                $('#NetInfoUsersList .searchable.active').removeClass("active");
                $(this).addClass('active');
                niw.ajax({ action: 'GetUserPermissions', uId: $(this).data('id') }, function (msg) {
                    $('#PermissionsList').html(msg);
                }, function () {
                    alert("Error");
                });
            },
            userUnselected: function () {
                $('#NetInfoUsersList .searchable.active').removeClass("active");
                $('#PermissionsList').html('');
            },
            setPermission: function () {
                var uId = $('#NetInfoUsersList .searchable.active').data('id');
                var sId = $(this).data('id');
                var btn = $(this);

                niw.ajax({ action: "SetPermission", uId: uId, sId: sId }, function (msg) {
                    if (msg == '1')
                        btn.removeClass('btn-default').removeClass('fa-eye-slash').addClass('btn-primary').addClass('fa-eye');
                }, function () {
                    alert("Error");
                });
            },
            delPermission: function () {
                var uId = $('#NetInfoUsersList .searchable.active').data('id');
                var sId = $(this).data('id');
                var btn = $(this);

                niw.ajax({ action: 'DelPermission', uId: uId, sId: sId }, function (msg) {
                    if(msg == '1')
                        btn.removeClass('btn-primary').removeClass('fa-eye').addClass('btn-default').addClass('fa-eye-slash');
                }, function(){
                    alert("Error");
                });
            }
        }
        $(iface.init);
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="NetInfoUsersList" CssClass="list-group" ClientIDMode="Static" runat="server">
        <div class="list-group-item active">
            <h4 class="list-group-item-heading">Búsqueda</h4>
            <div class="input-group">
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
                <input type="text" class="form-control" placeholder="Buscar" id="userSearch" />
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="PermissionsList" CssClass="row" ClientIDMode="Static" runat="server"></asp:Panel>
    <div style="height:50px"></div>
</asp:Content>
