# Usage: scoop reset <app>
# Summary: Reset an app to resolve conflicts
# Help: Used to resolve conflicts in favor of a particular app. For example,
# if you've installed 'python' and 'python27', you can use 'scoop reset' to switch between
# using one or the other.
param($app)

. "$($env:SCOOPDIR)\..\lib\core.ps1"
. "$($env:SCOOPDIR)\..\lib\manifest.ps1"
. "$($env:SCOOPDIR)\..\lib\help.ps1"
. "$($env:SCOOPDIR)\..\lib\install.ps1"
. "$($env:SCOOPDIR)\..\lib\versions.ps1"

reset_aliases

if(!$app) { 'ERROR: <app> missing'; my_usage; exit 1 }

if(!(installed $app)) { abort "$app isn't installed" }

$version = current_version $app
"resetting $app ($version)"

$dir = resolve-path (versiondir $app $version)
$manifest = installed_manifest $app $version

create_shims $manifest $dir $false
env_add_path $manifest $dir
env_set $manifest $dir