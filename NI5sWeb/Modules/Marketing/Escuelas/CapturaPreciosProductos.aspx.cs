using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.Marketing.Escuelas
{
    public partial class CapturaPreciosProductos : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();
        List<Producto> lprod = new List<Producto>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.HttpMethod == "POST")
                {
                    
                    this.switchAction();
                }
                else
                {
               
                    this.getPlacesList();
                   

                }
            }
        }

        protected void switchAction()
        {
            switch (Request["action"])
            {
             
                case "GetObjetiveDoneData":
                    this.getObjetivesMonthData();
                    break;
                case "InsertarCosto":
                    this.Insertarcosto();
                    break;

            }
        }

     

        protected void getPlacesList()
        {
            DataTable places = this.dbGetPlaces();
           

            string list = String.Empty;

            foreach (DataRow place in places.Rows)
            {
               

                    list += "<a href=\"#\" class=\"list-group-item\" data-id=\"" + place["Promotor"] + "\">";
                    list += "<h4 class=\"list-group-item-heading\"><strong> Promotor:</strong>" + place["Promotor"] + "</h4>";
                    list += "</a>";
                
            }

            PlacesList.Controls.Add(new LiteralControl(list));
        }

        

        protected void getObjetivesMonthData()
        {
            string list = "";

               
            string prm = Convert.ToString(Request["id"]);
           
            
            string item = Convert.ToString(Request["iditem"]);
            DataTable pp = this.dbGetProductsPromotor(prm);

            if (string.IsNullOrEmpty(item))
            {
                list += "<select class=\"form-control\" id=\"select\" >";

                foreach (DataRow prod in pp.Rows)
                {

                    list += "<option value=" + Convert.ToString(prod["NumProduc"]) + ">" + Convert.ToString(prod["NumProduc"]) + "</option>";

                    //Producto item = new Producto()
                    //{
                    //    producto = Convert.ToString(prod["NumProduc"])
                    //};

                    //lprod.Add(item);
                }

                list += "</select>";


                ClientScript.RegisterStartupScript(GetType(),"mostrarDatos", "dat.fillDataSelect();",true);
            }
            else
            {
                //var lisprod = lprod.Select(x => x.producto);


                //ListProducts.DataSource = lprod.Select(x => x.producto);
                //ListProducts.DataBind();



                //string lista = string.Empty; //ListProducts.SelectedValue.ToString();
                //if (ListProducts.SelectedValue!=null && ListProducts.SelectedIndex > -1)
                //    lista = ListProducts.SelectedItem.Value;

                DataTable objs = this.dbGetProducts(item, prm);



                list += "<h3 class=\"dateHeader\"></h3><table class=\"table\"><thead><tr><th rowspan=\"3\">Escuela</th><th rowspan=\"3\">Grado</th><th rowspan=\"3\">Nivel Escolar</th><th rowspan=\"3\">NumProduc</th><th rowspan=\"3\">Producto</th><th rowspan=\"3\">Cantidad</th></tr><tr></tr></thead><tbody>";


                foreach (DataRow obj in objs.Rows)
                {
                    list += "<th>" + obj["Escuela"] + "</th>";
                    list += "<th>" + obj["Grado"] + "</th>";
                    list += "<th>" + obj["NivelEscolar"] + "</th>";
                    list += "<th>" + obj["NumProduc"] + "</th>";
                    list += "<th>" + obj["Producto"] + "</th>";
                    list += "<th>" + obj["Cantidad"] + "</th>";
                    //list += "<td class=\"inpt-row\"><input type=\"text\" class=\"form-control\" required /></td>";
                    //list += "<td class=\"inpt-row\"><a href=\"#\" class=\"btn btn-success\"><i class=\"fa fa-check\"></i></a></td>";
                    //list += "<tr><td class=\"inpt-row\"><input type=\"text\" placeholder=\"Costo\" class=\"form-control\" required /></td><td class=\"inpt-row\"><input type=\"text\" placeholder=\"Descripción\" class=\"form-control\" required /></td><td class=\"inpt-row\"><input type=\"text\" placeholder=\"Referencia\" class=\"form-control\" /></td><td class=\"inpt-row\"><input type=\"text\" placeholder=\"0.00\" class=\"form-control\" required /></td><td class=\"inpt-row\"><input type=\"text\" placeholder=\"0.00\" class=\"form-control\" required /></td><td class=\"inpt-row\"><a href=\"#\" class=\"btn btn-success\"><i class=\"fa fa-check\"></i></a></td></tr>";
                    list += "</tr>";

                }
                list += "</tbody></table>";
            }
            
            if (Request.HttpMethod == "POST")
            {
                Response.Write(list);
                Response.End();

            }
            else
            {
                Tabla.Controls.Add(new LiteralControl(list));
            }
            
          
        }

        protected void Insertarcosto()
        {
            string prm = Convert.ToString(Request["id"]);
            int cost = Convert.ToInt32(Request["costo"]);

            if (this.dbSetDetail(cost,"",prm))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();


        }
               
        #region Base de Datos
        protected bool dbSetDetail(int costo, string prod, string promotor)
        {
            return core.executeSql("Update NIW_MK_CapturaCantProd set costo=" + costo + " WHERE NumProduc = '" + prod +"'and Promotor='"+promotor+"'");
        }
        protected DataTable dbGetPlaces()
        {
            return core.executeSqlTab("SELECT DISTINCT REPLACE(Promotor,'/',' ') as Promotor from NIW_MK_CapturaCantProd");
        }
        protected DataTable dbGetProducts(string producto,string promotor)
        {
            return core.executeProcedureTab("NIW_MK_ProductsReport'" + producto + "','"+promotor+"'");
        }
        protected DataTable dbGetProductsPromotor(string promotor)
        {
            return core.executeSqlTab("select distinct NumProduc from NIW_MK_CapturaCantProd where Promotor='" + promotor + "'");
        }
        #endregion
    }
}
class Producto
{
    public string producto { get; set; }


}