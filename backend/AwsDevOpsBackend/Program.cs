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
        SecretId = "aws-devops-sample/rds"
    });

// Parse the secret as JSON without forcing every value to be a string
using var secretJson = JsonDocument.Parse(secretResponse.SecretString!);

var username = secretJson.RootElement
    .GetProperty("username")
    .GetString();

var password = secretJson.RootElement
    .GetProperty("password")
    .GetString();

var connectionString =
    $"Host=aws-devops-sample-db.c5qas24gk1y5.ap-southeast-2.rds.amazonaws.com;" +
    $"Port=5432;" +
    $"Database=awsdevopsdb;" +
    $"Username={username};" +
    $"Password={password};";

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