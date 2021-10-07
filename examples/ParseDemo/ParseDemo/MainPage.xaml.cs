using Parse;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ParseDemo
{
    public partial class MainPage : ContentPage
    {

        public MainPage()
        {
            InitializeComponent();
            
            StudentList.RefreshCommand = new Command(
                o => _ = DoRefresh(o)
            );

            _ = LoginAndLoadStudents();

        }


        private async void CreateStudent_Clicked(object sender, EventArgs e)
        {
            try
            {

                Student stu = ParseClient.Instance.CreateObject<Student>();
                stu.FirstName = "George" + new Random().Next(0, 10000);
                stu.LastName = "Frederick";
                await stu.SaveAsync();


            } catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        private async void UpdateJoe_Clicked(object sender, EventArgs e)
        {
            // Must login first...
            var qry = ParseClient.Instance.GetQuery<Student>()
                    .WhereEqualTo("FirstName", "Joe")
                    .OrderBy(nameof(Student.FirstName));

            Student result = await qry.FirstOrDefaultAsync();

            result.LastName += "!";
            await result.SaveAsync();
            // await result.DeleteAsync();
        }

        protected async Task LoginAndLoadStudents() { 
            try
            {
                StudentList.IsRefreshing = true; // turn on list reload indicator, and prevent manual pull to refresh
                await ParseClient.Instance.LogInAsync("Test", "Test");
                await DoRefresh(StudentList);
            }
            catch (Exception e)
            {
                Console.WriteLine("Unable to login: " + e);
            } 
            finally
            {
                StudentList.IsRefreshing = false; 
            }          
        }

        private async Task DoRefresh(object obj)
        {
            
            try
            {                
                await Task.Delay(2000); // Introduce delay for demo; can remove this
                var qry = ParseClient.Instance.GetQuery<Student>()
                    .OrderBy(nameof(Student.FirstName));

                StudentList.ItemsSource = await qry.FindAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            finally
            {
                StudentList.IsRefreshing = false;
            }
        }
    }
}
