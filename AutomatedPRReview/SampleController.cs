using System;

// TODO: Add XML documentation
public class SampleController
{
    private readonly SampleService _service;

    public SampleController()
    {
        _service = new SampleService();
    }

    public void Get()
    {
        var data = _service.GetData();
        Console.WriteLine(data);
    }
}
