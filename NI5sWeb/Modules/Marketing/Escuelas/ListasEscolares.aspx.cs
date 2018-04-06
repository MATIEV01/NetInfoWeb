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
    public partial class ListasEscolares : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();

        protected string budgetYear = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
                this.switchAction(Request["action"]);
            else
            {
                //this.dbGetBudgetYear();
                YearTitle.Text = this.budgetYear;
            }
        }

        protected void switchAction(string act)
        {
            switch (act)
            {
                case "GetCentrosDeCostosPresupuestables":
                    this.getCentrosDeCostosPresupuestables();
                    break;
               
            }
        }

        protected void getCentrosDeCostosPresupuestables()
        {
            string usrId = Request.Cookies["Session"]["userId"];
            string res = core.dataTableToJson(this.dbGetCentrosDeCostosPresupuestables(usrId));
            Response.Write(res);
            Response.End();
        }

       

        #region Base de Datos
        //Pantalla inicial
        protected DataTable dbGetCentrosDeCostosPresupuestables(string usrId)
        {

            return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 2,'" + usrId + "',''");
        }
        
        #endregion
    }
}