## Setup on minikube environment

https://minikube.sigs.k8s.io/docs/start/

- TODO Add notes on how to setup for WSL2

#### Windows Setup

```
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
```

#### Add minikube to $PATH

```
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)
if ($oldPath.Split(';') -inotcontains 'C:\minikube'){ `
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine) `
}
```

#### Start minikube cluster - this command will build you a minikube container in docker engine for windows. 
```
minikube start
```

#### Launch GUI Dashboard
```
minikube dashboard
```
