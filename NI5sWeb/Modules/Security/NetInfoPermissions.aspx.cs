using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.Security
{
    public partial class NetInfoPermissions : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
            {
                this.actionsSwitch();
            }
            else
            {
                this.getUsers();
            }
        }

        protected void actionsSwitch()
        {
            switch (Request["action"])
            {
                case "GetUserPermissions":
                    this.getUserPermissions(Request["uId"]);
                    break;
                case "SetPermission":
                    this.setPermission(Request["uId"], Request["sId"]);
                    break;
                case "DelPermission":
                    this.delPermission(Request["uId"], Request["sId"]);
                    break;
            }
        }

        protected void getUsers()
        {
            DataTable users = this.dbGetUsers();
            string html = String.Empty;
            foreach (DataRow user in users.Rows)
            {
                html += "<a href=\"#\" class=\"list-group-item searchableh\" data-id=\"" + user["CdgUsu"] + "\"><span class=\"label label-default\">" + user["CdgUsu"] + "</span> " + user["NomUsu"] + "</a>";
            }
            NetInfoUsersList.Controls.Add(new LiteralControl(html));
        }

        protected void getUserPermissions(string uId)
        {
            DataTable perms = this.dbGetPermissions(uId);
            string html = String.Empty;
            foreach (DataRow perm in perms.Rows)
            {
                string selected = String.Empty;
                if (perm["UserId"].ToString() != "") selected = "btn-primary fa fa-eye"; else selected = "btn-default fa fa-eye-slash";
                html += "<div class=\"col-md-3\"><div class=\"input-group\">"+
                "<span class=\"input-group-btn\"><button class=\"btn "+selected+"\" data-id=\""+perm["ScreenId"]+"\" type=\"button\"></button></span>"+
                "<p class=\"form-control\">"+perm["ScreenName"]+"</p></div></div>";
            }

            Response.Write(html);
            Response.End();
        }

        protected void setPermission(string uId, string sId)
        {
            if (this.dbSetPermission(uId, sId))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        protected void delPermission(string uId, string sId)
        {
            if (this.dbDelPermission(uId, sId))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        #region DataBase
        protected DataTable dbGetUsers()
        {
            return core.executeProcedureTab("NIW_SYS_NetInfoPermissionsAdministrator '0','0','0'");
        }
        protected DataTable dbGetPermissions(string uId)
        {
            return core.executeProcedureTab("NIW_SYS_NetInfoPermissionsAdministrator '" + uId + "','0','1'");
        }
        protected bool dbSetPermission(string uId, string sId)
        {
            return core.executeSql("NIW_SYS_NetInfoPermissionsAdministrator '" + uId + "','" + sId + "','2'");
        }
        protected bool dbDelPermission(string uId, string sId)
        {
            return core.executeProcedure("NIW_SYS_NetInfoPermissionsAdministrator '" + uId + "','" + sId + "','3'");
        }
        #endregion
    }
}