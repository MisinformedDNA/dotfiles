# Pulumi PowerShell Module
function p {
    for ($i = 0; $i -lt $args.Count; $i++) {
        if ($args[$i] -eq "sp") {
            $args[$i] = "--skip-preview"
        }
    }

    pulumi @args
}

function pd {
    p destroy @args
}

function pp {
    p preview @args
}

function pr {
    p refresh @args
}

function pu {
    p up @args
}

function pw {
    p watch @args
}

# Export functions so they're available when module is imported
Export-ModuleMember -Function p, pd, pp, pr, pu, pw
