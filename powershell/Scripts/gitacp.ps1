function gitacp {
<#
.SYNOPSIS
    Git add, commit, push with a single command

.NOTES
    Author: Gourav Goyal
    Website: https://gourav.io/blog/powershell
    Twitter: https://twitter.com/GorvGoyl
#>

  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
  echo "> git add ."
  git add .

  echo "> git commit -a -m "$message""
  git commit -a -m "$message"

  echo "> git push"
  git push
}