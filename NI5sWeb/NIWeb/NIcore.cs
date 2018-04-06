using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Net.Mail;
using System.IO;

namespace NI5sWeb.NIWeb
{
    public class NIcore
    {
        public  string ConnStr = "Data Source=SRV-SQL;packet size=16384;Initial Catalog=NetInfo;User ID=SQL2015;Password=M4J3ST1C; connect timeout = 900;Persist security info= true;";
         //public string ConnStr = "Data Source=192.168.153.12;packet size=16384;Initial Catalog=NetInfo;User ID=SQL2015;Password=M4J3ST1C; connect timeout = 900;Persist security info= true;";
        
        private SqlConnection dbConn;

        private bool connProve()
        {
            bool var = false;

            try
            {

                dbConn = new SqlConnection(ConnStr);
                this.dbConn.Open();
                var = true;
            }
            catch
            {
                var = false;
            }

            return var;
        }

        public bool executeProcedure(string procedure)
        {
            if (this.connProve())
            {
                SqlCommand cmd = this.dbConn.CreateCommand();
                cmd.CommandText = "EXECUTE " + procedure;
                int dr = cmd.ExecuteNonQuery();
                this.dbConn.Close();
                if (dr == -1)
                    return true;
                else
                    return false;
            }
            else
            {
                return true;
            }
        }

        public bool executeSql(string sentence)
        {
            if (this.connProve())
            {
                SqlCommand cmd = this.dbConn.CreateCommand();
                cmd.CommandText = sentence;
                bool r = false;
                try
                {
                    cmd.ExecuteNonQuery();
                    r = true;
                }
                catch
                {
                    r = false;
                }
                this.dbConn.Close();
                return r;
            }
            else
            {
                return true;
            }
        }

        public DataTable executeProcedureTab(string procedure)
        {
            if (this.connProve())
            {
                SqlCommand cmd = this.dbConn.CreateCommand();
                cmd.CommandTimeout = 0;
                cmd.CommandText = "EXECUTE " + procedure;
                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                this.dbConn.Close();
                return dt;
            }
            else
            {
                this.dbConn.Close();
                return new DataTable();
            }
        }

        public DataTable executeSqlTab(string sentence)
        {
            if (this.connProve())
            {
                SqlCommand cmd = this.dbConn.CreateCommand();
                cmd.CommandText = sentence;
                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                this.dbConn.Close();
                return dt;
            }
            else
            {
                this.dbConn.Close();
                return new DataTable();
            }
        }

        public bool sendEmail(string[] from, string to, string subject, string body)
        {
            try
            {
                MailMessage mail = new MailMessage();
                SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");

                mail.From = new MailAddress(from[0] + "@gmail.com");
                mail.To.Add(to);
                mail.Subject = subject;
                mail.Body = body;

                SmtpServer.Port = 587;
                SmtpServer.Credentials = new System.Net.NetworkCredential(from[1], from[2]);
                SmtpServer.EnableSsl = true;

                SmtpServer.Send(mail);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public Stream GetStreamFile(string filePath)
        {
            using (FileStream fileStream = File.OpenRead(filePath))
            {
                MemoryStream memStream = new MemoryStream();
                memStream.SetLength(fileStream.Length);
                fileStream.Read(memStream.GetBuffer(), 0, (int)fileStream.Length);

                return memStream;
            }
        }

        public bool sendEmail(string[] from, string to, string subject, string body, string file, string type)
        {
            try
            {
                MailMessage mail = new MailMessage();
                SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");

                mail.From = new MailAddress(from[0] + "@gmail.com");
                mail.To.Add(to);
                mail.Subject = subject;
                mail.Body = body;

                System.Net.Mail.Attachment attachment;
                attachment = new System.Net.Mail.Attachment(GetStreamFile(file), Path.GetFileName(file), type);
                mail.Attachments.Add(attachment);

                SmtpServer.Port = 587;
                SmtpServer.Credentials = new System.Net.NetworkCredential(from[1], from[2]);
                SmtpServer.EnableSsl = true;

                SmtpServer.Send(mail);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool sendHtmlMail(string to, string subject, string html)
        {
            try
            {
                MailMessage mail = new MailMessage();
                SmtpClient SmtpServer = new SmtpClient("mail-pelikan.pelikanpue.com");

                mail.From = new MailAddress("administrator@pelikan.com.mx");
                mail.To.Add(to);

                mail.Subject = subject;
                mail.Body = html;
                mail.IsBodyHtml = true;

                SmtpServer.Port = 587;
                SmtpServer.Credentials = new System.Net.NetworkCredential("pelikanpue\administrator", "M4J3ST1C");
                SmtpServer.EnableSsl = true;

                SmtpServer.Send(mail);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public void alert(string text, HttpResponse resp)
        {
            resp.Write("<script>alert('" + text + "');</script>");
        }

        public string dataTableToJson(DataTable t)
        {
            string j = String.Empty;
            int a1 = 0;
            foreach (DataRow row in t.Rows)
            {
                if (a1 > 0)
                    j += ",";
                j += "{";
                int a2 = 0;
                foreach (DataColumn col in t.Columns)
                {
                    if (a2 > 0)
                        j += ",";
                    j += "\"" + col.ColumnName + "\": \"" + row[col.ColumnName].ToString() + "\"";
                    a2++;
                }
                j += "}";
                a1++;
            }

            return "[" + j + "]";
        }

        public bool hasPermissions(string usrId,string page)
        {
            DataTable r = this.executeSqlTab("SELECT t1.ScreenId FROM NIW_SYS_UI_Permissions as t1 INNER JOIN NIW_SYS_UI as t2 ON t1.ScreenId = t2.ScreenId WHERE t1.UserId = '" + usrId + "' AND t2.ScreenPath = '" + page + "'");
            //DataTable r = this.executeSqlTab("SELECT t1.ScreenId FROM NI_SYS_UI_Permissions as t1 INNER JOIN NIW_SYS_UI as t2 ON t1.ScreenId = t2.ScreenId WHERE t1.UserId = '" + usrId + "' AND t2.ScreenPath = '" + page + "'");
            if (r.Rows.Count > 0 || page == "/default.aspx")
                return true;
            else
                return false;
        }
    }
}