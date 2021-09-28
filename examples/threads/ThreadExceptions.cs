using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task t1 = Task.Run(() => Go());
        try {
            Task.WaitAll(t1);
        } catch (AggregateException ae) {
            foreach (Exception e in ae.Flatten().InnerExceptions) {
                Console.WriteLine($"Received {e.Message} in main thread...");
            }
        }
    }

    static void Go()
    {
        throw new Exception("Aaaagh!");
    }
}