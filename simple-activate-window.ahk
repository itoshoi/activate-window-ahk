#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

HighlightColor = 77DDFF
; execute highlight
SetTimer, HighlightActiveWindow, 50
Return

; key config
; Shift='+', Ctrl='^', Alt='!', Win='#'
!h::MoveActivate("l")
!l::MoveActivate("r")
!k::MoveActivate("u")
!j::MoveActivate("d")
!r::MoveActivate("b")

!m::ToggleMax()
!+r::Reload
!q::WinClose, A
!e::ExitApp

!t::ToggleTransparency()


HighlightActiveWindow:
    HighlightActiveWindow()
    return

MoveActivate(dir)
{
    WinGetPos, ax, ay, aw, ah, A
    WinGetTitle, atitle, A

    WinGet, windows, list
    nearestDist := 9999999
    nearestTitle = hoge

    loop, %windows%
    {
        idstr := "ahk_id " . windows%A_Index%
        WinGetTitle, title, %idstr%
        if (title = atitle)
            continue
        if (title = "")
            continue
        if (title = "Active Window Highlight")
            continue
        if (title = "Program Manager")
            continue

        ;move left
        if (dir = "l")
        {
            WinGetPos, x, y, w, h, %idstr%
            isLeft := x < ax
            isNearest := ax - x < nearestDist
            if (isLeft and isNearest)
            {
                nearestDist := ax - x
                nearestTitle = %title%
            }
        }

        ;move right
        if (dir = "r")
        {
            WinGetPos, x, y, w, h, %idstr%
            isRight := x > ax
            isNearest := x - ax < nearestDist
            if (isRight and isNearest)
            {
                nearestDist := x - ax
                nearestTitle = %title%
            }
        }

        ;move up
        if (dir = "u")
        {
            WinGetPos, x, y, w, h, %idstr%
            isUp := y < ay
            isNearest := Abs(ay - y) < nearestDist and Abs(ax - x) < 10
            if (isUp and isNearest)
            {
                nearestDist := Abs(ay - y)
                nearestTitle = %title%
            }
        }

        ;move down
        if (dir = "d")
        {
            WinGetPos, x, y, w, h, %idstr%
            isDown := y > ay
            isNearest := Abs(ay - y) < nearestDist and Abs(ax - x) < 10
            if (isDown and isNearest)
            {
                nearestDist := Abs(ay - y)
                nearestTitle = %title%
            }
        }

        ;move behind
        if (dir = "b")
        {
            WinGetPos, x, y, w, h, %idstr%
            isBehind := Abs(ay - y) < 100 and Abs(ax - x) < 100
            if (isBehind)
            {
                nearestTitle = %title%
            }
        }
    }
    WinActivate, %nearestTitle%
}

HighlightActiveWindow(){
    border_thickness = 5
	WinGetTitle, title, A
	WinGetPos, x, y, w, h, A
	Gui, +Lastfound +AlwaysOnTop +Toolwindow
	iw:= w + 4
	ih:= h + 4
	w:= w + 8
	h:= h + 8
	x:= x -border_thickness
	y:= y -border_thickness
    global HighlightColor
	Gui, Color, %HighlightColor%
	Gui, -Caption
	WinSet, Region, 0-0 %w%-0 %w%-%h% 0-%h% 0-0 %border_thickness%-%border_thickness% %iw%-%border_thickness% %iw%-%ih% %border_thickness%-%ih% %border_thickness%-%border_thickness%
    try
        Gui, Show, w%w% h%h% x%x% y%y% NoActivate, Active Window Highlight
    WinSet, Transparent, 255, Active Window Highlight
}

ToggleMax()
{
    WinGet, isMinMax, MinMax, A
    if (isMinMax = 1)
        WinRestore, A
    else
        WinMaximize, A
}

ToggleTransparency(){
    WinGet, a, Transparent, A
    if (a = 200)
        WinSet, Transparent, 255, A
    else
        WinSet, Transparent, 200, A
}

