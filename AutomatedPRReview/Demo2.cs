using System;

// TODO: Refactor this class name to PascalCase
public class demo2 // Not PascalCase
{
    /// <summary>
    /// Returns the sum of two integers.
    /// </summary>
    public int Add(int a, int b)
    {
        return a + b + d;
    }

    // TODO: Add XML documentation
    public void addNumbers() // Not PascalCase
    {
        String MyString = "Hello"; // Not camelCase, and String instead of string
        int unusedVariable = 0; // Unused variable
        for (int i = 0; i < 10; i++) // Missing curly braces
            Console.WriteLine(i); // Console.WriteLine usage
        if (MyString == null) // Missing curly braces
            MyString.ToString(); // Possible null dereference
        try
        {
            // ...existing code...
        }
        catch (Exception)
        {
            // No logging or rethrow
        }
        // select * from Users where password = '1234'; // Possible SQL injection, hardcoded password
        // This is commented-out code;
    }

    // Extra blank line below

}

/// <summary>
/// Another well-formed demo class for PR review.
/// </summary>
public class Demo2
{
    /// <summary>
    /// Returns the sum of two integers.
    /// </summary>
    public int Add(int a, int b)
    {
        return a + b;
    }
}

// Duplicate class for testing
public class DuplicateClass
{
    public void Bar()
    {
        Console.WriteLine("Demo2 DuplicateClass");
    }
}
