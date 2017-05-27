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

function __slns
    find $PWD -name '*.sln'
end

function __projs
    find $PWD -name '*.fsproj'
    find $PWD -name '*.csproj'
    find $PWD -name '*.sln'
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
    complete -fc dotnet -n '__fish_npm_using_command new'           -xa $app  
    complete -fc dotnet -n '__fish_npm_using_command new $app'      -l output   -xa '(__fish_complete_directories (commandline -ct))'
    complete -fc dotnet -n '__fish_npm_using_command new $app'      -l language -xa 'F# C#'
end

complete -fc dotnet -n '__fish_npm_using_command sln'           -xa '(__slns)'
complete -fc dotnet -n '__fish_npm_using_command sln'           -xa add
complete -fc dotnet -n '__fish_npm_using_command sln'           -xa remove
complete -fc dotnet -n '__fish_npm_using_command sln add'       -xa '(__projs)'
complete -fc dotnet -n '__fish_npm_using_command sln remove'    -xa '(__projs)'

complete -fc dotnet -n '__fish_npm_using_command add'           -xa '(__projs)'
complete -fc dotnet -n '__fish_npm_using_command add'           -xa 'package reference'
complete -fc dotnet -n '__fish_npm_using_command add'           -xa '(__projs)'

complete -fc dotnet -n '__fish_npm_using_command new sln'       -l name 

complete -fc dotnet -n '__fish_npm_using_command build'         -xa '(__projs)' 
complete -fc dotnet -n '__fish_npm_using_command restore'       -xa '(__projs)'
complete -fc dotnet -n '__fish_npm_using_command run'           -l  project -xa '(__projs)'
complete -fc dotnet -n '__fish_npm_using_command clean'         -xa '(__projs)'
complete -fc dotnet -n '__fish_npm_using_command pack'          -l  output  -xa '(__fish_complete_directories (commandline -ct))' 
complete -fc dotnet -n '__fish_npm_using_command pack'          -xa '(__projs)'
complete -fc dotnet -n '__fish_npm_using_command test'          -xa '(__projs)'

abbr --add daa "dotnet add"
abbr --add dnn "dotnet new"
abbr --add drr "dotnet restore"
abbr --add duu "dotnet run --project"
abbr --add dtt "dotnet test"
abbr --add dss "dotnet sln"
abbr --add dpp "dotnet pack"
abbr --add dbb "dotnet build"

# complete -c dotnet -s m -d 'Run library module as a script (terminates option list)' -xa '(python -c "import pkgutil; print(\'\n\'.join([p[1] for p in pkgutil.iter_modules()]))")'