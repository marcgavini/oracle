#!/bin/ksh
############################################################################
#@(#) Fonction : Librairie de fonctions communes autour des datapumps
#@(#) Creation : 1.0 M. Gavini 07/01/2019
#@(#) Modif    : 1.1 M. Gavini 27/08/2020 Rajout de l'affichage du chargement de la fonction
#@(#) Fichier  : MGDataPumpLib.sh
#@(#) Syntaxe  : . /BD_scripts/v?/exploite/Lib/MGDataPumpLib.sh
#@(#) Version  : 1.0 valide (en cours / en test / valide)
############################################################################
#
# CONTENU DE LA LIBRAIRIE
# ___________________________________________________________________
#  FctNB_APPEL_DataPumpLib   : Affiche le nombre d'appel a la librairie 
#  FctExport                 : Export   Datapump
# ___________________________________________________________________
#  Fonction internes: 
#  FctEchoPumpLib


 ####### #          #     #####
 #       #         # #   #     #
 #       #        #   #  #
 #####   #       #     # #  ####
 #       #       ####### #     #
 #       #       #     # #     #
 #       ####### #     #  #####

# Variables de la librairie : 
if [ "${FlagMGDataPumpLib}" = "Vrai" ]
then
   echo "..Fichier $0 déjà chargé"
   exit 0
fi
FlagMGDataPumpLib="Vrai"

  #####                          ######
 #     #   ####   #####   ###### #     #  ######   #####   ####   #    #  #####
 #        #    #  #    #  #      #     #  #          #    #    #  #    #  #    #
 #        #    #  #    #  #####  ######   #####      #    #    #  #    #  #    #
 #        #    #  #    #  #      #   #    #          #    #    #  #    #  #####
 #     #  #    #  #    #  #      #    #   #          #    #    #  #    #  #   #
  #####    ####   #####   ###### #     #  ######     #     ####    ####   #    #

# Nombre d'appel à la librairie
#integer NB_APPEL_DataPumpLib=0
NB_APPEL_DataPumpLib=0

# Variables generales
macote="'"
WFCT_NomFct=""

# Code retour de la librairie
#             RC généraux
         RC_OK=0
RC_ErreurParam=1
  RC_ErreurSql=2
   RC_ErreurOs=3
#             RC de la fonction FctVerifImportExport
RC_Pas_de_Succes_Dans_le_Fichier_log=2
RC_Erreur_Oracle_de_Type_ORA=3


 #######                   ###
 #         ####    #####    #     #    #   #####  ######  #####   #    #  ######
 #        #    #     #      #     ##   #     #    #       #    #  ##   #  #
 #####    #          #      #     # #  #     #    #####   #    #  # #  #  #####
 #        #          #      #     #  # #     #    #       #####   #  # #  #
 #        #    #     #      #     #   ##     #    #       #   #   #   ##  #
 #         ####      #     ###    #    #     #    ######  #    #  #    #  ######

# Fonction internes a la librairie

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchoPumpLib_0 () {

  ### -----------------------------------------------
  # fonction d'affichage d'un message par echo 
  ### -----------------------------------------------
  # Parametre 1 : Le message a afficher
  ### -----------------------------------------------

  echo          "$1"
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctDebugFct_0 () {

  ### -----------------------------------------------
  # fonction d'aide au Debug du code
  ### -----------------------------------------------

  if   [ "${WDEBUG}" = "oui" -a "${WQUIET}" != "oui" ]
  then
     echo "${WFCT_NomFct} __Debug-> $1 "
  fi

  return ${RC_OK}
}

 #######
 #         ####   #    #   ####    #####     #     ####   #    #   ####
 #        #    #  ##   #  #    #     #       #    #    #  ##   #  #
 #####    #    #  # #  #  #          #       #    #    #  # #  #   ####
 #        #    #  #  # #  #          #       #    #    #  #  # #       #
 #        #    #  #   ##  #    #     #       #    #    #  #   ##  #    #
 #         ####   #    #   ####      #       #     ####   #    #   ####

# fonctions de la librairie

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctNB_APPEL_DataPumpLib_0 () {
  ### --------------------------------------
  # fonction d'affichage du compteur NB_APPEL_DataPumpLib
  ### --------------------------------------

  WFCT_NomFct="..FctNB_APPEL_DataPumpLib_0"
  # ici on n'incremente pas la valeur du compteur, on l'affiche
  FctEchoPumpLib_0 "${Decallage} --> NB_APPEL_DataPumpLib   : <${NB_APPEL_DataPumpLib}>"
  return 0
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctTest_0 () {
  ### ----------------------------------------------------------------
  # fonction : 
  # Usage    :
  # Parametre:
  ### ----------------------------------------------------------------

  let NB_APPEL_DataPumpLib=NB_APPEL_DataPumpLib+1
  WFCT_NomFct="..Fcttest"
  FctEchoPumpLib_0 "${WFCT_NomFct}"
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctExport_0 () {
  ### ----------------------------------------------------------------
  # fonction : Export d'un fichier dump
  # Usage    : FctExport
  # Parametre: WUserExp WPassExp WNomUser WPassUser SidCib Dir UserCib NomFicDmp NomFicLog RepDump
  ### ----------------------------------------------------------------

  let NB_APPEL_DataPumpLib=NB_APPEL_DataPumpLib+1
  WFCT_NomFct="..FctExport_0"
  echo "..Suppression du fichier log s il existe "
  if [ ! -z "${RepDump}" -a ! -z "${NomFicLog}" ]; then rm -f ${RepDump}/${NomFicLog} ; fi
  FctDebugFct_0 "La commande : "
  FctDebugFct_0 "expdp ${WUserExp}/${WPassExp} directory=${Dir} SCHEMAS=${UserCib} dumpfile=${NomFicDmp} LOGFILE=${NomFicLog}"
  expdp ${WUserExp}/${WPassExp} DIRECTORY=${Dir}        \
                                  SCHEMAS=${UserCib}    \
                                 DUMPFILE=${NomFicDmp}  \
                                  LOGFILE=${NomFicLog}
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchora "${Decallage} librairie ${RepToolsLib}/MGDataPumpLib.sh Chargé"

#-------------------------------------#
# Fin de la librairie de fonction KSH #
#-------------------------------------#
