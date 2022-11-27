function gitaap {
 Param (
        [switch] $a = $false,
        $args
    )
<#
.SYNOPSIS
    Git amend to the latest commit

.DESCRIPTION
    Forgot something you wanted to add to the last commit? Run gitaap to quickly add + amend + push to the latest commit.

.NOTES
    Author: Gourav Goyal
    Website: https://gourav.io/blog/powershell
    Twitter: https://twitter.com/GorvGoyl
#>
  echo $args
  if($a){
    echo "> git add ."
    git add .
  }
  echo "> git commit --amend --no-edit"
  git commit --amend --no-edit

  echo "> git push --force"
  git push --force
}
