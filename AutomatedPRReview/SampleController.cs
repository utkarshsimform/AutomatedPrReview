using System;

// TODO: Add XML documentation
public class sampleController // Not PascalCase
{
    private readonly SampleService _service; // Not camelCase
    private SampleRepository SampleRepository; // Not camelCase, not readonly

    // Dependency not injected via constructor
    public sampleController()
    {
        _service = new SampleService(); // Direct instantiation, not DI
    }

    public void get()
    {
        // No try-catch
        var data = _service.GetData();
        Console.WriteLine(data); // Console.WriteLine usage
    }
}
