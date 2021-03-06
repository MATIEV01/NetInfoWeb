﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.Marketing.Escuelas
{
    
    public partial class Escuelas : System.Web.UI.Page
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
                //this.getPromoters(false);
                //this.getObjetives(false);
                //this.getPlaces();
                //this.getInCharge();
                //this.getPromoters();
                //this.getDatObjetives();
                //this.getObjetivesListDate();
                //this.getZones();
                this.getEstados();
                //this.getCodigoZona();
            }
        }

        protected void actionsSwitch()
        {
            switch (Request["action"])
            {
                case "GetDelegacionPnl":
                    this.getDelegacion();
                    break;
                case "GetEscuelas":
                    this.getEscuelas();
                    break; 
                case "GetZona":
                    this.getGetZona(); 
                    break;
                case "GetCliclos":
                    this.getCiclos();
                    break;
                case "GetStudentsNumber":
                    this.getStudentsNumber();
                    break;
                case "ShowSchoolProducts":
                    this.showSchoolProducts();
                    break;
                case "GetSearch":
                    this.getSearchProducts();
                    break;
                case "AddStudentsNumber":
                    this.addStudentsNumber();
                    break;
                case "AddProduct":
                    this.addProduct();
                    break;
                case "RemoveProduct":
                    this.removeProduct();
                    break;
                case "saveSchool":
                    this.guardarEscuela();
                    break;

                    //case "GetPromoters":
                    //    this.getPromoters(true);
                    //    break;
                    //case "GetPromoter":
                    //    this.getPromoterData();
                    //    break;
                    //case "DelPromoter":
                    //    this.delPromoter();
                    //    break;
                    //case "AddPlz":
                    //    this.addPlz();
                    //    break;
                    //case "AddObjetive":
                    //    this.addObjetive();
                    //    break;
                    //case "GetObjetives":
                    //    this.getObjetives(true);
                    //    break;
                    //case "DelObjetive":
                    //    this.delPromoterObjetive();
                    //    break;
                    //case "DelPlace":
                    //    this.delPlace();
                    //    break;
                    //case "GetPlaceObjetives":
                    //    this.getPlaceObjetives();
                    //    break;
                    //case "UpdatePlace":
                    //    this.updatePlace();
                    //    break;
            }
        }

        protected void getEstados()
        {
     

            DataTable estados = this.dbGetEstados();
            string str1 = "<option value=\"\"></option>";
            foreach (DataRow row in (InternalDataCollectionBase)estados.Rows)
                str1 = str1 + "<option value=\"" + row["Estado"] + "\">" + row["Descripcion"] + "</option>";
            string str2 = str1 + "</select>";
            //string str3 = "<select class=\"form-control\" id=\"plzEstado\">";
            string str4 = "<span class=\"input-group-addon\">Estado:</span> <select class=\"form-control\" id=\"estadoPnl\">" + str2;
            str4 += "<span class=\"input-group-addon\">Delegacion:</span> <select class=\"form-control \" id=\"delegacionPnl\"> </select> ";
            //str4 += "<span class=\"input-group-btn\"><button type = \"button\" class=\"btn btn-info\" data-toggle=\"modal\" data-target=\"#plazasModal\" data-backdrop=\"false\">Agregar Escuela</button>  </span>";

          //  this.PlzEstado.Controls.Add((Control)new LiteralControl(str3 + str2));
              this.PnlEstado.Controls.Add((Control)new LiteralControl(str4));
        }

        protected void getDelegacion()
        {
            int id = Convert.ToInt32(string.IsNullOrEmpty(Request["idEst"]) ? "0" : Request["idEst"]);
            DataTable estados = this.dbGetDelegacion(id);

            string str1 = "<option value=\"\"></option>";
            foreach (DataRow row in (InternalDataCollectionBase)estados.Rows)
                str1 = str1 + "<option value=\"" + row["Clave"] + "\">" + row["Delegacion"] + "</option>";

            Response.Write(str1);
            Response.End();
        }

        protected void getGetZona()
        {
            int id = Convert.ToInt32(string.IsNullOrEmpty(Request["idEst"]) ? "0" : Request["idEst"]);
            DataTable estados = this.dbGetZona(id);

            string str1 = "<option value=\"\"></option>";
            foreach (DataRow row in (InternalDataCollectionBase)estados.Rows)
                str1 = str1 + "<option value=\"" + row["Val"] + "\">" + row["Zona"] + "</option>";

            Response.Write(str1);
            Response.End();
        }


        protected void getEscuelas()
        {
            //DataTable plzs = this.dbGetPromoterPlace();
            //string list = String.Empty;

            //foreach (DataRow plz in plzs.Rows)
            //{
            //    list += "<a href=\"#\" class=\"list-group-item\" data-id=\"" + plz["PlaceId"] + "\" data-zone=\"" + plz["PlaceZone"] + "\" data-incharge=\"" + plz["PlaceInCharge"] + "\" data-type=\"" + plz["PlaceType"] + "\" data-ptype=\"" + plz["PromoterType"] + "\" data-promoter=\"" + plz["PromoterId"] + "\">";
            //    list += "<h4 class=\"list-group-item-heading\"><strong>P" + plz["PlaceId"] + ":</strong> " + plz["PromoterName"] + "</h4>";
            //    string prmType = "Pelikan";
            //    string pt = plz["PromoterType"].ToString();
            //    if (pt == "2")
            //        prmType = "Externo";
            //    list += "<p class=\"list-group-item-text\"><strong>Empleado:</strong> " + prmType + "</p>";
            //    list += "<p class=\"list-group-item-text\"><strong>Zona:</strong> " + plz["PromoterZone"] + "</p>";
            //    list += "<p class=\"list-group-item-text\"><strong>Encargado:</strong> " + plz["InChargeName"] + "</p>";
            //    list += "</a>";
            //}

            //PlzList.Controls.Add(new LiteralControl(list));
            int idEst = Convert.ToInt32(string.IsNullOrEmpty(Request["idEst"]) ? "0" : Request["idEst"]);
            int idDel = Convert.ToInt32(string.IsNullOrEmpty(Request["idDel"]) ? "0" : Request["idDel"]);

            DataTable promoterPlace = this.dbGetEscuelas(idEst,idDel);
            string text = string.Empty;
            int num = 1;
            foreach (DataRow row in (InternalDataCollectionBase)promoterPlace.Rows)
            {
                text = num != 1 ? text + "<a href=\"#\" class=\"list-group-item \" " : text + "<a href=\"#\" class=\"list-group-item \" ";
                text = text + " data-id=\"" + row["SEP"] + "\" data-zona=\"" + row["Zona"] + "\" data-nivel=\"" + row["Nivel"] + "\" data-periodo=\"" + row["Periodo"] + "\" data-nombre=\"" + row["Nombre"] + "\" data-tipoedu=\"" + row["TipoEducativo"] + "\"  data-turno=\"" + row["Turno"] + "\" ";
                text = text + " data-control=\"" + row["Control"] + "\" data-ambito=\"" + row["Ambito"] + "\"  data-tdocentes=\"" + row["TotalDocentes"] + "\" data-talumnos=\"" + row["TotalAlumnos"] + "\" data-clasificacion=\"" + row["Clasificacion"] + "\"";// data-zonacodigo=\"" + row["CodigoZonaId"] + "\">";
                text += " data-calle=\"" + row["Calle"] + "\" data-entrecalles=\"" + row["EntreCalles"] + "\"   data-num=\"" + row["Num"] + "\" data-cp=\"" + row["CP"] + "\" data-claved=\"" + row["ClaveD"] + "\"  data-colonia=\"" + row["Colonia"] + "\" ";
                text += "data-contacto1=\"" + row["Contacto1"] + "\" data-cargo1=\"" + row["Cargo1"] + "\" data-email1=\"" + row["Email1"] + "\"  data-contacto2=\"" + row["Contacto2"] + "\" data-cargo2=\"" + row["Cargo2"] + "\" data-email2=\"" + row["Email2"] + "\" ";
                text += " data-telefono=\"" + row["Telefono"] + "\" data-lada=\"" + row["Lada"] + "\" data-extesion=\"" + row["Extesion"] + "\" data-website=\"" + row["WebSite"] + "\"";
                text += " data-ckit=\"" + row["ClasificacionKit"] + "\" data-ekit=\"" + row["EntregaKit"] + "\" data-folio=\"" + row["Folio"] + "\" data-pep=\"" + row["IncorporadoPEP"] + "\" >";
                text = text + "<h4  class=\"list-group-item-heading\"><strong>CENTRO EDUCATIVO:</strong> " + row["Nombre"] + "</h4>";
                //string str = "Pelikan";
                //if (row["PromoterType"].ToString() == "2")
                ////    str = "Externo";
                //text = text + "<p class=\"list-group-item-text\"><strong>CCT:</strong> " + str.ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>CCT:</strong> " + row["SEP"].ToString().ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Zona:</strong> " + row["Zona"].ToString().ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Nivel Educativo:</strong> " + row["Nivel"].ToString().ToUpper() + "</p>";
                text += " </a>  ";
                ++num;
            }
            // this.PlzList.Controls.Add((Control)new LiteralControl(text));

            Response.Write(text);
            Response.End();
        }

        public void getCiclos()
        {
            string cct = Request["cct"];

            DataTable cicles = this.dbGetSchoolCicles(cct);

            string list = "<div class=\"listCiclos\"><div class=\"movible\"><div class=\"listContent\">";

            foreach (DataRow cicle in cicles.Rows)
                list += "<div class=\"form-field\"><a href=\"#\" class=\"btn btn-default form-control\"  data-backdrop=\"false\">" + cicle["Ciclo"] + "</a></div>";
            list += "</div><div class=\"row form-field\">";
            list += "<a href=\"#\" class=\"addCicloBtn\">Agregar Lista...</a>";
            list += "</div></div></div>";
            Response.Write(list);
            Response.End();
        }

        protected void getStudentsNumber()
        {
            string cct = Request["sc"];
            string lvl = Request["lvl"];
            int gr = Convert.ToInt32(Request["gr"]);
            string ci = Request["ci"];

            string res = this.dbGetStudentsNumber(cct, lvl, gr, ci);
            Response.Write(res);
            Response.End();
        }

        protected void showSchoolProducts()
        {
            string schoolId = Request["id"];
           // int id = Convert.ToInt32(schoolId);
            string el = Request["el"];
            int grade = Convert.ToInt32(Request["grade"]);
            string c = Request["ciclo"];

            DataTable prods = this.dbGetSchoolProducts(schoolId, el, grade, c);
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
            string school = Request["school"];
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
                list += "<span class=\"input-group-btn\"><button class=\"btn btn-danger\" type=\"button\" data-id=\"" + prod["RowId"] + "\"><i class=\"fa fa-trash\"></i></button></span></div>";
            }
            else
            {
                list = "0";
            }

            Response.Write(list);
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

        protected void addStudentsNumber()
        {
            string sc = Request["sc"];
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

        protected void guardarEscuela()
        {
            object[] oParams = new object[34];

            oParams[0] = Request["zona"];
            oParams[1] = Request["cct"].ToUpper();
            oParams[2] = Request["nombre"].ToUpper();
            oParams[3] = Request["nivel"];
            oParams[4] = Request["teducativo"];
            oParams[5] = Request["periodo"];
            oParams[6] = Request["turno"];
            oParams[7] = Request["control"];
            oParams[8] = Request["ambito"];
            oParams[9] = string.IsNullOrEmpty(Request["tdocentes"]) ? "0": Request["tdocentes"];
            oParams[10] = string.IsNullOrEmpty(Request["tdocentes"]) ? "0" : Request["talumnos"]; 
          //  oParams[11] = Request["clasificacion"];
            oParams[11] = Request["estado"];
            oParams[12] = Request["delegacion"];
            oParams[13] = Request["calle"].ToUpper();
            oParams[14] = Request["entrecalles"].ToUpper();
            oParams[15] = Request["numext"];
            oParams[16] = Request["cp"];
            oParams[17] = Request["colonia"].ToUpper();
            oParams[18] = Request["contacto1"].ToUpper();
            oParams[19] = Request["cargo1"].ToUpper();
            oParams[20] = Request["email1"];
            oParams[21] = Request["contacto2"].ToUpper();
            oParams[22] = Request["cargo2"].ToUpper();
            oParams[23] = Request["email2"];
            oParams[24] = Request["lada"];
            oParams[25] = Request["telefono"];
            oParams[26] = string.IsNullOrEmpty(Request["extension"]) ? "0" : Request["talumnos"];
            oParams[27] = Request["website"];
            oParams[28] = Request["ckit"];
            oParams[29] = string.IsNullOrEmpty(Request["ekit"]) ? "False" : Request["ekit"];
            oParams[30] =  Request["folio"].ToUpper();
            oParams[31] = string.IsNullOrEmpty(Request["pep"]) ? "False" : Request["pep"];
            oParams[32] = Request["nota"];
            oParams[33] = string.IsNullOrEmpty(Request["pep"]) ? "False" : Request["news"];


            DataTable dtSave = dbSaveSchool(oParams);

            string smnj = dtSave.Rows[0]["Error"].ToString() + "-" + dtSave.Rows[0]["Mensaje"].ToString();

            Response.Write(smnj);
            Response.End();
            

        }
        



        protected DataTable dbGetEstados()
        {
            return this.core.executeSqlTab("select  StateId as Estado,upper(State) as Descripcion from   NIW_MK_States  ");
        }


        protected DataTable dbGetDelegacion(int Estado)
        {
            return this.core.executeSqlTab("select  Clave,Delegacion from NIW_MK_SchoolDelegacion where Estado =" + Estado);
        }

        protected DataTable dbGetZona(int Estado)
        {
            return this.core.executeSqlTab(" select  ZonaPromocion as Val , ZonaPromocion +'-' +Delegacion  as Zona from NIW_MK_SchoolDelegacion where Estado =" + Estado);
        }

        protected DataTable dbGetEscuelas(int Estado, int Delegacion)
        {


            //string sql = "select ZonaPromocion as Zona,NombreEscuela as Nombre,ClaveSEP as SEP , NivelEducativo as Nivel,Periodo,TipoEducativo,Turno,Control,Ambito, ";
            //sql += " TotalDocentes,TotalAlumnos, case when TotalAlumnos <= 100 then 'A' 	when TotalAlumnos >100 and TotalAlumnos < =400 then 'AA' when TotalAlumnos > 400 then 'AAA' end as Clasificacion ";
            //sql += " ,Domicilio as Calle , case when EntreCalle1 ='NINGUNO' or EntreCalle1 =''  then '' else EntreCalle1  end +'  '+ case when EntreCalle2 ='NINGUNO' then '' else EntreCalle2 end as EntreCalles,";
            //sql += " NumExt as Num , CP,ClaveDelegacion as ClaveD ,DescripcionLocalidad as Colonia ";
            //sql += " ,'' as Contacto1,'' as Cargo1, Correo as Email1 ,'' as Contacto2,'' as Cargo2, Correo as Email2  ,Telefono,Lada,0 as Extesion , '' as WebSite ";
            //sql += string.Format(" from NIW_MK_Escuelas_Temp where IdEstado = {0} and ClaveDelegacion ={1}",Estado,Delegacion);

            string sql = "select ZonaPromocion as Zona,Nombre,ClaveSEP as SEP , Nivel,Periodo,TipoEducativo,Turno,Control,Ambito, ";
            sql += "  TotalDocentes,TotalAlumnos, case when TotalAlumnos <= 100 then 'A' 	when TotalAlumnos >100 and TotalAlumnos < =400 then 'AA' when TotalAlumnos > 400 then 'AAA' end as Clasificacion  ";
            sql += "  , Calle , EntreCalles, NumExt as Num , CP,IdDelegacion as ClaveD , Colonia ";
            sql += ",Contacto1, Cargo1,  Email1 ,Contacto2, Cargo2,  Email2  ,Telefono,Lada,NumExt as Extesion ,  WebSite ,ClasificacionKit,EntregaKit,Nota,Folio,IncorporadoPEP ";
            sql += string.Format(" from NIW_MK_Escuelas where IdEstado = {0} and IdDelegacion ={1}", Estado, Delegacion);

            return this.core.executeSqlTab(sql);
        }


        //protected DataTable dbGetSchoolCicles(string cct)
        //{
        //    string sql = "SELECT DISTINCT(Ciclo) FROM NIW_MK_ListasProductos Ciclo inner join NIW_MK_Escuelas E on Ciclo.SchoolId = e.IdEscuela ";
        //    sql += string.Format("  WHERE e.ClaveSEP = '{0}'", cct);

        //    return core.executeSqlTab(sql);
        //}

        protected DataTable dbGetSchoolCicles(string id)
        {
            return core.executeSqlTab("SELECT DISTINCT(Ciclo) FROM NIW_MK_ListasProductos WHERE SchoolId = '" + id + "'");
        }

        protected string dbGetStudentsNumber(string cct, string lvl, int gr, string ci)
        {

            string sql = "select *  from NIW_MK_EscuelasCliclos  ";
            sql +=string.Format(" WHERE SchoolId = '{0}' and EducationLevel ='{1}' and Grade={2} and Cicle='{3}'", cct,lvl,gr,ci);

            DataTable rows = core.executeSqlTab(sql);

            string res = "{}";
            if (rows.Rows.Count > 0)
                res = "{\"n\":" + rows.Rows[0]["Students"].ToString() + ",\"f\":\"" + rows.Rows[0]["ListCode"].ToString() + "\"}";

            return res;
        }

        protected DataTable dbGetSchoolProducts(string cct, string el, int gr, string c)
        {
            return core.executeProcedureTab(" NIW_MK_GetListaProductos '" + cct + "','" + el + "'," + gr + ",'" + c + "'");
        }

        protected DataTable dbGetSearchProducts(int c, string search)
        {
            return core.executeProcedureTab("NIW_MK_GetProductSearch " + c + ",'" + search + "'");
        }

        protected DataTable dbSetProduct(string prod, string sch, string el, int gr, int am, string ci)
        {
            return core.executeProcedureTab(" NIW_MK_SetSchoolProduct '" + prod + "','" + sch + "','" + el + "'," + gr + "," + am + ",'" + ci + "'");
        }

        protected bool dbSetStudentsNumber(string school, string level, int grade, int num, string cicle, string folio)
        {
            return core.executeProcedure("NIW_MK_SetStudentsNumber '" + school + "','" + level + "'," + grade + "," + num + ",'" + cicle + "','" + folio + "'");
        }

        protected bool dbRemoveProduct(int id)
        {
            return core.executeProcedure("NIW_MK_RemoveSchoolProduct " + id);
        }

        protected DataTable dbSaveSchool(object [] oParams)
        {
            string sql = string.Format(" NIW_MK_GuardarEscuela '{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}',{9},{10},{11},{12},'{13}','{14}','{15}','{16}','{17}','{18}','{19}','{20}','{21}','{22}','{23}','{24}','{25}',{26},'{27}','{28}','{29}','{30}','{31}','{32}','{33}' ",oParams);

            return core.executeProcedureTab(sql.ToString());
        }

        //protected bool dbSetStudentsNumber(int school, string level, int grade, int num, string cicle, string folio)
        //{
        //    return core.executeProcedure("NIW_MK_SetStudentsNumber " + school + ",'" + level + "'," + grade + "," + num + ",'" + cicle + "','" + folio + "'");
        //}
    }
}
