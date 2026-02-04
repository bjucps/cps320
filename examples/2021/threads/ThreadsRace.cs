using System;
using System.Threading.Tasks;

class Program
{
    static long sum = 0;

    static void Main(string[] args)
    {
        Task t1 = Task.Run(() => Sum(1, 100000));
        Task t2 = Task.Run(() => Sum(100001, 200000));
        Task.WaitAll(t1, t2);
     
        Console.WriteLine("Sum of 1 to 200000 = " + sum);
    }

    static void Sum(int start, int end)
    {
        for (int i = start; i <= end; ++i)
            sum += i;

    }
}