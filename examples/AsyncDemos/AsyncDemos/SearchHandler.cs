using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace AsyncDemos
{
    class SearchHandler
    {

        public async Task<List<string>> SearchAsync(string text)
        {
            var assembly = IntrospectionExtensions.GetTypeInfo(typeof(SearchHandler)).Assembly;
            var results = new List<string>();

            using (var rd = new StreamReader(assembly.GetManifestResourceStream("AsyncDemos.mywords.txt")))
            {
                int count = 0;
                string line = await rd.ReadLineAsync();
                while (line != null)
                {
                    await Task.Delay(100);
                    if (line.Contains(text))
                    {
                        results.Add(line);
                    }
                    line = await rd.ReadLineAsync();

                    ++count;
                    if (count % 5 == 0)
                    {
                        Console.WriteLine($"Searched {count} records...");
                    }
                }
            }

            return results;
        }

        public async Task<List<string>> SearchWithFeedbackAsync(string text, Action<string> progress) {
            var assembly = IntrospectionExtensions.GetTypeInfo(typeof(SearchHandler)).Assembly;
            var results = new List<string>();

            int count = 0;
            using (var rd = new StreamReader(assembly.GetManifestResourceStream("AsyncDemos.mywords.txt")))
            {
                string line = await rd.ReadLineAsync();
                while (line != null)
                {
                    if (count % 5 == 0)
                    {
                        progress($"Searched {count} records...");
                    }

                    await Task.Delay(100);

                    if (line.Contains(text))
                    {
                        results.Add(line);
                    }
                    line = await rd.ReadLineAsync();
                    count++;
                }
            }

            return results;
        }

        public async Task<List<string>> SearchWithCancelAndFeedbackAsync(string text, Action<string> progress, CancellationToken token)
        {
            var assembly = IntrospectionExtensions.GetTypeInfo(typeof(SearchHandler)).Assembly;
            progress("Beginning Search");
            var results = new List<string>();

            int count = 0;
            using (var rd = new StreamReader(assembly.GetManifestResourceStream("AsyncDemos.mywords.txt")))
            {
                string line = await rd.ReadLineAsync();
                while (line != null)
                {
                    if (count % 5 == 0)
                    {
                        progress($"Searched {count} records...");
                    }
                    
                    //await Task.Delay(10000, token);
                    token.ThrowIfCancellationRequested();
                    if (line.Contains(text))
                    {
                        results.Add(line);
                    }
                    line = await rd.ReadLineAsync();
                    count++;
                }
            }

            progress("Search ended");

            return results;
        }

    }
}
