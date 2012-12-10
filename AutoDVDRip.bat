:: Change the following to fit your needs"
:: Please only change only after the equal sign

:: What letter is your DVD Drive?
set DVDDrive=F:

:: Where do you want to store the DVD rip? It will store the files here in a folder called rips"
set localStorage=C:\Users\User\Videos\

:: Where is handbrake installed?
set handBrakeInstall=C:\Program Files\Handbrake

:: What preset do you want to rip with? 
:: See presets here https://trac.handbrake.fr/wiki/BuiltInPresets
set handbrakePreset=Normal

:: Where is nirCmd installed?
set nirmCmdInstall=c:\Program Files\NirCmd

:: Where is media companion installed?
set mediaCompanionInstall=C:\Users\UserName\Desktop\MediaCompanion3.510b

:: What is the name of your Media Companion Profile? 
:: Here is a link on how to create a profile 
:: http://imgur.com/aoOgN 
set mediaCompanionProfile=Movies

:: Do you have an external harddrive you want to transfer the files to?
:: If not just leave this how it is
:: If so what letter is the drive?
set externalDrive=D:

:: Where on the external do you want to put the movies?
set externalMovies=D:\Movies\


:: END HERE UNLESS YOU ARE AN ADVANCED USER


















:: This takes takes the name of the DVDDrive and creates a variable called vol which we will use for naming 
:: the file and folders
%DVDDrive%
for /f "tokens=1-5*" %%1 in ('vol') do (
   set vol=%%6& goto done
)
:done

:: This navigates to the user's localStorage input 
:: and creates a folder inside of it called Rips
C:
CD %localStorage%
mkdir Rips

:: this navigates to the Rips folder and creates a folder named afer the DVD title (vol is a variable)
cd %localStorage%\Rips
mkdir %vol%

:: Navigates to where the user said they installed handbrake 
CD %handBrakeInstall%

:: this says the input (-i) is the DVDdrive and it will rip to the local storage rip folder, and will rip it 
:: to the %vol% folder and name the movie %vol%.mp4 with whatever preset the user wants
:: maybe always have subtitles? Look into this later
handbrakecli -i %DVDDrive%/ -o %localStorage%\Rips\%vol%\%vol%.mp4 --preset="%handbrakePreset%" -f mp4 --main-feature

:: navigates to the nircmd install folder and opens the DVD drive
:: I really like this because even though the program is still running, it tells the user it is now 
:: safe to open the DVD drive and put in a new movie
CD %nirmCmdInstall%
nircmd.exe cdrom open %DVDDrive%

:: This gets the meta info for the movie
CD %mediaCompanionInstall%
mc_com.exe -m -p %mediaCompanionProfile%

:: This says hey is your external plugged in? if so move the file we made into the external harddrive
:: Please note robocopy only works with windows vista and up
IF EXIST %externalDrive%\ (robocopy %localStorage%\Rips %externalMovies% /mov /r:0 /S /dcopy:t)
IF EXIST %externalDrive%\ (rd /s/q %localStorage%\Rips)

:: Plays a noise to let your know it was sucessful 
:: Though it plays even if its not sucessful, need to fix if i ever get
:: serious about this
IF EXIST %externalDrive%\ (start C:\Windows\Media\Characters\"Windows Error.wav")

:: Computer beeps because they are fun
ECHO  
ECHO  
ECHO  
ECHO  

PAUSE