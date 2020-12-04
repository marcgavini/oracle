#!/bin/bash
############################################################################
#@(#) Fonction : Librairie de fonctions à usage des scripts Oracle
#@(#) Creation : 1.0 M. Gavini 10/01/2019 
#@(#) Modif    : 1.1 M. Gavini 06/02/2019 Rajout FctSauvegardeDbca_0
#@(#) Modif    : 1.2 M. Gavini 23/06/2020 Modif  FctSauvegardeRman_0 parametre retention policy rajouté 
#@(#) Modif                               Modif  FctCleanupFicSaveRman_0 suppression ancienne sauvegarde sur param nombre de sauvegarde gardé
#@(#) Modif    : 1.3 M. Gavini 27/08/2020 Rajout FctVerifVersionOracle_0
#@(#) Fichier  : MGOracleLib.sh
#@(#) Syntaxe  : . /home/oracle/BD_scripts/v0/Lib/MGOracleLib.sh
#@(#) Version  : 1.3 Valide (en cours / en test / valide)
############################################################################
#
# CONTENU DE LA LIBRAIRIE
# ___________________________________________________________________
#  FctEchora                      : Affichage message
#  FctEchOra                      : Affichage message Debug compris
#  FctEchoMGOracleLib_0           : Affichage message (versionné)
#  FctNB_APPEL_MGOracleLib_0      : Affiche le nombre d'appel a la librairie
#  FctVerifVersionOracle_0        : Verification de la version Oracle authorisé dans les programmes
#  FctVerifExistanceBase_0        : Verification de l'existance d'une base 
#  FctExecSqlRecupValeur_0        : Execution d'une select qui rend une valeur dans une variable 
#  FctCreateDirectory_0           : Creation d'un Directory
#  FctAfficheObjInvalide_0        : Affiche les Objets invalides par le user sys
#  FctAfficheObjInvalideUsr_0     : Affiche les Objets invalides par le user GRHUM
#  FctVerifInstanceIsOpen_0       : Verification que l'instance est ouverte
#  FctGenereRenameFicDataEtLog_0  :
#  FctSauvegardeRman_0            : Sauvegarde par Rman
#  FctSauvegardeDbca_0            : Sauvegarde par Dbca
#  FctCleanupFicSaveRman_0        : Suppression fichier temporaire de save Rman
#  FctCleanupFicSaveDbca_0        : Suppression fichier temporaire de save Dbca
#  FctAppels_install_patchs_0     : Appel aux programmes d'installation des patchs
# ___________________________________________________________________

#

 ####### #          #     #####
 #       #         # #   #     #
 #       #        #   #  #
 #####   #       #     # #  ####
 #       #       ####### #     #
 #       #       #     # #     #
 #       ####### #     #  #####

# Variables de la librairie :
if [ "${FlagMGOracleLib}" = "Vrai" ]
then
   echo ".. Fichier $0 déjà chargé"
   exit 0
fi
FlagMGOracleLib="Vrai"
FlagCalculDBAPassword="non"


  #####                          ######
 #     #   ####   #####   ###### #     #  ######   #####   ####   #    #  #####
 #        #    #  #    #  #      #     #  #          #    #    #  #    #  #    #
 #        #    #  #    #  #####  ######   #####      #    #    #  #    #  #    #
 #        #    #  #    #  #      #   #    #          #    #    #  #    #  #####
 #     #  #    #  #    #  #      #    #   #          #    #    #  #    #  #   #
  #####    ####   #####   ###### #     #  ######     #     ####    ####   #    #

# Nombre d'appel à la librairie
NB_APPEL_OracleLib=0

macote="'"
# code retour généraux
RC_OK=0
RC_KO=666
RC_ErrParam=1
RC_ErrSql=2
RC_ErrOs=3
#
# Code retour des fonctions
RC_InstanceInconnu=1
RC_ArretSurAbortDemande=9
RC_RepertoireInexistant=4
RC_InstanceArrete=9
#
 #######                   ###
 #         ####    #####    #     #    #   #####  ######  #####   #    #  ######
 #        #    #     #      #     ##   #     #    #       #    #  ##   #  #
 #####    #          #      #     # #  #     #    #####   #    #  # #  #  #####
 #        #          #      #     #  # #     #    #       #####   #  # #  #
 #        #    #     #      #     #   ##     #    #       #   #   #   ##  #
 #         ####      #     ###    #    #     #    ######  #    #  #    #  ######

# Les fonctions internes de la librairie :

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchora () {
  FctEchoMGOracleLib_0 "$1"
  return ${RC_OK}
}



# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchoMGOracleLib_0 () {
  ### -----------------------------------------------
  # fonction d'affichage d'un message par echo
  ### -----------------------------------------------
  # Parametre 1 : Le message a afficher
  # Parametre 2 : optionnel Le type de message a afficher (d=debug, l=FctEchoFicLog, *=echo)
  # Parametre 3 : optionnel Le nom du fichier log
  ### -----------------------------------------------

  if [ "${FlagMGScritpLib}" = "Vrai" ]
  then
     Fctecho "$1"
  else
     echo "$1"
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchOra () {
  ### -----------------------------------------------
  # fonction d'affichage d'un message par echo
  ### -----------------------------------------------
  # Parametre 1 : Le message a afficher
  # Parametre 2 : optionnel Le type de message a afficher (d=debug, l=FctEchoFicLog, *=echo)
  # Parametre 3 : optionnel Le nom du fichier log
  ### -----------------------------------------------

  if [ "${FlagMGScritpLib}" = "Vrai" ]
  then
     FctEcHo "$1" "$2"
  else
     if [ "${1}" = "D" ]
     then
        if [ "${WDEBUG}" = "oui" ]
        then
          echo "__Debug->$2"
        fi
     else
        echo "$2"
     fi
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

FctNB_APPEL_MGOracleLib_0 () {
  ### --------------------------------------
  # fonction d'affichage du compteur NB_APPEL_OracleLib
  ### --------------------------------------

  # ici on n'incremente pas la valeur du compteur, on l'affiche
  FctEchora "${Decallage} --> NB_APPEL_OracleLib     : <${NB_APPEL_OracleLib}>" "l"
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifVersionOracle_0 () {
  ### ----------------------------------------------------------------
  # fonction de Verification des versions Oracle utilisable 
  # Usage  : FctVerifVersionOracle_0 
  ### ----------------------------------------------------------------
  #WDEBUG="oui"
  NomFct="FctVerifVersionOracle_0"
  # Affichage si debugage
  FctEchOra "D" "${NomFonction} WFVersion=$1"
  FctEchOra "D" "${NomFonction} WFAppellant=$2"
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur Version Oracle vide" ; return ${RC_ErrParam} ; else       WFVersion=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "D" "${NomFct}: Arret sur abort       vide"                         ; else WFArretSurAbort=$2 ; fi
  if [ -z "$3" ] ; then FctEchOra "D" "${NomFct}: Appellant             vide"                         ; else     WFAppellant=$3 ; fi

  if [ "${WFVersion}" = "11.2.0" -o "${WFVersion}" = "12.2.0" -o "${WFVersion}" = "18.0.0" -o "${WFVersion}" = "19.0.0" ]
  then
    FctEchOra "X" "${Decallage}Version  OK <${WFVersion}>"
    return ${RC_OK}
  else
    FctEchOra "X" "${Decallage}Version  KO <${WFVersion}>"
    if [ "${WFArretSurAbort}" = "ArretSurAbort" ]
    then
       FctEchOra "X" "${Decallage}ABORT ${NomFct}"
       exit ${RC_ArretSurAbortDemande}
    else
       return ${RC_KO}
    fi 
  fi 
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctPositVariableOracle_0 () {
  ### ----------------------------------------------------------------
  # fonction de Positionnement des variables d'environnement Oracle
  # Usage  : FctPositVariableOracle_0 
  ### ----------------------------------------------------------------

  NomFct="FctPositVariableOracle_0"
  # Affichage si debugage
  FctEchOra "D" "${NomFonction} Instance=$1"
  if [ -z "$1" ] ; then FctEchOra "E"  "${NomFct}: Version Oracle vide" ; return ${RC_ErrParam} ; else WFVersion=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E"  "${NomFct}: SID            vide" ; return ${RC_ErrParam} ; else     WFSid=$2 ; fi

  export      ORACLE_HOME=$(cd -P /u0*/app/oracle/product/${WFVersion}/db_1;pwd)
  FctEcHo     "${Decallage}.ORACLE_HOME=${ORACLE_HOME}"
  PATH=$PATH:$ORACLE_HOME/bin/
  export        ORACLE_SID=${WFSid}
  FctEcHo     "${Decallage}.ORACLE_SID=${ORACLE_SID}"
  
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifExistanceBase_0 () {
  ### ----------------------------------------------------------------
  # fonction de verification de l'existance de la base dans le fichier oratab
  # Usage : FctVerifExistanceBase_0 SID "ArretSurAbort"
  # Param1 : Instance oracle 
  # Param2 : optionnel : "ArretSurAbort"
  ### ----------------------------------------------------------------
  #WDEBUG="oui"
  NomFct="FctVerifExistanceBase_0"
  # Affichage si debugage
  FctEchOra "D" "${NomFonction} Instance=$1"
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur instance vide"; return ${RC_ErrParam}      ; else WFInstance=$1      ; fi
  if [ -z "$2" ] ; then FctEchOra "D" "${NomFct}: Arret sur abort vide"                             ; else WFArretSurAbort=$2 ; fi

  # Verif existence de la base dans le fichier oratab
  CHECK_DB_IN_ORATAB=$( grep -i "${WFInstance}" /etc/oratab | awk -F: '! (/^ *#/) {print $1}' )
  FctEchOra "D" "CHECK_DB_IN_ORATAB $CHECK_DB_IN_ORATAB"
  if [ -z "${CHECK_DB_IN_ORATAB}" ]
  then
     FctEchOra "E" "${Decallage}Instance Oracle ${WFInstance} n_existe pas dans oratab "
     #FctEchora "Instance Oracle ${WFInstance} n_existe pas dans oratab "
     if [ "${WFArretSurAbort}" = "ArretSurAbort" ]
     then
        FctEchOra "X" "${Decallage}ABORT ${NomFct}"
        exit ${RC_ArretSurAbortDemande}
     else 
        return ${RC_InstanceInconnu}
     fi 
  else
    FctEchOra "X" "${Decallage}Instance OK <${WFInstance}> Existe dans oratab"  
     return ${RC_OK}
  fi
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifInstanceIsOpen_0 () {
  ### ----------------------------------------------------------------
  # fonction de verification de l'ouverture de l'instance ORACLE_SID
  # Usage : FctVerifInstanceIsOpen_0
  # Param : facultatif Nom_Instance "ArretSurAbort"  permet l'abort en cas d'erreur
  ### ----------------------------------------------------------------

  NomFct="FctVerifInstanceIsOpen_0"
  # Affichage si debug
  FctEchOra "D" ".${Decallage}${NomFct} Instance=$1"
  if [ -z "$1" ] ; then FctEchora ".${Decallage}${NomFct}: Erreur instance vide"; return ${RC_ErrParam} ; else WFInstance=$1      ; fi
  if [ -z "$2" ] ; then FctEchOra "D" ".${Decallage}${NomFct}: Arret sur abort vide"                    ; else WFArretSurAbort=$2 ; fi
  #
  # Verification de la presence du process pmon pour l'ORACLE_SID
  NBLIG=$(ps -ef | grep ${WFInstance} | grep pmon | wc -l)
  if [ ${NBLIG} -eq 0 ]
  then
     FctEchora "${Decallage}${NomFct} Verification base <${WFInstance}> BASE_ARRETE"
     if [ "${WFArretSurAbort}" = "ArretSurAbort" ]
     then
        FctEchora "${Decallage}${NomFct} ${Decallage} ABORT"
        FctEchora "${Decallage}${NomFct} ${Decallage} Verification Base ${WFInstance} ouverte KO"
        exit ${RC_ArretSurAbortDemande}
     fi
     return ${RC_InstanceArrete}
  else
    FctEchora ".${Decallage}${NomFct} ${Decallage} Verification base <${1}> BASE_DEMARRE"
    Affichage=$(ps -ef | grep $1 | grep pmon )
    FctEchOra "D" "${Decallage}${NomFct} ${Decallage} ${Affichage}"
    return ${RC_OK}
  fi
}


# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctExecSqlRecupValeur_0 () {
  ### ----------------------------------------------------------------
  # fonction D'execution d'une select et de recuperation de la valeur de retour
  # Appel : FctExecSqlRecupValeur
  # fct_FctExecSqlRecupValeur info_connection Commande_sql
  # Param 1) Les Info de connection
  # Param 2) La Commande SQL (sans le ;)
  ### ----------------------------------------------------------------
  # Variable de retour : WFMaValeurSelect
  ### ----------------------------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  NomFct="FctExecSqlRecupValeur_0"
  FctEchOra "D" "${NomFct} Connection=$1"
  FctEchOra "D" "${NomFct} Cmd sql   =$2"
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur Info de connection  vide"; return ${RC_ErrParam} ; else WFInfoconne=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur La Commande SQL     vide"; return ${RC_ErrParam} ; else    WFCmdSql=$2 ; fi
  # Affichage si debugage
  FctEchOra "D" "${NomFct} ${Decallage} Dbg:Variables d'appel"
  FctEchOra "D" "${NomFct} ${Decallage} Dbg:  Info de connection         :<$WFInfoconne>"
  FctEchOra "D" "${NomFct} ${Decallage} Dbg:  Commande SQL               :<$WFCmdSql>"

WFMaValeurSelect=$( sqlplus -S "${WFInfoconne}" <<_EOF
set heading  off
set feedback off
${WFCmdSql};
_EOF
)
  WFMaValeurSelect=$(echo ${WFMaValeurSelect} | awk  '{ print $0 }')
  if [ "${WDEBUG}" = "oui" ]
  then
     echo "Resultat de ma commande <${WFMaValeurSelect}>"
  fi

  FctEchOra "D"  "${WFMaValeurSelect}"
  return ${ReturnExecSqlRecupValeur}
}

cr_dir()
{
  FctEchora "Creation du directory expimp_dir = ${exp_dir}"
  $ORACLE_HOME/bin/sqlplus / as sysdba << EOF
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK
create or replace directory expimp_dir
as '${exp_dir}'
/
exit
EOF
  return 0
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctCreateDirectory_0 () {
  ### -----------------------------------------------
  # fonction de creation d'un Directory
  ### -----------------------------------------------
  # Parametre 1 : Le nom du directory
  # Parametre 2 : Le nom du Repertoire
  ### -----------------------------------------------
  # RetCode   0           : Creation du Directory OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------
  #WDEBUG="oui"
  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  RetCode=0
  NomFct="FctCreateDirectory_0"
  FctEchOra "D" "${NomFct} nom du directory =<$1>"
  FctEchOra "D" "${NomFct} nom du Repertoire=<$2>"
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre du nom du Directory  vide"; return ${RC_ErrParam} ; else WFDirectory=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre du nom du Repertoire vide"; return ${RC_ErrParam} ; else    WFRepert=$2 ; fi
  #
  if [ ! -e "${WFRepert}" ]
  then
     FctEchOra "E" "${NomFct} Repertoire innexistant =<${WFRepert}>"
     return ${RC_RepertoireInexistant}
  fi
  FctEchora "..${NomFct}: creation directory ${WFDirectory} sur le repertoire ${WFDirectory}. Action."
  sqlplus / as sysdba << EOF
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK
  CREATE OR REPLACE DIRECTORY ${WFDirectory} as '${WFRepert}';
EOF
  RetCode=$?
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctAfficheObjInvalide_0 () {
  ### -----------------------------------------------
  # fonction d'affichage de Objets invalides
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  RetCode=0
  NomFct="FctAfficheObjInvalide_0"
  #
  FctEchOra "X" "${NomFct} ${Decallage} Affichage de la liste des objets invalides"
  NLS_LANG=FRENCH_FRANCE.UTF8
  #${ORACLE_HOME}/bin/sqlplus -L -S grhum/${WFPwd} <<_EOF_
  ${ORACLE_HOME}/bin/sqlplus -L -S / as sysdba <<_EOF_
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK
  col OWNER       for A15
  col OBJECT_TYPE for A17
  col OBJECT_NAME for A40
  select OWNER,
         OBJECT_TYPE,
         OBJECT_NAME,
         to_char(LAST_DDL_TIME,'DD/MM/YY HH24:MI:SS') as LAST_DDL
  from   dba_objects
  where  STATUS = 'INVALID' order by 1, 2, 3
  ;
_EOF_
  RetCode=$?
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctAfficheObjInvalideUsr_0 () {
  ### -----------------------------------------------
  # fonction d'affichage de Objets invalides
  ### -----------------------------------------------
  # Parametre 1 : Le Password de GRHUM
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  RetCode=0
  NomFct="FctAfficheObjInvalideUsr_0"
  #
  FctEchOra "X" "${NomFct} ${Decallage} Affichage de la liste des objets invalides"
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre du password de GRHUM vide"; return ${RC_ErrParam} ; else WFPwd=$1 ; fi
  #
  NLS_LANG=FRENCH_FRANCE.UTF8
  ${ORACLE_HOME}/bin/sqlplus -L -S grhum/${WFPwd} <<_EOF_
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK
  col OWNER       for A15
  col OBJECT_TYPE for A17
  col OBJECT_NAME for A40
  select OWNER,
         OBJECT_TYPE,
         OBJECT_NAME,
         to_char(LAST_DDL_TIME,'DD/MM/YY HH24:MI:SS') as LAST_DDL
  from   dba_objects
  where  STATUS = 'INVALID' order by 1, 2, 3
  ;
_EOF_
  RetCode=$?
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctGenereRenameFicDataEtLog_0 () {
  ### -----------------------------------------------
  # fonction de Production des scripts permettant la réimplémentation 
  # de la base de données $ORACLE_SID dans une autre structure de fichiers"
  ### -----------------------------------------------
  # Parametre 1 : Le repertoire
  # Parametre 2 : Le fichier
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  NomFct="FctGenereRenameFicDataEtLog_0"
  FctEchOra "D" "${NomFct} WFRenomeDatafiles=<$1>"
  FctEchOra "D" "${NomFct} WFRenomeLogfiles=<$2>"
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre fic de renomage datafile vide"; return ${RC_ErrParam} ; else WFRenomeDatafiles=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre fic de renomage logfile  vide"; return ${RC_ErrParam} ; else  WFRenomeLogfiles=$2 ; fi
  #
  FctEchOra "D" "${NomFct} ${Decallage} Production des scripts permettant la réimplémentation de la base de données $ORACLE_SID dans une autre structure de fichier"

  FctEchOra "D" "${NomFct} ${Decallage}${Decallage} Generation ${WFRenomeDatafiles}"
  ${ORACLE_HOME}/bin/sqlplus -S / as sysdba << EOF > ${WFRenomeDatafiles}
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK 
  SET FEEDBACK OFF VERIFY OFF PAGESIZE 0 LINESIZE 300 TRIMSPOOL ON
  SELECT 'set newname for datafile '||FILE_ID||' to '||chr(39)||'\${instance_path}'||'/'||SUBSTR(FILE_NAME,(INSTR(FILE_NAME,'/',-1,1)+1),length(FILE_NAME))||chr(39)||';' from dba_data_files order by FILE_ID;
EOF
  RetCode=$?
  if [ ${RetCode} != 0 ]
  then 
     return ${RetCode}
  fi

  FctEchOra "D" "${NomFct} ${Decallage}${Decallage} Generation ${WFRenomeLogfiles}"
  ${ORACLE_HOME}/bin/sqlplus -S / as sysdba << EOF > ${WFRenomeLogfiles}
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK
  SET FEEDBACK OFF VERIFY OFF PAGESIZE 0 LINESIZE 300 TRIMSPOOL ON
  SELECT 'ALTER DATABASE RENAME FILE '||chr(39)||member||chr(39)||' TO '||chr(39)||'\${instance_path}'||'/'||SUBSTR(member,(INSTR(member,'/',-1,1)+1),length(member))||chr(39)||';' FROM v\$logfile;
EOF
  RetCode=$?
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctSauvegardeRman_0 () {
  ### -----------------------------------------------
  # fonction de Sauvegarde d'une base oracle par l'utilitaire RMAN
  ### -----------------------------------------------
  # Parametre 1 : L'oracle Sid
  # Parametre 2 : Le Repertoire de Sauvegarde
  # Parametre 3 : Le Tag de la Save
  # Parametre 4 : La date et heure du jour
  # Parametre 5 : La Retention Policy
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  NomFct="FctSauvegardeRman_0"
  FctEchOra "D" "${NomFct} WFOracleSid=<$1>"
  FctEchOra "D" "${NomFct} WFRepSave  =<$2>"
  FctEchOra "D" "${NomFct} WFSaveTag  =<$3>"
  FctEchOra "D" "${NomFct} WFDateHeure=<$4>"
  FctEchOra "D" "${NomFct} WFRetention=<$5>"
  #
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Oracle Sid            vide"; return ${RC_ErrParam} ; else WFOracleSid=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Repertoire sauvegarde vide"; return ${RC_ErrParam} ; else   WFRepSave=$2 ; fi
  if [ -z "$3" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFSaveTag             vide"; return ${RC_ErrParam} ; else   WFSaveTag=$3 ; fi
  if [ -z "$4" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFDateHeure           vide"; return ${RC_ErrParam} ; else WFDateHeure=$4 ; fi
  if [ -z "$5" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFRetention           vide"; return ${RC_ErrParam} ; else WFRetention=$5 ; fi
  #
  FctEchOra "X" "${NomFct} ${Decallage} Sauvegarde de la base ${WFOracleSid} sur le repertoire ${WFRepSave} par l_utilitaire RMAN"
  #
  # Suppression du fichier de travail s'il existe
  FctEchOra "D" "${NomFct} Suppression des fichiers temporaires"
  rm -f /tmp/spfile${WFOracleSid}.tmp > /dev/null 2>&1
  FctEchOra "D" "${NomFct} Create pfile et Spfile"
  $ORACLE_HOME/bin/sqlplus / as sysdba << EOF
  WHENEVER SQLERROR EXIT ${RC_ErrSql} ROLLBACK
  WHENEVER OSERROR  EXIT ${RC_ErrOs}  ROLLBACK
create spfile='/tmp/spfile${WFOracleSid}.tmp' from memory;
create pfile='${WFRepSave}/${WFSaveTag}_pfile.ora' from spfile='/tmp/spfile${WFOracleSid}.tmp';
exit
EOF
#-- Configuration de la politique de conservation des sauvegardes sur 7 jour glissant
#CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
#--      configurer ici sur un nombre de redoncance voulu
#CONFIGURE RETENTION POLICY TO REDUNDANCY 1;
  cat << EOF > rman.txt
connect target /
CONFIGURE RETENTION POLICY TO ${WFRetention};
CONFIGURE BACKUP OPTIMIZATION ON;
CONFIGURE DEFAULT DEVICE TYPE TO DISK;
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO BACKUPSET;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '${WFRepSave}/%d_${WFDateHeure}_%F.ora';
CONFIGURE CHANNEL DEVICE TYPE DISK MAXPIECESIZE 2G ;
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '${WFRepSave}/%d_${WFDateHeure}_%s%p' MAXPIECESIZE 2G ;
RUN
 {
shutdown immediate;
startup mount;
backup as compressed backupset full database include current controlfile tag '${WFSaveTag}';
alter database open;
delete noprompt obsolete;
 }
 exit;
EOF
  $ORACLE_HOME/bin/rman @rman.txt
  RetCode=$?
  return ${RetCode}
}


# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctSauvegardeDbca_0 () {
  ### -----------------------------------------------
  # fonction de Sauvegarde d'une base oracle par l'utilitaire DBCA
  ### -----------------------------------------------
  # Parametre 1 : L'oracle Sid 
  # Parametre 2 : Le Repertoire de Sauvegarde
  # Parametre 3 : Le Tag de la Save
  # Parametre 4 : Le password de Grhum
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  NomFct="FctSauvegardeDbca_0"
  FctEchOra "D" "${NomFct} WFOracleSid=<$1>"
  FctEchOra "D" "${NomFct} WFRepSave  =<$2>"
  FctEchOra "D" "${NomFct} WFSaveTag  =<$3>"
  FctEchOra "D" "${NomFct} WFPassGrhum=<$4>"
  #
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Oracle Sid               vide"; return ${RC_ErrParam} ; else WFOracleSid=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Repertoire de sauvegarde vide"; return ${RC_ErrParam} ; else   WFRepSave=$2 ; fi
  if [ -z "$3" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFSaveTag                vide"; return ${RC_ErrParam} ; else   WFSaveTag=$3 ; fi
  if [ -z "$4" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFPassGrhum              vide"; return ${RC_ErrParam} ; else WFPassGrhum=$4 ; fi
  #
  FctEchOra "X" "${NomFct} ${Decallage} Sauvegarde de la base ${WFOracleSid} sur le repertoire ${WFRepSave} par l_utilitaire DBCA"
  #
  # ${WSID} ${WREP} ${save_tag} ${smoment}
  jour=`date '+%w'`
  dbca -silent -createCloneTemplate -sourceSID ${WFOracleSid} -templateName ${WFRepSave} -sysDBAUserName sys -sysDBAPassword ${sys_pwd} -maintainFileLocations true -datafileJarLocation /u01/app/oracle/product/11.2.0/db_1/assistants/dbca/templates/

  # Suppression du fichier de travail s'il existe

  RetCode=$?
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctCleanupFicSaveRman_0 () {
  ### -----------------------------------------------
  # fonction de suppression des fichiers plus necessaire dans le repertoire de sauvegarde
  ### -----------------------------------------------
  # Parametre 1 : Le SID en majuscule
  # Parametre 2 : Le Repertoire de sauvegarde
  # Parametre 3 : Le nombre de sauvegarde gardé
  # Parametre 4 : Le Moment de la sauvegarde
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------
  #WDEBUG=oui
  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  NomFct="FctCleanupFicSaveRman_0"
  FctEchOra "D" "${NomFct}  WFSidMaj=<$1>"
  FctEchOra "D" "${NomFct} WFRepSave=<$2>"
  FctEchOra "D" "${NomFct} WFNbrSave=<$3>"
  FctEchOra "D" "${NomFct}  WFMoment=<$4>"
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre SID                   vide"; return ${RC_ErrParam} ; else  WFSidMaj=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Repertoire sauvegarde vide"; return ${RC_ErrParam} ; else WFRepSave=$2 ; fi
  if [ -z "$3" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Nombre     sauvegarde vide"; return ${RC_ErrParam} ; else WFNbrSave=$3 ; fi
  if [ -z "$4" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Moment     sauvegarde vide"; return ${RC_ErrParam} ; else  WFMoment=$4 ; fi
  #
  # Suppression des fichiers de travail
  FctEchOra "X" "${NomFct} ${Decallage} Suppression des fichiers de travail de ${WFRepSave} sur ${WFSidMaj}"
  #
  FctEchOra "X" "${NomFct} ${Decallage} Suppression rman.txt sur ${PWD}"
  rm -f rman.txt 
  FctEchOra "D" "${NomFct} ${Decallage} Les sauvegardes actuelles sur ${WFRepSave}:"
  WUneSaveOK="non"
  WNb_Sauvegarde=0
  Wcpt=0
  WNbrSave=0
  WNblig_Sauvegarde=0
  Wprecedsid=""
  Wpreceddateheure=""
  pwd
  WFNbFicSavEnCours=$( ls -1rl                    ${WFRepSave}/${WFSidMaj}*${WFMoment}* | wc -l )
  WFNbFicSaveEnPlus=$( ls -1rl                    ${WFRepSave}/${WFSidMaj}* | grep -v "${WFMoment}"  | wc -l )
  FctEchOra "D" "${NomFct} ${Decallage} WFNbFicSavEnCours       = ${WFNbFicSavEnCours}"
  FctEchOra "D" "${NomFct} ${Decallage} WFNbFicSaveEnPlus       = ${WFNbFicSaveEnPlus}"
  if [ "${WFNbFicSavEnCours}" <> 0 ]
  then 
     FctEchOra "D" "${NomFct} ${Decallage}                         WNb_Sauvegarde = ${WNb_Sauvegarde}"
     let WNb_Sauvegarde=${WFNbrSave}
     WNb_Sauvegarde="$(($WNb_Sauvegarde-1))"
     FctEchOra "D" "${NomFct} ${Decallage} Save En cours presente. WNb_Sauvegarde = ${WNb_Sauvegarde}"
  fi 
  if   [ ${WFNbFicSaveEnPlus} = 0 ]
  then 
     FctEchOra "D" "${NomFct} ${Decallage} Plus de fichier a supprimer            = ${WFNbFicSaveEnPlus}"
  elif [ ${WNb_Sauvegarde} = 0 -a ${WFNbFicSavEnCours} <> 0  ]
  then 
     FctEchOra "X" "${NomFct} ${Decallage} la save en cours est présente et on ne garde qu'un jeu de save. Suppression ${WFNbFicSaveEnPlus} fic "
     for line in $( ls -1rl ${WFRepSave}/${WFSidMaj}* | grep -v "${WFMoment}"  | awk '{print $9 }' ) 
     do    
       let Wcpt=Wcpt+1
       echo "$Wcpt-->$line" 
       FctEchOra "X" "${NomFct} --->>>> suppression fichier ${line}"
       Wpreceddateheure=""
       rm -rf ${line}
     done 
  else  
     WFNbrSave=${WNb_Sauvegarde}
     #Pour toutes les lignes du répertoire des saves
     #for line in $( ls -1rl ${WFRepSave}/${WFSidMaj}* | awk '{print $9 }' ) 
     # dans la boucle de suppression, on élimine la sauvegarde en cours
     for line in $( ls -1rl -I "*${WFMoment}*" ${WFRepSave}/${WFSidMaj}* | grep -v "${WFMoment}"  | awk '{print $9 }' ) 
     do    
       let Wcpt=Wcpt+1
       echo "$Wcpt-->$line" 
       Wsid=$(      echo "${line}" | awk -F_ '{print $1}' )
       Wdateheure=$(echo "${line}" | awk -F_ '{print $2}' )
       FctEchOra "D" "${NomFct} ${Decallage} Wprecedsid       = ${Wprecedsid}"
       FctEchOra "D" "${NomFct} ${Decallage} Wpreceddateheure = ${Wpreceddateheure}"
       FctEchOra "D" "${NomFct} ${Decallage} Wsid             = ${Wsid}"
       FctEchOra "D" "${NomFct} ${Decallage} Wdateheure       = ${Wdateheure}"
       # si la sauvegarde est la meme que la precedente alors on increment le nombre de ligne de la sauvegarde
       if [ "${Wsid}" = "${Wprecedsid}" -a "${Wdateheure}" = "${Wpreceddateheure}" ]
       then 
         FctEchOra "D" "${NomFct} Meme sauvegarde <${line}>"
         let WNblig_Sauvegarde=WNblig_Sauvegarde+1
         if [ ${WNblig_Sauvegarde} -gt 3 ]
         then  
           WUneSaveOK="oui"
         fi
         FctEchOra "D" "${NomFct} ${Decallage} WFNbrSave           = ${WFNbrSave}"
         FctEchOra "D" "${NomFct} ${Decallage} WNb_Sauvegarde      = ${WNb_Sauvegarde}"
         FctEchOra "D" "${NomFct} ${Decallage} WNblig_Sauvegarde   = ${WNblig_Sauvegarde}"
         FctEchOra "D" "${NomFct} ${Decallage} WUneSaveOK          = ${WUneSaveOK}"
       else
       # si la sauvegarde est differente de la precedente alors 
       #  1) on sauvegardes les infos de la ligne précedente a partir des infos de la ligne en cours"
       #  2) on incremente le nombre de sauvegarde
       #  3) on initialise le nombre de ligne de la nouvelle sauvegarde a 1
       # c'est le cas du premier passage quand les variables précédente sont vide
         FctEchOra "D" "${NomFct} diff sauvegarde <${line}>"
         Wprecedsid=${Wsid}
         Wpreceddateheure=${Wdateheure}
         let WNb_Sauvegarde=WNb_Sauvegarde+1
         let WNblig_Sauvegarde=1
         FctEchOra "D" "${NomFct} ${Decallage} WFNbrSave               = ${WFNbrSave}"
         FctEchOra "D" "${NomFct} ${Decallage} WNb_Sauvegarde          = ${WNb_Sauvegarde}"
         # si le nombre de sauvegarde dépasse le nombre de sauvegarde a garder et que j'ai au moins une sauvegarde correcte alors 
         # 1) je supprime le fichier de sauvegarde en cours
         # 2) je réinitialise la date et l'heure précédentes à vide et le nombre de ligne de sauvegarde en cours
         if [ ${WNb_Sauvegarde} -gt ${WFNbrSave} -a ${WUneSaveOK} = "oui" ]
         then
           FctEchOra "X" "${NomFct} --->>>> suppression  <${WNb_Sauvegarde}> ligne ${Wcpt} pour le fichier ${line}"
           Wpreceddateheure=""
           rm -rf ${line}
         fi
       fi
     done 
  fi
  return ${RC_OK}  
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctCleanupFicSaveDbca_0 () {
  ### -----------------------------------------------
  # fonction de suppression des fichiers plus necessaire dans le repertoire de sauvegarde
  ### -----------------------------------------------
  # Parametre 1 : L'oracle Sid 
  # Parametre 2 : Le Repertoire de Sauvegarde
  # Parametre 3 : Le Tag de la Save
  # Parametre 4 : Le password de Grhum
  ### -----------------------------------------------
  # RetCode   0           : Affichage OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  NomFct="FctSauvegardeDbca_0"
  FctEchOra "D" "${NomFct} WFOracleSid=<$1>"
  FctEchOra "D" "${NomFct} WFRepSave  =<$2>"
  FctEchOra "D" "${NomFct} WFSaveTag  =<$3>"
  FctEchOra "D" "${NomFct} WFPassGrhum=<$4>"
  #
  # Recuperation des parametres de la fonction
  if [ -z "$1" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Oracle Sid            vide"; return ${RC_ErrParam} ; else WFOracleSid=$1 ; fi
  if [ -z "$2" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre Repertoire sauvegarde vide"; return ${RC_ErrParam} ; else   WFRepSave=$2 ; fi
  if [ -z "$3" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFSaveTag             vide"; return ${RC_ErrParam} ; else   WFSaveTag=$3 ; fi
  if [ -z "$4" ] ; then FctEchOra "E" "${NomFct}: Erreur parametre WFPassGrhum           vide"; return ${RC_ErrParam} ; else WFPassGrhum=$4 ; fi

  # Suppression des fichiers de travail
  FctEchOra "X" "${NomFct} ${Decallage} Suppression des fichiers de travail de ${WFRepSave} sur ${WFOracleSid}"
  mv -f /u01/app/oracle/product/11.2.0/db_1/assistants/dbca/templates/${WFSaveTag}.* ${WFRepSave}
  #
  rm d.txt > /dev/null 2>&1
  FctEchOra "X" "Les sauvegardes actuelles :"
  ls -alt ${WFRepSave}/*${WFOracleSid}*  
  return ${RC_OK}  
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctAppels_install_patchs_0 () {
  ### -----------------------------------------------
  # fonction d'appel a l'installation des Patchs (utilisé uniquemement mais plusieurs fois par le programme patch/Deploie_Patch.sh)
  ### -----------------------------------------------
  # RetCode   RC_OK       : Retour OK
  # RetCode   RC_ErrParam : Erreur de parametre
  # RetCode   RC_ErrSql   : Erreur Sql
  # RetCode   RC_ErrOs    : Erreur OS
  ### -----------------------------------------------

  let NB_APPEL_OracleLib=NB_APPEL_OracleLib+1
  # Declaration des variables locales de la fonction
  NomFct="FctAppels_install_patchs_0"

  # Appels aux programmes d'install en fonction des flags de noyau : 11_2, 12_1, 12_2
  FctEchOra "X" "Deploiement des patchs du repertoire ${WDIR} sur ${WTYP}"
  #
  if [ "${W11_2}" = "oui" ]  
  then 
     echo "${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}11 -v 11.2.0  -p ${WTYP}11RHUM ${WDIR}"
     ${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}11 -v 11.2.0  -p ${WTYP}11RHUM ${WDIR}    
     if [ $? != 0 ] ; then Fctecho ABORT ; exit 1 ; fi  
  fi
  #
  if [ "${W12_1}" = "oui" ]  
  then 
     echo "${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}21 -v 12.1.0  -p ${WTYP}21RHUM ${WDIR}"
     ${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}21 -v 12.1.0  -p ${WTYP}21RHUM ${WDIR}
     if [ $? != 0 ] ; then Fctecho ABORT ; exit 1 ; fi  
  fi
  #
  if [ "${W12_2}" = "oui" ]  
  then 
     echo "${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}22 -v 12.2.0  -p ${WTYP}22RHUM ${WDIR}"
     ${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}22 -v 12.2.0  -p ${WTYP}22RHUM ${WDIR}
     if [ $? != 0 ] ; then Fctecho ABORT ; exit 1 ; fi  
  fi      
  if [ "${W18_0}" = "oui" ]  
  then 
     echo "${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}18 -v 18.0.0  -p ${WTYP}22RHUM ${WDIR}"
     ${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}18 -v 18.0.0  -p ${WTYP}18RHUM ${WDIR}
     if [ $? != 0 ] ; then Fctecho ABORT ; exit 1 ; fi  
  fi      
  if [ "${W19_0}" = "oui" ]  
  then 
     echo "${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}19 -v 19.0.0  -p ${WTYP}22RHUM ${WDIR}"
     ${RepTools}/Install_Patch.sh ${WIDEMPOT} -s ${WTYP}19 -v 19.0.0  -p ${WTYP}19RHUM ${WDIR}
     if [ $? != 0 ] ; then Fctecho ABORT ; exit 1 ; fi  
  fi      
  return ${RC_OK}  
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchora "${Decallage} librairie ${RepToolsLib}/MGOracleLib.sh Chargé"

#-------------------------------------#
# Fin de la librairie de fonction KSH #
#-------------------------------------#                                                       
