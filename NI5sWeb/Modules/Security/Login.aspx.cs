using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected static NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            //Cerrar Sesión
            if (Request.Cookies["Session"] != null)
            {
                HttpCookie session = new HttpCookie("Session");
                session.Expires = DateTime.Now.AddDays(-1d);
                Response.Cookies.Add(session);
            }
        }

        protected void Enter_Click(object sender, EventArgs e)
        {
            DataTable usr = this.dbGetLogin(Name.Text, Pass.Text);
            if (usr.Rows.Count > 0)
            {
                //Guardar datos en Cookies
                HttpCookie session = new HttpCookie("Session");
                session["userId"] = usr.Rows[0]["UserId"].ToString();
                session["userName"] = usr.Rows[0]["UserName"].ToString();
                //session["fullName"] = usr.Rows[0]["UserFullName"].ToString();
                session["userNT"] = usr.Rows[0]["EmployeeID"].ToString();
                //session["userType"] = usr.Rows[0]["UserType"].ToString();
                session.Expires = DateTime.Now.AddDays(1d);
                Response.Cookies.Add(session);
                Response.Redirect("/default.aspx");
            }
            else
                core.alert("Error en los datos de acceso, intente de nuevo", Response);
        }

        #region Base de Datos
        protected DataTable dbGetLogin(string n, string p)
        {
            return core.executeProcedureTab("NI_SYS_GetLogin '" + n + "','" + p + "'");
        }
        #endregion
    }
}