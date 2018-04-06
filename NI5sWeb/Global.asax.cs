using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace NI5sWeb
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {
            string strError;
            strError = Server.GetLastError().ToString();
            if (Context != null)
            {
                Context.ClearError();
                Response.Write("Application_Error" + "<br/>");
                Response.Write("<b>Error Msg:</b>" + strError + "<br/>" + "<b>End Error Msg<b/>");
            }
        }
    }
}