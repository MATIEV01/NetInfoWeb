using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NI5sWeb.Modules.RH.Reporte
{
    public partial class getFormato : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Request.Cookies["Session"] == null)
            {
                this.Response.Redirect("/Modules/Security/Login.aspx");
            }
            else
            {
                this.Response.ContentType = "Application/pdf";
                this.Response.WriteFile(this.getFile(this.Request["name"]));
                this.Response.End();
            }
        }

        protected string getFile(string name)
        {
            string path = Context.Server.MapPath("PDF\\"+name);

            return path;
        }
    }
}