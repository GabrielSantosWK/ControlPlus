using Microsoft.EntityFrameworkCore;
using FrontendWebAspMVC.Context;
using Microsoft.Extensions.Configuration;
using FrontendWebAspMVC.Repositories.Interfaces;
using FrontendWebAspMVC.Repositories;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<ControlPlusContext>(opt => opt.UseNpgsql(builder.Configuration.GetConnectionString("Default")));
// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddTransient<ILancamentosRepository,LancamentosRepository>();
builder.Services.AddTransient<ICartoesRepository, CartoesRepository>();
builder.Services.AddTransient<IBancosRepository, BancosRepository>();
builder.Services.AddTransient<IDependentesRepository, DependentesRepository>();
builder.Services.AddTransient<IOperacoesRepository, OperacoesRepository>();
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
