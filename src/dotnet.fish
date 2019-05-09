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
    find . -name '*.sln'    -not -path "*node_modules*" -type f | grep "sln" | sed 's/\.\///g'
end

function __projs
    find . -name '*.fsproj' -not -path "*node_modules*" -type f | grep "proj" | sed 's/\.\///g'
    find . -name '*.csproj' -not -path "*node_modules*" -type f | grep "proj" | sed 's/\.\///g'
    find . -name '*.sln'    -not -path "*node_modules*" -type f | grep "sln" | sed 's/\.\///g'
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
complete -fc dotnet -n 'dotnet_using_command watch'         -l  project -xa '(__projs)'

abbr --add daa "dotnet add"
abbr --add dnn "dotnet new"
abbr --add drr "dotnet restore"
abbr --add duu "dotnet run --project"
abbr --add dtt "dotnet test"
abbr --add dss "dotnet sln"
abbr --add dpp "dotnet pack"
abbr --add dbb "dotnet build"
abbr --add dcc "dotnet clean"
abbr --add dww "dotnet watch --project"

function d-project
    set -g __droot (pwd)
    cd (dirname $argv[1])
end

function d-root
    cd $__droot
end

function d-solution
    cd (dirname $argv[1])
end

function __dsolution_list
    mdfind -name ".sln"
end

function __dcake_list
    cat build.cake | grep  "Task" | grep -o '"[^"]\+"' | tr -d '"'
end

function d-cake
    dotnet cake build.cake -target=$argv[1] $argv[2]
end


complete -fc d-project   -xa '(__projs)'
complete -fc d-solution  -xa '(__dsolution_list)'
complete -fc d-cake      -xa '(__dcake_list)'


################## test ###########################

function d-test
    dotnet vstest $argv[1] /TestCaseFilter:"FullyQualifiedName~$argv[2]"
end

function __test_args1
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 1 ]
        return 0
    end
    return 1
end

function __test_args2
    set cmd (commandline -opc)
    if [ (count $cmd) -eq 2 ]
        return 0
    end
    return 1
end

function __dlls
    find . -name '*Tests.dll' | grep "bin" | grep "dll" | sed 's/\.\///g'
end

function __filters
    set cmd (commandline -opc)
    dotnet-filter (pwd)/$cmd[2]
end

complete -fc d-test -n '__test_args1'  -xa '(__dlls)'
complete -fc d-test -n '__test_args2'  -xa '(__filters)'
