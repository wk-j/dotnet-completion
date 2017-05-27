function dotnet_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
  return 1
end

function dotnet_needs_command
    set cmd (commandline -opc)

    if [ (count $cmd) -eq 1 ]
        return 0
    end

    return 1
end

function __slns
    find . -name '*.sln'  | grep "sln" | sed 's/\.\///g'
end

function __projs
    find . -name '*.fsproj'  | grep "proj" | sed 's/\.\///g'
    find . -name '*.csproj'  | grep "proj" | sed 's/\.\///g'
    find . -name '*.sln'  | grep "sln" | sed 's/\.\///g'
    #find $PWD -name '*.fsproj'
    #find $PWD -name '*.csproj'
    #find $PWD -name '*.sln'
end


complete -fc dotnet -n 'dotnet_using_command xxx' -a '(__test)'

complete -fc dotnet -n 'dotnet_needs_command' -a new        -d 'Initialize .NET projects'
complete -fc dotnet -n 'dotnet_needs_command' -a restore    -d 'Restore dependencies specified in the .NET project'
complete -fc dotnet -n 'dotnet_needs_command' -a build      -d 'Build a .NET projects'
complete -fc dotnet -n 'dotnet_needs_command' -a publish    -d 'Publishes a .NET project for deployment (including the runtime)'
complete -fc dotnet -n 'dotnet_needs_command' -a run        -d 'Compiles and immediately executes a .NET project'
complete -fc dotnet -n 'dotnet_needs_command' -a test       -d 'Run unit tests uing the test runner specified in the project'
complete -fc dotnet -n 'dotnet_needs_command' -a pack       -d 'Creates a NuGet package'
complete -fc dotnet -n 'dotnet_needs_command' -a migrate    -d 'Migrates a project.json based project to msbuild based project'
complete -fc dotnet -n 'dotnet_needs_command' -a clean      -d 'Clean build output(s)'
complete -fc dotnet -n 'dotnet_needs_command' -a sln        -d 'Modify solution (SLN) files'

for app in 'console' 'classlib' 'mstest' 'xunit' 'web' 'mvc' 'webapi' 'sln'
    complete -fc dotnet -n 'dotnet_using_command new'           -xa $app  
    complete -fc dotnet -n 'dotnet_using_command new $app'      -l output   -xa '(__fish_complete_directories (commandline -ct))'
    complete -fc dotnet -n 'dotnet_using_command new $app'      -l language -xa 'F# C#'
end


#################### solution ##########################

function sln_select_solution
    if not dotnet_using_command sln 
        return 1
    end

    set cmd (commandline -opc)
    if [ (count $cmd) = 2 ]
        if not dotnet_using_command sln 
            return 1
        else
            return 0
        end
    else
        return 1
    end
end

function sln_select_action

    if not dotnet_using_command sln 
        return 1
    end

    set cmd (commandline -opc)

    if [ (count $cmd) -eq 3 ]
        return 0
    else
        return 1
    end

    if not _select_solution
        return 0
    else 
        return 1
    end
end

function sln_select_project 
    if not dotnet_using_command sln 
        return 1
    end

    set cmd (commandline -opc)
    if [ (count $cmd) -eq 4 ]
        if [ $cmd[4] = "add" ]
            return 0
        else if [ $cmd[4] = "remove" ]
            return 0
        else
            return 1
        end
    else
        return 1
    end
end

complete -fc dotnet -n 'sln_select_action'              -xa 'add'
complete -fc dotnet -n 'sln_select_action'              -xa 'remove'
complete -fc dotnet -n 'sln_select_solution'            -xa '(__slns)'
complete -fc dotnet -n 'sln_select_project'             -xa '(__projs)'


#################### add ##########################
function add_select_project1
    if not dotnet_using_command add
        return 1
    end

    set cmd (commandline -opc)
    if [ (count $cmd) -eq 2 ]
        return 0
    else
        return 1
    end
end

function add_select_type
    if not dotnet_using_command add
        return 1
    end

    set cmd (commandline -opc)
    if [ (count $cmd) -eq 3 ]
        return 0
    end

    return 1
end

function add_select_project2
    if not dotnet_using_command add
        return 1
    end

    set cmd (commandline -opc)
    if [ (count $cmd) -eq 4 ]
        if [ $cmd[4] = "reference" ]
            return 0
        end
    end
    return 1
end

# dotnet add .proj reference .proj

complete -fc dotnet -n 'add_select_project1'           -xa '(__projs)'
complete -fc dotnet -n 'add_select_type'               -xa 'package reference'
complete -fc dotnet -n 'add_select_project2'           -xa '(__projs)'

#################### new ##########################

complete -fc dotnet -n 'dotnet_using_command new'       -l name 

complete -fc dotnet -n 'dotnet_using_command build'         -xa '(__projs)' 
complete -fc dotnet -n 'dotnet_using_command restore'       -xa '(__projs)'
complete -fc dotnet -n 'dotnet_using_command run'           -l  project -xa '(__projs)'
complete -fc dotnet -n 'dotnet_using_command clean'         -xa '(__projs)'
complete -fc dotnet -n 'dotnet_using_command pack'          -l  output  -xa '(__fish_complete_directories (commandline -ct))' 
complete -fc dotnet -n 'dotnet_using_command pack'          -xa '(__projs)'
complete -fc dotnet -n 'dotnet_using_command test'          -xa '(__projs)'

abbr --add daa "dotnet add"
abbr --add dnn "dotnet new"
abbr --add drr "dotnet restore"
abbr --add duu "dotnet run --project"
abbr --add dtt "dotnet test"
abbr --add dss "dotnet sln"
abbr --add dpp "dotnet pack"
abbr --add dbb "dotnet build"
abbr --add dcc "dotnet clean"

# complete -c dotnet -s m -d 'Run library module as a script (terminates option list)' -xa '(python -c "import pkgutil; print(\'\n\'.join([p[1] for p in pkgutil.iter_modules()]))")'