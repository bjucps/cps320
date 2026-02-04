using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task t1 = Task.Run(() => Go());
        Task t2 = Task.Run(Go); // same 
        Task.WaitAll(t1, t2);
        Console.WriteLine("Press Enter to exit...");
        Console.ReadLine();
    }

    static void Go()
    {
        for (int i = 0; i < 50; ++i)
            Console.WriteLine(i);
    }
}