;================================================
; ; COPY SCRIPT TO StartUp FOLDER FOR AUTORUNNING
; ;put this line near the top of your script: 
; FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir% 
; ;=============================================

#Persistent
#SingleInstance Force
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
; Run as Admin
if not A_IsAdmin
    Run *RunAs "%A_ScriptFullPath%"
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

; Change directory on terminals.      
; cd into projects folder
::cdt::cd "C:\Users\visco\OneDrive\Desktop\html-projects"
; cd into Home directory
::cdh::cd ~

; Amazon.com
::amz::site:amazon.com
; Stackoverflow.com
::stk::site:stackoverflow.com
; Reddit.com
::rtt::site:reddit.com
; Java docs
::jvd::https://docs.oracle.com/en/java/javase/17/docs/api/
; AutoHotKey docs
::ahk::https://www.autohotkey.com/docs/v1/
; Lorem Ipsum generator
::lri::https://loremipsum.io/