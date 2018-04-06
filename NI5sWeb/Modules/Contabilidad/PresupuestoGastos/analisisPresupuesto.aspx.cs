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
    public partial class analisisPresupuesto : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();
        string Cco = string.Empty;
        List<Entidad> lReal = new List<Entidad>();
        List<Entidad> lProyec = new List<Entidad>();
        List<Entidad> lPresu = new List<Entidad>();
        List<Entidad> lvar = new List<Entidad>();
         List<Entidad> lDif = new List<Entidad>();
        int sumaReal = 0;
        int sumaProyec = 0;
        int sumaPresu = 0;
        double sumaVar = 0;
        int sumaDif = 0;
       

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["Session"] == null)
                Response.Redirect("/Modules/Security/Login.aspx");
            
            if (Request.HttpMethod == "POST")
            {
                this.switchAction();
                
            }
            else
            {
                this.bindCostsCenters();
                //bindBudgetData();
            }
        }

        protected void switchAction()
        {
            switch (Request["action"])
            {
                case "GetCenterData":
                    this.bindBudgetData();
                    break;
                case "GetBudgetMonthDetails":
                    this.getBudgetDetailsByMonth();
                    break;
                case "ChangeBudget":
                    this.sendBudgetChanges();
                    break;
            }
        }

        protected void bindCostsCenters()
        {
            string usrId = Request.Cookies["Session"]["userId"].Replace(" ","");

            DataTable user = this.dbGetCctoID(usrId);
            foreach (DataRow data1 in user.Rows)
            {
                Cco = Convert.ToString(data1["CcTo_Id"]);
            }

            DataTable centers = this.dbGetCostsCentersBudgets(Cco);
            string list = "<table class=\"table table-condensed table-hover\" id=\"presupuestosAnuales\"><thead><tr><th>Cuenta</th><th>Centro de Costos</th><th>Real</th><th>Proyección</th><th>Presupuesto</th><th>% Variación</th><th>Diferencia</th></tr></thead><tbody>";
            foreach (DataRow data in centers.Rows)
            {
                //DataRow data = this.dbGetCostsCentersBudgets(center["Centro"].ToString()).Rows[0];
                list += "<tr><td>" + data["Centro"] + "</td><td>" + data["Descripcion"] + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", data["Real"]) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", data["Proyeccion"]) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", data["Presupuesto"]) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", data["Variacion"]) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", data["Maximo"]) + "</td></tr>";
                Entidad item = new Entidad()
                {
                    real = Convert.ToInt32(data["Real"])
                    
                };

                lReal.Add(item);

                Entidad item1 = new Entidad()
                {
                    proyeccion = Convert.ToInt32(data["Proyeccion"])
                };

                lProyec.Add(item1);

                Entidad item2 = new Entidad()
                {
                    presupuesto = Convert.ToInt32(data["Presupuesto"])
                };

                lPresu.Add(item2);

                Entidad item3 = new Entidad()
                {
                    variacion = Convert.ToDouble(data["Variacion"])
                };

                lvar.Add(item3);

                 Entidad item4 = new Entidad()
                {
                    diferencia = Convert.ToInt32(data["Maximo"])
                };

                 lDif.Add(item4);

                      
                    sumaReal = lReal.Sum(ltr => ltr.real);
                    sumaProyec = lProyec.Sum(ltp => ltp.proyeccion);
                    sumaPresu = lPresu.Sum(ltpr => ltpr.presupuesto);
                    sumaVar = lvar.Sum(ltv => ltv.variacion);
                    sumaDif = lDif.Sum(ltd => ltd.diferencia);
 
            }

            list += "<tr><td><th>" + "Totales" + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sumaReal) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sumaProyec) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sumaPresu) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sumaVar) + "</td><td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", sumaDif) + "</th></td></tr>";
            list += "</tbody></table>";
            this.presupuestosAnualesPanel.Controls.Add(new LiteralControl(list));
        }

        protected void bindBudgetData()
        {
            string ccId = Request["ccId"];
            DataTable ccs = this.dbGetAuxiliaresDeCuenta(ccId);
            string data = "<div class=\"panel panel-info\">";
            foreach (DataRow cc in ccs.Rows)
            {
                string acId = cc["Auxiliar"].ToString().Split('-')[2];
                string acDesc = cc["Descripcion"].ToString();
                data += "<div class=\"panel-heading\"><h3 class=\"panel-title\"><span>" + cc["Auxiliar"] + "</span> " + acDesc + "</h3></div>";
                data += "<div class=\"panel-body table-responsive\">";

                DataTable accs = this.dbGetCuentasContables(ccId, acId);
                foreach (DataRow acc in accs.Rows)
                {
                    string accId = acc["CUENTA"].ToString();
                    string accDesc = acc["DESCRIPCION"].ToString();
                    data += "<table class=\"table table-striped table-bordered presupuestosGenerales\">";
                    data += "<thead><tr><th colspan=\"14\" class=\"title\"><span>" + accId + "</span> " + accDesc + "</th></tr><tr><th>Año</th><th>ENE</th><th>FEB</th><th>MAR</th><th>ABR</th><th>MAY</th><th>JUN</th><th>JUL</th><th>AGO</th><th>SEP</th><th>OCT</th><th>NOV</th><th>DIC</th><th>TOTAL</th></tr></thead>";
                    data += "<tbody>";

                    DataTable centers = this.dbGetDetailsExtras(ccId, accId);
                    foreach (DataRow datos in centers.Rows)
                    {
                        data += "<tr><th>" + datos["Año"] + "</th>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Ene"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Feb"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Mar"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Abr"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["May"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Jun"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Jul"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Ago"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Sep"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Oct"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Nov"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Dic"]) + "</td>";
                        data += "<td>" + String.Format(CultureInfo.InvariantCulture, "{0:0,0.00}", datos["Total"]) + "</td></tr>";

                   
                    }

                    data += "</tbody></table>";
                }
                data += "</div>";
            }
            data += "</div>";

            Response.Write(data);
            Response.End();
        }

        protected void getBudgetDetailsByMonth()
        {
            string acc= Convert.ToString(Request["acc"]);
            string center= Convert.ToString(Request["acc"]);
            int year = Convert.ToInt32(Request["y"]);

            DataTable dets = this.dbGetPresupuestoGastos(acc,center,year);
            Response.Write(core.dataTableToJson(dets));
            Response.End();
        }

        protected void sendBudgetChanges()
        {
            string str = Request["dat"];
            string[] rs = str.Split(',');
            bool ret = true;
            foreach (string r in rs)
            {
                string[] dts = r.Split(';');
                int id = Convert.ToInt32(dts[0]);
                decimal amount = Convert.ToDecimal(dts[1]);
                if (this.dbGetBudgetsModification(id).Rows.Count > 0)
                {
                    if (!this.dbUpdateBudgetModification(id, amount, Request.Cookies["Session"]["userId"]))
                        ret = false;
                }
                else
                {
                    if (!this.dbSetNewBudgetModification(id, amount, Request.Cookies["Session"]["userId"]))
                        ret = false;
                }
            }
            if (ret) Response.Write("1"); else Response.Write("0");
            Response.End();
        }

           
            
            
        

        #region Base de Datos
        protected DataTable dbGetDetailsExtras(string center, string auxiliar)
        {
            return core.executeProcedureTab("NIW_CN_GetDetailsExtras '" + center + "','" + auxiliar + "'");
            //return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 4,'" + center + "','" + auxiliar + "'");
        }

        protected DataTable dbGetPresupuestoGastos(string center,string acc, int y)//cambio
        {
            //return core.executeProcedureTab("NIW_CN_GetBudgetDetailsExtras '" + center + "','','','3'");
            return core.executeProcedureTab("NIW_CN_PresupuestoMensualGastos '" + center + "','"+ acc +"'," +y);
        }

        protected DataTable dbGetCctoID(string user)
        {
            return core.executeSqlTab("select CcTo_Id from NIC_0011 where CdgUsu= '" + user+"'");
        }

        protected DataTable dbGetCostsCenters()
        {
            return core.executeSqlTab("EXECUTE NIW_CN_GetBudgetDataAccounts 1,'',''");
        }
        protected DataTable dbGetCostsCentersBudgets(string Ccto)//cambio
        {
            //return core.executeProcedureTab("NIW_CN_GetBudgetDetailsExtras '" + center + "','','','3'");
            return core.executeProcedureTab("NIW_CN_BudgetSummaryByCostCenter '"+Ccto+"'");
        }
        protected DataTable dbGetAuxiliaresDeCuenta(string center)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 3,'" + center + "',''");
        }
        protected DataTable dbGetCuentasContables(string center, string auxiliar)
        {
            return core.executeProcedureTab("NIW_CN_PresupuestoDataAccounts '" + center + "','" + auxiliar + "'");
            //return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 4,'" + center + "','" + auxiliar + "'");
        }
        protected DataTable dbGetBudgetsDatailsExtra(string acc)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDetailsExtras '" + acc + "','','',2");
        }
        protected DataTable dbGetBudgetsDetailsMonths(string acc, int y, int m)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDetailsExtras '" + acc + "'," + y + "," + m + ",1");
        }
        protected DataTable dbGetCentrodecostos(string center)
        {
            return core.executeSqlTab("SELECT * FROM CentrosdeCosto WHERE Centro= '" + center +"'");
        }
        protected DataTable dbGetBudgetsModification(int id)
        {
            return core.executeSqlTab("SELECT * FROM NIW_CN_BudgetDetailsEdited WHERE DetailId = " + id);
        }
        protected bool dbSetNewBudgetModification(int id, decimal amount, string usrId)
        {
            return core.executeSql("INSERT INTO NIW_CN_BudgetDetailsEdited (DetailId,Amount,EditedDate,EditedBy) VALUES ('" + id + "','" + amount + "',GETDATE(),'" + usrId + "')");
        }
        protected bool dbUpdateBudgetModification(int id, decimal amount, string usrId)
        {
            return core.executeSql("UPDATE NIW_CN_BudgetDetailsEdited SET Amount = '" + amount + "', EditedDate = GETDATE(), EditedBy = '" + usrId + "' WHERE DetailId = " + id);
        }
        #endregion
    }
}
class Entidad
{
    public int real { get; set; }
    public int proyeccion { get; set; }
    public int presupuesto {get; set;}
    public double variacion { get; set; }
    public int diferencia { get; set; }
    
}