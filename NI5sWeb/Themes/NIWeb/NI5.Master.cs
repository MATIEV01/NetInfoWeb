using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Themes
{
    public partial class NI5 : System.Web.UI.MasterPage
    {
        protected NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["Session"] == null)
                Response.Redirect("/Modules/Security/Login.aspx");
            else
            {
                if (core.hasPermissions(Request.Cookies["Session"]["UserId"], Request.AppRelativeCurrentExecutionFilePath.Substring(1)))
                {
                    //Mostrar Nombre de Usuario
                    UsrNameLabel.Text = Request.Cookies["Session"]["UserName"];
                }
                else
                    Response.Redirect("/");
            }

            if (Request.HttpMethod == "POST")
            {
                if (Request["action"] == "menu")
                    this.createMenu();
            }
        }

        protected void createMenu()
        {
            string r = String.Empty;
            string userId = Request.Cookies["Session"]["UserId"];
            DataTable m = core.executeProcedureTab(" NIW_CN_CREAMENU '" + userId + "'");

          
                    //DataTable m = core.executeSqlTab("SELECT ScreenName as nom, ScreenPath as path FROM NI_SYS_UI_Permissions as t1 INNER JOIN NIW_SYS_UI as t2 ON t1.ScreenId = t2.ScreenId WHERE t1.UserId = '" + userId + "'");
                    if (m.Rows.Count > 0 )
                       
                        r = core.dataTableToJson(m);
                    else
                        r = "0";

                    Response.Write(r);

                Response.End();
            
        }
    }
}