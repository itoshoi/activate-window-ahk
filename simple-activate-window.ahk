#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTimer, HighlightActiveWindow, 50
Return

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
	Gui, Color, 0077FF
	Gui, -Caption
	WinSet, Region, 0-0 %w%-0 %w%-%h% 0-%h% 0-0 %border_thickness%-%border_thickness% %iw%-%border_thickness% %iw%-%ih% %border_thickness%-%ih% %border_thickness%-%border_thickness%
    try
        Gui, Show, w%w% h%h% x%x% y%y% NoActivate, Active Window Highlight
    WinSet, Transparent, 200, Active Window Highlight
}

!h::MoveActivate("l")
!l::MoveActivate("r")
!k::MoveActivate("u")
!j::MoveActivate("d")

ToggleMax()
{
    WinGet, isMinMax, MinMax, A
    if (isMinMax = 1)
        WinRestore, A
    else
        WinMaximize, A
}

!m::ToggleMax()
!r::Reload
!q::WinClose, A
!e::ExitApp
