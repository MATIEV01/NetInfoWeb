using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Data;
using System.Data.SqlClient;

namespace NI5sWeb.Modules.Contabilidad.PresupuestoGastos
{
    public partial class ReportePresupuestodeGatos : System.Web.UI.Page
    {
        //ReportDocument Report = new ReportDocument();


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
                    this.Datos();
                   
                }
            }
            //var Report = new NI5sWeb.Modules.Contabilidad.PresupuestoGastos.Reportes.PresupuestoGastos() as ReportDocument;
            //Report.SetDatabaseLogon("SQL2015", "M4J3ST1C");
            //Report.SetParameterValue(0, "");
            //Report.SetParameterValue(1, "ZZZZZZ");
            //Report.SetParameterValue(2, "");
            //Report.SetParameterValue(3, "ZZZZZZ");
            //Report.SetParameterValue(4, "2016");
            //Report.SetParameterValue(5, "TOMAS");
            //ReportePresupuestoGatos.ReportSource = Report;           
            //this.ReportePresupuestoGatos.ReportSource = Report;
            //this.ReportePresupuestoGatos.RefreshReport();
            
            //ReportDocument Documento = new ReportDocument();
            //DataSet Reporte = new DataSet();
            //Reporte = GetReporte();
            //Documento = new NI5sWeb.Modules.Contabilidad.PresupuestoGastos.Reportes.PresupuestoGastos() as ReportDocument;
            //Documento.Load(Server.MapPath("PresupuestoGastos.rpt"));
            //Documento.Load(@"..\Reportes\PresupuestoGastos.rpt");
            //Documento.SetDataSource(Reporte);
            //ReportePresupuestoGatos.ReportSource = Documento;

        }
        protected void switchAction()
        {
            switch (Request["action"])
            {

                case "Datos":
                    this.Datos();
                    break;
              

            }
        }


        protected void Datos()
        {
            string valdrop = Convert.ToString(Request["iditem"]); 
        }

        public DataSet GetReporte()
        {
            DataSet ReportList = new DataSet();
            using (SqlConnection connection = new SqlConnection("Data Source=SRV-SQL;packet size=16384;Initial Catalog=NetInfo;User ID=SQL2015;Password=M4J3ST1C; connect timeout = 30;Persist security info= true;"))
            {
                SqlCommand comandoSql = new SqlCommand("Sp_ReportePresupuestoMensualGastos", connection);
                comandoSql.Parameters.AddWithValue("@pDireccion1", "");
                comandoSql.Parameters.AddWithValue("@pDireccion2", "ZZZZZZ");
                comandoSql.Parameters.AddWithValue("@pDepto1", "");
                comandoSql.Parameters.AddWithValue("@pDepto2", "ZZZZZZ");
                comandoSql.Parameters.AddWithValue("@pnAño", 2016);
                comandoSql.Parameters.AddWithValue("@psCdgUsu", "TOMAS");

                comandoSql.CommandType = CommandType.StoredProcedure;
                try
                {
                    if (connection.State == ConnectionState.Closed)
                        connection.Open();
                    SqlDataAdapter da = new SqlDataAdapter(comandoSql);
                    da.Fill(ReportList);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error getting data Reporte " + ex.Message, ex);
                }
                finally
                {
                    if (connection != null)
                        connection.Close();
                }
            }
            return ReportList;
        }

     
    }
}