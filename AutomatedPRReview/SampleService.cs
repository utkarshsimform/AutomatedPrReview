using System;

// TODO: Add XML documentation
public class SampleService
{
    private SampleRepository _repository; // Not injected via constructor

    public SampleService()
    {
        _repository = new SampleRepository(); // Direct instantiation, not DI
    }

    public string GetData()
    {
        // No try-catch
        return _repository.Fetch();
    }
}
