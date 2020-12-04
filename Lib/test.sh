Decallage=".."
echo "Test de la librairie MGDataPumpLib.sh"
. /home/oracle/BD_scripts/Lib/MGDataPumpLib.sh 
echo "Test du programme FctTest_0"
FctTest_0
FctNB_APPEL_DataPumpLib_0
echo "Test du programme FctExport_0"
RepDump=""
NomFicLog=""
WUserExp=""
WPassExp="" 
directory=""
SCHEMAS=${UserCib} 
dumpfile=${NomFicDmp} 
LOGFILE=${NomFicLog}"
Dir=""
UserCib=""
NomFicDmp=""
NomFicLog=""
FctExport_0 
