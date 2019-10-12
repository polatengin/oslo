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

namespace user_service
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

            app.Map("", builder =>
            {
                builder.Run(async context =>
                {
                    var userList = Enumerable.Range(1, random.Next(5, 15)).Select(index => new
                    {
                        BirthDate = DateTime.Now.AddDays(index),
                        Salary = ((random.NextDouble() * 100000) + 50000).ToString ("0.##"),
                        Name = words[random.Next(words.Length)] + " " + words[random.Next(words.Length)],
                        ProfilePictureUrl = "https://i.pravatar.cc/50?" + random.Next(1, 1000)
                    });

                    await JsonSerializer.SerializeAsync(context.Response.Body, userList);
                });
            });
        }
    }
}
