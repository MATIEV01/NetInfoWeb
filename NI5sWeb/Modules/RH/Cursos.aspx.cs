using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;
using NI5sWeb.NIWeb;

namespace NI5sWeb.Modules.RH
{
    public partial class Cursos : System.Web.UI.Page
    {
        protected NIcore core = new NIcore();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["Session"] == null)
                Response.Redirect("/Modules/Security/Login.aspx");
            else
            {
                if (Request.HttpMethod == "POST")
                {
                    this.actionsSwitch();
                }
                else
                {
                    this.getCursos(false);
                }
            }
        }

        protected void actionsSwitch()
        {
            switch (this.Request["action"])
            {
                case "GetDocumentos":
                    this.getDocumentos();
                    break;
                case "GetEvaluacion":
                    this.getEvaluacion();
                    break;
                case "SaveEvaluacion":
                    this.saveEvaluacion();
                    break;
                case "getCursos":
                    this.getCursos(true);
                    break;
            }
        }

        protected void getCursos(bool type)
        {
            this.CursList.Controls.Clear();
            DataTable cursosData = this.dbGetCursosData(this.Request.Cookies["Session"]["userId"]);
            string str1 = string.Empty;
            foreach (DataRow row in (InternalDataCollectionBase)cursosData.Rows)
            {
                string str2 = row["Terminado"].ToString() == "False" ? "SI" : "NO";
                str1 = str1 + "<a href=\"#\" class=\"list-group-item\" data-idc=\"" + row["Id"] + "\" data-id=\"" + row["IdCurso"] + "\" data-Nombre=\"" + row["Nombre"] + "\" data-descripcion=\"" + row["Descripcion"] + "\" data-pendiente=\"" + str2 + "\" data-responsable=\"" + row["Responsable"] + "\" data-fecha=\"" + DateTime.Parse(row["FechaExpiracion"].ToString()).ToString("dd/MM/yyyy") + "\"  data-result=\"" + row["Result"] + "\">";
                str1 = str1 + "<h4 class=\"list-group-item-heading\"><strong>C" + row["Id"] + ":</strong> " + row["Nombre"] + "</h4>";
                str1 = str1 + "<p class=\"list-group-item-text\"><strong>Responsable :</strong> " + row["Responsable"] + "</p>";
                str1 = str1 + "<p class=\"list-group-item-text\"><strong>Fecha Expiracion :</strong> " + DateTime.Parse(row["FechaExpiracion"].ToString()).ToString("dd/MM/yyyy") + "</p>";
                str1 = str1 + "<p class=\"list-group-item-text\"><strong>Pendiente :</strong> " + str2 + "</p>";
                str1 += "</a>";
            }
            if (!type)
            {
                this.CursList.Controls.Add((Control)new LiteralControl(str1));
            }
            else
            {
                this.Response.Write(str1);
                this.Response.End();
            }
        }

        protected void getDocumentos()
        {
            string str1 = this.Request["id"];
            string path = "\\\\12.12.71.96\\Digitalizacion\\Finanzas\\RH\\Cursos\\" + str1;
            string s = string.Empty;
            if (Directory.Exists(path))
            {
                foreach (string file in Directory.GetFiles(path))
                {
                    if (Path.GetExtension(file).Contains("pdf"))
                    {
                        string withoutExtension = Path.GetFileNameWithoutExtension(file);
                        string str2 = "id=" + str1 + "&name=" + withoutExtension;
                        s = s + "<a href=\"#\" class=\"list-group-item\" data-filename =\"" + str2 + "\">Documento - " + withoutExtension + "</a>";
                    }
                }
            }
            this.Response.Write(s);
            this.Response.End();
        }

        protected void getEvaluacion()
        {
            string IdCurso = this.Request["Id"];
            DataTable preguntasCurso = this.dbGetPreguntasCurso(IdCurso);
            string s = string.Empty;
            foreach (DataRow row1 in (InternalDataCollectionBase)preguntasCurso.Rows)
            {
                string idPregunta = row1["IdPregunta"].ToString();
                s += " <tr> ";
                s = s + "<th class=\"auto-style1\">" + row1["Descripcion"].ToString() + "</th> </tr>";
                DataTable respuestasCurso = this.dbGetRespuestasCurso(IdCurso, idPregunta);
                if (respuestasCurso != null && respuestasCurso.Rows.Count > 0)
                {
                    s = s + "<tr  id=" + idPregunta + " > <td lass=\"auto-style1\"> ";
                    foreach (DataRow row2 in (InternalDataCollectionBase)respuestasCurso.Rows)
                        s = s + " <label class=\"radio-inline\"> <input class=\"radio\" type=\"radio\" name=\"optradio" + idPregunta + "\" value = \"" + idPregunta + "-" + row2["Correcta"].ToString() + "\"/>" + row2["Descripcion"].ToString() + " </label>";
                    s += "</td></tr>";
                }
            }
            this.Response.Write(s);
            this.Response.End();
        }

        protected void saveEvaluacion()
        {
            string IdEmpleado = this.Request.Cookies["Session"]["userId"];
            string str1 = this.Request["arrayRes[]"];
            string IdCurso = this.Request["Id"];
            string idConsecutivo = this.Request["idC"];
            string[] strArray = str1.Split(',');
            int count = this.dbGetPreguntasCurso(IdCurso).Rows.Count;
            if (count == ((IEnumerable<string>)strArray).Count<string>())
            {
                Decimal num1 = new Decimal(0);
                foreach (string str2 in strArray)
                {
                    char[] chArray = new char[1] { '-' };
                    if (bool.Parse(str2.Split(chArray)[1]))
                        ++num1;
                }
                Decimal num2 = Decimal.Parse((num1 / Decimal.Parse(count.ToString()) * new Decimal(100)).ToString());
                this.GuardarEvaluacion(IdCurso, idConsecutivo, IdEmpleado, num2.ToString("N2"));
                this.Response.Write(num2.ToString("N2"));
                this.Response.End();
            }
            else
            {
                this.Response.Write("0");
                this.Response.End();
            }
        }

        protected DataTable dbGetCursosData(string cdgusu)
        {
            string empty = string.Empty;
            return this.core.executeSqlTab("select C_E.Consecutivo as Id, C_E.IdCurso,Nombre,Descripcion,UsuarioResponsable as Responsable,FechaExpiracion,Terminado,isnull(Evaluacion,0) as Result" + "  from NI_RH_Cursos_Empleados C_E left join NI_RH_Cursos C on C.IdCurso  = C_E.IdCurso " + "   where C_E.IdEmpleado = (select EmpleadoID from NI_0100 where CdgUsu ='" + cdgusu.Trim() + "') order by C_E.Consecutivo ");
        }

        protected DataTable dbGetPreguntasCurso(string IdCurso)
        {
            string empty = string.Empty;
            return this.core.executeSqlTab("select * from NI_RH_Cursos_Preguntas  where IdCurso= '" + IdCurso + "' ");
        }

        protected DataTable dbGetRespuestasCurso(string IdCurso, string idPregunta)
        {
            string empty = string.Empty;
            return this.core.executeSqlTab("select * from NI_RH_Cursos_Respuestas  where IdCurso= '" + IdCurso + "' and Idpregunta =" + idPregunta);
        }

        protected void GuardarEvaluacion(string IdCurso, string idConsecutivo, string IdEmpleado, string result)
        {
            string empty = string.Empty;
            this.core.executeSql("Update NI_RH_Cursos_Empleados set Evaluacion =" + result + " , Terminado = 1  where Idcurso='" + IdCurso + "' and Consecutivo=" + idConsecutivo + " and IdEmpleado =(select EmpleadoID from NI_0100 where CdgUsu ='" + IdEmpleado + "')");
        }
    }
}