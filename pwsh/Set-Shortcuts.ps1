function pl {
	pulumi @args
}

function pp {
	pulumi preview @args
}

function prp {
	pulumi refresh @args
}

function pr {
	pulumi refresh --skip-preview -y @args
}

function pu {
	pulumi up --skip-preview -y @args
}
