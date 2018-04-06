using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using NI5sWeb.NIWeb;


namespace NI5sWeb.Modules.Marketing.Promotores
{
    public partial class CatalogoPromotores : System.Web.UI.Page
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
                this.getPromoters(false);
                this.getObjetives(false);
                this.getPlaces();
                this.getInCharge();
                this.getPromoters();
                this.getDatObjetives();
                this.getObjetivesListDate();
                this.getZones();
                this.getEstados();
                this.getCodigoZona();
            }
        }

        protected void actionsSwitch()
        {
            switch (Request["action"])
            {
                case "SavePromoter":
                    this.savePromoter();
                    break;
                case "GetPromoters":
                    this.getPromoters(true);
                    break;
                case "GetPromoter":
                    this.getPromoterData();
                    break;
                case "DelPromoter":
                    this.delPromoter();
                    break;
                case "AddPlz":
                    this.addPlz();
                    break;
                case "AddObjetive":
                    this.addObjetive();
                    break;
                case "GetObjetives":
                    this.getObjetives(true);
                    break;
                case "DelObjetive":
                    this.delPromoterObjetive();
                    break;
                case "DelPlace":
                    this.delPlace();
                    break;
                case "GetPlaceObjetives":
                    this.getPlaceObjetives();
                    break;
                case "UpdatePlace":
                    this.updatePlace();
                    break;
            }
        }

        protected void savePromoter()
        {
            int actionType = Convert.ToInt32(Request["aType"]);
            string prmCode = Request["prmCode"];
            string prmName = Request["prmName"];
            string prmAgency = Request["prmAgency"];
            int prmId = Convert.ToInt32(Request["prmId"]);

            if (this.dbSavePromoterData(actionType, prmCode, prmName, prmAgency, prmId))
                Response.Write('1');
            else
                Response.Write('0');
            Response.End();
        }

        protected void getPromoters(bool type)
        {
            DataTable promoters = this.dbGetPromotersData();
            string list = String.Empty;

            foreach (DataRow promoter in promoters.Rows)
            {
                list += "<div class=\"input-group\" data-id=\"" + promoter["PromoterId"] + "\">";
                list += "<span class=\"input-group-addon\">" + promoter["PromoterCode"] + "</span>";
                list += "<p class=\"form-control\">" + promoter["PromoterName"] + "</p>";
                list += "<span class=\"input-group-btn\"><button class=\"btn btn-info prmEdit\" type=\"button\"><i class=\"fa fa-edit\"></i></button></span>";
                list += "<span class=\"input-group-btn\"><button class=\"btn btn-danger prmDelete\" type=\"button\"><i class=\"fa fa-trash\"></i></button></span>";
                list += "</div>";
            }

            if (type)
            {
                Response.Write(list);
                Response.End();
            }
            else
            {
                PrmList.Controls.Add(new LiteralControl(list));
            }
        }

        protected void getPromoterData()
        {
            DataTable Dats = this.dbGetPromoterData(Convert.ToInt32(Request["id"]));
            string res = core.dataTableToJson(Dats);
            Response.Write(res);
            Response.End();
        }

        protected void delPromoter()
        {
            if (dbDeletePromoter(Convert.ToInt32(Request["id"])))
                Response.Write('1');
            else
                Response.Write('0');
            Response.End();
        }

        protected void addPlz()
        {
            //int type = Convert.ToInt32(Request["type"]);
            //string zone = Request["zone"];
            //int enca = Convert.ToInt32(Request["enca"]);
            //int prom = Convert.ToInt32(Request["prom"]);
            //int tipo = Convert.ToInt32(Request["tipo"]);

            object[] oParams = new object[12];


            oParams[0]=Convert.ToInt32(this.Request["type"]);
            oParams[1]=this.Request["zone"];
            oParams[2]=Convert.ToInt32(this.Request["enca"]);
            oParams[3]=Convert.ToInt32(this.Request["prom"]);
            oParams[4]=Convert.ToInt32(this.Request["tipo"]);
            oParams[5]=Convert.ToInt32(this.Request["jefe"]);
            oParams[6]=this.Request["estado"].ToString();
            oParams[7]=this.Request["agencia"].ToString();
            oParams[8]=this.Request["mail"].ToString();
            oParams[9]=this.Request["tel"].ToString();
            oParams[10]=this.Request["muni"].ToString();
            oParams[11] = int.Parse(this.Request["cdgZona"]);



            if (this.dbSetPromoterPlace(oParams))
            {
                DataTable promoterPlace = this.dbGetPromoterPlace();
                string s = string.Empty;
                foreach (DataRow row in (InternalDataCollectionBase)promoterPlace.Rows)
                {
                    s = s + "<a href=\"#\" class=\"list-group-item\" data-id=\"" + row["PlaceId"] + "\" data-zone=\"" + row["PlaceZone"] + "\" data-incharge=\"" + row["PlaceInCharge"] + "\" data-type=\"" + row["PlaceType"] + "\" data-ptype=\"" + row["PromoterType"] + "\" data-promoter=\"" + row["PromoterId"] + "\"";
                    s = s + " data-jefe=\"" + row["PromotorJefeId"] + "\" data-estado=\"" + row["Estado"] + "\" data-agencia=\"" + row["Agencia"] + "\" data-telefono=\"" + row["Telefono"] + "\" data-correo=\"" + row["Correo"] + "\"  data-municipio=\"" + row["Municipio"] + "\"  data-zonacodigo=\"" + row["CodigoZonaId"] + "\" >";
                    s = s + "<h4 class=\"list-group-item-heading\"><strong>P" + row["PlaceId"] + ":</strong> " + row["PromoterName"] + "</h4>";
                    string str = "Pelikan";
                    if (row["PromoterType"].ToString() == "2")
                        str = "Externo";
                    s = s + "<p class=\"list-group-item-text\"><strong>Empleado:</strong> " + str.ToUpper() + "</p>";
                    s = s + "<p class=\"list-group-item-text\"><strong>Zona:</strong> " + row["PromoterZone"].ToString().ToUpper() + "</p>";
                    s = s + "<p class=\"list-group-item-text\"><strong>Encargado:</strong> " + row["InChargeName"].ToString().ToUpper() + "</p>";
                    s = s + "<p class=\"list-group-item-text\"><strong>Estado:</strong> " + row["DscEstado"].ToString().ToUpper() + "</p>";
                    s += "</a>";
                }
                this.Response.Write(s);
            }
            
            Response.End();
        }

        protected void getPlaces()
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
            DataTable promoterPlace = this.dbGetPromoterPlace();
            string text = string.Empty;
            int num = 1;
            foreach (DataRow row in (InternalDataCollectionBase)promoterPlace.Rows)
            {
                text = num != 1 ? text + "<a href=\"#\" class=\"list-group-item \" " : text + "<a href=\"#\" class=\"list-group-item \" ";
                text = text + " data-id=\"" + row["PlaceId"] + "\" data-zone=\"" + row["PlaceZone"] + "\" data-incharge=\"" + row["PlaceInCharge"] + "\" data-type=\"" + row["PlaceType"] + "\" data-ptype=\"" + row["PromoterType"] + "\" data-promoter=\"" + row["PromoterId"] + "\"  data-jefe=\"" + row["PromotorJefeId"] + "\" ";
                text = text + " data-estado=\"" + row["Estado"] + "\" data-agencia=\"" + row["Agencia"] + "\" data-telefono=\"" + row["Telefono"] + "\" data-correo=\"" + row["Correo"] + "\" data-municipio=\"" + row["Municipio"] + "\" data-zonacodigo=\"" + row["CodigoZonaId"] + "\">";
                text = text + "<h4  class=\"list-group-item-heading\"><strong>P" + row["PlaceId"] + ":</strong> " + row["PromoterName"] + "</h4>";
                string str = "Pelikan";
                if (row["PromoterType"].ToString() == "2")
                    str = "Externo";
                text = text + "<p class=\"list-group-item-text\"><strong>Empleado:</strong> " + str.ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Zona:</strong> " + row["PromoterZone"].ToString().ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Encargado:</strong> " + row["PromotorJefe"].ToString().ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Estado:</strong> " + row["DscEstado"].ToString().ToUpper() + "</p>";
                text += " </a>  ";
                ++num;
            }
            this.PlzList.Controls.Add((Control)new LiteralControl(text));
        }

        protected void addObjetive()
        {
            if (this.dbAddPromoterObjetive(Request["obj"], Request["des"]))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

       
        protected void getObjetives(bool type)
        {
            DataTable objs = this.dbGetPromoterObjetive();
            string list = String.Empty;

            foreach (DataRow obj in objs.Rows)
            {
                list += "<div class=\"input-group\" data-id=\"" + obj["ObjetiveId"] + "\">";
                list += "<p class=\"form-control\">" + obj["ObjetiveName"] + "</p>";
                list += "<span class=\"input-group-btn\"><button class=\"btn btn-danger objDel\" type=\"button\"><i class=\"fa fa-trash\"></i></button></span>";
                list += "</div>";
            }

            if (type)
            {
                Response.Write(list);
                Response.End();
            }
            else
            {
                OjetiveList.Controls.Add(new LiteralControl(list));
            }
        }

        protected void getDatObjetives()
        {
            DataTable objs = this.dbGetPromoterObjetive();
            string list = "<select class=\"form-control\">";
            list += "<option value=\"\">Nombre del Objetivo</option>";

            foreach (DataRow obj in objs.Rows)
                list += "<option value=\"" + obj["ObjetiveId"] + "\">" + obj["ObjetiveName"] + "</option>";

            list += "</select>";

            DatObjetives.Controls.Add(new LiteralControl(list));
        }

        protected void delPromoterObjetive()
        {
            if (this.dbDelPromoterObjetive(Convert.ToInt32(Request["id"])))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        //protected void getInCharge()
        //{
        //    DataTable rows = this.dbGetInCharge();

        //    string select = "<option value=\"\">Vendedor</option>";
        //    foreach(DataRow row in rows.Rows){
        //        select += "<option value=\""+row["NTRAB"]+"\">"+row["NNOM"]+"</option>";
        //    }
        //    select += "</select>";

        //    string select1 = "<select class=\"form-control\" id=\"plzEncargado\">";
        //    string select2 = "<select class=\"form-control\" id=\"encargadoData\">";

        //    PlzEncargado.Controls.Add(new LiteralControl(select1 + select));
        //    DatEncargado.Controls.Add(new LiteralControl(select2 + select));
        //}

        //protected void getPromoters()
        //{
        //    DataTable pelikans = this.dbGetPelikanPromoters();
        //    DataTable outs = this.dbGetPromotersData();

        //    string pselect = "<option value=\"\">Promotor</option>";
        //    foreach (DataRow pel in pelikans.Rows)
        //        pselect += "<option value=\"" + pel["NTRAB"] + "\">" + pel["NNOM"] + "</option>";
        //    pselect += "</select>";

        //    string oselect = "<option value=\"\">Promotor</option>";
        //    foreach (DataRow o in outs.Rows)
        //        oselect += "<option value=\"" + o["PromoterId"] + "\">" + o["PromoterName"] + "</option>";
        //    oselect += "</select>";

        //    string plzOutPromotor = "<select class=\"form-control plzPromotor\" id=\"plzOutPromotor\">";
        //    string plzPelPromotor = "<select class=\"form-control plzPromotor\" id=\"plzPelPromotor\">";

        //    PlzPromotor.Controls.Add(new LiteralControl(plzPelPromotor + pselect + plzOutPromotor + oselect));

        //    string plzOutData = "<select class=\"form-control\" id=\"plzOutData\">";
        //    string plzPelData = "<select class=\"form-control\" id=\"plzPelData\">";

        //    PromotorData.Controls.Add(new LiteralControl(plzPelData + pselect + plzOutData + oselect));
        //}
        protected void getInCharge()
        {
            DataTable inCharge = this.dbGetInCharge();
            string str1 = "<option value=\"\">Vendedor</option>";
            foreach (DataRow row in (InternalDataCollectionBase)inCharge.Rows)
                str1 = str1 + "<option value=\"" + row["Agente"] + "\">" + row["NombreVendedor"] + "</option>";
            string str2 = str1 + "</select>";
            string str3 = "<select class=\"form-control\" id=\"plzEncargado\">";
            string str4 = "<select class=\"form-control\" id=\"encargadoData\">";
            this.PlzEncargado.Controls.Add((Control)new LiteralControl(str3 + str2));
            this.DatEncargado.Controls.Add((Control)new LiteralControl(str4 + str2));
        }

        protected void getEstados()
        {
            DataTable estados = this.dbGetEstados();
            string str1 = "<option value=\"\">Estado</option>";
            foreach (DataRow row in (InternalDataCollectionBase)estados.Rows)
                str1 = str1 + "<option value=\"" + row["Estado"] + "\">" + row["Descripcion"] + "</option>";
            string str2 = str1 + "</select>";
            string str3 = "<select class=\"form-control\" id=\"plzEstado\">";
            string str4 = "<select class=\"form-control\" id=\"estadoData\">";
            this.PlzEstado.Controls.Add((Control)new LiteralControl(str3 + str2));
            this.DatEstado.Controls.Add((Control)new LiteralControl(str4 + str2));
        }

        protected void getCodigoZona()
        {
            DataTable cdgZona = this.dbGetCdgZona();
            string str1 = "<option value=\"\">Codigo Zona</option>";
            foreach (DataRow row in (InternalDataCollectionBase)cdgZona.Rows)
                str1 = str1 + "<option value=\"" + row["IdZona"] + "\">" + row["Descripcion"] + "</option>";
            string str2 = str1 + "</select>";
            string str3 = "<select class=\"form-control\" id=\"plzCdgZona\">";
            string str4 = "<select class=\"form-control\" id=\"cdgZonaData\">";
            this.PlzZonaCodigo.Controls.Add((Control)new LiteralControl(str3 + str2));
            this.DatCdgZona.Controls.Add((Control)new LiteralControl(str4 + str2));
        }

        protected void getPromoters()
        {
            DataTable pelikanPromoters = this.dbGetPelikanPromoters();
            DataTable promotersData = this.dbGetPromotersData();
            string str1 = "<option value=\"\">Promotor</option>";
            foreach (DataRow row in (InternalDataCollectionBase)pelikanPromoters.Rows)
                str1 = str1 + "<option value=\"" + row["NTRAB"] + "\">" + row["NTRAB"] + " | " + row["NNOM"] + "</option>";
            string str2 = str1 + "</select>";
            string str3 = "<option value=\"\">Promotor</option>";
            foreach (DataRow row in (InternalDataCollectionBase)promotersData.Rows)
                str3 = str3 + "<option value=\"" + row["PromoterId"] + "\">" + row["PromoterCode"] + " | " + row["PromoterName"] + "</option>";
            string str4 = str3 + "</select>";
            string str5 = "<select class=\"form-control plzPromotor\" id=\"plzOutPromotor\">";
            this.PlzPromotor.Controls.Add((Control)new LiteralControl("<select class=\"form-control plzPromotor\" id=\"plzPelPromotor\">" + str2 + str5 + str4));
            string str6 = "<select class=\"form-control\" id=\"plzOutData\">";
            this.PromotorData.Controls.Add((Control)new LiteralControl("<select class=\"form-control\" id=\"plzPelData\">" + str2 + str6 + str4));
        }

        protected void getZones()
        {
            DataTable zones = this.dbGetZones();
            
            string sel1 = "<select id=\"plzZona\" class=\"form-control\">";
            string sel2 = "<select id=\"datZone\" class=\"form-control\">";
            string sel = "<option value=\"\">Zona</option>";
            foreach (DataRow zone in zones.Rows)
                sel += "<option value=\"" + zone["PromoterZoneId"] + "\">" + zone["PromoterZone"] + "</option>";
            sel += "</select>";


            PlzZone.Controls.Add(new LiteralControl(sel1 + sel));
            DatZone.Controls.Add(new LiteralControl(sel2 + sel));
        }

        protected void delPlace()
        {
            int id = Convert.ToInt32(Request["id"]);
            if (this.dbDelPlace(id))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        protected void getObjetivesListDate()
        {
            string list = "<div class=\"input-group\"><span class=\"input-group-addon\">Año:</span>";
            
            int ymin = 2015;
            DateTime now = DateTime.Now;
            int ynow = Convert.ToInt32(now.ToString("yyy"));

            string ylist = "<select class=\"form-control year\" data-now=\"" + ynow + "\">";
            for (int y = ynow; y >= ymin; y--)
            {
                ylist += "<option value=\"" + y + "\">" + y + "</option>";
            }
            ylist += "</select>";

            list += ylist + "<span class=\"input-group-addon\">Mes:</span>";

            string mlist = "<select class=\"form-control month\" data-now=\"" + Convert.ToInt32(now.ToString("MM")) + "\">";
            mlist += "<option value=\"1\">Enero</option><option value=\"2\">Febrero</option>";
            mlist += "<option value=\"3\">Marzo</option><option value=\"4\">Abril</option>";
            mlist += "<option value=\"5\">Mayo</option><option value=\"6\">Junio</option>";
            mlist += "<option value=\"7\">Julio</option><option value=\"8\">Agosto</option>";
            mlist += "<option value=\"9\">Septiembre</option><option value=\"10\">Octubre</option>";
            mlist += "<option value=\"11\">Noviembre</option><option value=\"12\">Diciembre</option>";
            mlist += "</select>";

            list += mlist + "</div>";
            PlzObjetivs.Controls.Add(new LiteralControl(list));
        }

        protected void getPlaceObjetives()
        {
            DataTable objs = this.dbGetObjetiveData(Convert.ToInt32(Request["id"]),Convert.ToInt32(Request["y"]),Convert.ToInt32(Request["m"]));

            string list = String.Empty;
            {
                foreach (DataRow obj in objs.Rows)
                    list += "<div class=\"input-group\" data-id=\"" + obj["ObjetiveId"] + "\"><p class=\"form-control\">" + obj["ObjetiveName"] + "</p><span class=\"input-group-addon\"><i class=\"fa fa-chevron-right\"></i></span><input type=\"number\" class=\"form-control\" min=\"0\" value=\"" + obj["TargetAmount"] + "\" placeholder=\"Cantidad\" /><div class=\"input-group-btn\"><button class=\"btn btn-danger\" type=\"button\"><i class=\"fa fa-times\"></i></button></div></div>";
            }

            Response.Write(list);
            Response.End();
        }

        protected void updatePlace()
        {
            int r = 1;
            int id = Convert.ToInt32(Request["id"]);

            object[] oParams = new object[13];

            oParams[0]=this.Request["zone"];
            oParams[1]=int.Parse(this.Request["charge"]);
            oParams[2]=int.Parse(this.Request["tipo"]);
            oParams[3]=int.Parse(this.Request["type"]);
            oParams[4]=int.Parse(this.Request["promoter"]);
            oParams[5]=int.Parse(this.Request["jefe"]);
            oParams[6]=this.Request["estado"];
            oParams[7]=this.Request["agencia"];
            oParams[8]=this.Request["correo"];
            oParams[9]=this.Request["tel"];
            oParams[10]=Convert.ToInt32(this.Request["id"]);
            oParams[11]=this.Request["muni"];
            oParams[12] = Convert.ToInt32(this.Request["cdgZona"]);

            //if (this.dbUpdatePlace(id,Request["zone"], Convert.ToInt32(Request["charge"]), Convert.ToInt32(Request["tipo"]), Convert.ToInt32(Request["type"]), Convert.ToInt32(Request["promoter"]),Convert.ToString(Request["emailp"]),Convert.ToString(Request["emailc"]))){
            if (this.dbUpdatePlace(oParams))
            {
                string objstring = Request["objs"];
                if (objstring != "")
                {
                    string[] objs = objstring.Split(',');
                    for (int i = 0; i < objs.Length; i++)
                    {
                        string[] obj = objs[i].Split(':');
                        if (!this.dbUpdateObjetivesPlace(id, Convert.ToInt32(obj[0]), Convert.ToInt32(obj[1]), Convert.ToInt32(Request["y"]), Convert.ToInt32(Request["m"]), i))
                            r = 0;
                    }
                }
                else
                {
                    if (!this.dbUpdateObjetivesPlace(id, 0, 0, Convert.ToInt32(Request["y"]), Convert.ToInt32(Request["m"]), -1))
                        r = 0;
                }
            }
            else
            {
                r = 0;
            }
            Response.Write(r);
            Response.End();
        }

        protected void updateEmail()
        {
            int r = 1;
            int id = Convert.ToInt32(Request["id"]);
            if (this.dbUpdateEmail(id, Convert.ToString(Request["emailp"]), Convert.ToString(Request["emailc"]), Convert.ToString(Request["tel1"]), Convert.ToString(Request["tel2"]))){
            
                string objstring = Request["objs"];
                if (objstring != "")
                {
                    string[] objs = objstring.Split(',');
                    for (int i = 0; i < objs.Length; i++)
                    {
                        string[] obj = objs[i].Split(':');
                        if (!this.dbUpdateObjetivesPlace(id, Convert.ToInt32(obj[0]), Convert.ToInt32(obj[1]), Convert.ToInt32(Request["y"]), Convert.ToInt32(Request["m"]), i))
                            r = 0;
                    }
                }
                else
                {
                    if (!this.dbUpdateObjetivesPlace(id, 0, 0, Convert.ToInt32(Request["y"]), Convert.ToInt32(Request["m"]), -1))
                        r = 0;
                }
            }
            else
            {
                r = 0;
            }
            Response.Write(r);
            Response.End();
        }

        #region Base de Datos
        protected bool dbSavePromoterData(int type, string prmCode, string prmName, string prmAgency, int prmId)
        {
            return core.executeProcedure("NIW_MK_SetPromotersData " + type + ",'" + prmCode + "','" + prmName + "','" + prmAgency + "'," + prmId);
        }
        protected DataTable dbGetPromotersData()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_OutPromoters");
        }
        protected DataTable dbGetPromoterData(int id)
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_OutPromoters WHERE PromoterId = " + id);
        }
        protected bool dbDeletePromoter(int id)
        {
            return core.executeSql("DELETE FROM NIW_MK_OutPromoters WHERE PromoterId = " + id);
        }
        //protected bool dbSetPromoterPlace(int type, string zone, int enca, int prom, int tipo)
        //{
        //    return core.executeSql("INSERT INTO NIW_MK_PromotersPlaces (PromoterType,PlaceZone,PlaceInCharge,PromoterId,PlaceType) VALUES (" + type + ",'" + zone + "'," + enca + "," + prom + "," + tipo + ")");
        //}
        protected bool dbSetPromoterPlace(object[] oParams)
        {
            return this.core.executeSql(string.Format("INSERT INTO NIW_MK_PromotersPlaces (PromoterType,PlaceZone,PlaceInCharge,PromoterId,PlaceType,JefeId,Estado,Agencia,Correo,Telefono,Municipio,CodigoZonaId) values ({0},'{1}',{2},{3},{4},{5},'{6}','{7}','{8}','{9}','{10}',{11})", oParams));
        }

        protected DataTable dbGetPromoterPlace()
        {
            return core.executeProcedureTab("NIW_MK_GetPromotersPlaces 0");
        }
        protected bool dbAddPromoterObjetive(string obj, string des)
        {
            return core.executeSql("INSERT INTO NIW_MK_PromotersObjetives (ObjetiveName, ObjetiveDesc) VALUES ('" + obj + "','" + des + "')");
        }
        protected DataTable dbGetEmails()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_PromotersPlaces");
        }
        protected DataTable dbGetPromoterObjetive()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_PromotersObjetives");
        }
        protected bool dbDelPromoterObjetive(int id)
        {
            return core.executeSql("DELETE FROM NIW_MK_PromotersObjetives WHERE ObjetiveId = " + id);
        }

        //protected DataTable dbGetInCharge()
        //{
        //    return core.executeSqlTab("SELECT NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NCCTO = '60' union all select NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NTRAB = 24035 union all select NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NTRAB = 22028 union all select NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NTRAB = 16007 union all select NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NTRAB = 99050 union all select NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NTRAB = 20320 union all select NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales WHERE NTRAB = 11118 ORDER BY NNOM");
        //}

        protected DataTable dbGetInCharge()
        {
            return this.core.executeSqlTab("select * from NIW_MK_PromotorVendedor  ");
        }
        protected DataTable dbGetPelikanPromoters()
        {
            return core.executeSqlTab("SELECT NTRAB, dbo.Fnt_NombreEmpleadoNomina(NNOM) as NNOM FROM EmpleadosTotales ORDER BY NNOM");
        }
        protected bool dbSetObjetivesData(int id,int obj, int ta, int da, int dm)
        {
            return core.executeSql("INSERT INTO NIW_MK_PlacesObjetives (PlaceId,ObjetiveId,TargetAmount,ObjetiveYear,ObjetiveMonth) VALUES (" + id + "," + obj + "," + ta + "," + da + ", " + dm + ")");
        }

        protected DataTable dbGetObjetiveData(int id, int y, int m)
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_PlacesObjetives as t1 INNER JOIN NIW_MK_PromotersObjetives as t2 ON t1.ObjetiveId = t2.ObjetiveId WHERE PlaceId = " + id + " AND ObjetiveYear = " + y + " AND ObjetiveMonth = " + m);
        }
        protected bool dbDelPlace(int id)
        {
            return core.executeSql("DELETE FROM NIW_MK_PromotersPlaces WHERE PlaceId = " + id);
        }
        protected DataTable dbGetZones()
        {
            return core.executeSqlTab("SELECT * FROM NIW_MK_PromoterZones");
        }
        //protected bool dbUpdatePlace(int id, string zone, int charge, int tipo, int type, int prom, string emailp, string emailc)
        //{
        //    return core.executeSql("UPDATE NIW_MK_PromotersPlaces SET PlaceZone = '" + zone + "', PlaceInCharge = " + charge + ", PlaceType = " + tipo + ", PromoterType = " + type + ", PromoterId = " + prom + " WHERE PlaceId = " + id);
        //}

        protected bool dbUpdatePlace(object[] oParams)
        {
            return this.core.executeSql(string.Format("update NIW_MK_PromotersPlaces set PlaceZone ='{0}', PlaceInCharge ={1}, PlaceType = {2},PromoterType = {3}, PromoterId = {4},JefeId = {5},Estado ='{6}' ,Agencia ='{7}',Correo ='{8}', Telefono ='{9}', Municipio ='{11}' , CodigoZonaId ={12}  WHERE PlaceId = {10} ", oParams));
        }

        protected bool dbUpdateEmail(int id,string emailp, string emailc,string tel1,string tel2)
        {
            return core.executeSql("UPDATE NIW_MK_PromotersPlaces SET EmailPersonal = '" + emailp + "',EmailCorporativo = '" + emailc + "',Tel1 = '" + tel1 + "',Tel1 = '" + tel2 + "' WHERE PlaceId = " + id);
        }
        protected bool dbUpdateObjetivesPlace(int id, int oId, int num, int y, int m, int i)
        {
            return core.executeProcedure("NIW_MK_UpdateObjetivesPlace " + id + "," + oId + "," + num + "," + y + "," + m + "," + i);
        }


        protected DataTable dbGetEstados()
        {
            return this.core.executeSqlTab("select Estado,Descripcion from NI_2001  where Pais ='MEX' ");
        }

        protected DataTable dbGetCdgZona()
        {
            return this.core.executeSqlTab("select IdZonaPromocion as IdZona,CodigoZona as Descripcion from NIW_MK_PromotorZonaCodigo  order by IdZonaPromocion ");
        }

        #endregion
    }
}