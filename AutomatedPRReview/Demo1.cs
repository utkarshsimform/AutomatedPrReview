using System;

/// <summary>
/// A well-formed demo class for PR review.
/// </summary>
public class demo5
{
    /// <summary>
    /// Prints a message safely.
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
