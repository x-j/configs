
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode RegEx

;MSI ps65: shift+win+left/right is shift+home/end
;#<+Left::
;Send +{Home}
;Return
;
;#<+Right::
;Send +{End}
;Return


;MSI ps65: alt+f3 is alt+f4
!F3::
Send !{F4}
Return

;win+s is win+space
#S::
Send #{Space}
Return

;TUTAJ JEST MEDIA NEXT/PREV PLAY PAUSE NA NUM KLAWISZACH

#XButton2::
#Numpad6::
SendInput, {Media_Next}
Return
#XButton1::
#Numpad4::
SendInput, {Media_Prev}
Return
#MButton::
#Numpad5::
SendInput, {Media_Play_Pause}
Return

;TUTAJ JEST VOL UP/DOWN NA WIN+[-+]

#=::
SendInput, {Volume_Up}
Return
#-::
SendInput, {Volume_Down}
Return
#0::
SendInput, {Volume_Mute}
Return


;TUTAJ JEST PLAYPAUSE VLC
SendToWindows(objWindows, key)
{
    for index, winID in objWindows
    {
        ControlSend,, %key%, ahk_id %winID%
    }
}

^Numpad5::
if WinActive, VLC media player
{
winget, winList, list, ahk_exe vlc.exe
oWinList := object()
loop, % winlist
	{
	oWinList.push(winlist%A_Index%)
	}
SendToWindows(oWinList, Space)
}
Return


;OTO JEST HOME I END NA ARROW STRZAŁKACH (dla MSI gs63)
; Home and End by using arrow keys + Fn (only for MSI gs63)

SC12E:: ; Replace 12E with your key's value.
Send {Home}
return

+SC12E::
Send +{Home}
return

SC130::
Send {End}
return

+SC130::
Send +{End}
return

;OTO JEST CONTEXT MENU POD \ TYM OBOK SPACJI
;WORKS ON MSI gs63 AND (somewhat) on ps65
VKE2::
Send {AppsKey}
return

+SC056::
Send +{AppsKey}
return


;OTO JEST PROTEZA KTÓRA SPRAWIA ZE LEWY Fn PONIEKAD DZIALA JAK Win

SC075 & d::
Send #d
return


;oto jest Ctrl+Capslock as enter

^Capslock::
Send {enter}
return

;OTO JEST GOOGLE MAGIA
; disable Xbox game bar in order to use this

#g::    ; <-- Google Web Search Using Highlighted Text (Win+G)
   Search := 1
   Gosub Google
return

^#g::    ; <-- Google Image Search Using Highlighted Text (Win+Ctrl+G)
   Search := 2
   Gosub Google
return

!#g::    ; <-- Google Map Search Using Highlighted Text (Win+Alt+G)
   Search := 3
   Gosub Google
return

; OTO JEST ROZSZERZENIE POWYŻSZEGO BY YOUTUBE TEŻ
#y::
   Search = 4
   Gosub Google
return

Google:
   Save_Clipboard := ClipboardAll
   Clipboard := ""
   Send ^c
   ClipWait, .5
   if !ErrorLevel
      Query := Clipboard
   else
      InputBox, Query, Google Search, , , 200, 100, , , , , %Query%
   Query := UriEncode(Trim(Query))
   if (Search = 1)
      Address := "https://duckduckgo.com/?q=" Query ; Web Search
   else if (Search = 2)
      Address := "https://duckduckgo.com/?iax=images&ia=images&q=" Query ; Image Search
   else if (Search = 3)
      Address := "http://www.google.com/maps/search/" Query ; Map Search
   else if (Search = 4)
      Address := "https://www.youtube.com/results?search_query=" Query ; youtube search
   Run, firefox.exe %Address%  ; Change this if require different browser search
   WinActivate, Firefox
   Clipboard := Save_Clipboard
   Save_Clipboard := ""
return

Firefox:
   Save_Clipboard := ClipboardAll
   Clipboard := ""
   Send ^c
   ClipWait, .5
   if !ErrorLevel
      Address := Clipboard
   else
      InputBox, Address, Firefox URL..., , , 200, 100, , , , , %Address%
   Address := UriEncode(Trim(Address))
   Run, firefox.exe %Address%  ;
   WinActivate, Firefox
   Clipboard := Save_Clipboard
   Save_Clipboard := ""
return

UriEncode(Uri)
{
   VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0)
   StrPut(Uri, &Var, "UTF-8")
   f := A_FormatInteger
   Res := ""
   SetFormat, IntegerFast, H
   While Code := NumGet(Var, A_Index - 1, "UChar")
      If (Code >= 0x30 && Code <= 0x39 ; 0-9
         || Code >= 0x41 && Code <= 0x5A ; A-Z
         || Code >= 0x61 && Code <= 0x7A) ; a-z
         Res .= Chr(Code)
      Else
         Res .= "%" . SubStr(Code + 0x100, -1)
   SetFormat, IntegerFast, %f%
   Return, Res
}
return

;OTO JEST firefox otwierajacy link pod Win+F
#f::
	Gosub Firefox
return

;OTO JEST Powershell pod Win+A
#a::
	Run powershell
   WinActivate, "ahk_exe powershell.exe"
return


;OTO JEST szybki paint 
;~ ^PrintScreen::
	;~ Send, {PrintScreen}
	;~ Run mspaint
	;~ ControlFocus, ,,Paint
	;~ Sleep, 500
	;~ Send ^v
	;~ return

;~ !^PrintScreen::
	;~ Send, !{PrintScreen}
	;~ Run mspaint
	;~ ControlFocus, ,,Paint
	;~ Sleep, 500
	;~ Send ^v
	;~ return
    
!^v::
   Run mspaint
   while !WinActive("Paint"){
      Sleep, 10
   } 
   WinActivate, "Paint"
   Send ^v
   return
