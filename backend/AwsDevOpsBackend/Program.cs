using Amazon.SecretsManager;
using Amazon.SecretsManager.Model;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

// Create Secrets Manager client using the EC2 IAM role
var secretsClient = new AmazonSecretsManagerClient();

var secretResponse = await secretsClient.GetSecretValueAsync(
    new GetSecretValueRequest
    {
        SecretId = "aws-devops-terraform/rds"
    });

// Parse the RDS connection details from Secrets Manager
using var secretJson = JsonDocument.Parse(secretResponse.SecretString!);

var root = secretJson.RootElement;

var username = root.GetProperty("username").GetString();
var password = root.GetProperty("password").GetString();
var host = root.GetProperty("host").GetString();
var port = root.GetProperty("port").GetInt32();
var database = root.GetProperty("database").GetString();

var connectionString =
    $"Host={host};" +
    $"Port={port};" +
    $"Database={database};" +
    $"Username={username};" +
    $"Password={password};" +
    $"Ssl Mode=Require;";

app.MapGet("/api/products", async () =>
{
    var products = new List<object>();

    await using var connection =
        new Npgsql.NpgsqlConnection(connectionString);

    await connection.OpenAsync();

    await using var command =
        new Npgsql.NpgsqlCommand(
            "SELECT id, name, price FROM products ORDER BY id",
            connection);

    await using var reader = await command.ExecuteReaderAsync();

    while (await reader.ReadAsync())
    {
        products.Add(new
        {
            Id = reader.GetInt32(0),
            Name = reader.GetString(1),
            Price = reader.GetDecimal(2)
        });
    }

    return Results.Ok(products);
});

app.Run();
