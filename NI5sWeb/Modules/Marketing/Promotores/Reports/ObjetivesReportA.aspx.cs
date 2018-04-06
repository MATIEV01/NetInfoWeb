using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.Marketing.Promotores.Reports
{
    public partial class ObjetivesReportA : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();

        protected string[] months = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" };

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
            DateTime date = DateTime.Now;
            int month = date.Month;
            int year = date.Year;
            int done = 0;
            int Target=0;
            int consulta = 0;
            int porcentaje1 = 0;
            //int porcentaje = 0;

            if (Request.HttpMethod == "POST")
            {
                month = Convert.ToInt32(Request["month"]);
                year = Convert.ToInt32(Request["year"]);
            }

            DataTable objs = this.dbGetReportA(year, month);
            DataTable cataloge = this.dbGetObjetives(year, month);
            

            string t1 = "";
            string t2 = "";
            string t3 = "";
            string t4 = "";
            int porcentaje=0;


            for (int i = 0; i < cataloge.Rows.Count; i++)
            {

                    t1 += "<th align=\"center\" style=\"width:220px\" colspan=\"3\">" + cataloge.Rows[i]["ObjetiveName"] + "</th>";
                    t2 += "<th>Cumplido</th><th>Objetivo</th><th>%</th>";
                
             
            }
            //t3 = "<th colspan=\"3\">Asistencia</th>";
            //t4 = "<th>Cumplido</th><th>Objetivo</th><th>%</th>";
          
           string tab = "<h3 class=\"dateHeader\">" + this.months[month - 1] + " " + year + "</h3><table width=\"100%\"  class=\"table table-bordered\"><thead><tr><th rowspan=\"3\">Plaza</th><th style=\"width:250px\" rowspan=\"4\">Promotor</th>" + t1 + "</th></tr><tr>" + t2 + "</tr></thead><tbody>";
            //"<h3 class=\"dateHeader\">" + this.months[month - 1] + " " + year + "</h3><table class=\"table\"><thead><tr><th rowspan=\"3\">Plaza</th><th rowspan=\"3\">No. Control</th><th rowspan=\"3\">Promotor</th>" + t1 + "</th></tr><tr>" + t2 + "</tr></thead><tbody>";



            foreach (DataRow obj in objs.Rows)
            {
               
                tab += "<tr>";
                tab += "<td>" + obj["Plaza"] + "</td>";
              //  tab += "<td>" + obj["No"] + "</td>";
                tab += "<td>" + obj["Promotor"] + "</td>";
                
            

                for (int i = 0; i < cataloge.Rows.Count; i++)
                {
                                  
                    //if (cataloge.Rows[i].ItemArray[1].ToString() == "Asistencia")
                    //{

                    //    tab += "<td>" + obj["Asistencia"] + "</td>";
                    //    tab += "<td>" + obj[cataloge.Rows[i]["ObjetiveId"] + "Target"] + "</td>";

                    //    done = Convert.ToInt16(obj["Asistencia"].ToString());
                    //    Target = Convert.ToInt16(obj[cataloge.Rows[i]["ObjetiveId"] + "Target"].ToString());

                    //    if (done == 0 & Target == 0)
                    //    {
                    //        porcentaje = 0;
                    //    }
                    //    else
                    //    {
                    //        porcentaje = ((done * 100) / (Target));
                    //    }

                    //    tab += "<td>" + porcentaje + "</td>";
                    //}

                    //else 
             
                    //{
                        tab += "<td align=\"Center\">" + obj[cataloge.Rows[i]["ObjetiveId"] + "Done"] + "</td>";
                        tab += "<td align=\"Center\" >" + obj[cataloge.Rows[i]["ObjetiveId"] + "Target"] + "</td>";

                        done = Convert.ToInt16(obj[cataloge.Rows[i]["ObjetiveId"] + "Done"].ToString());
                        Target = Convert.ToInt16(obj[cataloge.Rows[i]["ObjetiveId"] + "Target"].ToString());

                        if (done == 0 & Target == 0)
                        {
                            porcentaje = 0;
                        }
                        else
                        {
                            porcentaje = ((done * 100) / (Target));
                        }

                        tab += "<td>" + porcentaje + "</td>";

                    
                    
                }
                
                //string s= obj["Plaza"].ToString().Replace('P',' ');
              
                //DataTable asis = this.dbGetObjetivesMonthData(Convert.ToInt32(s), 50, year, month);
                //int vacio = asis.Rows.Count;
                //if(vacio==0)
                //{
                    
                //    consulta = 0;
                //}
                
                //else if (asis.Rows[0].ItemArray[0].ToString() == string.Empty)
                
                //{
                //    consulta = 0;
                //}
                //else
                //{
                //    consulta = Convert.ToInt32(asis.Rows[0].ItemArray[0].ToString());
                //}
                
               
                //tab += "<td>" + obj["Asistencia"] + "</td>";
                //tab += "<td>" + consulta + "</td>";

                //int p1 = Convert.ToInt32(obj["Asistencia"].ToString());
                //int p2 = consulta;

                //if(p1!=0 && p2==0)
                //{
                //    porcentaje1 = 0;
                //}
                //else
                //{
                //    porcentaje1 = ((p1 * 100) / (p2));
                //}
                 

                //tab += "<td>" + porcentaje1 + "</td>";
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
        protected DataTable dbGetReportA(int year, int month)
        {
            return core.executeProcedureTab("NIW_MK_GetObjetivesReportA " + year + "," + month);
        }
        protected DataTable dbGetObjetivesMonthData(int pl, int ObjId, int year, int month)
        {
            return core.executeSqlTab("select TargetAmount from NIW_MK_PlacesObjetives where PlaceId="+ pl +" and ObjetiveYear="+ year +" and ObjetiveMonth="+ month +" and ObjetiveId="+ObjId );
        }
        protected DataTable dbGetObjetives(int year, int month)
        {
            // return core.executeSqlTab("select distinct ObjetiveId,(select ObjetiveName from NIW_MK_PromotersObjetives where ObjetiveId = t1.ObjetiveId) as ObjetiveName from NIW_MK_PlaObjDone as t1 where  ObjetiveId in (30,36,40,48) AND DATEPART(Month,Date) = " + month + " and DATEPART(Year,Date) = " + year);
            return ObjetivesReportA.core.executeSqlTab("select ObjetiveId, ObjetiveName from NIW_MK_PromotersObjetives");
        }
        #endregion
    }
}