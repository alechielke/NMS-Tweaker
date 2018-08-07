;Required files
#include <String.au3>
#include <IE.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <Timers.au3>
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <FontConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Constants.au3>
#include <GuiListView.au3>
#include <TabConstants.au3>
#include <ColorConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

;Setting temporary hotkeys
HotKeySet('{ESC}', 'breakscript')

;Set the GUI to enable function interrupting
Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 802)

;Set the GUI events
GUIRegisterMsg($WM_SIZE, 'GUIResizeControls')
;GUISetOnEvent($GUI_EVENT_RESIZED, 'GUIResizeControls')
GUISetOnEvent($GUI_EVENT_CLOSE, 'closeGUI')

;Setting variables
$tabRowHeight = 20

;Creating default arrays
Global $GCGAMEPLAYGLOBALSarray[1000][5]

;Populating default arrays

;Analysis visor scan time
$GCGAMEPLAYGLOBALSarray[0][0] = False
$GCGAMEPLAYGLOBALSarray[0][1] = 5

;Starship interact range
$GCGAMEPLAYGLOBALSarray[1][0] = False
$GCGAMEPLAYGLOBALSarray[1][1] = 50

;Multitool scanner range
$GCGAMEPLAYGLOBALSarray[2][0] = False
$GCGAMEPLAYGLOBALSarray[2][1] = 200


Func breakscript()

   Exit

EndFunc ;==> breakscript


Func closeGUI()

   GUIDelete($GUI)
   Exit

EndFunc ;==> closeGUI


Func createGUI()

   Global $GUI = GUICreate('NMS Tweaker', 1000, 800, -1, -1, $WS_SIZEBOX + $WS_SYSMENU + $WS_MINIMIZEBOX)

   ;Set the GUI events
   GUISetOnEvent($GUI_EVENT_RESIZED, 'GUIResizeControls')
   GUISetOnEvent($GUI_EVENT_CLOSE, 'closeGUI')

   ;Create the label that shows which files have been edited
   Global $incompatibleListTitle = GUICtrlCreateLabel('Edited files', 498, 5, 95, 25, $WS_BORDER + $SS_CENTER)
   GUICtrlSetBkColor($incompatibleListTitle, 0xffffff)
   GUICtrlSetFont($incompatibleListTitle, 14)
   Global $incompatibleList = GUICtrlCreateLabel('', 498, 35, 95, 310, $WS_BORDER + $SS_CENTER)
   GUICtrlSetBkColor($incompatibleList, 0xffffff)
   Global $generateButton = GUICtrlCreateButton('Generate', 498, 345, 95, 20)
   GUICtrlSetOnEvent($generateButton, 'generatePakFile')

   ;Create the tab framework
   Global $Tab = GUICtrlCreateTab(5, 5, 750, 765)
   GUICtrlSetResizing($Tab, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKAUTO)

   ;Create the scanning tab
   GUICtrlCreateTabItem('Scanning')

	  ;Creating dividers
	  GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
	  GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

	  ;The input for analysis time
	  Global $analysisTimeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[0][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($analysisTimeInput)
	  GUICtrlSetLimit(-1, 100, 0)
	  Global $analysisTimeLabel = GUICtrlCreateLabel('Analysis scanner speed', 10, $tabRowHeight+12, 165, 20)

	  ;The input for multitool scanner range
	  Global $multitoolScannerRangeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[2][1], 430, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($multitoolScannerRangeInput)
	  GUICtrlSetLimit(-1, 9999999, 0)
	  Global $multitoolScannerRangeLabel = GUICtrlCreateLabel('Multitool scanner range', 260, $tabRowHeight+12, 165, 30)

   ;Create the spaceship tab
   GUICtrlCreateTabItem('Spaceship')

	  ;Creating dividers
	  GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
	  GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

	  ;The input for Starship interact range
	  Global $starshipInteractRangeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[1][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($starshipInteractRangeInput)
	  GUICtrlSetLimit(-1, 9999999, 0)
	  Global $starshipInteractRangeLabel = GUICtrlCreateLabel('Starship interact range', 10, $tabRowHeight+12, 165, 30)

   ;Close the tab framework
   GUICtrlCreateTabItem('')

   ;Show the GUI
   GUISetState(@SW_SHOW)

EndFunc ;==> createGUI


Func GUIResizeControls()

   Local $GUISize = WinGetClientSize($GUI)
   Local $GUIWidth = $GUISize[0]
   Local $GUIHeight = $GUISize[1]

   Local $tabSize = ControlGetPos('', '', $Tab)
   Local $tabLeft = $tabSize[0]
   Local $tabTop = $tabSize[1]
   Local $tabWidth = $tabSize[2]
   Local $tabHeight = $tabSize[3]

   GUICtrlSetPos($incompatibleList, $tabLeft+$tabWidth+5, 35, $GUIWidth - $tabWidth - $tabLeft - 10, $tabHeight-55)
   GUICtrlSetPos($incompatibleListTitle, $tabLeft+$tabWidth+5, 5, $GUIWidth - $tabWidth - $tabLeft - 10, 25)
   GUICtrlSetPos($generateButton, $tabLeft+$tabWidth+5, 35+$tabHeight-50, $GUIWidth - $tabWidth - $tabLeft - 10, 20)

   ;GUICtrlSetPos($analysisTimeLabel, $tabLeft+10, $tabRowHeight+10, 140, 30)
   ;GUICtrlSetPos($analysisTimeInput, $tabLeft+15+140, $tabRowHeight+10, 40, 20)

EndFunc ;==> GUIResizeControls


Func generatePakFile()

   updateIncompatibleList()

   Global $pakParameterString = ''
   Global $pakDeleteParameterString = ''

   For $c=0 To UBound($modifiedFileArray)-1 Step 1

	  $a = $modifiedFileArray[$c]
	  Local $aExplode = _StringExplode($a, '\')
	  Local $destFilePath = ''

	  $pakParameterString &= $a&'.MBIN '
	  $pakDeleteParameterString &= $a&'.MBIN '&$a&'.exml '

	  For $b=0 To UBound($aExplode)-2 Step 1
		 $destFilePath &= $aExplode[$b]&'\'
	  Next

	  Run(@ScriptDir&'\Workshop\MBINCompiler.exe Workshop\Default\'&$a&'.MBIN Workshop\'&$a&'.exml' , '', 0)
	  Sleep(2000)

	  Switch $a

		 Case 'GCGAMEPLAYGLOBALS.GLOBAL'
			;Writing analysisTime to file
			If $GCGAMEPLAYGLOBALSarray[0][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 51, '<Property name="BinocMinScanTime" value="'&GUICtrlRead($analysisTimeInput)&'" />', True)
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 52, '<Property name="BinocScanTime" value="'&GUICtrlRead($analysisTimeInput)&'" />', True)
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 53, '<Property name="BinocCreatureScanTime" value="'&GUICtrlRead($analysisTimeInput)&'" />', True)
			EndIf

			;Writing starship interact range to file
			If $GCGAMEPLAYGLOBALSarray[1][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 401, '<Property name="ShipInteractRadius" value="'&GUICtrlRead($starshipInteractRangeInput)&'" />', True)
			EndIf

			;Writing multitool scanner range to file
			If $GCGAMEPLAYGLOBALSarray[2][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 420, '<Property name="PulseRange" value="'&GUICtrlRead($multitoolScannerRangeInput)&'" />', True)
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 427, '<Property name="PulseRange" value="'&GUICtrlRead($multitoolScannerRangeInput)&'" />', True)
			EndIf

	  EndSwitch

	  Run(@ScriptDir&'\Workshop\MBINCompiler.exe Workshop\'&$a&'.exml Workshop\'&$a&'.MBIN' , '', 0)
	  Sleep(2000)

   Next



   Sleep(1000)

   ;Creating the pak file
   RunWait('"' & @ComSpec & '" /c cd Workshop && PSArcTool.exe '&$pakParameterString, '', @SW_HIDE)
   Sleep(5000)
   RunWait('"' & @ComSpec & '" /c cd Workshop && Del '&$pakDeleteParameterString&' && move psarc.pak ..\MyNMSTweaks.pak', '', @SW_HIDE)
   ProcessClose('cmd.exe')

   MsgBox($MB_OK, 'NMS Tweaker', 'Pak file generated')

EndFunc ;==> generatePakFile


Func updateIncompatibleList()

   ;Check if analysisTime has been modified
   If GUICtrlRead($analysisTimeInput) <> $GCGAMEPLAYGLOBALSarray[0][1] Then
	  $GCGAMEPLAYGLOBALSarray[0][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[0][0] = False
   EndIf

   ;Check if starship interact range has been modified
   If GUICtrlRead($starshipInteractRangeInput) <> $GCGAMEPLAYGLOBALSarray[1][1] Then
	  $GCGAMEPLAYGLOBALSarray[1][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[1][0] = False
   EndIf

   ;Check if multitool scanner range has been modified
   If GUICtrlRead($multitoolScannerRangeInput) <> $GCGAMEPLAYGLOBALSarray[2][1] Then
	  $GCGAMEPLAYGLOBALSarray[2][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[2][0] = False
   EndIf

   ;Update incompatibleList
   Local $incompatibleListValue = ''
   Global $modifiedFileArray[0]

   For $a=0 To UBound($GCGAMEPLAYGLOBALSarray)-1 Step 1
	  If $GCGAMEPLAYGLOBALSarray[$a][0] Then
		 $incompatibleListValue &= 'GCGAMEPLAYGLOBALS.GLOBAL.MBIN'&@CRLF
		 _ArrayAdd($modifiedFileArray, 'GCGAMEPLAYGLOBALS.GLOBAL')
		 ExitLoop
	  EndIf
   Next

   If GUICtrlRead($incompatibleList) <> $incompatibleListValue Then
	  GUICtrlSetData($incompatibleList, $incompatibleListValue)
   EndIf

EndFunc ;==> redCtrlValues

;Actual code
createGUI()
While 1

   updateIncompatibleList()
   Sleep(1000)

WEnd