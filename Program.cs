using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Azure.Identity;

var host = new HostBuilder()
    .ConfigureAppConfiguration(builder =>
    {
        string cs = Environment.GetEnvironmentVariable("ConnectionString");
        builder.AddAzureAppConfiguration(options =>
        {
            options.Connect(new Uri("https://appc-rpm-accounting-dev.azconfig.io"), new DefaultAzureCredential());
        });
    })
    .ConfigureFunctionsWebApplication()
    .ConfigureServices(services =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();
    })

    .Build();

host.Run();