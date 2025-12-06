#SingleInstance Force
#NoEnv
SendMode Input
CoordMode, Mouse, Screen

pointX := []
pointY := []
pointCount := 0
repeatCount := 0

; ---------- SAVE POINT 1 ----------
Numpad1::
    MouseGetPos, mx, my
    pointCount++
    pointX[pointCount] := mx
    pointY[pointCount] := my
    MsgBox, % "Saved Point " pointCount " at X=" mx "  Y=" my
return

; ---------- SAVE POINT 2 ----------
Numpad2::
    MouseGetPos, mx, my
    pointCount++
    pointX[pointCount] := mx
    pointY[pointCount] := my
    MsgBox, % "Saved Point " pointCount " at X=" mx "  Y=" my
return

; ---------- SAVE POINT 3 (COPY POINT) ----------
Numpad3::
    MouseGetPos, mx, my
    pointCount++
    pointX[pointCount] := mx
    pointY[pointCount] := my
    MsgBox, % "Saved COPY Point (Point " pointCount ") at X=" mx " Y=" my
return

; CLEAR
Numpad0::
    pointX := []
    pointY := []
    pointCount := 0
    MsgBox, All points cleared!
return

; SET REPEAT COUNT
Numpad8::
    InputBox, tmpCount, Repeat?, Kitni baar chalana hai?
    if ErrorLevel
        return
    repeatCount := tmpCount
    MsgBox, % "Repetitions set to: " repeatCount
return


; ---------------- START AUTOMATION ----------------
Numpad7::
    if (pointCount < 3) {
        MsgBox, Kam se kam 3 points required! (3rd is copy point)
        return
    }
    if (!repeatCount) {
        MsgBox, Repeat count Numpad8 se set karo!
        return
    }

    Loop, %repeatCount%
    {
        ; ----------------- STEP 1: SHEET → IMAGE NAME COPY -----------------
        WinActivate, ahk_exe chrome.exe
        Sleep, 300

        Send, {F2}
        Sleep, 120
        Send, ^a
        Sleep, 120
        Send, ^c
        Sleep, 120
        Send, {Left}
        Sleep, 80
        Send, {Enter}
        Sleep, 120

        ; ----------------- STEP 2: MEESHO TAB -----------------
        Send, ^{Tab}
        Sleep, 500


        ; ----------------- STEP 3: CLICK ALL POINTS -----------------
        Loop, %pointCount%
        {
            idx := A_Index
            xCoord := pointX[idx]
            yCoord := pointY[idx]

            Click, %xCoord%, %yCoord%
            Sleep, 300

            ; 🔥 FIX — File Explorer open hone ke baad "File name" box me paste & open
            if (idx = 1)
            {
                Sleep, 900
                ; Wait for Open dialog (common classes)
                WinWaitActive, ahk_class #32770, , 4
                if ErrorLevel
                {
                    WinWaitActive, ahk_class CabinetWClass, , 4
                }
                Sleep, 250
                Send, !n            ; ALT + N → "File name" box focus
                Sleep, 250
                Send, ^v            ; paste image name
                Sleep, 250
                Send, {Enter}       ; select/open image
                Sleep, 800
            }
            
           
          if (idx = 2)
           {
             ; TRIPLE CLICK
               Sleep, 120
               Click, %xCoord%, %yCoord%, 3
               Sleep, 200
               Sleep, 500

           }

            ; COPY ONLY WHEN POINT = 3 (double-click select specific item, then copy)
            if (idx = 3)
            {
                Sleep, 250
                Click                  ; ensure focus
                Sleep, 120
                Click, 2               ; double-click the control to select the value at that point
                Sleep, 180
                Send, ^c               ; copy selected text
                Sleep, 250
            }
        } ; end inner Loop over points


        ; ----------------- STEP 4: BACK TO SHEET -----------------
        Send, ^+{Tab}
        Sleep, 400
; ----- HARD FIX: STOP SKIP -----
        Send, {Up}
        Sleep, 150

        ; ----------------- STEP 5: PASTE NEXT CELL -----------------
        Send, {Right}
        Sleep, 120
        Send, ^v
        Sleep, 200
        Sleep, 300
        Send, {Enter}
        Sleep, 200
        Send, {Up}
        Sleep, 150
        Send, {Left}
        Sleep, 100
        Send, {Down}
        Sleep, 200


    } ; end outer Loop repeatCount

    MsgBox, DONE!
return


; EMERGENCY STOP
Esc::ExitApp


; ---------------- AutoJump Activation ----------------
AutoJumpActive := false

F12::
    AutoJumpActive := !AutoJumpActive
    if AutoJumpActive
        TrayTip,, AutoJump ENABLED, 2
    else
        TrayTip,, AutoJump DISABLED, 2
return

; ---------------- AutoJump Functions ----------------
JumpAtoB() {
    Sleep, 150
    Send, {Right}
    Sleep, 100
}

JumpBtoNextA() {
    Sleep, 150
    Send, {Left}
    Sleep, 100
    Send, {Down}
    Sleep, 100
}




