using System;

// This file is for PR review demo and intentionally contains issues
public class Demo
{
    // TODO: Refactor this method before merging
    public void PrintMessage()
    {
        string message = null;
        Console.WriteLine(message.ToString()); // Possible NullReferenceException
    }
}
