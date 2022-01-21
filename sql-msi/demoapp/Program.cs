using demoapp.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddRouting(options => options.LowercaseUrls = true);

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<BloggingContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("BloggingContext"), 
        sqlOptions =>
        {
            sqlOptions.CommandTimeout(2);
        });
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<BloggingContext>();
    var pendingMigrations = context.Database.GetPendingMigrations().ToList();
    foreach (var pendingMigration in pendingMigrations)
    {
        Console.WriteLine($"Pending Migration: {pendingMigration}");
    }

    if (pendingMigrations.Any())
        throw new InvalidOperationException("There are Pending Migrations, Shutting Down.");
}

app.Run();