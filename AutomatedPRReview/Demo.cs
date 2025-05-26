using System;

// This file is for PR review demo and intentionally contains issues
public class Demo
{
    // TODO: Refactor this method before merging
    public void PrintMessage()
    {
        string message = null;
        string unusedVariable = "This variable is not used"; // Unused variable
        Console.WriteLine(message.ToString()); // Possible NullReferenceException
    }
}
