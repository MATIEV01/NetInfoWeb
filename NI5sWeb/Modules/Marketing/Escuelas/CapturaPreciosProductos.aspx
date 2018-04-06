<%@ Page Title="CapturaPreciosProductos" Language="C#" AutoEventWireup="true" MasterPageFile="~/Themes/NIWeb/NI5.Master" CodeBehind="CapturaPreciosProductos.aspx.cs" Inherits="NI5sWeb.Modules.Marketing.Escuelas.CapturaPreciosProductos" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
     
        .table td{text-align:center;}
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
                $(document).on("change", "#DatePanel");
                $(document).on('click', '#Tabla thead .btn', dat.addCosto);
                $(document).on("change", "#select", dat.fillDataSelect);
                //$('#cargardatos').click(dat.fillData);
            },
           
            fillData: function () {
                mp.waitPage('show')
                niw.ajax({ action: "GetObjetiveDoneData", id: dat.placeId }, function (msg) {
                    $('#PanelCombo').html(msg);
                    mp.waitPage('hide')
                });
               
            },
            fillDataSelect: function () {

                mp.waitPage('show')
                var idItem = $(this).val();
                niw.ajax({ action: "GetObjetiveDoneData", id: dat.placeId, idItem: idItem }, function (msg) {
                    $('#Tabla').html(msg);
                    mp.waitPage('hide')
                });
               
            },
          
           

            addCosto: function () {
                var promotor = dat.placeId;
                var ctrl = $(this).parents('tr').find('input');
                var costo = ctrl.eq(0).val();
                
                niw.ajax({
                    action: "InsertarCosto", costo: costo
                });
                
            },
        };
      
        $(dat.init);
    </script>
   <script type="text/javascript">

      

</script>
 
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
    <div class="row">
        <asp:Panel ID="PlacesList" ClientIDMode="Static" CssClass="col-md-2 list-group" runat="server"></asp:Panel>
        <div class="col-md-10" id="placeObjetive">
            <asp:Panel ID="DatePanel" ClientIDMode="Static" CssClass="input-group" runat="server">
               
            </asp:Panel>
            
                
                <asp:Panel ID="PanelCombo" ClientIDMode="Static" runat="server">
                    
                </asp:Panel>
            
                <asp:Panel ID="Tabla" ClientIDMode="Static" runat="server">
                    
                </asp:Panel>
            
            
          
        </div>
    </div>
</asp:Content>