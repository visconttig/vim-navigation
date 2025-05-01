;================================================
; COPY SCRIPT TO StartUp FOLDER FOR AUTORUNNING
;put this line near the top of your script: 
    FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir% 
;=============================================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Global variables
inputNumber := " "
lastCommand = {ShiftDown}{ShiftUp}

; -------------------------------------------------------------
;    Make sure native Ctrl+X/C/V never get eaten by other hotkeys
; -------------------------------------------------------------
#If !WinExist("VIM-Mode Activated")
~^x::SendInput ^x
~^c::SendInput ^c
~^v::SendInput ^v
#If



; Notification GUI {{{
notify(text, time = 2000)
{
    #IfWinExist VIM-Mode commands
        resetGUI()
    #IfWinExist
    ; Set the flags for OSD
    Gui, 90:+AlwaysOnTop -Caption +ToolWindow +Disabled -SysMenu +Owner
    ; Add and set the OSD Text
    Gui, 90:Font, s10 bold
    Gui, 90:Add, Text, cAA0000, %text%
    ; OSD Background Color (Black)
    Gui, 90:Color, 000000
    Gui, 90:Show,NoActivate xCenter yCenter, VIM-Mode commands
    Sleep, %time%
    Gui, 90:Destroy
    return
} ;}}}

; HotKey to Initiate VI-mode with Double-tap of Esc {{{
$Esc::
    If (A_PriorHotKey = "$Esc" AND A_TimeSincePriorHotKey < 500)
    {
        ; Set the flags for OSD
        Gui, 99:+AlwaysOnTop -Caption +ToolWindow +Disabled -SysMenu +Owner
        ; Add and set the OSD Text
        Gui, 99:Font, s15 bold
        Gui, 99:Add, Text, cAA0000, VI-NORMAL
        ; OSD Background Color (Black)
        Gui, 99:Color, 000000
        Gui, 99:Show,NoActivate x25 y125, VIM-Mode Activated
    }
    Else
    {
        SendInput {Esc}
    }
Return ; }}}

;--------------------------------------------------------------------------
;  - Uses `~Ctrl::` so Ctrl always passes through natively
;  - Only runs the “activate VI-mode” code when you double-tap Ctrl quickly
;
;–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
; Double-tap Ctrl on KEY-UP, not key-down, so holds don’t repeat
;–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
~Ctrl Up::
    ; only trigger if the *previous* Up was also Ctrl Up
    ; and happened under 500 ms ago, with no other modifiers
    if (A_PriorHotkey = "~Ctrl Up"
        && A_TimeSincePriorHotkey < 500
        && !GetKeyState("Shift","P")
        && !GetKeyState("Alt","P")
        && !GetKeyState("LWin","P")
        && !GetKeyState("RWin","P"))
    {
        Gui, 99:+AlwaysOnTop -Caption +ToolWindow +Disabled -SysMenu +Owner
        Gui, 99:Font, s14 w800, Arial
        Gui, 99:Add, Text, cff0005, VIM Mode
        Gui, 99:Color, 000000
        Gui, 99:Show,NoActivate x1625 y125, VIM-Mode Activated
    }
Return


; }}}

#IfWinExist VIM-Mode Activated ; {{{

    ; ESC ends VIM-mode
    ESC:: 
    {
        if (inputNumber != " ")
        {
            resetInputNumber()
            return
        }
        else
        {
            endVIM()
            return
        }
    }

        ; CTRL ends VIM-mode
        CTRL:: 
        {
            if (inputNumber != " ")
            {
                resetInputNumber()
                return
            }
            else
            {
                endVIM()
                return
            }
        }

    ; i(nput) end VIM-mode
    i::
    {
        endVIM()
        return
    }

    ; Other input modes ...
    +i::
    {
        SendInput {Home}
        endVIM()
        return
    }
    a::
    {
        SendInput {Right}
        endVIM()
        return
    }
    +a::
    {
        SendInput {End}
        endVIM()
        return
    }

    ; cursor movements
    h::
    {
        SendInput {Left %inputNumber%}
        resetInputNumber()
        return
    }
    j::
    {
        SendInput {Down %inputNumber%}
        resetInputNumber()
        return
    }
    k::
    {
        SendInput {Up %inputNumber%}
        resetInputNumber()
        return
    }
    l::
    {
        SendInput {Right %inputNumber%}
        resetInputNumber()
        return
    }

    ; ; page movements
    w::
    {
        SendInput ^{Right %inputNumber%}
        resetInputNumber()
        return
    }
    b::
    {
        SendInput ^{Left %inputNumber%}
        resetInputNumber()
        return
    }
    x::
    {
        lastCommand = {Delete %inputNumber%}
        SendInput, %lastCommand%
        resetInputNumber()
        return
    }
    >::
    {
        lastCommand = {ShiftDown}{LeftArrow}{LeftArrow}{RightArrow}{ShiftUp}{Tab}{Esc}
        SendInput, %lastCommand%
        resetInputNumber()
        return
    }
    <::
    {
        lastCommand = {ShiftDown}{LeftArrow}{LeftArrow}{RightArrow}{ShiftUp}{ShiftDown}{Tab}{ShiftUp}{Esc}
        SendInput, %lastCommand%
        resetInputNumber()
        return
    }
    0:: ; Add to the inputNumber if inputNumber != null, otherwise HOME
    {
        if (inputNumber != " ")
        {
            inputNumber = %inputNumber%0
            normalize(0)
            notify(inputNumber)
            return
        }
        else
        {
            SendInput {Home}
            resetInputNumber()
            return
        }
    }
    -::
    {
        SendInput {End}
        resetInputNumber()
        return
    }
    $::
    {
        SendInput {End}
        resetInputNumber()
        return
    }

    ; repeat
    .::
    {
        SendInput, %lastCommand%
        resetInputNumber()
        return
    }

    ; selection movements with Shift
    +h::
    {
        SendInput +{Left %inputNumber%}
        resetInputNumber()
        return
    }
    +j::
    {
        SendInput +{Down %inputNumber%}
        resetInputNumber()
        return
    }
    +k::
    {
        SendInput +{Up %inputNumber%}
        resetInputNumber()
        return
    }
    +l::
    {
        SendInput +{Right %inputNumber%}
        resetInputNumber()
        return
    }
    +w::
    {
        SendInput +^{Right %inputNumber%}
        resetInputNumber()
        return
    }
    +b::
    {
        SendInput +^{Left %inputNumber%}
        resetInputNumber()
        return
    }
    +x::
    {
        lastCommand = +{Delete}
        SendInput, %lastCommand%
        resetInputNumber()
        return
    }
    )::
    {
        SendInput +{Home}
        resetInputNumber()
        return
    }
    _::
    {
        SendInput +{End}
        resetInputNumber()
        return
    }

    ; Copy (Yank) / Cut (Delete) / Paste (Put)
    ; -------------------------------------------------------------
; In VI-mode, make y (yank) and d (delete→cut) clear + wait
; -------------------------------------------------------------
y::
{
    Clipboard := ""         ; empty out any old clipboard
    SendInput ^c            ; copy selection
    ClipWait, 0.5           ; wait up to 0.5s for clipboard to change
    resetInputNumber()
    return
}

d::
{
    Clipboard := ""         ; empty out any old clipboard
    SendInput ^x            ; cut selection
    ClipWait, 0.5           ; wait up to 0.5s for clipboard to change
    resetInputNumber()
    return
}
    p::
    {
        SendInput ^v
        resetInputNumber()
        return
    }

    ; Search with /
    /::
    {
        SendInput ^f
        resetInputNumber()
        return
    }

    ; HotKey to VIM maps
    u:: 
    {
        SendInput ^z
        resetInputNumber()
        return
    }

    ; Catch numbers to repeat commands
    $1::
    {
       inputNumber = %inputNumber%1
       normalize(1)
       notify(inputNumber)
       return
    }

    $2::
    {
       inputNumber = %inputNumber%2
       normalize(2)
       notify(inputNumber)
       return
    }

    $3::
    {
       inputNumber = %inputNumber%3
       normalize(3)
       notify(inputNumber)
       return
    }

    $4::
    {
       inputNumber = %inputNumber%4
       normalize(4)
       notify(inputNumber)
       return
    }

    $5::
    {
       inputNumber = %inputNumber%5
       normalize(5)
       notify(inputNumber)
       return
    }

    $6::
    {
       inputNumber = %inputNumber%6
       normalize(6)
       notify(inputNumber)
       return
    }

    $7::
    {
       inputNumber = %inputNumber%7
       normalize(7)
       notify(inputNumber)
       return
    }

    $8::
    {
       inputNumber = %inputNumber%8
       normalize(8)
       notify(inputNumber)
       return
    }

    $9::
    {
       inputNumber = %inputNumber%9
       normalize(9)
       notify(inputNumber)
       return
    }
        
#IfWinExist ;}}}

;; Ad-hoc Vi navigation with Space + key combo {{{

Space & F1::Return
; send explicitly when no other key is pressed before release
*Space:: SendInput {Blind}{Space}
 KeyDown:=A_TickCount
 KeyWait /
 if (A_TickCount-KeyDown < 1000)
    Send {Space}
 Return

#If GetKeyState("Space", "p")

; cursor movements
 h::left 
 j::down 
 k::up 
 l::right 

; page movements
 w::^right
 b::^left
 x::delete
 0::home
 -::end
 $::end


; HotKey to VIM maps
 u:: SendInput ^z

; Change file name
 i:: SendInput {F2}

#If

;}}}

; Validate the inputNumber and make sure that it's less than 500 {{{
normalize(resetNumber)
{
    global inputNumber
    if (inputNumber > 500)
    {
        inputNumber := resetNumber
    }
} ;}}}

; Reset the inputNumber to " "
resetInputNumber()
{              
   global
   resetGUI()
   inputNumber := " "
   return
}

resetGUI()
{
    Gui, 90:Destroy
    return
}
endVIM()
{
    Gui, 99:Destroy
    resetInputNumber()
    return
}


;### ALT Keypress Implied for all below ###
; For ad hoc navigation when ALT where other methods are
; not practical (ex: in popup menus).

; i UP          (Cursor up line)
!i::Send {UP} 
; k DOWN            (Cursor down line)
!k::Send {DOWN} 

; j LEFT        (Cursor left one character)
!j::Send {LEFT} 
; l RIGHT       (Cursor right one character)
!l::Send {RIGHT} 

; h     ALT + RIGHT (Cursor to beginning of line)
!h::Send {HOME} 
; ; ALT + LEFT  (Cursor to end of line)
!;::Send {END}      

; h     SHIFT + HOME    (Cursor to beginning of document)
!u::Send ^{HOME} 
; o SHIFT + END (Cursor to end of document)
!o::Send ^{END} 

;### CTRL + ALT Keypress Implied for all below ###
; j     CTRL + LEFT (Cursor left per word)
!^j::Send ^{LEFT} 
; l CTRL + RIGHT    (Cursor right per word)
!^l::Send ^{RIGHT} 

;### SHIFT + ALT Keypress Implied for all below ###
; i SHIFT + UP  (Highlight per line)
!+i::Send +{UP} 
; k SHIFT + DOWN    (Highlight per line)
!+k::Send +{DOWN} 

; j SHIFT + LEFT    (Highlight per character)
!+j::Send +{LEFT} 
; l SHIFT + RIGHT   (Highlight per character)
!+l::Send +{RIGHT} 

; h SHIFT + ALT + LEFT  (Highlight to beginning of line)
!+h::Send +{HOME} 
; ; SHIFT + ALT + RIGHT (Hightlight to end of line)
!+;::Send +{END}    

; u SHIFT + CTRL + HOME (Highlight to beggininng of document)
!+u::Send ^+{HOME} 
; o SHIFT + CTRL + END  (Hightlight to end of document)
!+o::Send ^+{END} 

;### SHIFT + CTRL + ALT Keypress Implied for all below ###
; i SHIFT + ALT + UP    (Multiply cursor up)
!+^j::Send +^{LEFT} 
; i SHIFT + ALT + UP    (Multiply cursor up)
!+^l::Send +^{RIGHT} 

; i SHIFT + ALT + UP    (Multiply cursor up)
!+^i::Send +!{UP} 
; i SHIFT + ALT + UP    (Multiply cursor up)
!+^k::Send +!{DOWN} 

;### CTRL + SHIFT Keypress Implied for all below ###
+^i::Send +^{UP}
+^k::Send +^{DOWN}

; Run Everything search program
^!e:: ; CTRL+ALT+E
    Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Everything.lnk

; Maps ALTgr to just ALT
LControl & RAlt::Alt

; Enter ZEN Mode on VScode or Intellij
F3::Send ^kz 

; Remap Mayus (Lock-key) to Backspace
CapsLock::BackSpace
^CapsLock::CapsLock
+CapsLock::CapsLock
; Remap bakcspace 
;   To un-learn the habit of using it 
;   constantly instead of CapsLock key.
Backspace::CapsLock


; -------------------------------------------------------------
; Make Shift+Del Shift+Del → “delete entire line”
; -------------------------------------------------------------
+Del::
    Send {Home}+{End}{Del}    ; go to start of line, select to end, delete
Return
#If



