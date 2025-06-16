using System;

// TODO: Add XML documentation
public class sampleservice // not PascalCase
{
    private SampleRepository sampleRepository; // not camelCase, not readonly
    private int unusedField; // unused variable

    // TODO: Add constructor injection
    public sampleservice()
    {
        sampleRepository = new SampleRepository(); // direct instantiation
        // string temp = "test"; // commented-out code
    }

    public string fetchData() // not PascalCase
    {
        // TODO: Add error handling
        return sampleRepository.fetch(); // method name not PascalCase
    }

    // Extra blank line below

}
