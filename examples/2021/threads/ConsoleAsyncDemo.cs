using System;
using System.Threading.Tasks;


class Program
{
    static void Main(string[] args)
    {
        FooWithAwait();
        Foo();
        Console.WriteLine("Press Enter to exit...");
        Console.ReadLine();
    }

    // use await
    static async void FooWithAwait()
    {
        Console.WriteLine("In Foo");
        await Task.Run(() => Boo());
        Console.WriteLine("Finished With Foo");
    }

    static void Boo()
    {
        Console.WriteLine("In Boo");
        for (int i = 0; i < 10; ++i)
            Console.WriteLine(i + "...");
        Console.WriteLine("Done With Boo");
    }

    // use ContinueWith
    static void Foo() {
        Console.WriteLine("In Foo");
        Task t1 = Task.Run(() => Boo());
        Task t2 = t1.ContinueWith(t => Console.WriteLine("Finished with Foo"));
    }
        
}