#include <Vis2>
#InstallMouseHook
#Persistent
#UseHook
#InstallKeybdHook

F1::

; The list of potentials being cubed for. 
ArrayGoodPot := ["Meso", "Item", "HP"]

; # of matches you want 
NumberGoodPot := 2

; Finds the unique ID of the Swordie window, fixes the window to pos 0,0 for OCR. Can be changed manually. 
WinGet, swordie_id, ID, Swordie
WinMove, ahk_id %swordie_id%, , 0, 0

; Fuction for reading Fredrick potential lines 
ReadFredrickLines() {
    global
    line1 := OCR([565, 360, 300, 20])
    line2 := OCR([565, 380, 300, 20])
    line3 := OCR([565, 400, 300, 18])
}

; Parser Function that reduces potential lines to description and %
PotParser(linex) {
	linex := StrReplace(linex, "%", "")
	linex := StrReplace(linex, "+", "")
	linex := StrReplace(linex, ")", "")
	linex := StrReplace(linex, "(", "")
	linex := StrReplace(linex, ":", "")
	linex := StrReplace(linex, "Legendary", "")
	linex := StrReplace(linex, "Unique", "")
	linex := StrReplace(linex, "Epic", "")
	linex := RegExReplace(linex, "\s+", "")
	Return linex
}

; Function to check array elements (wanted pots) vs. line pot
CheckForGPMatch() {
    global
    GPcounter := 0
    potmatch := 0

    for x, line in [line1, line2, line3] {
        for k, pot in ArrayGoodPot {
            if InStr(line, pot, False) {
                potmatch += 1
                if (potmatch >= 1) {
                    potmatch := 1
                }
            }
        }
        GPcounter := GPcounter + potmatch
        potmatch := 0
    }
}

Loop {
	; Calls the OCR, then parses the raw input
		ReadFredrickLines()
	For k, line in [line1, line2, line3] {
		line := PotParser(line)
	}

	Sleep 0

	CheckForGPMatch()

	if (GPcounter >= NumberGoodPot) {
		MsgBox, "The following lines were found:" `n%line1% `n%line2% `n%line3% 
		break 
	}

	else {
		ControlSend,,{enter 1}, Swordie	
	}
}

F2::
{
    ExitApp
}
