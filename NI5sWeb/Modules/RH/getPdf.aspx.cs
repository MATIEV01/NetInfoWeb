using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NI5sWeb.Modules.RH
{
    public partial class getPdf : System.Web.UI.Page
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
                this.Response.WriteFile(this.getFileFromMonth(this.Request["Id"], this.Request["name"]));
                this.Response.End();
            }
        }

        protected string getFileFromMonth(string id, string name)
        {
            return "\\\\12.12.71.96\\Digitalizacion\\Finanzas\\RH\\Cursos\\" + id + "\\" + name + ".pdf";
        }
    }
}