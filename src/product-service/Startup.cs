using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace product_service
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services) { }

        string[] words = {"lorem", "ipsum", "dolor", "sit", "amet", "consectetuer", "adipiscing", "elit", "sed", "diam", "nonummy", "nibh", "euismod", "tincidunt", "ut", "laoreet", "dolore", "magna", "aliquam", "erat"};
        Random random = new Random();

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.Map("", builder =>
            {
                builder.Run(async context =>
                {
                    var productList = Enumerable.Range(1, random.Next(5, 15)).Select(index => new
                    {
                        Date = DateTime.Now.AddDays(index),
                        Price = (random.NextDouble() * 100).ToString ("0.##"),
                        StockCount = random.Next(-20, 55),
                        Name = words[random.Next(words.Length)],
                        IconUrl = "https://picsum.photos/50" + (random.NextDouble() > 0.5 ? "?grayscale" : "?color") + "&" + random.Next(1, 1000)
                    });

                    await JsonSerializer.SerializeAsync(context.Response.Body, productList);
                });
            });
        }
    }
}
