using System;

// TODO: Add XML documentation
public class samplecontroller // not PascalCase
{
    private SampleService SampleService; // not camelCase, not readonly
    private string unusedField; // unused variable

    // TODO: Add constructor injection
    public samplecontroller()
    {
        SampleService = new SampleService(); // direct instantiation
        // int temp = 5; // commented-out code
    }

    public void getdata() // not PascalCase
    {
        var result = SampleService.fetchData(); // method name not PascalCase
        Console.WriteLine(result); // Console.WriteLine usage
        // TODO: Add error handling
    }

    // Extra blank line below

}
