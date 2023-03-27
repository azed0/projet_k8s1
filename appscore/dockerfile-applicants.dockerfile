# Base image

FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim as base
WORKDIR /app



# Build image
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch as build
RUN mkdir src
WORKDIR /src
COPY ./Services/Applicants.Api Services/Applicants.Api
COPY ./Foundation/Events Foundation/Events
RUN dotnet restore /src/Services/Applicants.Api/applicants.api.csproj
COPY . .
WORKDIR /src/Services/Applicants.Api
RUN dotnet build "applicants.api.csproj" -c Release -o /app/build

# Publish image
FROM build as publish
RUN dotnet publish "applicants.api.csproj" -c Release -o /app/pub

# Final image
FROM base as final
EXPOSE 80
EXPOSE 443
WORKDIR /app
COPY --from=publish /app/pub .
ENTRYPOINT ["dotnet", "applicants.api.dll"]