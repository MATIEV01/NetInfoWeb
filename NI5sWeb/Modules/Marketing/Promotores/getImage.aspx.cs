using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace NI5sWeb.Modules.Marketing.Promotores
{
    public partial class getImage : System.Web.UI.Page
    {

        protected string path = "\\\\12.12.71.96\\Departaments\\RecursosHumanos\\TimeManager\\Image\\";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.Request.Cookies["Session"] == null)
            {
                this.Response.Redirect("/Modules/Security/Login.aspx");
            }
            else
            {
                this.Response.ContentType = "Application/pdf";
                string[] imgFile = this.getImgFile(this.Request["Id"]);
                this.Response.ContentType = imgFile[1];
                string str = this.Request["img"];
                this.Response.WriteFile(imgFile[0]);
                this.Response.End();
            }
        }

        protected string[] getImgFile(string usrId)
        {
            string[] strArray = new string[2];
            int length = usrId.Length;
            foreach (string file in Directory.GetFiles(this.path))
            {
                if (file.ToUpper().IndexOf("C" + usrId + ".") != -1)
                {
                    strArray[0] = file;
                    strArray[1] = !(file.Substring(file.Length - 3, 3) == "jpg") ? "image/bmp" : "image/jpeg";
                }
            }
            return strArray;
        }
    }
}