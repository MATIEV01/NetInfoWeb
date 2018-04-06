using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NI5sWeb.Themes.NIWeb
{
    public partial class NI5Local : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request["form"] != null)
                Response.Write("Entró");
        }
    }
}