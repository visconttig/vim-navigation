;================================================
; ; COPY SCRIPT TO StartUp FOLDER FOR AUTORUNNING
; ;put this line near the top of your script: 
;     FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir% 
; ;=============================================
; AutoHotKey Version 1 

#NoEnv  
SendMode Input  
SetWorkingDir %A_ScriptDir%  

#SingleInstance Force
if not A_IsAdmin
    Run *RunAs "%A_ScriptFullPath%"


inputNumber := " "
lastCommand = {ShiftDown}{ShiftUp}



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
        Gui, 99:+AlwaysOnTop -Caption +ToolWindow +Disabled -SysMenu +Owner
        Gui, 99:Font, s15 bold
        Gui, 99:Add, Text, cAA0000, VI-NORMAL
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

                ShowMessage(msg) {
                    Gui, 44:Destroy  ; Destroy previous GUI (if any)
                    Gui, 44:+AlwaysOnTop +ToolWindow -SysMenu -Caption
                    Gui, 44:Font, s14 Bolder, Segoe UI
                    Gui, 44:Color, Black
                    Gui, 44:Add, Text, cWhite, %msg%
                    Gui, 44:Show, NoActivate, AutoSize xCenter y425
                    
                    HideMessage()
                    return
                }
                
                HideMessage(){
                    SetTimer, DestroyGui, -1000
                    return
                    
                    DestroyGui:
                    Gui, 44: Destroy
                    Return
                }
        
#IfWinExist VIM-Mode Activated ; {{{
            
        ; Block letters while Vim mode activated {{{
    ; 'i' key disabled (chang to 'true' to activate)
    Global IkeyActivatesInputMode := false
    c::
    e::
    f::
    g::
    m::
    n::
    o::
    q::
    r::
    s::
    t::
    v::
    z::
        ShowMessage("[Vim Mode is Active]")
        return
    ; }}}
    


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
    ; if 'i' is enabled
    i::
    {   
        if(IkeyActivatesInputMode){
            endVIM()
        } else {
            ShowMessage("i : Input Mode")
        }
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
        SendInput {Up}
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
        lastCommand = ^x
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
    ShowMessage("Copy")
    ClipWait, 0.5           ; wait up to 0.5s for clipboard to change
    resetInputNumber()
    return
}

d::
{
    Clipboard := ""         ; empty out any old clipboard
    SendInput ^x            ; cut selection
    ShowMessage("Cut")
    ClipWait, 0.5           ; wait up to 0.5s for clipboard to change
    resetInputNumber()
    return
}
    p::
    {
        SendInput ^v
        ShowMessage("Paste")
        resetInputNumber()
        return
    }

    ; Search with /
    /::
    {
        SendInput ^f
        ShowMessage("Search")
        resetInputNumber()
        return
    }

    ; HotKey to VIM maps
    u:: 
    {
        SendInput ^z
        ShowMessage("Undo")
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


;### Navigation / actions with ALT ###
; For ad hoc navigation with ALT where other methods are
; not practical (ex.: in popup menus).

;## ALT-based Vim-like Navigation (! = ALT)
; Basic Vim-style movement
!h::Send {Left}      ; h - Left
!j::Send {Down}      ; j - Down
!k::Send {Up}        ; k - Up
!l::Send {Right}     ; l - Right

; Word-level movement (Vim: w and b)
!w::Send ^{Right}    ; w - Word forward
!b::Send ^{Left}     ; b - Word backward

; Line navigation
!0::Send {Home}      ; 0 - Line start
!$::Send {End}       ; $ - Line end

; Document navigation
!u::Send ^{Home}     ; u - Start of document
!o::Send ^{End}      ; o - End of document


;## ALT + SHIFT = Selection (like Visual mode)
; Selection with shift
!+h::Send +{Left}        ; Select left
!+j::Send +{Down}        ; Select down
!+k::Send +{Up}          ; Select up
!+l::Send +{Right}       ; Select right

!+w::Send +^{Right}      ; Select word forward
!+b::Send +^{Left}       ; Select word backward

!+0::Send +{Home}        ; Select to line start
!+$::Send +{End}         ; Select to line end

!+u::Send ^+{Home}       ; Select to document start
!+o::Send ^+{End}        ; Select to document end

;## CTRL + ALT = Word-level navigation
!^w::Send ^{Right}    ; Word forward
!^b::Send ^{Left}     ; Word backward


; Run Everything search program
^!e:: ; CTRL+ALT+E
    Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Everything.lnk

; Maps ALTgr to just ALT
LControl & RAlt::Alt

; Enter ZEN Mode on VScode or Intellij
F3::Send ^kz 

; Remap Mayus (Lock-key) to Backspace
CapsLock::BackSpace
; Remap bakcspace 
$Backspace::
    ShowMessage("Use 'CapsLock' key!!")
    return

;–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
; Double-tap Shift to **toggle CapsLock**
;–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
~Shift Up::
    ; only trigger if the *previous* Up was also Shift Up
    ; and happened under 500 ms ago, with no other modifiers
    if (A_PriorHotkey = "~Shift Up"
        && A_TimeSincePriorHotkey < 500
        && !GetKeyState("Ctrl","P")
        && !GetKeyState("Alt","P")
        && !GetKeyState("LWin","P")
        && !GetKeyState("RWin","P"))
        {
            ;IsCapsLockOn := GetKeyState("CapsLock", "T")
            IsCapsLockOn := GetCapsLockState()
            if(IsCapsLockOn != 0){
                SetCapsLockState, Off
            } else {
                SetCapsLockState, On
            }
         } 
        
        Return
        ; }}}


        GetCapsLockState(){
            return GetKeyState("CapsLock", "T")
        }


; -------------------------------------------------------------
; Make Shift+Del Shift+Del → “delete entire line”
; -------------------------------------------------------------

+Del::
    Send {Home}+{End}{Del}    ; go to start of line, select to end, delete
Return
#If



