using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task<int> t1 = Task.Run(() => Sum(1, 10));
        Task<int> t2 = Task.Run(() => Sum(11, 20));
        
        // The following statement will not complete until both threads have finished
        int finalSum = t1.Result + t2.Result; 
        
        Console.WriteLine("Sum of 1 to 20 = " + finalSum);
    }

    static int Sum(int start, int end)
    {
        int sum = start;
        for (int i = start + 1; i <= end; ++i)
            sum += i;
        return sum;
    }
}