#Persistent
#NoEnv
#Include <classMemory>
#Include <convertToHex>
#SingleInstance, Force
#WinActivateForce
SendMode Input
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
FileEncoding UTF-8

Gui, 1:Default
Gui, Font, s16, Segoe UI
Gui, Add, Text,, What is this?
Gui, Font, s12, Segoe UI
Gui, Add, Text,, A small program to get around no copy/paste support in DQX.
Gui, Add, Text,y+1, Helpful for quests where you need to type Japanese to proceed, but you don't know how.
Gui, Font, s16, Segoe UI
Gui, Add, Text,, How to use:
Gui, Font, s12, Segoe UI
Gui, Add, Link,, - Open DQX with something like <a href="https://xupefei.github.io/Locale-Emulator/">Locale Emulator</a> to allow typing in Japanese`n    (you don't need the Japanese IME keyboard active for this)
Gui, Add, Text,y+1, - Open a fresh chat box in game and switch to the desired chat category
Gui, Add, Text,y+1, - Bring this program into focus and paste the Japanese text you want to send to DQX
Gui, Add, Text,y+1, - Click 'Send to DQX'. The program will move your DQX chat cursor to the appropriate`n    position and send the text into the DQX chat window
Gui, Add, Edit, r1 vTextToSend w500, %textToSend%
Gui, Add, Button, gSend, Send to DQX

Gui, +alwaysontop
Gui, Show, Autosize
Return

Send:
  GuiControlGet, TextToSend
  sanitizedBytes := StrReplace(convertStrToHex(textToSend), "`r`n", "")
  numberToArrowOver := StrLen(sanitizedBytes) // 2

  Process, Exist, DQXGame.exe
  if ErrorLevel
  {
    WinActivate, ahk_exe DQXGame.exe
    ;; Have to move the chat cursor to the position to where it should be for the text to send correctly
    Loop {
      Sleep 50
      Send {Right}
    }
    Until A_Index = numberToArrowOver

    dqx := new _ClassMemory("ahk_exe DQXGame.exe", "", hProcessCopy)
    baseAddress := dqx.getProcessBaseAddress("ahk_exe DQXGame.exe")
    chatAddress := 0x01FF377C
    chatOffsets := [0x4C, 0x44, 0x8, 0x1E0, 0x2DC, 0x0]
    dqx.writeBytes(baseAddress + chatAddress, convertStrToHex(textToSend), chatOffsets*)
  }
  else
  {
    msgBox "DQX window not found."
  }
