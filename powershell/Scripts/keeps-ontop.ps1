function keep_powershell_ontop {
 <#
.SYNOPSIS
    Force Powershell's window(s) to be always on top.

.NOTES
    Author:  François-Xavier Cat 
    Source: https://gist.github.com/lazywinadmin/7e4ac3cd86eedda7427f
    
#>
  
$signature = @'
[DllImport("user32.dll")] 
public static extern bool SetWindowPos( 
    IntPtr hWnd, 
    IntPtr hWndInsertAfter, 
    int X, 
    int Y, 
    int cx, 
    int cy, 
    uint uFlags); 
'@
  
$type = Add-Type -MemberDefinition $signature -Name SetWindowPosition -Namespace SetWindowPos -Using System.Text -PassThru

$handle = (Get-Process -id $Global:PID).MainWindowHandle 
$alwaysOnTop = New-Object -TypeName System.IntPtr -ArgumentList (-1) 
$type::SetWindowPos($handle, $alwaysOnTop, 0, 0, 0, 0, 0x0003)

}

function keeps-ontop{
    if(keep_powershell_ontop){
        echo "I am top."
        # todo: randomize an echo
    }else{
        echo "I am bottom."
    }
}