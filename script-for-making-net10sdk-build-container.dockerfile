# download the latest compatible windows server core images
FROM mcr.microsoft.com/windows/servercore:20H2

# configure powershell to be shell sink to execute silently
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# create a working directory
RUN mkdir dependencies

# create a source-repository
WORKDIR /dependencies

# download the installer for .net framework
RUN Invoke-WebRequest -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile /dependencies/dotnet-install.ps1

#switching to TLS12
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

# installing the .NET SDK with 
RUN ./dotnet-install.ps1 -Version '10.0.102' -InstallDir 'C:\dotnet'

# Manually update the PATH so 'dotnet' can be called globally
RUN $newPath = 'C:\dotnet;' + [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine)

#setting the env path    
RUN [Environment]::SetEnvironmentVariable('PATH', $newPath, [EnvironmentVariableTarget]::Machine)

# Set the environment variable for .NET
ENV DOTNET_ROOT="C:\dotnet"

# Verify installation
RUN dotnet --version