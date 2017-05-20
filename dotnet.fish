function _new_options
    find . -name "*.*"
end

complete -fc dotnet -xa '(__fish_complete_pids)'

complete -fc dotnet -a "new" -d "New project"
complete -fc dotnet -a "console" -n '__fish_contains_opt new' -d "Console"
complete -fc dotnet -a "restore"    -d "Restore packages"

complete -fc dotnet -a "-v --verbose"       -d "Enables verbose output"
complete -fc dotnet -a "-d --disgnostics"   -d "Enables diagonostic"

complete -c xxurl -a '(__fish_complete_file_url)'
complete -c xxpath -a '(__fish_complete_path)'
complete -c xxdir -a '(__fish_complete_directories)'

complete -c xxln -f -s t -l target-directory -xa "(__fish_complete_directories (commandline -ct) 'Target directory')" -d 'Specify the DIRECTORY in which to create the links'
