;AHk Audio Luxification/Reverse Sonification/Image2Audio
;Pandela 2022 /)
;Many Thanks to Dastar For The Square Root Epiphany I Needed <3 <3 <3
;Life Is A Party, Bake Cupcakes. - Gordon Ramsey 1945

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

/*
;old default settings
	AudioFormat := "u32le" ;or u8
	ChannelCount := "4" ;1 for mono, 2 for stereo
	SampleRate := "44100" ;default is 44100
	PixelFormat := "rgba64le" ;or rgb24
	OutputFormat := "flac" ;audio format of the final/baked output.
	Padded := "False" ;pad with extra null data, if something is seems wrong. This may also break it.
	CleanFiles := "True" ;if true, it fucken removes the .data file after the .tiff is made
	ImageFormat := "tiff"
*/


Gui Font, s9, Segoe UI
Gui, Color, 999999,White
Gui Add, ComboBox, x25 y211 w120 Choose1 vAudioFormat, u8|u16le|u32le 
Gui Add, ComboBox, x154 y228 w48 Choose1 vChannelCount, 2|4|6|8
Gui Add, ComboBox, x25 y244 w120 Choose3 vSampleRate, 8000|16000|44100|88100
Gui Add, ComboBox, x211 y211 w120 Choose1 vImageFormat, tiff|bmp|xwd
Gui Add, ComboBox, x211 y244 w120 Choose1 vOutputFormat, flac|wav|mp3|ogg
Gui Add, ComboBox, x116 y273 w120 Choose1 vPixelFormat, rgb24|rgb48le|rgba64le
Gui Add, Text, x27 y188 w88 h23 +0x200, Audio Format
Gui Add, Text, x26 y267 w68 h29 +0x200, Sample Rate
Gui Add, Text, x109 y300 w135 h23 +0x200, Colorspace/Pixel Format
Gui Add, Text, x153 y204 w52 h23 +0x200, Channels
Gui Add, Text, x252 y188 w78 h23 +0x200, Image Format
Gui Add, Text, x255 y267 w79 h23 +0x200, Export Format
Gui Add, Radio, x27 y35 w152 h23 +Checked g8BitPreset,Uncompressed 8-Bit
Gui Add, Radio, x27 y62 w153 h23 g16BitPreset, Uncompressed 16-bit
Gui Add, Radio, x27 y89 w153 h23 g32BitPreset, Uncompressed 32-bit
Gui Add, GroupBox, x15 y8 w176 h118, Audio Format Options
Gui Add, GroupBox, x215 y8 w120 h118, Nomal Options
Gui Add, CheckBox, x220 y51 w93 h23 +Checked vCleanFiles, Cleanup Files?
Gui Add, CheckBox, x220 y75 w112 h23 vPadded gPadded +Disabled, Toggle Silence?
Gui Add, CheckBox, x220 y27 w102 h23 gAddSilence vSilenceCheck +Disabled, Add Silence?
Gui Add, CheckBox, x220 y99 w105 h23 gAlwaysOnTopToggle, Always On Top?
Gui Add, Button, x244 y145 w80 h23 gSelectFile, Input
Gui Add, Button, x88 y330 w80 h23 gCreateImage +Disabled vCreateImageButton, Create Image
Gui Add, Edit, x134 y177 w85 h21 +Disabled +Center vImgDimensions hwndHED
Gui Add, Button, x180 y330 w80 h23 +Disabled vExportAudioButton gBakedGoods, Export Audio
Gui Add, Text, x127 y154 w101 h23 +0x200, Image Dimensions
Gui Add, Button, x27 y145 w80 h23 +Disabled gPreviewAudio vPreviewButton, Preview


SilenceVar := 0 ;do no touch >:(
SilenceFile := "silence.data" ;do no touch >:(
uhh := 0 ;do no touch >:(
NotPaddedYet = 1 ;do no touch >:(
oneTimePreviewMsg := 1 ;do no touch >:(
oneTimeBakeMsg := 1 ;do no touch >:(
Gui Show, w352 h367, Audio2Image - R3V153D
Return



8BitPreset:


GuiControl,Disable, Padded
GuiControl,, Padded,0
GuiControl,Disable, SilenceCheck
GuiControl,, SilenceCheck,0

GuiControl,Choose,AudioFormat,1
GuiControl,Choose,ChannelCount,1
GuiControl,Choose,PixelFormat,1
tooltip, good quality/the most stable

Gui,Submit,Nohide

SilenceVar := SilenceCheck


GuiControlGet,CurrentAudioFormat,,AudioFormat
Outputfile := Filename . "-" . SampleRate . "-" . CurrentAudioFormat

Gosub,CreateTemplateFile


if (SilenceVar = 1) %SilenceVar% {
	FileGetSize,Filesize,%PaddedOutput% ;get filesize of raw/uncompressed audio file
}

if (SilenceVar = 0) {
	FileGetSize,Filesize,%Outputfile%.data ;get filesize of raw/uncompressed audio file	
}
;Dimensions := Floor(Sqrt((Filesize)/3))
;Dimensions := Dimensions . "x" . Dimensions

ControlFocus, ImgDimensions, ahk_id %HED%
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False,&Blank, , ahk_id %HED%   ; EM_REPLACESEL
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False, &NewDimensions, , ahk_id %HED%   ; EM_REPLACESEL


sleep, 1000
tooltip
return

16BitPreset:
Gui,Submit,Nohide

SilenceVar := SilenceCheck


GuiControl,Disable, Padded
GuiControl,, Padded,0
GuiControl,Disable, SilenceCheck
GuiControl,, SilenceCheck,0

GuiControl,Choose,AudioFormat,2
GuiControl,Choose,ChannelCount,1
GuiControl,Choose,PixelFormat,2
tooltip, better quality/mostly stable

Gui,Submit,Nohide

sleep, 20

GuiControlGet,CurrentAudioFormat,,AudioFormat
Outputfile := Filename . "-" . SampleRate . "-" . CurrentAudioFormat

gosub, CreateTemplateFile


;clipboard := Outputfile ".data"

if (SilenceVar = 1) {
	FileGetSize,Filesize,%PaddedOutput% ;get filesize of raw/uncompressed audio file
}

if (SilenceVar = 0) {
	FileGetSize,Filesize,%Outputfile%.data ;get filesize of raw/uncompressed audio file	
}
;Dimensions := Floor(Sqrt((Filesize)/6))
;Dimensions := Dimensions . "x" . Dimensions


ControlFocus, ImgDimensions, ahk_id %HED%
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False,&Blank, , ahk_id %HED%   ; EM_REPLACESEL
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False, &NewDimensions, , ahk_id %HED%   ; EM_REPLACESEL

sleep, 1000
tooltip
Return



32BitPreset:
Gui,Submit,Nohide
;gosub, SelectFile

SilenceVar := SilenceCheck


GuiControl,Choose,AudioFormat,3
GuiControl,Choose,ChannelCount,2
GuiControl,Choose,PixelFormat,3
GuiControl,Disable, Padded
GuiControl,, Padded,0
GuiControl,Disable, SilenceCheck
GuiControl,, SilenceCheck,0

Gui,Submit,NoHide

GuiControlGet,CurrentAudioFormat,,AudioFormat
Outputfile := Filename . "-" . SampleRate . "-" . CurrentAudioFormat

Outputfile := Filename . "-" . SampleRate . "-" . CurrentAudioFormat

gosub, CreateTemplateFile


if (SilenceVar = 1) %SilenceVar% {
	FileGetSize,Filesize,%PaddedOutput% ;get filesize of raw/uncompressed audio file
}

if (SilenceVar = 0) {
	FileGetSize,Filesize,%Outputfile%.data ;get filesize of raw/uncompressed audio file	
}
;Dimensions := Floor(Sqrt((Filesize)/8))
;Dimensions := Dimensions . "x" . Dimensions





ControlFocus, ImgDimensions, ahk_id %HED%
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False,&Blank, , ahk_id %HED%   ; EM_REPLACESEL
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False, &NewDimensions, , ahk_id %HED%   ; EM_REPLACESEL

tooltip, best quality/unstable
sleep, 1000
tooltip

Return

AddSilence:
GuiControlGet,SilenceVar,,SilenceCheck
GuiControl,Enable, Padded
OldFile := File



if (SilenceVar = 1) {
	;tooltip, ye %SilenceVar%
	Gui Font, s9, Segoe UI
	Gui, Silence:Color, 999999,White
	Gui, Silence:-Sysmenu
	
	Gui Silence:Add, GroupBox, x21 y28 w150 h105, .....How Much Silence?
	Gui Silence:Add, Edit, x35 y64 w120 h21 vSilenceDuration +Center,120
	Gui Silence:Add, Button, x55 y90 w80 h23 gCloseSilenceMenu, &OK
	Gui Silence:Add, Text, x26 y137 w162 h17 +0x200, Adding silence to your sample
	Gui Silence:Add, Text, x19 y154 w178 h18 +0x200, can sometimes fix things such as
	Gui Silence:Add, Text, x14 y170 w200 h23 +0x200, Popping/Crackling sounds, or even
	Gui Silence:Add, Text, x15 y190 w184 h23 +0x200, change the tempo of your glitches
	Gui Silence:Add, Text, x32 y211 w155 h24 +0x200, and how they sound entirely
	
	GuiControl,,Padded,1
	Gui Silence:Show, w195 h239, Add Silence! (in seconds)
}

if (SilenceVar = 0) {
	OldDimensions := OldDimensions . "x" . OldDimensions
	
	GuiControl,Disable, Padded
	GuiControl,, Padded,0
	
	ControlFocus, ImgDimensions, ahk_id %HED%
	sleep, 100
	SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
	sleep, 100
	SendMessage, 0x00C2, False,&Blank, , ahk_id %HED%   ; EM_REPLACESEL
	sleep, 100
	SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
	sleep, 100
	SendMessage, 0x00C2, False, &OldDimensions, , ahk_id %HED%   ; EM_REPLACESEL
	
	
	;tooltip silence padding Disabled %SilenceVar%
	;sleep, 1000
	;tooltip
	
}
Return

CloseSilenceMenu:
Gui, Silence:Submit,Nohide
Gui,Silence:Destroy
Gui,Submit,NoHide

SplitPath,File, OutputFilename
SplitPath,File,,,,PaddedOutputName
SplitPath,File,,PaddedFileDir
PaddedOutput := PaddedOutputName . "-" . SampleRate . "-" . AudioFormat . "-Padded.data"
NoCompression := ""
OldDimensions := Dimensions	

if !RegExMatch(File, ".data") { ;if input file is NOT wav then we need to convert it to such for the silence concat to work.
		;msgbox, Converting to wav...	
	global NewWav := PaddedOutputName . ".data"
	MakeWAV := "cmd.exe /c ffmpeg -i " . File . " -y " . " -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " " . chr(0x22) . NewWav . chr(0x22)
	runwait, %MakeWAV%
}	

	;if input file is wav then skip encoding.
if RegExMatch(File, ".data") {
	global NewWav := FileInput
		;msgbox % NewWav
}
	;Generate Silence and pad it at the end of the input file.
	;msgbox, Generating Silence...
MakeSilence := "cmd.exe /c ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=" . SampleRate . " -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " -t " . SilenceDuration . " -y " . SilenceFile
ConcatTXT := "cmd.exe /c (echo file `'" . NewWav . "`' & echo file `'" . SilenceFile . "`' )>list.txt"
FinalFile := "cmd.exe /c ffmpeg -y -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " -i concat:" . chr(0x22) . NewWav .  "|" . SilenceFile . chr(0x22) . "  -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " " . chr(0x22) . PaddedOutput . chr(0x22)

;FinalFile := "cmd.exe /k ffmpeg -safe 0 -f concat -i list.txt -y -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " " . chr(0x22) . PaddedOutput . chr(0x22)
;msgbox % FinalFile
clipboard := FinalFile
runwait, %MakeSilence%
runwait, %ConcatTXT%
runwait, %FinalFile%
File := PaddedOutput
;msgbox % File
gosub, TestMe
Return


Padded:
Gui,Submit,Nohide
if (Padded = 1) {
	if (NotPaddedYet = 1) && (uhh = 0) {
		;OldDimensions := Dimensions	
		;Dimensions := Dimensions + 1
		uhh := 1
	}
	GuiControl,,ImgDimensions,%Dimensions%x%Dimensions%
}

if (Padded = 0) {
	GuiControl,,ImgDimensions,%OldDimensions%x%OldDimensions%
}
Return

SelectFile:
Gui,Submit,NoHide

FileSelectFile,File
SplitPath,File,,,,Filename
Filename := StrReplace(Filename," ","_") ;replace space with underscore
File := chr(0x22) . File . chr(0x22) ;wrap filename in double quotes
Outputfile := Filename . "-" . SampleRate . "-" . AudioFormat


CreateTemplateFile: ;testing HWERE
CreateTemplateFile := ComSpec . " /c ffmpeg  -i " File . " -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " -vn -y " . Outputfile . ".data"
runwait, %CreateTemplateFile% ;create raw/uncompressed audio file
GuiControl,Enable,ImgDimensions
GuiControl,Enable, CreateImageButton
GuiControl,Enable, SilenceCheck

FileGetSize,Filesize,%Outputfile%.data ;get filesize of raw/uncompressed audio file	



if (AudioFormat = "u8") {
	Dimensions := Floor(Sqrt((Filesize)/3))   ;square root of filesize divided by three
	if (Padded = 1) && (uhh = 1)  {
		NotPaddedYet := 0
		;OldDimensions := Dimensions		
		;Dimensions := Dimensions + 1
	}
}


if (AudioFormat = "u16le") {
	Dimensions := Floor(Sqrt((Filesize)/6))   ;square root of filesize divided by six
	if (Padded = 1) && (uhh = 1) {
		NotPaddedYet := 0		
		;OldDimensions := Dimensions		
		;Dimensions := Dimensions + 1
	}
}


if (AudioFormat = "u32le") {
	Dimensions := Floor(Sqrt((Filesize)/8))   ;square root of filesize divided by eight
	if (Padded = 1) && (uhh = 1) {
		NotPaddedYet := 0		
		;OldDimensions := Dimensions
		;Dimensions := Dimensions + 1
	}
}

global NewDimensions := Dimensions . "x" . Dimensions


ControlFocus, ImgDimensions, ahk_id %HED%
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False,&Blank, , ahk_id %HED%   ; EM_REPLACESEL
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False, &NewDimensions, , ahk_id %HED%   ; EM_REPLACESEL


return

TestMe:
;Gui,Submit,NoHide
;GuiControlGet,CheckSilence,,SilenceCheck
if (SilenceVar = 1) %SilenceVar% {
	FileGetSize,Filesize,%PaddedOutput% ;get filesize of raw/uncompressed audio file
}

if (SilenceVar = 0) {
	FileGetSize,Filesize,%Outputfile%.data ;get filesize of raw/uncompressed audio file	
}
	


if (AudioFormat = "u8") {
	Dimensions := Floor(Sqrt((Filesize)/3))   ;square root of filesize divided by three
	if (Padded = 1) && (uhh = 1)  {
		NotPaddedYet := 0
		;OldDimensions := Dimensions		
		;Dimensions := Dimensions + 1
	}
}


if (AudioFormat = "u16le") {
	Dimensions := Floor(Sqrt((Filesize)/6))   ;square root of filesize divided by six
	if (Padded = 1) && (uhh = 1) {
		NotPaddedYet := 0		
		;OldDimensions := Dimensions		
		;Dimensions := Dimensions + 1
	}
}


if (AudioFormat = "u32le") {
	Dimensions := Floor(Sqrt((Filesize)/8))   ;square root of filesize divided by eight
	if (Padded = 1) && (uhh = 1) {
		NotPaddedYet := 0		
		;OldDimensions := Dimensions
		;Dimensions := Dimensions + 1
	}
}


NewDimensions := Dimensions . "x" . Dimensions
Blank := ""

GuiControl,Enable,ImgDimensions
GuiControl,Enable, CreateImageButton
GuiControl,Enable, SilenceCheck


;GuiControl,,ImgDimensions,%NewDimensions%
ControlFocus, ImgDimensions, ahk_id %HED%
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False,&Blank, , ahk_id %HED%   ; EM_REPLACESEL
sleep, 100
SendMessage, 0x00B1,, -1, , ahk_id %HED%           ; EM_SETSEL (original idea by SKAN): sets the caret to the end of text
sleep, 100
SendMessage, 0x00C2, False, &NewDimensions, , ahk_id %HED%   ; EM_REPLACESEL

;ControlSetText,ImgDimensions,%NewDimensions%,A
File := OldFile
Return



CreateImage:
Gui,Submit,NoHide
Outputfile := Filename . "-" . SampleRate . "-" . AudioFormat
if (SilenceCheck = 1) {
	
	if !InStr(PaddedOutput,chr(0x22)) {
		NewInputFile := chr(0x22) PaddedOutput chr(0x22)
		
	}
	if InStr(PaddedOutput,chr(0x22)) {
		NewInputFile := PaddedOutput
		
	}
}

if (SilenceCheck = 0) {
	NewInputFile := Outputfile . ".data"
}



CreateImage := ComSpec . " /c ffmpeg -f rawvideo -s " . ImgDimensions . " -pix_fmt " . PixelFormat . " -i " . NewInputFile . " -vframes 1 -y -compression_algo raw " Outputfile . "." . ImageFormat
runwait, %CreateImage% ;generate the FUCKING tiff image 
;msgbox % CreateImage

if (CleanFiles = 1) {
	RemoveMe := A_WorkingDir . "\" . Outputfile . ".data"
	
	FileDelete, %RemoveMe% ;get that shit outta here >:c
	RemoveMe2 := A_WorkingDir . "\" . PaddedOutput
	FileDelete, %RemoveMe2% ;get that shit outta here >:c
	RemoveMe3 := A_WorkingDir . "\" . 	NewWav	
	FileDelete, %RemoveMe3% ;get that shit outta here >:c
	RemoveMe4 := A_WorkingDir . "\" . 	NewWav		
	FileDelete, %RemoveMe4% ;get that shit outta here >:c
	RemoveMe5 := A_WorkingDir . "\" . 	SilenceFile		
	FileDelete, %RemoveMe5% ;get that shit outta here >:c
	RemoveMe6 := A_WorkingDir . "\" . 	"list.txt"		
	FileDelete, %RemoveMe6% ;get that shit outta here >:c
}

GuiControl,Enable, PreviewButton
GuiControl,Enable, ExportAudioButton
return



;Preview Audio
!F2:: ;Alt+F2
PreviewAudio:
if (oneTimePreviewMsg = 1) {
	msgbox, You can also Alt+F2
	oneTimePreviewMsg := 0
}

Gui,Submit,NoHide
sleep, 30
PreviewImage := ComSpec . " /c ffplay -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " -i " . A_WorkingDir . "\" . Outputfile . "." . ImageFormat " -af " chr(0x22) "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" chr(0x22)
clipboard := PreviewImage
run, %PreviewImage%
return


;Bake/Finalize Audio
!F3:: ;Alt+F3
BakedGoods:
if (oneTimeBakeMsg = 1) {
	msgbox, You can also Alt+F3
	oneTimeBakeMsg := 0
}

Gui,Submit,NoHide
sleep, 30
BakedGoods := ComSpec . " /c ffmpeg -f " . AudioFormat . " -ac " . ChannelCount . " -ar " . SampleRate . " -i " . A_WorkingDir . "\" . Outputfile . "." . ImageFormat . " Final-" . Outputfile . "." OutputFormat
run, %BakedGoods%
return


AlwaysOnTopToggle:
Winset, Alwaysontop,Toggle, Audio2Image - R3V153D
return

