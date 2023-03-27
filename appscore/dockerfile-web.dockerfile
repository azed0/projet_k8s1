# Base image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim as base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build image
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch as build
RUN mkdir src
WORKDIR /src
COPY ./Web /src/Web
COPY ./Foundation/Http /src/Foundation/Http
RUN dotnet restore /src/Web/Web.csproj
COPY . .
WORKDIR /src/Web
RUN dotnet build "Web.csproj" -c Release -o /app/build

# Publish image
FROM build as publish
RUN dotnet publish "Web.csproj" -c Release -o /app/pub

# Final image
FROM base as final
WORKDIR /app
COPY --from=publish /app/pub .
ENTRYPOINT ["dotnet", "Web.dll"]