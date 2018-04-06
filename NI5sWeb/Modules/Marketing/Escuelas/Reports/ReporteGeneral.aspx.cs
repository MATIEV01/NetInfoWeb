using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.Marketing.Escuelas.Reports
{
    public partial class ReporteGeneral : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();
        List<Ciclo> lciclo = new List<Ciclo>();
        string lista = string.Empty;


        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                
             }

            if (Request.HttpMethod == "POST")
            {
                
                this.switchAction(Request["action"]);
               
            }
            else
            {
                
                DataTable objs = this.dbGetCicles();

                //lciclo.Add(new Ciclo { ciclos = "Selecciona el ciclo" });

                foreach (DataRow obj in objs.Rows)
                {
                    Ciclo item = new Ciclo()
                    {
                        ciclos = Convert.ToString(obj["cicle"])
                    };

                    lciclo.Add(item);
                }

                var list = lciclo.Select(x => x.ciclos);

                List.DataSource = lciclo.Select(x => x.ciclos);
                //List.DataSource = objs;
                //List.DataTextField = "cicle";
                //List.DataValueField = "cicle";
                List.DataBind();

                this.getReportA();

            }
        }

        protected void switchAction(string act)
        {
            switch (act)
            {
                case "GetReport":
                    this.getReportA();
                    break;
            }
        }
 
        protected void getReportA()
        {
            
          
            lista = List.SelectedValue.ToString();
               if (List.SelectedIndex > -1)
                lista = List.SelectedItem.Value;


            string tab = "<h3 class=\"dateHeader\">" + " " + "Ciclo:"+" " + lista + "" + "</h3><table class=\"table\"><thead><tr><th rowspan=\"3\">Region</th><th rowspan=\"3\">Estado</th><th rowspan=\"3\">NumPromotor</th><th rowspan=\"3\">Promotor</th><th rowspan=\"3\">Escuela</th><th rowspan=\"3\">NivelEscolar</th><th rowspan=\"3\">Grado</th><th rowspan=\"3\">NoLista</th></tr></thead><tbody>";


            DataTable ciclos = this.dbGetReport(lista);
            foreach (DataRow objss in ciclos.Rows)
            {
                tab += "<tr>";
                tab += "<td>" + objss["Region"] + "</td>";
                tab += "<td>" + objss["EStado"] + "</td>";
                tab += "<td>" + objss["NumPromotor"] + "</td>";
                tab += "<td>" + objss["Promotor"] + "</td>";
                tab += "<td>" + objss["Escuela"] + "</td>";
                tab += "<td>" + objss["NivelEscolar"] + "</td>";
                tab += "<td>" + objss["Grado"] + "</td>";
                tab += "<td>" + objss["NoLista"] + "</td>";
                tab += "</tr>";
            }
            tab += "</tbody></table>";

            if (Request.HttpMethod == "POST")
            {
                Response.Write(tab);
                Response.End();
            }
            else
            {
            
                ReportPanel.Controls.Add(new LiteralControl(tab));
            }
        }

        #region Base de Datos
        protected DataTable dbGetReport(string ciclo)
        {
            return core.executeProcedureTab("NIW_MK_SchoolReport '" + ciclo + "'");
        }
        protected DataTable dbGetCicles()
        {
            return core.executeProcedureTab("NIW_MK_SchoolCicle");
        }
        protected DataTable dbGetObjetives(int year, int month)
        {
            return core.executeSqlTab("select distinct ObjetiveId,(select ObjetiveName from NIW_MK_PromotersObjetives where ObjetiveId = t1.ObjetiveId) as ObjetiveName from NIW_MK_PlaObjDone as t1 where  ObjetiveId in (30,36,40,48) AND DATEPART(Month,Date) = " + month + " and DATEPART(Year,Date) = " + year);
        }
        #endregion

 
        
    }

    class Ciclo
    {
        public string ciclos { get; set; }
        

    }
}