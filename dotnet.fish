function ___fish_npm_using_command
    set cmd (commandline -opc)

    if [ (count $cmd) -gt 1 ]
        if [ $argv[1] = $cmd[2] ]
            return 0
        end
    end

    return 1
end

function __fish_npm_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function __fish_npm_needs_option
    switch (commandline -ct)
        case "-*"
            return 0
    end
    return 1
end

function __fish_npm_needs_command
    set cmd (commandline -opc)

    if [ (count $cmd) -eq 1 ]
        return 0
    end

    return 1
end


complete -fc dotnet -n '__fish_npm_needs_command' -a new        -d 'Initialize .NET projects'
complete -fc dotnet -n '__fish_npm_needs_command' -a restore    -d 'Restore dependencies specified in the .NET project'
complete -fc dotnet -n '__fish_npm_needs_command' -a build      -d 'Build a .NET projects'
complete -fc dotnet -n '__fish_npm_needs_command' -a publish    -d 'Publishes a .NET project for deployment (including the runtime)'
complete -fc dotnet -n '__fish_npm_needs_command' -a run        -d 'Compiles and immediately executes a .NET project'
complete -fc dotnet -n '__fish_npm_needs_command' -a test       -d 'Run unit tests uing the test runner specified in the project'
complete -fc dotnet -n '__fish_npm_needs_command' -a pack       -d 'Creates a NuGet package'
complete -fc dotnet -n '__fish_npm_needs_command' -a migrate    -d 'Migrates a project.json based project to msbuild based project'
complete -fc dotnet -n '__fish_npm_needs_command' -a clean      -d 'Clean build output(s)'
complete -fc dotnet -n '__fish_npm_needs_command' -a sln        -d 'Modify solution (SLN) files'

for app in 'console' 'classlib' 'mstest' 'xunit' 'web' 'mvc' 'webapi' 'sln'
    complete -fc dotnet -n '__fish_npm_using_command new' -a $app  
end

function projs
    find $PWD -name '*.fsproj'
    find $PWD -name '*.csproj'
    find $PWD -name '*.sln'
end

complete -fc dotnet -n '__fish_npm_using_command build'         -a '(projs)' 
complete -fc dotnet -n '__fish_npm_using_command restore'       -a '(projs)'
complete -fc dotnet -n '__fish_npm_using_command run'           -l  project  -xa '(projs)'
complete -fc dotnet -n '__fish_npm_using_command -l project'    -a '(projs)'
complete -fc dotnet -n '__fish_npm_using_command clean'         -a '(projs)'
complete -fc dotnet -n '__fish_npm_using_command pack'          -a '(projs)'
complete -fc dotnet -n '__fish_npm_using_command test'          -a '(projs)'

# complete -fc dotnet -n '__fish_npm_using_command'         -xa '(projs)'

complete -c dotnet -s m -d 'Run library module as a script (terminates option list)' -xa '(python -c "import pkgutil; print(\'\n\'.join([p[1] for p in pkgutil.iter_modules()]))")'