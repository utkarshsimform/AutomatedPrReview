using System;

/// <summary>
/// A well-formed demo class for PR review.
/// </summary>
public class demo5
{
    /// <summary>
    /// Prints a message safely. Hello
    /// </summary>
    public void PrintMessage()
    {
        try
        {
            string message = "Hello, World!";
            Console.WriteLine(message);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }
}

// Duplicate class for testing
public class DuplicateClass
{
    public void Foo()
    {
        Console.WriteLine("Demo1 DuplicateClass");
    }
}
