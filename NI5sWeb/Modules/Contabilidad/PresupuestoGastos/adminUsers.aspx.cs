using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;
using System.Text;

namespace NI5sWeb.Modules.Contabilidad
{
    public partial class adminUsers : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
            {
                this.switchActions();
            }
            else
            {
                //this.bindUserAllowed();
                this.bindUsersNotAllowed();
                this.bindCostCenters();
                
            }
        }

        protected void switchActions()
        {
            switch (Request["action"])
            {
                case "DeleteUser":
                    this.deleteUserAccess();
                    break;
                case "AddUser":
                    this.addUser();
                    break;
                case "GetUserPermissions":
                    this.getUserPermissions();
                    break;
                case "getUserCuentas":
                    this.getUserCuentas();
                    break;
                case "addPermission":
                    this.addPermission();
                    break;
                case "delPermission":
                    this.delPermission();
                    break;
                case "getAllAccounts":
                    this.getAllAccount();
                    break;
                case "readOnly":
                    this.setReadOnly();
                    break;
                case "readWrite":
                    this.setReadWrite();
                    break;
                case "BindCuentas":
                    this.bindCuentas();
                    break;
                case "updateSelect":
                    this.updateSelect();
                    break;
                case "bindCostCenters":
                    this.bindUserAllowed();
                    break;

                case "UpdateFecha":
                    this.UpdateFechaExp();
                    break;
            }
        }

        protected void UpdateFechaExp()
        {
            string User=Request["user"];
            string fecha = Request["dtFecha"];

            if(this.dbUpdateFechaExp(fecha, User))
                Response.Write(1);
            else Response.Write(0);
            Response.End();
        }


        protected void bindUserAllowed()
        {
            DataTable users = this.dbGetUsersAllowed();
            string list = string.Empty;
            //list += "<table class=\"page-header\"><tr>";
            //list += "<h5 rowspan=\"3\"><small>No. de Empleado</small></h5><h5><small>Nombre de Empleado</small></h5>";
            //list+="</tr></table>";
            UsersBox.Controls.Clear();

            foreach (DataRow user in users.Rows)
            {
                string usersa = user["UserId"].ToString();
               
                list += "<div class=\"input-group searchField\" data-user=\"" + user["UserId"] + "\">";
                list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon sf-userId\">" + user["UserEmp"] + "</span>";
                list += "<p style=\"font-family:Tahoma; font-size:9px;\" class=\"form-control sf-userName\">" + user["UserName"] + "</p>";
                //DataTable date = this.dbGetUsersDateExpiration(usersa);
                
                //foreach (DataRow date1 in date.Rows)
                //{
                    //this.fechaExp.Value = Convert.ToDateTime(date1["FechaCaducidad"]).ToShortDateString();

                list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon \">" + Convert.ToDateTime(user["FechaAlta"]).ToShortDateString() + "</span>";
                list += "<span  style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon \">" + Convert.ToDateTime(user["FechaCaducidad"]).ToShortDateString() + "</span>";
                list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon \">" + Convert.ToDateTime(user["FechaRenovacion"]).ToShortDateString() + "</span>";
                list += "<span style=\"font-family:Tahoma; font-size:9px;\" id=\"centro\" class=\"input-group-addon \">" + user["CcTo_Id"] + "</span>";
                   // list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon \">" + user["NivelDepartamento"] + "</span>";
               // }
                list += "<span class=\"input-group-btn\">";
                list += "<a href=\"#\" class=\"btn btn-info\" data-toggle=\"modal\" data-target=\"#permissionUsersModal\">Permisos</a>";
                list += "<a href=\"#\" class=\"btn btn-danger\"><i class=\"fa fa-trash\"></i></a>";
                list += "</span>";
                list += "</div>";
            }

            Response.Write(list);
            Response.End();
            //UsersBox.Controls.Add(new LiteralControl(list));
        }

        protected void bindUsersNotAllowed()
        {
            DataTable users = this.dbGetUsersNotAllowed();
            string list = String.Empty;
            foreach (DataRow user in users.Rows)
            {
               
                list += "<div class=\"input-group searchField\" data-user=\""+user["UserId"]+"\">";
                list += "<span class=\"input-group-addon sf-userId\">"+user["UserEmp"]+"</span>";
                list += "<p class=\"form-control sf-userName\">"+user["UserName"]+"</p>";
                list += "<span class=\"input-group-btn\">";
                list += "<a href=\"#\" class=\"btn btn-success\"><i class=\"fa fa-check\"></i></a>";
                list += "</span>";
                list += "</div>";
            }

            UsersNoPermitted.Controls.Add(new LiteralControl(list));
        }

        protected void deleteUserAccess()
        {
            string res = "0";
            if (this.dbDeleteUserAccess(Request["usr"]))
                res = "1";
            Response.Write(res);
            Response.End();
        }

        protected void addUser()
        {
            if (this.dbSetUserPermission(Request["usrId"]))
                Response.Write("1");
            else
                Response.Write("0");
            Response.End();
        }

        protected void updateSelect()
        {
            string user = Request["user"];
            string cuenta = Request["value"];
            int valor = Convert.ToBoolean(Request["select"].ToString()) ? 1 : 0;
           
           

            int tipo = 0;
            if (this.dbUpdate(tipo, user, cuenta))
                Response.Write("1");
            else
                Response.Write("0");
            Response.End();

        }

        protected void bindCostCenters()
        {
            DataTable centers = this.dbGetCostCenters();
            string list = String.Empty;
            foreach (DataRow center in centers.Rows)
            {
                list += "<div class=\"input-group searchField\" data-id=\"" + center["centro"] + "\">";
                list += "<span style=\"font-family:Tahoma; font-size:9px;\"class=\"input-group-addon sf-centerId\">" + center["centro"] + "</span>";
                list += "<p style=\"font-family:Tahoma; font-size:9px;\" class=\"form-control sf-centerName\">" + center["Descripcion"] + "</p>";
                list += "<span class=\"input-group-btn\"><a href=\"#\" class=\"btn btn-success\"><i class=\"fa fa-plus\"></i></a></span></div>";
            }

            areasList.Controls.Add(new LiteralControl(list));
        }

        protected void bindCuentas()
        {
            string User = Request["user"];
            DataTable cuentas = this.dbGetCuentas(User);
            string list = String.Empty;
            foreach (DataRow cuenta in cuentas.Rows)
            {
                list += "<div class=\"input-group searchField\" data-id=\"" + cuenta["Grupo"] + "\">";
                list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon sf-centerId\">" + cuenta["Grupo"] + "</span>";
                list += "<p style=\"font-family:Tahoma; font-size:9px;\" class=\"form-control sf-centerName\">" + cuenta["Descripcion"] + "</p>";
                list += "<span class=\"input-group-btn\"><a href=\"#\" class=\"btn btn-success\"><i class=\"fa fa-plus\"></i></a></span></div>";
            }

            Response.Write(list);
            Response.End();
          
        }
        protected void getUserCuentas()
        {
            int select = 0;
            string User = Request["user"];
            DataTable cuentas = this.dbGetUserCuentas(User);
            string list = String.Empty;
            foreach (DataRow cuenta in cuentas.Rows)
            {
                list += "<div class=\"input-group searchField\" data-id=\"" + cuenta["Cuenta"] + "\">";
                if (cuenta["Tipo"].ToString() == "False")
                {
                    list += "<span class=\"input-group-btn btn-primary\"><input  class=\"checkbox \"  id=\"checkbox\" value=\"" + cuenta["Cuenta"] + "\" type=\"checkbox\"></span>";
                }
                else
                {
                    list += "<span class=\"input-group-btn btn-primary\"><input class=\"checkbox \" id=\"checkbox\" value=\"" + cuenta["Cuenta"] + "\" type=\"checkbox\" checked=\"checked\" ></span>";
                }
               
                list += "<span style=\"font-family:Tahoma; font-size:9px;\" class=\"input-group-addon sf-centerId\">" + cuenta["Cuenta"] + "</span>";
                list += "<p style=\"font-family:Tahoma; font-size:9px;\" class=\"form-control sf-centerName\">" + cuenta["DescCuenta"] + "</p>";
                list += "<span id=\"eliminarcuenta\" class=\"input-group-btn\"><a href=\"#\" class=\"btn btn-danger\"><i class=\"fa fa-times\"></i></a></span></div>";
             
                
               
            }

            Response.Write(list);
            Response.End();
            
        }

        protected void getUserPermissions()
        {
            DataTable prs = this.dbGetUserPermissions(Request["usr"]);
            Response.Write(core.dataTableToJson(prs));
            Response.End();
        }

      

        protected void addPermission()
        {

            if (this.dbSetPermission(Request["usr"], Request["id"])) Response.Write(1);
            else Response.Write(0);
            Response.End();
        }

        protected void delPermission()
        {
            if (this.dbDelPermission(Request["usr"], Request["id"])) Response.Write(1); else Response.Write(0);
            Response.End();
        }

        protected void getAllAccount()
        {
            DataTable rws = this.dbGetAllAccounts(Request["usr"], Request["id"]);
            Response.Write(core.dataTableToJson(rws));
            Response.End();
        }

        protected void setReadOnly()
        {
            if (this.dbSetAccountPermission(Request["usr"], Request["id"])) Response.Write(1); else Response.Write(0);
            Response.End();
        }

        protected void setReadWrite()
        {
            if (this.dbDelAccountPermission(Request["usr"], Request["id"])) Response.Write(1); else Response.Write(0);
            Response.End();
        }

        #region Base de Datos
        protected DataTable dbGetUsersAllowed()
        {
            StringBuilder sql = new StringBuilder();

            sql.Append("select distinct NIC.CdgUsu as UserId,t2.EmpleadoID as UserEmp , dbo.Fnt_NombreEmpleadoNomina(t2.NomUsu) as UserName , FechaAlta,FechaCaducidad,FechaRenovacion,CcTo_Id ");
            sql.Append(" from NIC_0011 NIC INNER JOIN NI_0100 as t2 ON NIC.CdgUsu = t2.CdgUsu  ");

            return core.executeSqlTab(sql.ToString());
        }
        protected DataTable dbGetUsersDateExpiration(string user)
        {
            return core.executeSqlTab("select FechaAlta,FechaCaducidad,FechaRenovacion,CcTo_Id,NivelDepartamento from NIC_0011 where CdgUsu='"+user+"'");
        }
        protected bool dbDeleteUserAccess(string usrId)
        {
            if (core.executeSql("DELETE FROM NIW_SYS_UI_Permissions WHERE UserId = '" + usrId + "' and ScreenId in (2,13)"))
                return core.executeSql("DELETE FROM NIC_0011 where CdgUsu='" + usrId + "'");
            else
                return false;
        }
        protected DataTable dbGetUsersNotAllowed()
        {
            return core.executeProcedureTab("NIW_CN_GetNetInfoUsers");
        }
        protected bool dbSetUserPermission(string usrId)
        {
            if (core.executeSql("INSERT INTO NIW_SYS_UI_Permissions (UserId, ScreenId) VALUES ('" + usrId + "','2'),('" + usrId + "','13')"))
                return core.executeSql("insert into NIC_0011 values('" + usrId + "','',GETDATE(),GETDATE(),GETDATE(),'','')");
            else
                return false;
        }

        protected bool dbUpdateFechaExp(string date, string user)
        {
            return core.executeSql("update NIC_0011 set FechaCaducidad='" + date + "' where CdgUsu='" + user + "'");
        }

        protected bool dbUpdate(int tipo, string user, string account)
        {
            return core.executeSql("update nic_0012 set Tipo="+ tipo +" where CdgUsu='"+ user +"' and Cuenta='"+ account +"'");
        }
        
        protected DataTable dbGetCostCenters()
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 1,'',''");
        }
        protected DataTable dbGetCuentas(string User)
        {
            return core.executeProcedureTab("NIW_Sp_Cuentas_Pendientes_Segur_Presup'"+User+"'");
        }
        protected DataTable dbGetUserPermissions(string usrId)
        {
            return core.executeProcedureTab("WNI_Sp_ResumenPresupuestoDepartamentos_NI5'" + usrId + "'");
            //return core.executeProcedureTab("NIW_CN_GetUserPermissions 1,'" + usrId + "',''");
        }
        protected DataTable dbGetUserCuentas(string usrId)
        {
            return core.executeProcedureTab("WNI_Sp_ResumenCuentas_NI5'" + usrId + "'");
            //return core.executeProcedureTab("NIW_CN_GetUserPermissions 1,'" + usrId + "',''");
        }
        protected bool dbSetPermission(string usrId, string id)
        {

             DataTable res =core.executeSqlTab("select CcTo_Id from NIC_0011 where CdgUsu='"+usrId+"'");
             string CCto = res.Rows[0]["CcTo_Id"].ToString();

            return core.executeSql("INSERT INTO NIC_0015 VALUES ('" + usrId + "','"+ CCto +"','" + id + "')");
        }
        protected bool dbDelPermission(string usrId, string id)
        {
            return core.executeSql("DELETE FROM NIC_0015 where CdgUsu='" + usrId + "' AND  Departamento= '" + id + "'");
        }
        protected DataTable dbGetAllAccounts(string usrId, string id)
        {
            return core.executeProcedureTab("NIW_CN_GetBudgetDataAccounts 5,'" + usrId + "','" + id + "'");
        }
        protected bool dbSetAccountPermission(string usrId, string id)
        {
            return core.executeSql("INSERT NIC_0012 VALUES ('" + usrId + "','" + id + "','01',1)");
        }
        protected bool dbDelAccountPermission(string usrId, string id)
        {
            return core.executeSql("DELETE FROM NIC_0012 WHERE CdgUsu = '" + usrId + "' AND Cuenta = '" + id + "'");
        }
        #endregion
    }
}