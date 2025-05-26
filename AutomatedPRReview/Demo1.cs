using System;

/// <summary>
/// A well-formed demo class for PR review.
/// </summary>
public class Demo1
{
    /// <summary>
    /// Prints a message safely.
    /// </summary>
    public void PrintMessage()
    {
        try
        {
            string message1 = "Hello, World!";
            Console.WriteLine(message);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }
}
