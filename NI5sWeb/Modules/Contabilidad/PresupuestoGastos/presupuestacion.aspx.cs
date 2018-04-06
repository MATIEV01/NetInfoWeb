using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NI5sWeb.NIWeb;
using System.Globalization;

namespace NI5Web.Modules.Contabilidad
{
    public partial class presupuestacion : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();

        protected string budgetYear = String.Empty;

       protected void Page_Load(object sender, EventArgs e)
        {
            //if (Request.HttpMethod == "POST")
            //    this.switchAction(Request["action"]);
            //else
            //{
            //    this.dbGetBudgetYear();           

            //    YearTitle.Text = this.budgetYear;
            //    //Session.Add("Year", budgetYear);
            //}


            if (!(this.Request.HttpMethod == "POST"))
                return;
            this.switchAction(this.Request["action"]);
        }

        protected void switchAction(string act)
        {
            switch(act){
                case "GetCentrosDeCostosPresupuestables":
                    this.getCentrosDeCostosPresupuestables();
                    break;
                case "GetAuxiliaresDeCuenta":
                    this.getAuxiliaresDeCuenta();
                    break;
                case "GetConceptosConTotalesAnuales":
                    this.getConceptosConTotalesAnuales();
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
                case "GetPresupuestosMensualesPorCuenta":
                    this.getPresupuestosMensualesPorCuenta();
                    break;
                case "GetPresupuestosAnuales":
                    this.getPresupuestosAnuales();
                    break;
                case "GetPresupuestosMensualesGenerales":
                    this.getPresupuestosMensualesGenerales();
                    break;
                case "GetCentrosCostos":
                    this.getCentrosCostos();
                    break;
                case "getAño":
                    this.getAño();
                    break;
            }
        }

        protected void getAño()
        {
            this.Response.Write(presupuestacion.core.dataTableToJson(this.dbGetBudgetYear()));
            this.Response.End();
        }

        protected void getCentrosCostos()
        {
            string usrId = this.Request.Cookies["Session"]["userId"];
            this.Response.Write(presupuestacion.core.dataTableToJson(this.dbGetCentroscostos(usrId)));
            this.Response.End();
        }

        protected void getCentrosDeCostosPresupuestables()
        {
            string usrId = Request.Cookies["Session"]["userId"];
            string res = core.dataTableToJson(this.dbGetCentrosDeCostosPresupuestables(usrId));
            Response.Write(res);
            Response.End();
        }

        protected void getAuxiliaresDeCuenta()
        {
            string centroDeCostos = Request["id"];
            string res = core.dataTableToJson(this.dbGetAuxiliaresDeCuenta(centroDeCostos));
            Response.Write(res);
            Response.End();
        }

        protected void getConceptosConTotalesAnuales()
        {
            int periodo = 0;
            //Obtener todos los conceptos que pertenecen al auxiliar
            DataTable conceptos = dbGetConceptosContables(Request["id"]);

            if (HttpContext.Current.Session["Year"] != null)
                periodo = int.Parse(HttpContext.Current.Session["Year"].ToString());
            else
            {
                
                periodo = Convert.ToInt32(budgetYear);
                Session.Add("Year", periodo);
            }

            
            int proyeccion = periodo - 1;
            int real = periodo - 2;

            string res = "[{\"periodo\":\"" + periodo + "\",\"proyeccion\":\"" + proyeccion + "\",\"real\":\"" + real + "\"}";
            foreach (DataRow rC in conceptos.Rows)
            {
                decimal aPeri = Convert.ToDecimal(rC["Presupuesto"]);
                decimal aProy = Convert.ToDecimal(rC["Proyeccion"]);
                decimal aReal = Convert.ToDecimal(rC["Real"]);

                res += ",{\"cuenta\":\"" + rC["MasterAccount"].ToString() + "\",\"nombre\":\"" + rC["GLAccountGroupDescription"].ToString() + "\",\"periodo\":\"" + aPeri + "\",\"proyeccion\":\"" + aProy + "\",\"real\":\"" + aReal + "\"}";
            }
            Response.Write(res + "]");
            Response.End();
        }

        protected void getDetallesDePresupuestoPorConcepto()
        {
            DataTable detalles = dbGetDetallesDePresupuestoPorConcepto(Request["id"],Convert.ToInt32(Request["year"]));
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
            //Recibir toda la cadena
            string[] detailHeaders = Request["cadena"].Split('|');
            string res = String.Empty;
            int l = 0;
            foreach (string s in detailHeaders)//Insertar detalle
            {
                string[] detalle = s.Split('¬');
                string[] head = detalle[0].Split(';');
                //Obtener datos de cabecera
                int byear = Convert.ToInt32(head[0]);
                string bDeta = head[1];
                string fsacc = head[2];
                Decimal total = Convert.ToDecimal(head[3]);
                //Obtener cadena de detalles por mes
                string details = detalle[1];

                //Obtener línea
                l++;
                string line = "00";
                if (l > 9) line = "0";
                if (l > 99) line = String.Empty;
                line += l.ToString();

                if (this.dbSetDetallesDePresupuestoPorConcepto(byear, bDeta, fsacc, total, details, line))
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

        protected void getPresupuestosMensualesPorCuenta()
        {
            string acc = Request["acc"];
            DataTable presupuestos = this.dbGetPresupuestosMensualesPorCuenta(acc);
            DataView presup = new DataView(presupuestos);
            string resString = "[";
            if (presupuestos.Rows.Count > 0)
            {
                string aaux = String.Empty;
                //Dividir por años
                DataTable anos = presup.ToTable(true, "BudgetYear");
                foreach (DataRow a in anos.Rows)
                {
                    aaux += ",{\"year\":\"" + a["BudgetYear"].ToString() + "\"";
                    //Obtener Meses
                    DataRow[] enes = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 1");
                    DataRow[] febs = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 2");
                    DataRow[] mars = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 3");
                    DataRow[] abrs = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 4");
                    DataRow[] mays = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 5");
                    DataRow[] juns = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 6");
                    DataRow[] juls = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 7");
                    DataRow[] agos = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 8");
                    DataRow[] seps = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 9");
                    DataRow[] octs = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 10");
                    DataRow[] novs = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 11");
                    DataRow[] dics = presupuestos.Select("BudgetYear = " + a["BudgetYear"].ToString() + " and BudgetMonth = 12");
                    double sene = 0; double sfeb = 0; double smar = 0; double sabr = 0; double smay = 0; double sjun = 0; double sjul = 0; double sago = 0; double ssep = 0; double soct = 0; double snov = 0; double sdic = 0;
                    foreach (DataRow m in enes) sene += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in febs) sfeb += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in mars) smar += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in abrs) sabr += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in mays) smay += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in juns) sjun += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in juls) sjul += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in agos) sago += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in seps) ssep += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in octs) soct += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in novs) snov += Convert.ToDouble(m["Amount"].ToString());
                    foreach (DataRow m in dics) sdic += Convert.ToDouble(m["Amount"].ToString());
                    aaux += ",\"ene\":\"" + sene.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"feb\":\"" + sfeb.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"mar\":\"" + smar.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"abr\":\"" + sabr.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"may\":\"" + smay.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"jun\":\"" + sjun.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"jul\":\"" + sjul.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"ago\":\"" + sago.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"sep\":\"" + ssep.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"oct\":\"" + soct.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"nov\":\"" + snov.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += ",\"dic\":\"" + sdic.ToString("0,0", CultureInfo.InvariantCulture) + "\"";
                    aaux += "}";
                }
                resString += aaux.Substring(1);
            }
            resString += "]";

            Response.Write(resString);
            Response.End();
        }

        protected void getPresupuestosAnuales()
        {
            Response.Write(core.dataTableToJson(this.dbGetNumbersByCenter(Request["acc"])));
            Response.End();
        }

        protected void getPresupuestosMensualesGenerales()
        {
            Response.Write(core.dataTableToJson(this.dbGetPresupuestosMensualesGenerales(Request["acc"])));
            Response.End();
        }

        #region Base de Datos
        //Pantalla inicial
        protected DataTable dbGetCentrosDeCostosPresupuestables(string usrId)
        {
            return core.executeProcedureTab(" WNI_Sp_ResumenPresupuestoDepartamentos_NI5 '" + usrId + "'");
            //return core.executeSqlTab("SELECT t2.Centro,t2.Descripcion FROM NIW_CN_UserPresupPermissions as t1 JOIN CentrosdeCosto as t2 ON LTRIM(RTRIM(t1.DatoId))COLLATE SQL_Latin1_General_CP1_CI_AS = t2.Centro WHERE DatoType = 1 AND UserId = '" + usrId + "' ORDER BY t2.Centro");
            //return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 2,'" + usrId + "',''");
        }
        protected DataTable dbGetAuxiliaresDeCuenta(string centroDeCostos)
        {
            //return core.executeSqlTab("SELECT GOMSTORG as Auxiliar,GORGDESC as Descripcion FROM FSDBMR.dbo.Fin_GACTORG WHERE LEFT(GOMSTORG,4) ='" + centroDeCostos + "' AND RIGHT(GOMSTORG,6) !='" + centroDeCostos + "' AND GOMSTORG COLLATE SQL_Latin1_General_CP1_CI_AS in (select DISTINCT LEFT(Cuenta,10) as Cuenta from NIC_0020 where ParticipaPresupuesto = 1) ORDER BY GOMSTORG");
            //return core.executeSqlTab("SELECT GOMSTORG as Auxiliar,GORGDESC as Descripcion FROM FSDBMR.dbo.Fin_GACTORG WHERE LEFT(GOMSTORG,4) ='" + centroDeCostos + "' AND RIGHT(GOMSTORG,6) !='" + centroDeCostos + "' AND GOMSTORG COLLATE SQL_Latin1_General_CP1_CI_AS in (select DISTINCT LEFT(Cuenta,10) as Cuenta from NIC_0020) ORDER BY GOMSTORG");
            return core.executeSqlTab("SELECT GOMSTORG as Auxiliar, GORGDESC as Descripcion FROM FSDBMR.dbo.Fin_GACTORG WHERE GOMSTORG =CONCAT('" + centroDeCostos + "','-','00000')");
        }
        protected DataTable dbGetConceptosContables(string centroDeCostos)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetsNumbers '" + centroDeCostos + "','', 1");
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
            return core.executeProcedureTab("NIW_CN_GetBudgetDetails '2','"+id+"',"+ano);
        }
        protected bool dbSetDetallesDePresupuestoPorConcepto(int year, string detail, string account, Decimal total, string details, string line)
        {
            //Armar los datos para detalles por mes
            string[] acc = account.Split('-');//obtenemos centro de costos de la cuenta
            string center = acc[0] + '-' + acc[1];
            bool res = true;
            try
            {
                if (core.executeProcedure("NIW_CN_SetBudgetDetails '" + year.ToString() + "','" + account + "','" + center + "','" + detail + "',1,12,'" + line + "'"))
                {
                    string[] meses = details.Split('>');
                    foreach (string mes in meses)
                    {
                        string[] data = mes.Split(';');
                        if (!core.executeProcedure("NIW_CN_SetBudgetDetailsByMonth '" + year.ToString() + "','" + account + "','" + line + "','" + data[0] + "','" + data[1] + "'"))
                            res = false;
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
        protected DataTable dbGetPresupuestosMensualesPorCuenta(string account)
        {
            DataTable r = core.executeProcedureTab("NIW_CN_GetBudgetDetailsMonthlyByAccount '" + account + "'");
            return r;
        }
        protected DataTable dbGetPresupuestosAnuales(string centroCostos)
        {
            return core.executeProcedureTab("NIW_CN_GetYearlyBudgetsByAccount '" + centroCostos + "'");
        }
        protected DataTable dbGetPresupuestosMensualesGenerales(string centroCostos)
        {

            return core.executeProcedureTab("NIW_CN_PresupuestosGenerales '" + centroCostos + "'");
        }
        //protected void dbGetBudgetYear()
        //{
        //    //DataTable res = core.executeSqlTab("SELECT MesCortePresupuesto as Month,PresupuestoGastos as Year From NIC_0016");
        //    //this.budgetYear = res.Rows[0]["Year"].ToString();
        //    DataTable res = core.executeSqlTab("SELECT dbo.Fnt_NIW_CN_GetBudgetYear() as anio");
        //    this.budgetYear = res.Rows[0]["anio"].ToString();
        //}

        protected DataTable dbGetBudgetYear()
        {
            DataTable dataTable = presupuestacion.core.executeSqlTab("SELECT MesCortePresupuesto as Month,PresupuestoGastos as Year From NIC_0016");
            if (dataTable.Rows.Count > 0)
            {
                this.budgetYear = dataTable.Rows[0]["Year"].ToString();
            }
            else
            {
                dataTable.Columns.Add("Month");
                dataTable.Columns.Add("Year");
                this.budgetYear = (DateTime.Now.Year + 1).ToString();
                dataTable.Rows.Add((object)8, (object)this.budgetYear);
            }
            this.Session.Add("Year", (object)this.budgetYear);
            return dataTable;
        }

        protected DataTable dbGetCentroscostos(string usrId)
        {
            return presupuestacion.core.executeProcedureTab("NIW_Sp_ResumenPresupuestoDepartamentos_NI5 '" + usrId + "'");
        }

        #endregion
    }
}

