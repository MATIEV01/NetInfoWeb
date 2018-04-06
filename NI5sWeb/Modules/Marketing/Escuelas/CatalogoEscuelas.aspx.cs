using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;
using System.Net;

namespace NI5sWeb.Modules.Marketing.Escuelas
{
    public partial class CatalogoEscuelas : System.Web.UI.Page
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
                this.bindCreatingWizard();
                this.bindSchools(false);
            }
        }

        protected void actionsSwitch()
        {
            switch (Request["action"])
            {
                case "CreateSchool":
                    this.createSchool();
                    break;
                case "DeleteSchool":
                    this.DeleteSchool();
                    break;
                case "ShowAllSchools":
                    this.bindSchools(true);
                    break;
                case "GetSearch":
                    this.getSearchProducts();
                    break;
                case "AddProduct":
                    this.addProduct();
                    break;
                case "RemoveProduct":
                    this.removeProduct();
                    break;
                case "ShowSchoolProducts":
                    this.showSchoolProducts();
                    break;
                case "AddStudentsNumber":
                    this.addStudentsNumber();
                    break;
                case "GetStudentsNumber":
                    this.getStudentsNumber();
                    break;
                case "GetEditSchoolLevels":
                    this.getEditSchoolLevels();
                    break;
                case "SetEditSchoolLevels":
                    this.setEditSchoolLevels();
                    break;
            }
        }

        protected void bindCreatingWizard()
        {
            //Step 1
            DataTable states = this.dbGetStates();
            string opts = "<select id=\"escEst\" class=\"form-control\" required=\"required\">";
            opts += "<option value=\"\">Estado</option>";
            foreach(DataRow re in states.Rows)
                opts += "<option value=\""+re["StateId"]+"\">"+re["State"]+"</option>";
            opts += "</select>";
            escEstado.Controls.Add(new LiteralControl(opts));

            DataTable localities = this.dbGetLocalities();
            opts = "<select id=\"escCiu\" class=\"form-control\" required=\"required\">";
            opts += "<option value=\"\" class=\"ciuAll\">Ciudad</option>";
            foreach (DataRow rc in localities.Rows)
            {
                opts += "<option value=\"" + rc["LocalityId"] + "\" class=\"ciu" + rc["StateId"] + "\">" + rc["Locality"] + "</option>";
            }
            opts += "</select>";
            escCiudad.Controls.Add(new LiteralControl(opts));

            DataTable prms = this.dbGetPromoters();
            //DataRow[] places = prms.Select("PlaceType = 1 or PlaceType = 3");
            opts = "<select id=\"escPromotor\" class=\"form-control\" required=\"required\">";
            opts += "<option value=\"\">Promotor</option>";
            foreach (DataRow prm in prms.Rows)
            {
                opts += "<option value=\"" + prm["PlaceId"] + "\">" + prm["PromoterName"] + "</option>";
            }
            opts += "</select>";
            PromotersList.Controls.Add(new LiteralControl(opts));
            //nuevo campo colombia
            DataTable Estratos = this.dbGetEstrato();
            opts = "<select id=\"escEstrato\" class=\"form-control\" required=\"required\">";
            opts += "<option value=\"\" class=\"ciuAll\">Estrato</option>";
            foreach (DataRow rc in Estratos.Rows)
            {
                opts += "<option value=\"" + rc["EstratoId"] + "\">" + rc["Estrato"] + "</option>";
            }
            opts += "</select>";
            EstractoList.Controls.Add(new LiteralControl(opts));
        }

        protected void createSchool()
        {
            string name =  Request["escNom"];
            string addr = Request["escDir"];
            int state = Convert.ToInt32(Request["escEst"]);
            int local = Convert.ToInt32(Request["escCiu"]);
            string col = Request["escCol"];
            int zipCode = Convert.ToInt32(Request["escCP"]);
            string mail = Request["escEmail"];
            long phone = 0;
            if(Request["escTel"] != "")
                phone = Convert.ToInt64(Request["escTel"]);
            int promo = 0;
            if(Request["escPromotor"] != "")
                promo = Convert.ToInt32(Request["escPromotor"]);
            int center = Convert.ToInt32(Request["escCentro"]);
            int teachers = Convert.ToInt32(Request["escMaestros"]);
            string cargo = Request["escCargosCargo"];
            string cargNom = Request["escCargosNom"];
            string cargApp = Request["escCargosApp"];
            string cargApm = Request["escCargosApm"];
            long cargTel = 0;
            if (Request["escCargosTel"] != "")
                cargTel = Convert.ToInt64(Request["escCargosTel"]);
            string cargMail = Request["escCargosMail"];
            int estrato = 0;
            if (Request["escEstrato"] != "")
                estrato = Convert.ToInt32(Request["escEstrato"]);
            string nivel = Request["nivel"];
            string res = "0";
            if (this.dbCreateSchools(name, addr, state, local, col, zipCode, mail, phone, promo, center, teachers, cargo, cargNom, cargApp, cargApm, cargTel, cargMail, estrato, nivel))
                res = "1";
            Response.Write(res);
            Response.End();
        }

        protected void bindSchools(bool post)
        {
            string list = String.Empty;
            DataTable schools = this.dbGetSchools();
            foreach (DataRow school in schools.Rows)
            {
                DataTable levels = dbGetSchoolLevels(Convert.ToInt32(school["SchoolId"]));
                bool lvls = false;
                if (levels.Rows.Count > 0) lvls = true;
                int loaded = this.dataLevelSchool(school, lvls);
                list += "<div class=\"col-md-4 col-sm-6 searchField\"><div class=\"panel panel-default\" data-id=\"" + school["SchoolId"] + "\"><div class=\"panel-heading\">" + school["SchoolName"] + "</div><div class=\"panel-body\">";
                //list += "<h5>"+school["SchoolName"]+"</h5>";
                //list += "<div class=\"progress\"><div class=\"progress-bar progress-bar-info\" role=\"progressbar\" aria-valuenow=" + loaded + " aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + loaded + "%;\"><span class=\"sr-only\">" + loaded + "% Completado</span></div></div>";
                list += "<p class=\"list-group-item-text\">Estado: "+school["State"]+"</p>";
                list += "<p class=\"list-group-item-text\">Niveles de Estudio: ";
                int caux = 0;
                string s = school["Jardin"].ToString();
                if (school["Maternal"].ToString() != "") { list += "Maternal"; caux++; }
                if (school["Jardin"].ToString() != "") { if (caux > 0) list += ","; list += "Jardín de Niños"; caux++; }
                if (school["Primaria"].ToString() != "") { if (caux > 0) list += ","; list += "Primaria"; caux++; }
                if (school["Secundaria"].ToString() != "") { if (caux > 0) list += ","; list += "Secundaria"; caux++; }
                if (school["Preparatoria"].ToString() != "") { if (caux > 0) list += ","; list += "Preparatoria"; caux++; }
                list += "<p class=\"list-group-item-text\">Estrato: " + school["Estrato"] + "</p>";
                list += "</p></div><div class=\"panel-footer\"><div class=\"btn-group\" role=\"group\" aria-label=\"...\" data-school=\"" + school["SchoolId"] + "\">";
                list += "<a href=\"#\" class=\"btn btn-primary btn-xs\" data-toggle=\"tooltip\" data-placement=\"bottom\" title=\"Lista Escolar\"><i class=\"fa fa-list\"></i></a>";
                list += "<a href=\"#\" class=\"btn btn-info btn-xs modSchool\" data-toggle=\"tooltip\" data-placement=\"bottom\" title=\"Modificar\"><i class=\"fa fa-edit\"></i></a>";
                list += "<a href=\"#\" class=\"btn btn-danger btn-xs delSchool\" data-toggle=\"tooltip\" data-placement=\"bottom\" title=\"Eliminar\"><i class=\"fa fa-trash\"></i></a>";
                list += "</div><div class=\"listCiclos\"><div class=\"movible\"><div class=\"listContent\">";

                DataTable cicles = this.dbGetSchoolCicles(Convert.ToInt32(school["SchoolId"]));
                foreach (DataRow cicle in cicles.Rows)
                    list += "<div class=\"form-field\"><a href=\"#\" class=\"btn btn-default form-control\" data-toggle=\"modal\" data-target=\"#listaEscolarModal\" data-backdrop=\"false\">" + cicle["Ciclo"] + "</a></div>";
                list += "</div><div class=\"row form-field\">";
                list += "<a href=\"#\" class=\"addCicloBtn\">Agregar Lista...</a>";
                list += "</div></div></div></div></div></div>";
            }

            if (post)
            {
                Response.Write(list);
                Response.End();
            }
            else
                SchoolList.Controls.Add(new LiteralControl(list));
        }

        protected int dataLevelSchool(DataRow r, bool n)
        {
            int i = 0;
            string e = r["Email"].ToString();
            string ph = r["Phone"].ToString();
            string pr = r["PromotorId"].ToString();
            string ap = r["ApellidoP"].ToString();
            string am = r["ApellidoM"].ToString();
            string t = r["Telefono"].ToString();
            if (e != "") i++;
            if (ph != "0") i++;
            if (pr != "0") i++;
            if (ap != "") i++;
            if (am != "") i++;
            if (t != "0") i++;

            decimal obligatorios = 66.67M;
            decimal opcionales = (i * 100) / 21;
            decimal nivelAcademico = 0;
            if (n) nivelAcademico = (1 * 100) / 21;

            decimal aux = obligatorios + opcionales + nivelAcademico;
            int res = 0;
            if (aux > 100) res = 100;
            else res = (int)Math.Round(aux);

            return res;
        }

        protected void DeleteSchool(){
            string res = "0";
            if (this.dbDelSchool(Convert.ToInt32(Request["schoolId"])))
                res = "1";

            Response.Write(res);
            Response.End();
        }

        protected void getSearchProducts()
        {
            DataTable prods = this.dbGetSearchProducts(Convert.ToInt32(Request["case"]), Request["search"]);
            string list = String.Empty;
            foreach (DataRow prod in prods.Rows)
            {
                list += "<a href=\"#\" class=\"list-group-item\" data-um=\"" + prod["UnidadMedida"] + "\"><span class=\"label label-default\">" + prod["ProdId"] + "</span> " + prod["Prod"] + "</a>";
            }
            //dbProductList.Controls.Add(new LiteralControl(list));
            Response.Write(list);
            Response.End();
        }

        protected void addProduct()
        {
            string prodId = Request["prod"];
            int school = Convert.ToInt32(Request["school"]);
            string el = Request["el"];
            int grade = Convert.ToInt32(Request["grade"]);
            int amount = Convert.ToInt32(Request["amount"]);
            string ci = Request["ciclo"];
            string list = String.Empty;

            DataTable product = this.dbSetProduct(prodId, school, el, grade, amount, ci);
            if (product.Rows.Count > 0)
            {
                DataRow prod = product.Rows[0];
                list = "<div class=\"input-group\" data-school=\"" + prod["SchoolId"] + "\" data-el=\"" + prod["EducationLevel"] + "\" data-grade=\"" + prod["Grade"] + "\">";
                list += "<span class=\"input-group-addon\">" + prod["ProductId"] + "</span>";
                list += "<p class=\"form-control\">" + prod["Product"] + "</p>";
                list += "<span class=\"input-group-addon\">" + prod["Amount"] + " " + prod["UnidadMedida"] + "</span>";
                list += "<span class=\"input-group-btn\"><button class=\"btn btn-danger\" type=\"button\" data-id=\""+prod["RowId"]+"\"><i class=\"fa fa-trash\"></i></button></span></div>";
            }
            else
            {
                list = "0";
            }

            Response.Write(list);
            Response.End();
        }

        protected void addStudentsNumber()
        {
            int sc = Convert.ToInt32(Request["sc"]);
            string lvl = Request["lvl"];
            int gr = Convert.ToInt32(Request["gr"]);
            int no = Convert.ToInt32(Request["no"]);
            string ci = Request["ci"];
            string fo = Request["fo"];//folio

            if (dbSetStudentsNumber(sc, lvl, gr, no, ci, fo))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        protected void getStudentsNumber()
        {
            int sc = Convert.ToInt32(Request["sc"]);
            string lvl = Request["lvl"];
            int gr = Convert.ToInt32(Request["gr"]);
            string ci = Request["ci"];

            string res = this.dbGetStudentsNumber(sc, lvl, gr, ci);
            Response.Write(res);
            Response.End();
        }

        protected void removeProduct()
        {
            if (this.dbRemoveProduct(Convert.ToInt32(Request["id"])))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        protected void showSchoolProducts()
        {
            string schoolId = Request["id"];
            int id = Convert.ToInt32(schoolId);
            string el = Request["el"];
            int grade = Convert.ToInt32(Request["grade"]);
            string c = Request["ciclo"];

            DataTable prods = this.dbGetSchoolProducts(id, el, grade, c);
            string list = String.Empty;

            foreach (DataRow prod in prods.Rows)
            {
                list += "<div class=\"input-group\" data-school=\"" + prod["SchoolId"] + "\" data-el=\"" + prod["EducationLevel"] + "\" data-grade=\"" + prod["Grade"] + "\">";
                list += "<span class=\"input-group-addon\">" + prod["ProductId"] + "</span>";
                list += "<p class=\"form-control\">" + prod["Product"] + "</p>";
                list += "<span class=\"input-group-addon\">" + prod["Amount"] + " " + prod["UnidadMedida"] + "</span>";
                list += "<span class=\"input-group-btn\"><button class=\"btn btn-danger\" type=\"button\" data-id=\"" + prod["RowId"] + "\"><i class=\"fa fa-trash\"></i></button></span></div>";
            }

            Response.Write(list);
            Response.End();
        }

        protected void getEditSchoolLevels()
        {
            DataTable lvls = this.dbGetSchoolLevels(Convert.ToInt32(Request["id"]));
            string res = core.dataTableToJson(lvls);
            Response.Write(res);
            Response.End();
        }

        protected void setEditSchoolLevels()
        {
            int id = Convert.ToInt32(Request["id"]);
            string mat = Request["mat"];
            string jar = Request["jar"];
            string pri = Request["pri"];
            string sec = Request["sec"];
            string pre = Request["pre"];

            if (this.dbSetEditSchoolLevels(id, mat, jar, pri, sec, pre))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        #region Base de Datos
        protected DataTable dbGetEstrato()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_Estratos");
        }
        protected DataTable dbGetStates()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_States");
        }
        protected DataTable dbGetLocalities()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_Localities");
        }
        protected bool dbCreateSchools(string name, string addr, int state, int local, string col, int zipCode, string mail, long phone, int promo, int center, int teachers, string cargo, string cargNom, string cargApp, string cargApm, long cargTel, string cargMail,int estrato, string nivel)
        {
            bool res = false;

            DataTable school = core.executeProcedureTab("NIW_MK_SetSchool '" + name + "','" + addr + "','" + state + "','" + local + "','" + col + "','" + zipCode + "','" + mail + "','" + phone + "','" + promo + "','" + center + "','" + teachers + "','" + cargo + "','" + cargNom + "','" + cargApp + "','" + cargApm + "','" + cargTel + "','" + cargMail + "','" + estrato + "'");
            if (school.Rows.Count > 0)
            {
                if (nivel != null)
                {
                    string[] n = nivel.Split(',');
                    int id = Convert.ToInt32(school.Rows[0]["SchoolId"].ToString());
                    foreach (string ni in n)
                    {
                        string[] s = ni.Split('|');
                        string desc = String.Empty;
                        if (s[0] == "CSM") desc = "Maternal";
                        if (s[0] == "CSJ") desc = "Jardin";
                        if (s[0] == "CSPrim") desc = "Primaria";
                        if (s[0] == "CSS") desc = "Secundaria";
                        if (s[0] == "CSPrep") desc = "Preparatoria";
                        if (core.executeProcedure("NIW_MK_SetEducationLevel '" + id + "','" + desc + "','" + s[1] + "'"))
                            res = true;
                    }
                }
                else
                    res = true;
            }
            return res;
        }
        protected DataTable dbGetSchools()
        {
            return core.executeProcedureTab("NIW_MK_GetSchoolsData");
        }
        protected DataTable dbGetSchoolLevels(int id)
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_SchoolsEducationLevels WHERE SchoolId = '" + id + "'");
        }
        protected bool dbDelSchool(int id)
        {
            return core.executeSql("DELETE FROM NIW_MK_SchoolsGeneral WHERE SchoolId = '" + id + "'");
        }
        protected DataTable dbGetSearchProducts(int c, string search)
        {
            return core.executeProcedureTab("NIW_MK_GetProductSearch " + c + ",'" + search + "'");
        }
        protected DataTable dbSetProduct(string prod, int sch, string el, int gr, int am, string ci)
        {
            return core.executeProcedureTab("NIW_MK_SetSchoolProduct '" + prod + "'," + sch + ",'" + el + "'," + gr + "," + am + ",'" + ci + "'");
        }
        protected bool dbRemoveProduct(int id)
        {
            return core.executeProcedure("NIW_MK_RemoveSchoolProduct " + id);
        }
        protected DataTable dbGetSchoolProducts(int id, string el, int gr, string c)
        {
            return core.executeProcedureTab("NIW_MK_GetSchoolProducs " + id + ",'" + el + "'," + gr + ",'" + c + "'");
        }
        protected DataTable dbGetSchoolCicles(int id)
        {
            return core.executeSqlTab("SELECT DISTINCT(Ciclo) FROM NIW_MK_SchoolProducts WHERE SchoolId = " + id);
        }
        protected DataTable dbGetPromoters()
        {
            return core.executeProcedureTab("NIW_MK_GetPromotersPlaces 1");
        }
        protected bool dbSetStudentsNumber(int school, string level, int grade, int num, string cicle, string folio)
        {
            return core.executeProcedure("NIW_MK_SetStudentsNumber " + school + ",'" + level + "'," + grade + "," + num + ",'" + cicle + "','" + folio + "'");
        }
        protected string dbGetStudentsNumber(int sc, string lvl, int gr, string ci)
        {
            DataTable rows = core.executeSqlTab("SELECT * FROM NIW_MK_SchoolCicleStudents WHERE SchoolId = " + sc + " AND EducationLevel = '" + lvl + "' AND Grade = " + gr + " AND Cicle = '" + ci + "'");
            string res = "{}";
            if (rows.Rows.Count > 0)
                res = "{\"n\":" + rows.Rows[0]["Students"].ToString() + ",\"f\":\"" + rows.Rows[0]["ListCode"].ToString() + "\"}";

            return res;
        }
        protected bool dbSetEditSchoolLevels(int id, string mat, string jar, string pri, string sec, string pre)
        {
            return core.executeProcedure("NIW_MK_UpdateEducationLevels " + id + ",'" + mat + "','" + jar + "','" + pri + "','" + sec + "','" + pre + "'");
        }
        #endregion
    }
}