FROM registry.suse.com/bci/dotnet-sdk:9.0 AS build-env
WORKDIR /app
RUN mkdir WebApp && \
    cd WebApp && \
    dotnet new webapp -n AspNetWebApp && \
    cd AspNetWebApp && \
    dotnet restore && \
    dotnet publish -c Release -o out

# Build the runtime image
FROM registry.suse.com/bci/dotnet-runtime:9.0
WORKDIR /app
COPY --from=build-env /app/WebApp/AspNetWebApp/out .
RUN zypper -n install dotnet-sdk-9.0
CMD ["dotnet", "AspNetWebApp.dll"]
