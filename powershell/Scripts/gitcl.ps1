function gitcl {
    Param (
        [Parameter(Mandatory = $true)]
        [string]$url,
    
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [string[]]
        $args
    )

    $cwd = Convert-Path .
    
    $token = cat $env:GITOKEN
    
    if(-not($url -like "https://github.com*" -or $url.EndsWith(".git"))){
        $username = git config --global --get user.name
        $url = "https://github.com/" + $username + "/" + $url
    }
    if(-not $url.StartsWith("https://")){
        $url = "https://" + $url
    }
    if(-not $url.EndsWith(".git")){
        $url += ".git"           
    }
    if($url.Length -lt 8  -or -not($url -like "*github.com*")){
        echo "Provided url has an unexpected format. Trying to clone anyway..."
    }else{
        if($url -imatch $username) {
            $url = "https://$($token)@$($url.Substring(8))"
        }
    }

    $exprstr = "git clone $($url) $args"
    Invoke-Expression $exprstr
    
}