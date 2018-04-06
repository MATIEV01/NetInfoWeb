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
    public partial class AnalisisObjetivos : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
            {
                this.switchAction();
            }
            else
            {
                this.getPlacesList();
                this.getYearNow();
            }
        }

        protected void switchAction()
        {
            switch (Request["action"])
            {
                case "GetObjetivesPlaces":
                    this.getObjetivesPlaces();
                    break;
                case "GetObjetivesDone":
                    this.getObjetivesDone();
                    break;
                case "AddObjetivesDone":
                    this.addObjetiveDone();
                    break;
                case "DeleteObjetiveDone":
                    this.delObjetiveDone();
                    break;
                case "GetObjetiveDoneData":
                    this.getObjetivesMonthData();
                    break;
                //case "Carga Archivo":
                //    this.CargaArchivo();
                //    break;
                
            }
        }

        protected void getListPuntualidad()
        {
         
            
        }

        protected void getPlacesList()
        {
            //DataTable places = this.dbGetPlaces();
            //string list = String.Empty;

            //foreach (DataRow place in places.Rows)
            //{
            //    list += "<a href=\"#\" class=\"list-group-item\" data-id=\"" + place["PlaceId"] + "\" data-zone=\"" + place["PlaceZone"] + "\" data-incharge=\"" + place["PlaceInCharge"] + "\" data-type=\"" + place["PlaceType"] + "\" data-ptype=\"" + place["PromoterType"] + "\" data-promoter=\"" + place["PromoterId"] + "\">";
            //    list += "<h4 class=\"list-group-item-heading\"><strong>P" + place["PlaceId"] + ":</strong> " + place["PromoterName"] + "</h4>";
            //    string prmType = "Pelikan";
            //    string pt = place["PromoterType"].ToString();
            //    if (pt == "2")
            //        prmType = "Externo";
            //    list += "<p class=\"list-group-item-text\"><strong>Empleado:</strong> " + prmType + "</p>";
            //    list += "<p class=\"list-group-item-text\"><strong>Zona:</strong> " + place["PlaceZone"] + "</p>";
            //    list += "<p class=\"list-group-item-text\"><strong>Encargado:</strong> " + place["InChargeName"] + "</p>";
            //    list += "</a>";
            //}

            //PlacesList.Controls.Add(new LiteralControl(list));

            DataTable places = this.dbGetPlaces();
            string text = string.Empty;
            foreach (DataRow row in (InternalDataCollectionBase)places.Rows)
            {
                text = text + "<a href=\"#\" class=\"list-group-item\" data-id=\"" + row["PlaceId"] + "\" data-zone=\"" + row["PlaceZone"] + "\" data-incharge=\"" + row["PlaceInCharge"] + "\" data-type=\"" + row["PlaceType"] + "\" data-ptype=\"" + row["PromoterType"] + "\" data-promoter=\"" + row["PromoterId"] + "\">";
                text = text + "<h4 class=\"list-group-item-heading\"><strong>P" + row["PlaceId"] + ":</strong> " + row["PromoterName"] + "</h4>";
                string str = "Pelikan";
                if (row["PromoterType"].ToString() == "2")
                    str = "Externo";
                text = text + "<p class=\"list-group-item-text\"><strong>Empleado:</strong> " + str.ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Zona:</strong> " + row["PromoterZone"].ToString().ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Encargado:</strong> " + row["InChargeName"].ToString().ToUpper() + "</p>";
                text = text + "<p class=\"list-group-item-text\"><strong>Estado:</strong> " + row["DscEstado"].ToString().ToUpper() + "</p>";
                text += "</a>";
            }
            this.PlacesList.Controls.Add((Control)new LiteralControl(text));
        }

        protected void getObjetivesPlaces()
        {
            DataTable objs = this.dbGetObjetives(Convert.ToInt32(Request["id"]), Convert.ToInt32(Request["y"]), Convert.ToInt32(Request["m"]));
            string list = "<select class=\"form-control\">";
            if (objs.Rows.Count < 1)
                list += "<option value=\"\">No se han agregado objetivos</option>";
            else
                list += "<option value=\"\">Seleccionar Objetivo</option>";
            foreach (DataRow obj in objs.Rows)
            {
                list += "<option value=\"" + obj["ObjetiveId"] + "\" data-desc=\"" + obj["ObjetiveDesc"] + "\">" + obj["ObjetiveName"] + "</option>";
            }
            list += "</select>";

            Response.Write(list);
            Response.End();
        }

        protected void getObjetivesDone()
        {
            int pl = Convert.ToInt32(Request["id"]);
            int m = Convert.ToInt32(Request["m"]);
            int y = Convert.ToInt32(Request["y"]);

            DataTable objs = this.dbGetObjetivesDone(pl, y, m);
            string list = String.Empty;
            foreach (DataRow obj in objs.Rows)
            {
                list += "<div class=\"input-group\" data-id=\"" + obj["DoneId"] + "\"><span class=\"input-group-addon\">" + obj["DateDone"] + "</span><p class=\"form-control\">" + obj["ObjetiveName"] + "</p><span class=\"input-group-btn\"><button class=\"btn btn-danger del\" type=\"button\"><i class=\"fa fa-times\"></i></button></span></div>";
            }
            Response.Write(list);
            Response.End();
        }

        protected void getYearNow()
        {
            DateTime dateNow = DateTime.Now;
            DatePanel.Attributes.Add("data-year",dateNow.ToString("yyy"));
            DatePanel.Attributes.Add("data-month", dateNow.ToString("MM"));
        }

        protected void addObjetiveDone()
        {
            int puntual = 0;
            int dias = Convert.ToInt32(Request["dias"]);
            int pl = Convert.ToInt32(Request["pl"]);
            int ob = Convert.ToInt32(Request["obj"]);
            string date = Request["date"];
            string cli = Request["cli"];
            string con = Request["con"];
            string car = Request["car"];
            string fields = Request["desc"];
            //CargaArchivo();
            if (ob==48)
            {
                puntual = Convert.ToInt16(Select1.Value);
            }

            if (this.dbSetObjetivesDone(pl, ob, date, cli, con, car, fields, puntual))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        protected void delObjetiveDone()
        {
            if (this.dbDelObjetiveDone(Convert.ToInt64(Request["id"])))
                Response.Write(1);
            else
                Response.Write(0);
            Response.End();
        }

        protected void getObjetivesMonthData()
        {
            //int y = Convert.ToInt32(Request["y"]);
            //int m = Convert.ToInt32(Request["m"]);
            //int id = Convert.ToInt32(Request["id"]);
            //DataTable objs = this.dbGetObjetivesMonthData(id, m, y);
            //DataTable cols = this.dbGetObjetives(id, y, m);
            //int days = DateTime.DaysInMonth(y, m);
            //string listh = "<thead>";
            //string listb = "<tbody>";
            //string list = String.Empty;

            //for (int i = 1; i <= days; i++)
            //{
            //    if (list == String.Empty) listh += "<tr><th>Días</th>";
            //    DateTime date = new DateTime(y, m, i);
            //    string formattedDay = date.ToString("dd ddd");
            //    if (formattedDay.Substring(3) == "do.")
            //        listb += "<tr class=\"weekend\">";
            //    else
            //        listb += "<tr>";
            //    listb += "<th>" + formattedDay + "</th>";
            //    int sum = 0;
            //    foreach (DataRow col in cols.Rows)
            //    {
            //        if (list == String.Empty) listh += "<th>" + col["ObjetiveName"] + "</th>";
            //        string query = "ObjetiveId = " + col["ObjetiveId"] + " and Day = " + i;
            //        DataRow[] rs = objs.Select(query);
            //        if (rs.Count() > 0)
            //        {
            //            int count = Convert.ToInt32(rs[0]["Count"]);
            //            listb += "<td>" + count +"</td>";
            //            sum += count;
            //        }
            //        else
            //        {
            //            listb += "<td>0</td>";
            //            sum += 0;
            //        }
            //    }
            //    if (list == String.Empty) { listh += "<th>Total</th></tr></thead>"; list += listh; }
            //    listb += "<th>" + sum + "</th></tr>";
            //}
            //listb += "</tbody>";
            //list += listb;
            //Response.Write(list);
            //Response.End();


            int y = Convert.ToInt32(Request["y"]);
            int m = Convert.ToInt32(Request["m"]);
            int id = Convert.ToInt32(Request["id"]);
            DataTable objetivesMonthData = this.dbGetObjetivesMonthData(id, m, y);
            DataTable objetives = this.dbGetObjetives(id, y, m);
            int num1 = DateTime.DaysInMonth(y, m);
            string str1 = "<thead>";
            string str2 = "<tbody>";
            string empty = string.Empty;
            for (int day = 1; day <= num1; ++day)
            {
                if (empty == string.Empty)
                    str1 += "<tr><th>Días</th>";
                string str3 = new DateTime(y, m, day).ToString("dd ddd");
                string str4 = (!(str3.Substring(3) == "do.") ? str2 + "<tr>" : str2 + "<tr class=\"weekend\">") + "<th>" + str3 + "</th>";
                int num2 = 0;
                foreach (DataRow row in (InternalDataCollectionBase)objetives.Rows)
                {
                    if (empty == string.Empty)
                        str1 = str1 + "<th>" + row["ObjetiveName"] + "</th>";
                    string filterExpression = "ObjetiveId = " + row["ObjetiveId"] + " and Day = " + (object)day;
                    DataRow[] dataRowArray = objetivesMonthData.Select(filterExpression);
                    if (((IEnumerable<DataRow>)dataRowArray).Count<DataRow>() > 0)
                    {
                        int int32_4 = Convert.ToInt32(dataRowArray[0]["Count"]);
                        str4 = str4 + "<td data-idobjetivo =\"" + row["ObjetiveId"] + "\"><input type=\"number\" id=\"" + (object)day + "\" class=\"form-control\" Value = \"" + (object)int32_4 + "\" /></td> \"";
                        num2 += int32_4;
                    }
                    else
                    {
                        str4 = str4 + "<td data-idobjetivo =\"" + row["ObjetiveId"] + "\"><input type=\"number\" id=\"" + (object)day + "\" class=\"form-control\" Value=\"0\" /></td> \"";
                        num2 = num2;
                    }
                }
                if (empty == string.Empty)
                {
                    str1 += "</tr>";
                    empty += str1;
                }
                str2 = str4 + "</tr>";
            }
            string str5 = "<tfoot> <tr><th>TOTAL</th> ";
            foreach (DataRow row in (InternalDataCollectionBase)objetives.Rows)
            {
                string filterExpression = "ObjetiveId = " + row["ObjetiveId"] + " ";
                DataRow[] dataRowArray = objetivesMonthData.Select(filterExpression);
                if (((IEnumerable<DataRow>)dataRowArray).Count<DataRow>() > 0)
                {
                    Decimal num2 = (Decimal)((IEnumerable<DataRow>)dataRowArray).Sum<DataRow>((Func<DataRow, int>)(r => int.Parse(r.Field<string>("Count"))));
                    str5 = str5 + "<th align = \"Center\">" + num2.ToString() + "</th>";
                }
                else
                    str5 += "<th align = \"Center\" >0</th>";
            }
            if (str5 == string.Empty)
                empty += "</tr></tfoot>";
            string str6 = str2 + "</tbody>";
            this.Response.Write(empty + str6 + str5);
            this.Response.End();
        }

        //protected void CargaArchivo()
        //{
        //    if ((File1.PostedFile != null) && (File1.PostedFile.ContentLength > 0))
        //    {
        //        string fn = System.IO.Path.GetFileName(File1.PostedFile.FileName);
        //        string carpeta = Server.MapPath("Data") + "\\ " + fn;
        //        try
        //        {
        //            File1.PostedFile.SaveAs(carpeta);
        //            Response.Write("El archivo se cargo");
        //        }
        //        catch (Exception ex)
        //        {
        //            Response.Write("Error: " + ex.Message);
        //        }
        //    }
        //    else
        //    {
        //        Response.Write("Seleccione un archivo que cargar");
        //    }
        //}

        #region Base de Datos
        protected DataTable dbGetPlaces()
        {
            return core.executeProcedureTab("NIW_MK_GetPromotersPlaces 0");
        }
        protected DataTable dbGetObjetives(int id,int y, int m)
        {
            return core.executeProcedureTab("NIW_MK_GetPlaceObjetivesByMonth " + id + "," + y + "," + m);
        }
        protected DataTable dbGetObjetivesDone(int id, int y, int m)
        {
            return core.executeProcedureTab("NIW_MK_GetPlaceObjetivesDoneByMonth " + id + "," + m + "," + y);
        }
        protected DataTable dbGetReporte(int tipo, int y, int m)
        {
            return core.executeProcedureTab("NIW_MK_GetPromotoresReport " + tipo + "," + y + "," + m);
        }
        //protected bool dbSetObjetivesDone(int pl, int ob, string date, string cli, string con, string car, string fields)
        //{
        //    return core.executeSql("INSERT INTO NIW_MK_PlaObjDone (PlaceId, ObjetiveId, Date, Client, Contact, Cargo, Fields) VALUES (" + pl + "," + ob + ",'" + date + "','" + cli + "','" + con + "','" + car + "','" + fields + "')");
        //}
        protected bool dbSetObjetivesDone(int pl, int ob, string date, string cli, string con, string car, string fields, int puntual)
        {
            return core.executeSql("INSERT INTO NIW_MK_PlaObjDone (PlaceId, ObjetiveId, Date, Client, Contact, Cargo, Fields, Puntual) VALUES (" + pl + "," + ob + ",'" + date + "','" + cli + "','" + con + "','" + car + "','" + fields + "','" + puntual + "')");
        }
        protected bool dbDelObjetiveDone(long done)
        {
            return core.executeSql("DELETE FROM NIW_MK_PlaObjDone WHERE DoneId = " + done);
        }
        protected DataTable dbGetObjetivesMonthData(int pl, int m, int y)
        {
            //return core.executeSqlTab("SELECT DATEPART(YY, t1.Date) as Year, DATEPART(MM, t1.Date) as Month, DATEPART(DD, t1.Date) as Day, COUNT(t1.DoneId) as Count, t1.ObjetiveId, (SELECT ObjetiveName FROM NIW_MK_PromotersObjetives WHERE ObjetiveId = t1.ObjetiveId) as ObjetiveName FROM NIW_MK_PlaObjDone as t1 WHERE t1.PlaceId = " + pl + "  AND DATEPART(MM, t1.Date) = " + m + " AND DATEPART(YY, t1.Date) = " + y + " GROUP BY Date, t1.ObjetiveId");
            return this.core.executeSqlTab("SELECT DATEPART(YY, t1.Date) as Year, DATEPART(MM, t1.Date) as Month, DATEPART(DD, t1.Date) as Day, Fields as Count, t1.ObjetiveId, (SELECT ObjetiveName FROM NIW_MK_PromotersObjetives WHERE ObjetiveId = t1.ObjetiveId) as ObjetiveName FROM NIW_MK_PlaObjDone as t1 WHERE t1.PlaceId = " + (object)pl + "  AND DATEPART(MM, t1.Date) = " + (object)m + " AND DATEPART(YY, t1.Date) = " + (object)y + " order BY Date, t1.ObjetiveId");
        }
        #endregion
    }
}