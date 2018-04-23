using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using CrystalDecisions.Web;
using NI5sWeb.NIWeb;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NI5sWeb.Modules.RH
{
    
    public partial class ControlVacaciones : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Request.HttpMethod == "POST")
                this.actionsSwitch();
            else
                this.getEmpleados();
        }

        protected void actionsSwitch()
        {
            switch (this.Request["action"])
            {
                case "getVacacionesStatus":
                    this.getVacationsStatus();
                    break;
                case "getFormato":
                    this.getFormato();
                    break;
                case "getDias":
                    this.CalculateVacationDays();
                    break;
                case "setNewFormato":
                    this.setNewFormat();
                    break;
            }
        }

        protected void getEmpleados()
        {
            DataTable userData = this.dbGetUserData();
            string str = " <select  multiple  class=\"form-control\" id=\"empleados\" style=\"height:550px; font-size: 15px; font-family: Tahoma\">";
            foreach (DataRow row in userData.Rows)
            {
                str = str + "<option data-noemp=\"" + row["NTRAB"].ToString() + "\" data-nombre=\"" + row["NNOM"].ToString() + "\" data-puesto = \"" + row["Puesto"].ToString() + "\" data-depa=\"" + row["Departmento"].ToString() + "\" data-fecha=\"" + row["FIngreso"].ToString() + "\" ";
                str = str + " style=\"margin: 5px 0;\" value=\"" + row["NTRAB"].ToString() + "\"> " + row["NTRAB"].ToString() + " | " + row["NNOM"].ToString() + "</option>";
            }
            this.listEmpleados.Controls.Add((Control)new LiteralControl(str + "</select>"));
        }

        protected void getVacationsStatus()
        {
            DataTable vacationsStatus = this.dbGetVacationsStatus(this.Request["noemp"]);
            DataView defaultView = vacationsStatus.DefaultView;
            string s = "";
            string totaldias = "0";
            if (vacationsStatus.Rows.Count > 0)
            {
                string str = "<table class=\"table table-striped table-bordered\"><thead><tr><th>Año</th><th>Días con Derecho</th><th>Días Tomados</th></tr></thead><tbody>";
                int num1 = 0;
                int num2 = 0;
                defaultView.Sort = "Ano desc";
                foreach (DataRow row1 in defaultView.ToTable().Rows)
                {
                    num1 += Convert.ToInt32(row1["Derecho"].ToString());
                    num2 += Convert.ToInt32(row1["Tomados"].ToString());
                    str = str + "<tr data-toggle=\"collapse\" data-target=\"#a" + row1["Ano"] + "\" aria-expanded=\"false\" aria-controls=\"a" + row1["Ano"] + "\"><td>" + row1["Ano"] + "</td><td>" + row1["Derecho"] + "</td><td>" + row1["Tomados"] + "</td></tr>";
                    str = str + "<tr id=\"a" + row1["Ano"] + "\" class=\"collapse\"><td colspan=\"3\"><table id=\"folios\" data-toggle=\"table\" data-toolbar=\".toolbar\" class=\"table table-striped\"><thead><tr><th data-field=\"folio\">Folio</th><th>Desde</th><th>Hasta</th><th>Días Tomados</th></tr></thead><tbody>";
                    DataTable vacationsDetails = this.dbGetVacationsDetails(this.Request.Cookies["Session"]["userNT"], row1["Ano"].ToString());
                    int num3 = 0;
                    foreach (DataRow row2 in vacationsDetails.Rows)
                    {
                        ++num3;
                        str = str + "<tr data-index =\"" + (object)num3 + "\"><td>" + row2["Folio"] + "</td><td>" + row2["Desde"] + "</td><td>" + row2["Hasta"] + "</td><td>" + row2["Dias"] + "</td></tr>";
                    }
                    str += "</tbody></table></td></tr>";
                }
                s = str + "</tbody>" + "<tfoot> <tr><th>TOTAL</th> <th>" + (object)num1 + "</th> <th>" + (object)num2 + "</th> </tfoot>   </table> ";
                //this.AvailableDays.Text = (num1 - num2).ToString();
                //if (num1 - num2 < 0)
                //    this.AvailableDays.CssClass += " label-danger";
                //else
                //    this.AvailableDays.CssClass += " label-primary";

                totaldias = (num1 - num2).ToString();
            }

            s = s +'|'+ totaldias;
            this.Response.Write(s);
            this.Response.End();
        }

        protected void getFormato()
        {
            string ntrab = Request["noemp"];
            string folio = Request["folio"];

            string[] files = Directory.GetFiles(Context.Server.MapPath(@"..\RH\Reporte\PDF\"));

            foreach (string f in files)
            {
                File.Delete(f);
            }


            ReportDocument report = new ReportDocument();

            report = new Modules.RH.Reporte.VacacionesFormato5s();

            report.SetDatabaseLogon("SQL2015","M4J3ST1C");

            asignarDB(report);

            report.SetParameterValue(0, folio);
            report.SetParameterValue(1, ntrab);

            string snombre = folio + ".pdf";

            report.ExportToDisk(ExportFormatType.PortableDocFormat, Context.Server.MapPath(@"..\RH\Reporte\PDF\"+snombre));

            //CrystalReportViewer1.ReportSource = report;

            Response.Write(snombre);
            Response.End();
                //ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true, "S:\\NetInfo5s\\Pdfconver.pdf");
        }
        
        public void CalculateVacationDays()
        {
            //string fromDate = Request["from"];
            //string toDate = Request["toDate"];

            string sdias = "N/A";

            DateTime from = DateTime.Parse(Request["from"].ToString());
            DateTime to = DateTime.Parse(Request["to"].ToString());

            if(DateTime.Parse(from.ToShortDateString())  >= DateTime.Parse(DateTime.Now.ToShortDateString()))
            {

                Double saturdays = CountDays(DayOfWeek.Saturday, from, to);
                Double sundays = CountDays(DayOfWeek.Sunday, from, to);

                Double calc = ((to - from).TotalDays + 1) - (saturdays + sundays);

                if (calc > 0)
                    sdias = Math.Round(calc, 0).ToString();
            }

            Response.Write(sdias);
            Response.End();

            //DiasVac.Text = Math.Round(calc, 0).ToString();
        }

        protected void setNewFormat()
        {

            string r = "0";

            if (Request["dias"] != "N/A")
            {
                object[] oparams = new object[5];

                DataTable dtFolio = this.dbGetFolio();

                oparams[0] = dtFolio.Rows[0]["Folio"].ToString().PadLeft(15,'0');
                oparams[1] = Request["noemp"];
                oparams[2] = Request["coment"];
                oparams[3] = DateTime.Parse(Request["from"]).ToString("MM/dd/yyyy");
                oparams[4] = DateTime.Parse(Request["from"]).ToString("MM/dd/yyyy");

                if (!dbSaveNewFormato(oparams))
                    r = "1";
            }

            Response.Write(r);
            Response.End();

        }


        private Double CountDays(DayOfWeek day, DateTime start, DateTime end)
        {
            TimeSpan ts = end - start;                       // Total duration
            int count = (int)Math.Floor(ts.TotalDays / 7);   // Number of whole weeks
            int remainder = (int)(ts.TotalDays % 7);         // Number of remaining days
            int sinceLastDay = (int)(end.DayOfWeek - day);   // Number of days since last [day]
            if (sinceLastDay < 0) sinceLastDay += 7;         // Adjust for negative days since last [day]

            // If the days in excess of an even week are greater than or equal to the number days since the last [day], then count this one, too.
            if (remainder >= sinceLastDay) count++;

            return count;
        }

        private void asignarDB(ReportDocument reporte)
        {
            System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(core.ConnStr);

            //reporte.SetDatabaseLogon(ClsParameters.sUserSQL, ClsParameters.sPassWordSQL, conn.DataSource, conn.Database);
            ConnectionInfo connInfo = new ConnectionInfo();
            connInfo.ServerName = conn.DataSource;
            connInfo.DatabaseName = conn.Database;
            connInfo.UserID = "SQL2015";
            connInfo.Password = "M4J3ST1C";

            foreach (CrystalDecisions.CrystalReports.Engine.Table table in reporte.Database.Tables)
            {
                table.LogOnInfo.ConnectionInfo = connInfo;
                table.ApplyLogOnInfo(table.LogOnInfo);
            }

            foreach (ReportDocument subReporte in reporte.Subreports)
            {
                foreach (CrystalDecisions.CrystalReports.Engine.Table table in subReporte.Database.Tables)
                {
                    table.LogOnInfo.ConnectionInfo = connInfo;
                    table.ApplyLogOnInfo(table.LogOnInfo);
                }
            }

        }

        protected DataTable dbGetUserData()
        {
            return this.core.executeSqlTab("select NTRAB,NNOM,CCTO_ID +' '+ ICDNOM as Departmento,DSCPUESTO as Puesto,NEMPFECA as FIngreso from NI_RH_PES_Vacaciones_Empleados Empl left outer join NI_RH_PES_Vacaciones_CentrosdeCosto  Cent on Empl.NCCTO = Cent.CCTO_ID ");
        }

        protected DataTable dbGetVacationsStatus(string usrId)
        {
            return this.core.executeProcedureTab("NIW_RH_Pes_GetVacationDaysByYear '" + usrId + "',1,''");
        }

        protected DataTable dbGetVacationsDetails(string usrId, string year)
        {
            return this.core.executeProcedureTab("NIW_RH_Pes_GetVacationDaysByYear '" + usrId + "',2,'" + year + "'");
        }

        protected DataTable dbGetFolio()
        {
            return this.core.executeSqlTab("select isnull((MAX(convert(int,isnull(Folio,0))) + 1),1) as Folio from NI_RH_PES_Vacaciones_Cabecera");
        }

        protected bool dbSaveNewFormato(object [] oParams)
        {
            return this.core.executeProcedure(string.Format("NI_RH_PES_SetVacationForm '{0}',{1},'{2}','{3}','{4}' ",oParams));
        }
    }
}