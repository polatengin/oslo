FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build

WORKDIR /src

COPY . .

RUN dotnet restore

RUN dotnet publish -c release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:3.0

WORKDIR /app

COPY --from=build /app .

EXPOSE 80

ENTRYPOINT ["dotnet", "product-service.dll"]
