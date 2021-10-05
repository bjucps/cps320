﻿using Parse;
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

        private async void Login_Clicked(object sender, EventArgs e)
        {
            await ParseClient.Instance.LogInAsync("Test", "Test");

        }

        private async void DisplayStudents_Clicked(object sender, EventArgs e)
        {
            try
            {
                // Must login first...
                var qry = ParseClient.Instance.GetQuery<Student>()
                    //.WhereEqualTo("FirstName", "Joe")
                    .OrderBy(nameof(Student.FirstName));

                var results = await qry.FindAsync();
                List<Student> students = results.ToList();
                foreach (Student result in students)
                {
                    Console.WriteLine(result);
                }
                StudentList.ItemsSource = students;
            }
            catch (Exception ex)
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
    }
}
