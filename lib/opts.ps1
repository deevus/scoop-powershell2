# adapted from http://hg.python.org/cpython/file/2.7/Lib/getopt.py
# returns @(opts hash, rem_args array, error string)
function getopt($argv, $shortopts, $longopts) {
	$opts = @{}; $rem = @()

	function err($msg) {
		$opts, $rem, $msg
	}

	# ensure these are arrays
	$argv = @($argv)
	$longopts = @($longopts)

	for($i = 0; $i -lt $argv.length; $i++) {
		$arg = $argv[$i]

		if($arg.startswith('--')) {
			$name = $arg.substring(2)

			$longopt = $longopts | ? { $_ -match "^$name=?$" }

			if($longopt) {
				if($longopt.endswith('=')) { # requires arg
					if($i -eq $argv.length - 1) {
						return err "option --$name requires an argument"
					}
					$opts.$name = $argv[++$i]
				} else {
					$opts.$name = $true
				}
			} else {
				return err "option --$name not recognized"
			}
		} elseif($arg.startswith('-') -and $arg -ne '-') {
			for($j = 1; $j -lt $arg.length; $j++) {
				$letter = $arg[$j].tostring()

				if($shortopts -match "$letter`:?") {
					$shortopt = $matches[0]
					if($shortopt[1] -eq ':') {
						if($j -ne $arg.length -1 -or $i -eq $argv.length - 1) {
							return err "option -$letter requires an argument"
						}
						$opts.$letter = $argv[++$i]
					} else {
						$opts.$letter = $true
					}
				} else {
					return err "option -$letter not recognized"
				}
			}
		} else {
			$rem += $arg
		}
	}

	$opts, $rem
}