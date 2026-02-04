using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Task t = Task.Run(async () => {
            Task<int> t1 = Sum(1, 10);
            Task<int> t2 = Sum(11, 20);

            // The following statement will not complete until both threads have finished
            int sum1 = await t1;
            int sum2 = await t2;
            int finalSum = sum1 + sum2; 
            
            Console.WriteLine("Sum of 1 to 20 = " + finalSum);
        });

        Task.WaitAll(t);        
        
    }

    static Task<int> SumAsync(int start, int end)
    {
        return Task.Run( () => {
            int sum = start;
            for (int i = start + 1; i <= end; ++i)
                sum += i;
            return sum;
        });
    }
}