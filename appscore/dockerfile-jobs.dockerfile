# Base image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim as base
WORKDIR /app
EXPOSE 80
EXPOSE 443



# Build image
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch as build
RUN mkdir src
WORKDIR /src
COPY ./Services/Jobs.Api Services/Jobs.Api
COPY ./Foundation/Events Foundation/Events
RUN dotnet restore /src/Services/Jobs.Api/jobs.api.csproj
COPY . .
WORKDIR /src/Services/Jobs.Api
RUN dotnet build "jobs.api.csproj" -c Release -o /app/build

# Publish image
FROM build as publish
RUN dotnet publish "jobs.api.csproj" -c Release -o /app/pub

# Final image
FROM base as final
WORKDIR /app
COPY --from=publish /app/pub .
EXPOSE 80
ENTRYPOINT ["dotnet", "jobs.api.dll"]