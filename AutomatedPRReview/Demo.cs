using System;

// This file is for PR review demo and intentionally contains issues
public class demo // not PascalCase
{
    // TODO: Refactor this method before merging
    public void printmessage1() // not PascalCase
    {
        string Message = null; // not camelCase
        string unusedVariable = "This variable is not used"; // Unused variable
        Console.WriteLine(Message.ToString()); // Possible NullReferenceException
        // int x = 5;
    }
}
