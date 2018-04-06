using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;
using System.Globalization;

namespace NI5sWeb.Modules.Contabilidad.PresupuestoGastos
{
    public partial class CapturaPresupuesto : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();
        string cencos = string.Empty;
        protected string budgetYear = String.Empty;
        protected string center = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.HttpMethod == "POST")
            {
                this.switchAction(Request["action"]);
               
            }
            else
            {
                //this.dbGetBudgetYear();
                //YearTitle.Text = this.budgetYear;


                //Presupuesto.Text = this.budgetYear;

                //int proyeccion=  Convert.ToInt32(this.budgetYear.ToString()) - 1;
                //Proyeccion.Text = Convert.ToString(proyeccion);

                //int real = Convert.ToInt32(this.budgetYear.ToString()) - 2;
                //Real.Text = Convert.ToString(real);

                //this.dbGetBudgetcentro(Request.QueryString["Centro"].ToString());
                //string centro = this.center.ToString();
                //desccentro.Text = Request.QueryString["Centro"].ToString() +"  "+ centro;

                //string centrocostos = Request.QueryString["Centro"].ToString();
                //Session.Add("centro",centrocostos);

                //string cuenta = Request.QueryString["Cuenta"].ToString();
                //Session.Add("cuenta", cuenta);

                this.desccentro.Text = this.Request.QueryString["Centro"].ToString();
                this.Session.Add("centro", (object)this.Request.QueryString["Centro"].ToString().Split(' ')[0]);
                this.Session.Add("cuenta", (object)this.Request.QueryString["Cuenta"].ToString());


            }
        }

        protected void switchAction(string act)
        {
            switch (act)
            {
                case "getAño":
                    this.getAño();
                    break;
                case "GetCentrosDeCostosPresupuestables":
                    this.getCentrosDeCostosPresupuestables();
                    break;
                case "GetMovimientos":
                    this.getMovimientos();
                    break;
                case "GetDetallesDePresupuestoPorConcepto":
                    this.getDetallesDePresupuestoPorConcepto();
                    break;
                case "SetDetallesDePresupuestoPorConcepto":
                    this.setDetallesDePresupuestoPorConcepto();
                    break;
                case "DelDetallesDePresupuestoPorConcepto":
                    this.delDetallesDePresupuestoPorConcepto();
                    break;
                case "GetPresupuestosMensualesGenerales":
                    this.getPresupuestosMensualesGenerales();
                    break;
                case "GetConseptosPresupuestados":
                    this.getConseptosPresupuestados();
                    break;
                case "GetEditMes":
                    this.getEditMes();
                    break;
                case "SetEditMes":
                    this.setEditMes();
                    break;
                case "DelConsepto":
                    this.deleteConsepto();
                    break;
            }
        }

        protected void getCentrosDeCostosPresupuestables()
        {
            string centro = HttpContext.Current.Session["centro"].ToString();
            string UserId = Request.Cookies["Session"]["UserId"];

            string res = core.dataTableToJson(this.dbGetCuentasPresupuestables(centro, UserId));
            Response.Write(res);
            Response.End();
        }
        protected void getAño()
        {
            string res = core.dataTableToJson(this.dbGetaño());
            Response.Write(res);
            Response.End(); 
        }

  

        protected void getDetallesDePresupuestoPorConcepto()
        {
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }
            DataTable detalles = dbGetDetallesDePresupuestoPorConcepto(Request["id"], year);
            //Obtener distinct de id de Detalles
            if (detalles.Rows.Count > 0)
            {
                DataView view = new DataView(detalles);
                DataTable dIds = view.ToTable(true, "Linea", "Concepto");
                string res = String.Empty;
                foreach (DataRow did in dIds.Rows)
                {
                    string subRes = String.Empty;
                    res += ",{\"id\":\"" + did["Linea"].ToString() + "\",\"nombre\":\"" + did["Concepto"].ToString() + "\",\"montos\":[";
                    //Filtrar por id
                    DataRow[] fr;
                    fr = detalles.Select("Id = " + did["Linea"].ToString());
                    foreach (DataRow det in fr)
                    {
                        subRes += ",{\"mes\":\"" + det["Mes"].ToString() + "\",\"monto\":\"" + det["Monto"].ToString() + "\"}";
                    }
                    res += subRes.Substring(1) + "]}";
                }

                Response.Write("[" + res.Substring(1) + "]");
                Response.End();
            }
            else
            {
                Response.Write("0");
                Response.End();
            }
        }

        protected void setDetallesDePresupuestoPorConcepto()
        {
            string meses = "";
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }

            //DataTable año = this.dbGetPeriodoDePresupuesto();
            //DataRow row = año.Rows[0];
            //int year = Convert.ToInt32(row["Year"]);
            string linea = "";
            //Recibir toda la cadena
            string[] detailHeaders = Request["cadena"].Split('|');
            string res = String.Empty;
            int l = 0;
            foreach (string s in detailHeaders)//Insertar detalle
            {
                string[] detalle = s.Split('¬');
                string[] head = detalle[0].Split(';');
                //Obtener datos de cabecera
                 linea =head[0];
                string bDeta = head[1];
                string fsacc = head[2];
                Decimal total = Convert.ToDecimal(head[3]);
                int mesdesde = 0; //Convert.ToInt32(head[4]);
                int meshasta = 0; //Convert.ToInt32(head[5]);
                //Obtener cadena de detalles por mes

                Dictionary<string, double> dcMeses = new Dictionary<string, double>();

                for (int i = 1; i <= 12; i++)
                {
                    double Monto= Convert.ToDouble(head[i+5].ToString());

                    dcMeses.Add(i.ToString().PadLeft(2,'0'),Monto);

                    if(Monto>0)
                    {
                        if(mesdesde==0)
                            mesdesde = i;

                        meshasta = i;
                    }
                        
                }


                
                string line = linea.PadLeft(3, '0');


                if (this.dbSetDetallesDePresupuestoPorConcepto(year, fsacc, line, bDeta, mesdesde, meshasta,dcMeses))
                    res = "1";
                else
                    res = "0";

            }
            Response.Write(res);
            Response.End();
        }

        protected void delDetallesDePresupuestoPorConcepto()
        {
            string[] cad = Request["cadena"].Split(',');
            string res = "1";
            foreach (string id in cad)
                if (!this.dbDelDetallesDePresupuestoPorConcepto(Convert.ToInt32(id)))
                    res = "0";

            Response.Write(res);
            Response.End();
        }

       

        protected void getPresupuestosMensualesGenerales()
        {
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);

                Session.Add("Year", year);
            }
            //DataTable año = this.dbGetPeriodoDePresupuesto();
            //DataRow row = año.Rows[0];
            //int year = Convert.ToInt32(row["Year"]);
            string acc = Request["acc"];

            if(acc == string.Empty)
            {
                acc=HttpContext.Current.Session["cuenta"].ToString();
            }
            else
            {
                acc = Request["acc"];
            }

            DataTable table = this.dbGetPresupuestosMensualesPorCuenta(acc, year);
            string List = String.Empty;

            foreach (DataRow dr in table.Rows)
            {

                List += "<tr><td>" + dr["NombreMes"] + "</td>";
                List += "<td>" + Convert.ToDecimal(dr["ANTERIOR"].ToString()).ToString("N0") + "</td>";
                List += "<td>" + Convert.ToDecimal(dr["ACTUAL"].ToString()).ToString("N0") + "</td>";
                List += "<td>" + Convert.ToDecimal(dr["Presupuesto"].ToString()).ToString("N0") + "</td>";
                //List += "<td>" + dr["ANTERIOR"] + "</td>";
                //List += "<td>" + dr["ACTUAL"] + "</td>";
                //List += "<td>" + dr["Presupuesto"] + "</td></tr>";
            }
            Response.Write(List);
            Response.End();
                       
        }


        protected void getMovimientos()
        {
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }
            string acc = Request["acc"].ToString().Split(' ')[0];
            if (acc == string.Empty)
            {
                acc = HttpContext.Current.Session["cuenta"].ToString();
            }
            else
            {
                acc = Request["acc"];
            }



            DataTable table = this.dbMovimientos(acc, year);
            string List = String.Empty;

            foreach (DataRow dr in table.Rows)
            {
                List += "<tr><td>" + dr["PERIOD_NO"] + "</td>";
                List += "<td>" + dr["BATCH_NO"] + "</td>";
                List += "<td>" + dr["BATCH_SEQN"] + "</td>";
                List += "<td>" + dr["BATCH_SRCE"] + "</td>";
                List += "<td>" + dr["TRANS_DESC"] + "</td>";
                if (dr["TRANS_AMT"].ToString() == String.Empty)
                List += "<td>" + dr["TRANS_AMT"] + "</td></tr>";
                else
                List += "<td>" + Convert.ToDecimal(dr["TRANS_AMT"].ToString()).ToString("N0") + "</td></tr>";
                
            }

            Response.Write(List);
            Response.End();
        }

        protected void getConseptosPresupuestados()
        {
            string sCuenta = string.Empty;
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }

            string acc = Request["acc"].ToString().Split(' ')[0];

            if (acc == string.Empty)
            {
                acc = HttpContext.Current.Session["cuenta"].ToString();
            }
            else
            {
                acc = Request["acc"].ToString().Split(' ')[0];
            }

            DataTable table = this.dbConseptosPresupuestados(acc, year);

            string UserId = Request.Cookies["Session"]["UserId"];

            if (acc.Length == 17)
            {
                sCuenta = acc.Substring(acc.Length - 6, 6);
            }
            else
            {
                sCuenta = acc.Substring(acc.Length - 5, 5);
            }

            bool tipo = this.dbGetPermisoCuenta(UserId,sCuenta);

            string List = String.Empty;

            string sclass = "mes";

            if(!tipo)
                sclass="mesbloqueado";

            List = acc +"|" + tipo.ToString() + "|";
                       
            foreach (DataRow dr in table.Rows)
            {
                List += "<tr><td>" + dr["linea"] + "</td>";
                List += "<td style='word-wrap: break-word;min-width: 160px;max-width: 160px; text-align :left;' >" + dr["concepto"] + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes1"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes2"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes3"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes4"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes5"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes6"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes7"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes8"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes9"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes10"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes11"]).ToString("N0")  + "</td>";
                List += "<td class=\""+sclass+"\">" + Convert.ToDecimal(dr["mes12"]).ToString("N0") + "</td>";
                List += "<td>" + Convert.ToDecimal(dr["Total"]).ToString("N0") + "</td>";
                if(tipo)
                    List += "<td class=\"eliminar\"><a href='#'  class=\"btn btn-danger\"  title=\"Eliminar Detalle\"><i class='fa fa-times'></i></a></td></tr>";
                else
                    List += "<td> </td></tr>";

            }
            

            Response.Write(List);
            Response.End();
        }

        protected void deleteConsepto()
        {
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }
            string acc = Request["acc"].ToString().Split(' ')[0];

            string res = "0";
            if (this.dbDelConsepto(year, acc, Convert.ToString(Request["linea"])))
                res = "1";
            
            Response.Write(res);
            Response.End();
                
        }

        protected void getEditMes()
        {
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }

            string acc = Request["acc"].ToString().Split(' ')[0];

            DataTable lvls = this.dbDetalleConseptos1(acc, year, Convert.ToString(Request["linea"]));
            string res = core.dataTableToJson(lvls);
            Response.Write(res);
            Response.End();
        }
        protected void setEditMes()
        {
            int year = 0;

            if (HttpContext.Current.Session["Year"] != null)
                year = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                DataTable año = this.dbGetPeriodoDePresupuesto();
                DataRow row = año.Rows[0];
                year = Convert.ToInt32(row["Year"]);
                Session.Add("Year", year);
            }
           
            double ene = Convert.ToDouble(Request["ene"]);
            if (ene.ToString() == "NaN")
            {
                ene = 0;
            }
            double feb = Convert.ToDouble(Request["feb"]);
            if (feb.ToString() == "NaN")
            {
                feb = 0;
            }
            double mar = Convert.ToDouble(Request["mar"]);
            if(mar.ToString()=="NaN")
            {
                mar = 0;
            }
            double abr = Convert.ToDouble(Request["abr"]);
            if (abr.ToString() == "NaN")
            {
                abr = 0;
            }
            double may = Convert.ToDouble(Request["may"]);
            if (may.ToString() == "NaN")
            {
                may = 0;
            }
            double jun = Convert.ToDouble(Request["jun"]);
            if (jun.ToString() == "NaN")
            {
                jun = 0;
            }
            double jul = Convert.ToDouble(Request["jul"]);
            if (jul.ToString() == "NaN")
            {
                jul = 0;
            }
            double ago = Convert.ToDouble(Request["ago"]);
            if (ago.ToString() == "NaN")
            {
                ago = 0;
            }
            double sep = Convert.ToDouble(Request["sep"]);
            if (sep.ToString() == "NaN")
            {
                sep = 0;
            }
            double oct = Convert.ToDouble(Request["oct"]);
            if (oct.ToString() == "NaN")
            {
                oct = 0;
            }
            double nov = Convert.ToDouble(Request["nov"]);
            if (nov.ToString() == "NaN")
            {
                nov = 0;
            }
            double dic = Convert.ToDouble(Request["dic"]);
            if (dic.ToString() == "NaN")
            {
                dic = 0;
            }

            string acc = Request["acc"].ToString().Split(' ')[0];

            if (this.dbSetEdit(Convert.ToString(Request["linea"]),acc, ene, feb, mar,abr,may, jun, jul,ago,sep,oct,nov,dic,year))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        #region Base de Datos
        //Pantalla inicial
        protected DataTable dbGetCuentasPresupuestables(string centro, string UserId)
        {
            return core.executeProcedureTab("NIW_CN_PresupuestoDataAccountsCenter '" + centro.Trim() + "','"+UserId.Trim()+"'");
            //return core.executeSqlTab("SELECT CUENTA As Codigo, DESCRIPCION2 AS Descripcion FROM dbo.NIC_0020 WHERE LEFT(CUENTA,4) ='" + centro + "' ORDER BY CUENTA");
        }

        protected bool dbDelConsepto(int year,string account,string line)
        {
            return core.executeProcedure("NIW_EliminarLinea_Presupuesto_NI5 " + year + ",'" + account + "','" + line + "'");
        }

        protected bool dbSetEdit(string linea, string cuenta, double ene, double feb, double mar, double abr, double may, double jun, double jul, double ago, double sep, double oct, double nov, double dic, int year)
        {
            return core.executeProcedure("NIW_MK_UpdateMes " + ene + "," + feb + "," + mar + "," + abr + "," + may + "," + jun + "," + jul + "," + ago + "," + sep + "," + oct + "," + nov + "," + dic + ",'" + cuenta +"','"+linea+"',"+year);
        }

        protected DataTable dbGetaño()
        {

            return core.executeSqlTab("SELECT MesCortePresupuesto as Month,PresupuestoGastos as Year From NIC_0016");

        }
        protected DataTable dbGetaños()
        {

            return core.executeSqlTab("select PresupuestoAnterior,PresupuestoActual,PresupuestoGastos from NIC_0016");
        }

        protected DataTable dbGetAuxiliaresDeCuenta(string centroDeCostos)
        {
            return core.executeSqlTab("NIW_CN_GetBudgetDataAccounts 3,'" + centroDeCostos + "',''");
        }
        protected DataTable dbGetConceptosContables(string centroDeCostos, string auxiliarDeCuenta)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetsNumbers '" + centroDeCostos + "','" + auxiliarDeCuenta.Substring(5) + "', 1");
        }
        protected DataTable dbGetPeriodoDePresupuesto()
        {
            return core.executeSqlTab("SELECT MesCortePresupuesto as Month,PresupuestoGastos as Year From NIC_0016");
        }
        protected DataTable dbGetNumbersByCenter(string center)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetsNumbers '" + center + "','',2");
        }
        //Pantalla de conceptos
        protected DataTable dbGetPresupuestoAnualPorConcepto(string id, int ano)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDetails '1','" + id + "'," + ano);
        }
        protected DataTable dbGetDetallesDePresupuestoPorConcepto(string id, int ano)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDetails '2','" + id + "'," + ano);
        }
        //protected bool dbSetDetallesDePresupuestoPorConcepto(int year, string account, string line, string detail, int desde, int hasta, double montEne, double montFeb , double montMar,double montAbr,double montMay,double montJun,double montJul,double montAgo,double montSep,double montOct,double montNov,double montDic)
        protected bool dbSetDetallesDePresupuestoPorConcepto(int year, string account, string line, string detail, int desde, int hasta,Dictionary<string,double> dcMeses)
        {
            //Armar los datos para detalles por mes
       
            string[] acc = account.Split('-');//obtenemos centro de costos de la cuenta
            string center = acc[0] + '-' + acc[1];
            bool res = true;
            try
            {
                if (core.executeProcedure("NIW_CN_SetBudgetDetails " + year + ",'" + account + "','" + center + "','" + detail + "'," + desde +"," + hasta+",'"+ line +"'"))
                {

                    foreach (var item in dcMeses)
                    {
                        if(item.Value!=null)
                        {
                            if (!core.executeProcedure("NIW_CN_SetBudgetDetailsByMonth '" + year.ToString() + "','" + account + "','" + line + "','" + item.Key + "','" + item.Value + "'"))
                                res = false;
                        }                            
                        
                    }

                }
                else res = false;
            }
            catch
            {
                res = false;
            }
            return res;

        }
        protected bool dbDelDetallesDePresupuestoPorConcepto(int id)
        {
            return core.executeSql("DELETE FROM NIW_CN_BudgetDetailsHeaders WHERE BudgetId = " + id);
        }
        protected DataTable dbGetPresupuestosMensualesPorCuenta(string account, int Year)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDetails '1','" + account + "'," + Year);
            
        }
        protected DataTable dbMovimientos(string account, int Year)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDetails '4','" + account + "'," + Year);

        }
        protected DataTable dbConseptosPresupuestados(string account, int Year)
        {
            return core.executeProcedureTab("NIW_CN_CONSULTACONSEPTO '" + account.Trim() + "'," + Year);

        }
        protected DataTable dbDetalleConseptos(string account, int Year)
        {
            
            return core.executeProcedureTab("NIW_CN_GetBudgetDetails '3','" + account + "'," + Year);


        }
        protected DataTable dbDetalleConseptos1(string account, int Year, string linea)
        {

            return core.executeProcedureTab("NIW_CN_SetDetalle '" + account + "'," + Year+",'"+linea+"'");


        }
        protected DataTable dbGetPresupuestosAnuales(string centroCostos)
        {
            return core.executeProcedureTab("NIW_CN_GetYearlyBudgetsByAccount '" + centroCostos + "'");
        }
        protected DataTable dbGetPresupuestosMensualesGenerales(string centroCostos)
        {

            return core.executeProcedureTab("NIW_CN_PresupuestosGenerales '" + centroCostos + "'");
        }
        protected void dbGetBudgetYear()
        {
            DataTable res = core.executeSqlTab("SELECT MesCortePresupuesto as Month,PresupuestoGastos as Year From NIC_0016");
            this.budgetYear = res.Rows[0]["Year"].ToString();
        }

        protected void dbGetBudgetcentro(string centrocostos1)
        {
            
            DataTable res = core.executeSqlTab("select Descripcion from CentrosdeCosto where Centro='" + centrocostos1 + "'");
            this.center = res.Rows[0]["Descripcion"].ToString();
        }


        protected bool dbGetPermisoCuenta(string userid , string sCuenta)
        {

            DataTable res = core.executeSqlTab("SELECT isnull(Tipo,0) as Tipo FROM NIC_0012 WHERE CdgUsu='" + userid + "' and Cuenta='" + sCuenta + "'");

            bool tipo = false;

            if(res!=null && res.Rows.Count > 0)
                tipo = res.Rows[0]["Tipo"] != null ? bool.Parse(res.Rows[0]["Tipo"].ToString()) : false;

            return tipo;

        }
        #endregion

  
    }
}