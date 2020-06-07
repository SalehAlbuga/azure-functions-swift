FROM swift:5.2-bionic-slim
LABEL MAINTAINER Saleh Albuga <salehalbuga@outlook.com>

RUN apt-get update && apt-get install -y \
    ca-certificates \
    # .NET Core dependencies
    #krb5-libs libgcc libintl libssl1.0 libstdc++ lttng-ust userspace-rcu zlib\
    build-essential \
    libkrb5-dev \
    libc6-dev  \
    libssl1.0-dev \
    libstdc++6 \
    liblttng-ust0 \
    tzdata \
    liburcu-dev \
    zlib1g-dev

# Configure web servers to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \
# Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
# Set the invariant mode since icu_libs isn't included (see https://github.com/dotnet/announcements/issues/20)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    HOME=/home \
    FUNCTIONS_WORKER_RUNTIME=swift \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

CMD ["/bin/true"]