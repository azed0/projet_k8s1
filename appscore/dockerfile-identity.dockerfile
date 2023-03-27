# Base image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim as base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build image
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch as build
WORKDIR /src
COPY ./Services/Identity.Api Services/Identity.Api
COPY ./Foundation/Events Foundation/Events
RUN dotnet restore /src/Services/Identity.Api/Identity.Api.csproj
COPY . .
WORKDIR /src/Services/Identity.Api
RUN dotnet build "Identity.Api.csproj" -c Release -o /app/build

# Publish image
FROM build as publish
RUN dotnet publish "Identity.Api.csproj" -c Release -o /app/pub

# Final image
FROM base as final
WORKDIR /app
COPY --from=publish /app/pub .
EXPOSE 80
ENTRYPOINT ["dotnet", "Identity.Api.dll"]