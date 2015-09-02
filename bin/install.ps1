# remote install:
#   iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
$erroractionpreference='stop' # quit if anything goes wrong

# get core functions
$core_url = 'https://raw.github.com/deevus/scoop-powershell2/master/lib/core.ps1'
echo 'initializing...'
iex (new-object net.webclient).downloadstring($core_url)

# prep
if(installed 'scoop') {
  write-host "scoop is already installed. run 'scoop update' to get the latest version." -f red
  # don't abort if invoked with iex——that would close the PS session
  if($myinvocation.commandorigin -eq 'Internal') { return } else { exit 1 }
}
$dir = ensure (versiondir 'scoop' 'current')

# download scoop zip
$zipurl = 'https://github.com/deevus/scoop-powershell2/archive/master.zip'
$zipfile = "$dir\scoop.zip"
echo 'downloading...'
dl $zipurl $zipfile

'extracting...'
unzip $zipfile "$dir\_scoop_extract"
cp "$dir\_scoop_extract\scoop-powershell2-master\*" $dir -r -force
rm "$dir\_scoop_extract" -r -force
rm $zipfile

echo 'getting json libraries...'
$jqDlUrl = "https://github.com/stedolan/jq/releases/download/jq-1.4/jq-win32.exe"
$jqDir = ensure (libdir "jq")
echo 'downloading jq...'
dl $jqDlUrl "$jqDir\jq.exe"

$ctDlUrl = "http://nuget.org/api/v2/package/codetitans-json/1.8.3"
$ctZipFile = "$dir\json.zip"
$ctDir = ensure (libdir "codetitans-json")
echo 'downloading codetitans-json...'
dl $ctDlUrl $ctZipFile
echo 'extracting codetitans-json...'
unzip $ctZipFile "$dir\_json_extract"
cp "$dir\_json_extract\lib\net20\*" $ctDir -r -force
rm "$dir\_json_extract" -r -force
rm $ctZipFile

echo 'creating shims...'
shim "$dir\bin\scoop.ps1" $false
shim "$jqDir\jq.exe" $false "jq-1.4"

ensure_robocopy_in_path
ensure_scoop_in_path

$null = scoop config SCOOP_BRANCH master
$null = scoop config SCOOP_REPO "https://github.com/deevus/scoop-powershell2/"

success 'scoop was installed successfully!'
echo "type 'scoop help' for instructions"
