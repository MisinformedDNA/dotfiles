[Environment]::SetEnvironmentVariable("PULUMI_SKIP_UPDATE_CHECK", $newpath, "User")

function p {
	pulumi @args
}

function pd {
	pulumi destroy @args
}
function pl {
	pulumi @args
}

function pp {
	pulumi preview @args
}

function pr {
	pulumi refresh @args
}

function pu {
	pulumi up @args
}
