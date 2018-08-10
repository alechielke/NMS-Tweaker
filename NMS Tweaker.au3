#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\NMS Tweaker\Pictures\NMS Tweaker Icon.ico
#AutoIt3Wrapper_Outfile=NMS Tweaker 32 bit.Exe
#AutoIt3Wrapper_Outfile_x64=NMS Tweaker 64 bit.Exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
Global $GCAISPACESHIPGLOBALSarray[1000][5]

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

;Multitool scanner recharge rate
$GCGAMEPLAYGLOBALSarray[3][0] = False
$GCGAMEPLAYGLOBALSarray[3][1] = 30

;Ship scanner range
$GCGAMEPLAYGLOBALSarray[4][0] = False
$GCGAMEPLAYGLOBALSarray[4][1] = 10000

;Ship scanner recharge rate
$GCGAMEPLAYGLOBALSarray[5][0] = False
$GCGAMEPLAYGLOBALSarray[5][1] = 10

;Max tech stacking
$GCGAMEPLAYGLOBALSarray[6][0] = False
$GCGAMEPLAYGLOBALSarray[6][1] = 3

;Freighter spawn chance
$GCAISPACESHIPGLOBALSarray[0][0] = False
$GCAISPACESHIPGLOBALSarray[0][1] = 40

;Warps between battles
$GCGAMEPLAYGLOBALSarray[7][0] = False
$GCGAMEPLAYGLOBALSarray[7][1] = 5

;Hours between battles
$GCGAMEPLAYGLOBALSarray[8][0] = False
$GCGAMEPLAYGLOBALSarray[8][1] = 3

;Crashed Ship Minimum Broken Slots
$GCAISPACESHIPGLOBALSarray[1][0] = False
$GCAISPACESHIPGLOBALSarray[1][1] = 3


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

   ;Create the full mods tab
   GUICtrlCreateTabItem('Full Mods')

	  ;Create a select box for Starship Out of Range (alechielke)
	  Global $fullmodSSOORInput = GUICtrlCreateCombo('None selected', 548, $tabRowHeight+10, 200, 20)
	  Global $fullmodSSOORLabel = GUICtrlCreateLabel('Starship Out of Range (alechielke)', 10, $tabRowHeight+12, 533, 20)
	  GUICtrlSetData($fullmodSSOORInput, '200 units|500 units|1000 units|5000 units|Infinite', 'None selected')
	  Global $fullmodSSOORCurrentValue = 'None selected'

	  ;Create a select box for Faster Scanner (alechielke)
	  Global $fullmodFasterScannerInput = GUICtrlCreateCombo('None selected', 548, $tabRowHeight+10+25, 200, 20)
	  Global $fullmodFasterScannerLabel = GUICtrlCreateLabel('Faster Scanner (alechielke)', 10, $tabRowHeight+12+25, 533, 20)
	  GUICtrlSetData($fullmodFasterScannerInput, 'Standard version', 'None selected')
	  Global $fullmodFasterScannerCurrentValue = 'None selected'

	  ;Create a select box for Faster Analysis (alechielke)
	  Global $fullmodFasterAnalysisInput = GUICtrlCreateCombo('None selected', 548, $tabRowHeight+10+50, 200, 20)
	  Global $fullmodFasterAnalysisLabel = GUICtrlCreateLabel('Faster Analysis (alechielke)', 10, $tabRowHeight+12+50, 533, 20)
	  GUICtrlSetData($fullmodFasterAnalysisInput, '3 seconds|1 second|Instant', 'None selected')
	  Global $fullmodFasterAnalysisCurrentValue = 'None selected'

	  ;Create a select box for Unlimited Tech Stacking (Greshloc)
	  Global $fullmodUnlimitedTechStackingInput = GUICtrlCreateCombo('None selected', 548, $tabRowHeight+10+75, 200, 20)
	  Global $fullmodUnlimitedTechStackingLabel = GUICtrlCreateLabel('Unlimited Tech Stacking (Greshloc)', 10, $tabRowHeight+12+75, 533, 20)
	  GUICtrlSetData($fullmodUnlimitedTechStackingInput, '2x|4x|6x|Unlimited', 'None selected')
	  Global $fullmodUnlimitedTechStackingCurrentValue = 'None selected'


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

	  ;The input for multitool scanner recharge speed
	  Global $multitoolScannerRechargeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[3][1], 680, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($multitoolScannerRechargeInput)
	  GUICtrlSetLimit(-1, 9999999, 0)
	  Global $multitoolScannerRechargeLabel = GUICtrlCreateLabel('Multitool scanner recharge speed', 510, $tabRowHeight+12, 165, 30)

	  ;The input for ship scanner range
	  Global $shipScannerRangeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[4][1], 180, $tabRowHeight+10+30, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($shipScannerRangeInput)
	  GUICtrlSetLimit(-1, 9999999, 0)
	  Global $shipScannerRangeLabel = GUICtrlCreateLabel('Ship scanner range', 10, $tabRowHeight+12+30, 165, 30)

	  ;The input for ship scanner recharge rate
	  Global $shipScannerRechargeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[5][1], 430, $tabRowHeight+10+30, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($shipScannerRechargeInput)
	  GUICtrlSetLimit(-1, 9999999, 0)
	  Global $shipScannerRechargeLabel = GUICtrlCreateLabel('Ship scanner recharge rate', 260, $tabRowHeight+12+30, 165, 30)


   ;Create the inventory tab
   GUICtrlCreateTabItem('Inventory')

	  ;Creating dividers
	  GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
	  GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

	  ;The input for Starship interact range
	  Global $starshipInteractRangeInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[1][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($starshipInteractRangeInput)
	  GUICtrlSetLimit(-1, 9999999, 0)
	  Global $starshipInteractRangeLabel = GUICtrlCreateLabel('Starship interact range', 10, $tabRowHeight+12, 165, 30)


   ;Create the technology tab
   GUICtrlCreateTabItem('Technology')

	  ;Creating dividers
	  GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
	  GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

	  ;The input for max tech stacking
	  Global $maxTechStackingInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[6][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown($maxTechStackingInput)
	  GUICtrlSetLimit(-1, 100, 0)
	  Global $maxTechStackingLabel = GUICtrlCreateLabel('Max tech stacking', 10, $tabRowHeight+12, 165, 20)


   ;Create the fleet tab
   GUICtrlCreateTabItem('Fleet')

	  ;Creating dividers
	  GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
	  GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

	  ;The input for freighter spawn chance
	  Global $freighterSpawnChanceInput = GUICtrlCreateInput($GCAISPACESHIPGLOBALSarray[0][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown(-1)
	  GUICtrlSetLimit(-1, 100, 0)
	  Global $freighterSpawnChanceLabel = GUICtrlCreateLabel('Freighter Spawn Chance', 10, $tabRowHeight+12, 165, 20)


   ;Create the space tab
   GUICtrlCreateTabItem('Space')

	  ;Creating dividers
	  GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
	  GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

	  ;The input for warps between battles
	  Global $warpsBetweenBattlesInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[7][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown(-1)
	  GUICtrlSetLimit(-1, 100, 0)
	  Global $warpsBetweenBattlesLabel = GUICtrlCreateLabel('Warps between battles', 10, $tabRowHeight+12, 165, 20)

	  ;The input for hours between battles
	  Global $hoursBetweenBattlesInput = GUICtrlCreateInput($GCGAMEPLAYGLOBALSarray[8][1], 430, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
	  GUICtrlCreateUpdown(-1)
	  GUICtrlSetLimit(-1, 100, 0)
	  Global $HoursBetweenBattlesLabel = GUICtrlCreateLabel('Hours between battles', 260, $tabRowHeight+12, 165, 20)

	;Create the starship tab
	GUICtrlCreateTabItem('Starship')

		;Creating dividers
		GUICtrlCreateLabel("", 254, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)
		GUICtrlCreateLabel("", 504, $tabRowHeight+10, 2, 755-$tabRowHeight, $SS_SUNKEN)

		;The input for crashed ship minimum unbroken slots
		Global $shipMinUnbrokenSlotsInput = GUICtrlCreateInput($GCAISPACESHIPGLOBALSarray[1][1], 180, $tabRowHeight+10, 70, 20, $SS_NOTIFY)
		GUICtrlCreateUpdown(-1)
		GUICtrlSetLimit(-1, 100, 0)
		Global $shipMinUnbrokenSlotsLabel = GUICtrlCreateLabel('Minimum Unbroken Slots', 10, $tabRowHeight+12, 165, 20)

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

			;Writing multitool scanner recharge rate to file
			If $GCGAMEPLAYGLOBALSarray[3][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 423, '<Property name="ChargeTime" value="'&GUICtrlRead($multitoolScannerRechargeInput)&'" />', True)
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 430, '<Property name="ChargeTime" value="'&GUICtrlRead($multitoolScannerRechargeInput)&'" />', True)
			EndIf

			;Writing ship scanner range to file
			If $GCGAMEPLAYGLOBALSarray[4][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 483, '<Property name="PulseRange" value="'&GUICtrlRead($shipScannerRangeInput)&'" />', True)
			EndIf

			;Writing ship scanner recharge rate to file
			If $GCGAMEPLAYGLOBALSarray[5][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 486, '<Property name="ChargeTime" value="'&GUICtrlRead($shipScannerRechargeInput)&'" />', True)
			EndIf

			;Writing max tech stacking to file
			If $GCGAMEPLAYGLOBALSarray[6][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 12, '<Property name="MaxNumSameGroupTech" value="'&GUICtrlRead($maxTechStackingInput)&'" />', True)
			EndIf

			;Writing warps between battles to file
			If $GCGAMEPLAYGLOBALSarray[7][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 234, '<Property name="WarpsBetweenBattles" value="'&GUICtrlRead($warpsBetweenBattlesInput)&'" />', True)
			EndIf

			;Writing hours between battles to file
			If $GCGAMEPLAYGLOBALSarray[7][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCGAMEPLAYGLOBALS.GLOBAL.exml', 235, '<Property name="HoursBetweenBattles" value="'&GUICtrlRead($hoursBetweenBattlesInput)&'" />', True)
			EndIf

		Case 'GCAISPACESHIPGLOBALS.GLOBAL'
			;Writing freighter spawn chance to file
			If $GCAISPACESHIPGLOBALSarray[0][0] Then
			   _FileWriteToLine(@ScriptDir&'\Workshop\GCAISPACESHIPGLOBALS.GLOBAL.exml', 555, '<Property name="FreighterSpawnRate" value="'&GUICtrlRead($freighterSpawnChanceInput)&'" />', True)
			EndIf

			;Writing crashed ship minimum unbroken slots to file
			If $GCAISPACESHIPGLOBALSarray[1][0] Then
			   _FileWriteToLine(@ScriptDir&"\Workshop\GCAISPACESHIPGLOBALS.GLOBAL.exml", 22, '<Property name="CrashedShipMinNonBrokenSlots" value="'&GUICtrlRead($shipMinUnbrokenSlotsInput)&'" />', True)
			EndIf

	  EndSwitch

	  Run(@ScriptDir&"\Workshop\MBINCompiler.exe Workshop\"&$a&".exml Workshop\"&$a&".MBIN" , '', 0)
	  Sleep(2000)

   Next



   Sleep(1000)

   ;Creating the pak file
   Local $pakName = InputBox('NMS Tweaker', 'Name your pak file', 'MyNMSTweaks')
   RunWait('"' & @ComSpec & '" /c cd Workshop && PSArcTool.exe '&$pakParameterString, '', @SW_HIDE)
   Sleep(5000)
   RunWait('"' & @ComSpec & '" /c cd Workshop && Del '&$pakDeleteParameterString&' && move psarc.pak ..\'&$pakName&'.pak', '', @SW_HIDE)
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

   ;Check if multitool scanner recharge rate has been modified
   If GUICtrlRead($multitoolScannerRechargeInput) <> $GCGAMEPLAYGLOBALSarray[3][1] Then
	  $GCGAMEPLAYGLOBALSarray[3][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[3][0] = False
   EndIf

   ;Check if ship scanner range has been modified
   If GUICtrlRead($shipScannerRangeInput) <> $GCGAMEPLAYGLOBALSarray[4][1] Then
	  $GCGAMEPLAYGLOBALSarray[4][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[4][0] = False
   EndIf

   ;Check if ship scanner recharge rate has been modified
   If GUICtrlRead($shipScannerRechargeInput) <> $GCGAMEPLAYGLOBALSarray[5][1] Then
	  $GCGAMEPLAYGLOBALSarray[5][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[5][0] = False
   EndIf

   ;Check if max tech stacking has been modified
   If GUICtrlRead($maxTechStackingInput) <> $GCGAMEPLAYGLOBALSarray[6][1] Then
	  $GCGAMEPLAYGLOBALSarray[6][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[6][0] = False
   EndIf

   ;Check if freighter spawn chance has been modified
   If GUICtrlRead($freighterSpawnChanceInput) <> $GCAISPACESHIPGLOBALSarray[0][1] Then
	  $GCAISPACESHIPGLOBALSarray[0][0] = True
   Else
	  $GCAISPACESHIPGLOBALSarray[0][0] = False
   EndIf

   ;Check if warps between battles has been modified
   If GUICtrlRead($warpsBetweenBattlesInput) <> $GCGAMEPLAYGLOBALSarray[7][1] Then
	  $GCGAMEPLAYGLOBALSarray[7][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[7][0] = False
   EndIf

   ;Check if hours between battles has been modified
   If GUICtrlRead($hoursBetweenBattlesInput) <> $GCGAMEPLAYGLOBALSarray[8][1] Then
	  $GCGAMEPLAYGLOBALSarray[8][0] = True
   Else
	  $GCGAMEPLAYGLOBALSarray[8][0] = False
   EndIf

   ;Check if minimum unbroken slots has been modified
   If GUICtrlRead($shipMinUnbrokenSlotsInput) <> $GCAISPACESHIPGLOBALSarray[1][1] Then
	  $GCAISPACESHIPGLOBALSarray[1][0] = True
   Else
	  $GCAISPACESHIPGLOBALSarray[1][0] = False
   EndIf

   ;Update incompatibleList
   Local $incompatibleListValue = ''
   Global $modifiedFileArray[0]

   ;Check if GCGAMEPLAYGLOBALS.GLOBAL.MBIN has been modified
   For $a=0 To UBound($GCGAMEPLAYGLOBALSarray)-1 Step 1
	  If $GCGAMEPLAYGLOBALSarray[$a][0] Then
		 $incompatibleListValue &= 'GCGAMEPLAYGLOBALS.GLOBAL.MBIN'&@CRLF
		 _ArrayAdd($modifiedFileArray, 'GCGAMEPLAYGLOBALS.GLOBAL')
		 ExitLoop
	  EndIf
   Next

   ;Check if GCAISPACESHIPGLOBALS.GLOBAL.MBIN has been modified
   For $a=0 To UBound($GCAISPACESHIPGLOBALSarray)-1 Step 1
	  If $GCAISPACESHIPGLOBALSarray[$a][0] Then
		 $incompatibleListValue &= 'GCAISPACESHIPGLOBALS.GLOBAL.MBIN'&@CRLF
		 _ArrayAdd($modifiedFileArray, 'GCAISPACESHIPGLOBALS.GLOBAL')
		 ExitLoop
	  EndIf
   Next

   If GUICtrlRead($incompatibleList) <> $incompatibleListValue Then
	  GUICtrlSetData($incompatibleList, $incompatibleListValue)
   EndIf

EndFunc ;==> updateIncompatibleList


Func updateValuesForFullMod()

   ;Updating values for Starship Out of Range (alechielke)
   If $fullmodSSOORCurrentValue <> GUICtrlRead($fullmodSSOORInput) Then
	  Switch GUICtrlRead($fullmodSSOORInput)
		 Case 'None selected'
			GUICtrlSetData($starshipInteractRangeInput, $GCGAMEPLAYGLOBALSarray[1][1])
			$fullmodSSOORCurrentValue = 'None selected'
		 Case '200 units'
			GUICtrlSetData($starshipInteractRangeInput, 200)
			$fullmodSSOORCurrentValue = '200 units'
		 Case '500 units'
			GUICtrlSetData($starshipInteractRangeInput, 500)
			$fullmodSSOORCurrentValue = '500 units'
		 Case '1000 units'
			GUICtrlSetData($starshipInteractRangeInput, 1000)
			$fullmodSSOORCurrentValue = '1000 units'
		 Case '5000 units'
			GUICtrlSetData($starshipInteractRangeInput, 5000)
			$fullmodSSOORCurrentValue = '5000 units'
		 Case 'Infinite'
			GUICtrlSetData($starshipInteractRangeInput, 999999)
			$fullmodSSOORCurrentValue = 'Infinite'
	  EndSwitch
   EndIf

   ;Updating values for Faster Scanner (alechielke)
   If $fullmodFasterScannerCurrentValue <> GUICtrlRead($fullmodFasterScannerInput) Then
	  Switch GUICtrlRead($fullmodFasterScannerInput)
		 Case 'None selected'
			GUICtrlSetData($multitoolScannerRangeInput, $GCGAMEPLAYGLOBALSarray[2][1])
			GUICtrlSetData($multitoolScannerRechargeInput, $GCGAMEPLAYGLOBALSarray[3][1])
			GUICtrlSetData($shipScannerRangeInput, $GCGAMEPLAYGLOBALSarray[4][1])
			GUICtrlSetData($shipScannerRechargeInput, $GCGAMEPLAYGLOBALSarray[5][1])
			$fullmodFasterScannerCurrentValue = 'None selected'
		 Case 'Standard version'
			GUICtrlSetData($multitoolScannerRangeInput, 400)
			GUICtrlSetData($multitoolScannerRechargeInput, 2)
			GUICtrlSetData($shipScannerRangeInput, 20000)
			GUICtrlSetData($shipScannerRechargeInput, 2)
			$fullmodFasterScannerCurrentValue = 'Standard version'
	  EndSwitch
   EndIf

   ;Updating values for Faster Analysis (alechielke)
   If $fullmodFasterAnalysisCurrentValue <> GUICtrlRead($fullmodFasterAnalysisInput) Then
	  Switch GUICtrlRead($fullmodFasterAnalysisInput)
		 Case 'None selected'
			GUICtrlSetData($analysisTimeInput, $GCGAMEPLAYGLOBALSarray[0][1])
			$fullmodFasterAnalysisCurrentValue = 'None selected'
		 Case '3 seconds'
			GUICtrlSetData($analysisTimeInput, 3)
			$fullmodFasterAnalysisCurrentValue = '3 seconds'
		 Case '1 second'
			GUICtrlSetData($analysisTimeInput, 1)
			$fullmodFasterAnalysisCurrentValue = '1 second'
		 Case 'Instant'
			GUICtrlSetData($analysisTimeInput, 0)
			$fullmodFasterAnalysisCurrentValue = 'Instant'
	  EndSwitch
   EndIf

	;Updating values for Unlimited Tech Stacking (Greshloc)
	If $fullmodUnlimitedTechStackingCurrentValue <> GUICtrlRead($fullmodUnlimitedTechStackingInput) Then
		Switch GUICtrlRead($fullmodUnlimitedTechStackingInput)
			Case 'None selected'
				GUICtrlSetData($maxTechStackingInput, $GCGAMEPLAYGLOBALSarray[6][1])
				$fullmodUnlimitedTechStackingCurrentValue = 'None selected'
			Case '2x'
				GUICtrlSetData($maxTechStackingInput, $GCGAMEPLAYGLOBALSarray[6][1]*2)
				$fullmodUnlimitedTechStackingCurrentValue = '2x'
			Case '4x'
				GUICtrlSetData($maxTechStackingInput, $GCGAMEPLAYGLOBALSarray[6][1]*4)
				$fullmodUnlimitedTechStackingCurrentValue = '4x'
			Case '6x'
				GUICtrlSetData($maxTechStackingInput, $GCGAMEPLAYGLOBALSarray[6][1]*6)
				$fullmodUnlimitedTechStackingCurrentValue = '6x'
			Case 'Unlimited'
				GUICtrlSetData($maxTechStackingInput, 9999999)
				$fullmodUnlimitedTechStackingCurrentValue = 'Unlimited'
	  EndSwitch
	EndIf

EndFunc ;==> updateValuesforFullMod

;Actual code
createGUI()
While 1

   updateIncompatibleList()
   updateValuesForFullMod()
   Sleep(1000)

WEnd