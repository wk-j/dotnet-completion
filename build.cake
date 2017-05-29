var sln = "App.sln";

Task("Build").Does(() => {
    DotNetCoreBuild(sln);
});

Task("Run").Does(() => {
    DotNetCoreRun(sln);
});

Task("Restore").Does(() => {
    DotNetCoreRestore(sln);
});

var target = Argument("target", "default");
RunTarget(target);