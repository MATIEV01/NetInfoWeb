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
    public partial class ProductsReport : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();

       

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
                this.switchAction(Request["action"]);
            else
            {
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
            string region = string.Empty;
            int done = 0;
            int Target=0;
            int consulta = 0;
            int porcentaje1 = 0;
            //int porcentaje = 0;

            if (Request.HttpMethod == "POST")
            {
                region = Convert.ToString(Request["region"]); 
            }

            DataTable objs = this.dbGetReport(region);
            
            //t3 = "<th colspan=\"3\">Asistencia</th>";
            //t4 = "<th>Cumplido</th><th>Objetivo</th><th>%</th>";

            string tab = "<h3 class=\"dateHeader\">" + "" + "Region" +" "+ region + "</h3><table class=\"table\"><thead><tr><th rowspan=\"3\">Producto</th><th rowspan=\"3\">Cantidad</th><th rowspan=\"3\">Ciclo</th></tr></thead><tbody>";

          
            
            foreach (DataRow obj in objs.Rows)
            {
               
                tab += "<tr>";
                tab += "<td>" + obj["Descripcion"] + "</td>";
                tab += "<td>" + obj["Cantidad"] + "</td>";
                tab += "<td>" + obj["ciclo"] + "</td>";
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
        protected DataTable dbGetReport(string region)
        {
            return core.executeProcedureTab("NIW_MK_RegionesReport '" + region + "'");
        }
        protected DataTable dbGetObjetivesMonthData(int pl, int ObjId, int year, int month)
        {
            return core.executeSqlTab("select TargetAmount from NIW_MK_PlacesObjetives where PlaceId="+ pl +" and ObjetiveYear="+ year +" and ObjetiveMonth="+ month +" and ObjetiveId="+ObjId );
        }
        protected DataTable dbGetObjetives(int year, int month)
        {
            return core.executeSqlTab("select distinct ObjetiveId,(select ObjetiveName from NIW_MK_PromotersObjetives where ObjetiveId = t1.ObjetiveId) as ObjetiveName from NIW_MK_PlaObjDone as t1 where  ObjetiveId in (30,36,40,48) AND DATEPART(Month,Date) = " + month + " and DATEPART(Year,Date) = " + year);
        }
        #endregion
    
    }
}