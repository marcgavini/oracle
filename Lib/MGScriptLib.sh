#!/bin/ksh
############################################################################
#@(#) Fonction : Librairie de fonctions communes à usage des scripts
#@(#) Creation : 1.0 M. Gavini 03/01/2018
#@(#) Modif    : 1.1 M. Gavini 24/06/2020 Rajout FctGestionCodeRetour pour la gestion du Code Retour
#@(#)                                     Modif  FctVerifServeurOracle_0 sur affichage
#@(#) Modif    : 1.2 M. Gavini 18/00/2020 Rajout FctVerifParamObligatoire_0 pour la gestion des parametres
#@(#) Fichier  : MGScritpLib.sh
#@(#) Syntaxe  : . /home/oracle/BD_scripts/v0/Lib/MGScriptLib.sh
#@(#) Version  : 1.1 valide (en cours / en test / valide)
############################################################################
#
# CONTENU DE LA LIBRAIRIE
# ___________________________________________________________________
#
# Fonction d'utilisation interne___________________________________________________
#  Fctecho                     : Affiche le parametre $1 avec la commande echo a l'ecran et dans le fichier log $FicLog si la variable existe
#  FctVerifNbParam             : Test le nombre de parametre de la fonction 
#                       
# Fonction interactives_______________________________________________
#  FctPasAPas                  : Permet l'execution en pas en pas dans un script
#  FctValidezContinuer         : Affiche et attente de la validation
#  FctValidezOuvrirFichier_0   : Ouverture du fichier si validation
#  FctDemandeCreateRepertoire_0: 
#  FctDemandeCreateRepEnSudo_0 : NON UTILISE/Creation du repertoire passe en parametre si necessaire
#                       
# Fonction d'utilisation externe d'affichage________________________________________
#  Fctecho                     : Affiche le parametre $1 avec la commande echo a l'ecran et dans le fichier log $FicLog si la variable existe
#  FctEcHo                     : Affiche conditionne par le premier parametre
#  FctNB_APPEL_MGScritpLib     : Affiche le nombre d'appel a la librairie
#  FctAfficheAppels            : Affiche le nombre d'appel des toutes les librairies
#  FctEchoDateHeure            : Affiche date et heure
#  FctGestCodeRetour_0         : Unification des codes retour pour l'ordonnanceur
#  FctUsage                    : Affiche l'aide
#  FctTransl_0                 : Translate de chaine $1 pour retirer les accents
#  FctDeGzip_0                 : Decompression d'un fichier vers un autre emplacemment
#  FctAfficheATTENTION_0       : Affichage d_un gros ATTENTION                                                              
#
# Fonction d'utilisation externe de verification____________________________________
#  FctVerifExt_0               : Verification de l'extention du fichier
#  FctVerifFicGzTgzEtDezip_0   : Verification de l'existence du fichier Tgz et Decompression
#  FctVerifFicGzEtDezip_0      : Verification de l'existence du fichier Tgz et Decompression
#  FctVerifFicTarEtDetar_0     : Verification de l'existence du fichier Tgz et Decompression
#  FctVerifFicDmp_0            : Verification de l'existence du fichier dmp
#  FctVerifListeVersionOracle_0: Verification que version Oracle en parametre est bien dans la liste : 11.2.0, 12.1.0, 12.2.0
#  FctVerifServeurOracle_0     : Verification que le serveur passé en parametre est bien un serveur oracle
#  FctVerifServeurOracleDeRef_0: Verification que le serveur passé en parametre est bien le serveur oracle de reference : bdoratec
#  FctVerifFicSupervision_0    : Verification d'un fichier resultat de supervision                          
#  FctVerifParamObligatoire_0  : Verification du parametre obligatoire
#
# Fonction d'utilisation externe de gestion de fichier______________________________
#  FctCreateRepertoire_0       : Creation d'un repertoire et touch de celui ci
#  FctVerifRepertoire_0        : Verification de l'existence du repertoire passe en parametre
#  FctVerifEtCreationRep_0     : Creation du repertoire passe en parametre si necessaire
#  FctVerifCreateRepertoire  : Creation du repertoire passe en parametre si necessaire
#  FctVerifEtCreateRep_0       : 
#
# Fonction d'utilisation externe de gestion du Code Retour__________________________
#  FctGestionCodeRetour        : Affichage du message en fonction du code passé parametre
# ___________________________________________________________________
#

 ####### #          #     #####
 #       #         # #   #     #
 #       #        #   #  #
 #####   #       #     # #  ####
 #       #       ####### #     #
 #       #       #     # #     #
 #       ####### #     #  #####

if [ "${FlagMGScritpLib}" = "Vrai" ]
then
  echo ".. Fichier $0 déjà chargé"
  exit 0
fi
FlagMGScritpLib="Vrai"
#
  #####                          ######
 #     #   ####   #####   ###### #     #  ######   #####   ####   #    #  #####
 #        #    #  #    #  #      #     #  #          #    #    #  #    #  #    #
 #        #    #  #    #  #####  ######   #####      #    #    #  #    #  #    #
 #        #    #  #    #  #      #   #    #          #    #    #  #    #  #####
 #     #  #    #  #    #  #      #    #   #          #    #    #  #    #  #   #
  #####    ####   #####   ###### #     #  ######     #     ####    ####   #    #

# Nombre d'appel à la librairie
NB_APPEL_MGScritpLib=0
# code retour généraux
         RC_OK=0
RC_ErreurParam=1
  RC_ErreurSql=2
   RC_ErreurOs=3
# code retour de FctVerifFichierExiste_0 :
       RC_Fichier_Existe=0
RC_Repertoire_Inexistant=1
   RC_Fichier_Inexistant=2
# code retour des autres fonctions :
RC_Serveur_Non_Oracle=5


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
FctVerifNbParam () {
  ### ----------------------------------------------------------------
  # fonction de Translate de chaine pour retirer les accents
  # Param : 1) Le nombre de parametre
  # Param : 2) Le nombre de parametre attendu
  # Param : 3) Le nom de la fonction
  ### ----------------------------------------------------------------
  
  NomFct="..FctVerifNbParam"
  if [ $# != 3  ] ; then   FctEcHo "E" "Nombre de parametre incorrect $# au lieu de 3  dans ${NomFct}" ; return ${RC_ErreurParam} ; fi
  if [ $1 != $2 ] ; then   FctEcHo "E" "Nombre de parametre incorrect $1 au lieu de $2 dans ${3}"      ; return ${RC_ErreurParam} ; fi
  return ${RC_OK}
}

 #######                   ###
 #         ####    #####    #     #    #   #####  ######  #####   ACTIVE
 #        #    #     #      #     ##   #     #    #       #    #  ACTIVE
 #####    #          #      #     # #  #     #    #####   #    #  ACTIVE
 #        #          #      #     #  # #     #    #       #####   ACTIVE
 #        #    #     #      #     #   ##     #    #       #   #   ACTIVE
 #         ####      #     ###    #    #     #    ######  #    #  ACTIVE

# Les fonctions interactives de la librairie :

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctValidezContinuer () {
  ### ----------------------------------------------------------------
  # fonction : Affichage du valider pour continuer
  # Usage    : FctValidezContinuer
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  echo "..Validez pour continuer"
  read mapause
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctPasAPas () {
  ### -----------------------------------------------
  # fonction : Pas a pas
  # Usage    : FctPasAPas
  ### -----------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctPasAPas"
  if [ ! -z "${WPASAPAS}" -a "${WQUIET}" != "oui" ]
  then
    echo "..Valider pour continuer"; read LaReponse
    if [ "${LaReponse}" = "GO" ]
    then
       PASAPAS=""
    fi
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctValidezOuvrirFichier_0 () {
  ### ----------------------------------------------------------------
  # fonction : Affichage du valider pour ouvrir le fichier et ouverture de celui ci
  # Usage    : FctValidezOuvrirFichier_0 NomFichier
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctValidezOuvrirFichier_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  echo "..Validez pour ouvrir le fichier $1"
  echo "..Ou n pour continuer"
  ouverturefichier=""
  read ouverturefichier
  if [ "$ouverturefichier" != "n" -a "$ouverturefichier" != "N" ]
  then
     vi $1
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctDemandeCreateRepertoire_0 () {
  ### ----------------------------------------------------------------
  # fonction : Demande la creation d'un repertoire s'il n'existe pas
  # Usage    : FctDemandeCreateRepertoire_0
  # Param    : 1) Le Repertoire
  # Param    : 2) Variable de forcage = force pour éviter les questions
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctDemandeCreateRepertoire_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  #if [ "${2}" = "force" ]
  #  ls -tlr ${1}  || mkdir -p ${1}
  #  return $?
  #fi
  if [ ! -d "${1}" ]
  then
     FctEcHo "Repertoire non existant :<${1}>. Voulez vous le creer ? (o pour oui) "
     read rep
     if [ "$rep" = "o" -o  "$rep" = "O" ]
     then
        mkdir -p "${1}"
        return $?
     fi
  else
    FctEcHo "D" "Repertoire existant :<${1}>"
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctDemandeCreateRepEnSudo_0 () {
  ### ----------------------------------------------------------------
  # fonction : Demande la creation en sudo d'un repertoire s'il n'existe pas
  # Usage    : FctDemandeCreateRepEnSudo_0
  # Param    : 1) Le Repertoire
  # Param    : 2) Le user de creation
  # Param    : 3) Les droits du repertoire
  # Param    : 4) User:Groupe
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctDemandeCreateRepEnSudo_0"
  FctVerifNbParam $# 4 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi

  if [ ! -d "${1}" ]
  then
     FctEcHo "D" "Repertoire non existant :<${1}>. Voulez vous le creer ? (o pour oui) "
     read rep
     if [ "$rep" = "o" -o  "$rep" = "O" ]
     then
        sudo su - $2 -c mkdir -p "${1}"
        sudo su - $2 -c chmod $3 $1
        sudo su - $2 -c chown $4 $1
        ls -trl $1
        return $?
     fi
  else
    FctEcHo "D" "Repertoire existant :<${1}>"
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
FctNB_APPEL_MGScritpLib () {
  ### --------------------------------------
  # fonction d'affichage du compteur NB_APPEL_MGScritpLib
  ### --------------------------------------

  # ici on n'incremente pas la valeur du compteur, on l'affiche
  Fctecho "${Decallage} --> NB_APPEL_MGScritpLib   : <${NB_APPEL_MGScritpLib}>"
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctAfficheAppels () {
  ### --------------------------------------
  # Affiche le nombre d'appel des toutes les librairies
  ### --------------------------------------

  FctNB_APPEL_MGScritpLib
  if [ "${FlagMGDataPumpLib}"   = "Vrai" ]; then FctNB_APPEL_MGDataPumpLib  ; fi
  if [ "${FlagMGOracleLib_New}" = "Vrai" ]; then FctNB_APPEL_MGOracleLib    ; fi
  if [ "${FlagMGVerifCalcLib}"  = "Vrai" ]; then FctNB_APPEL_MGVerifCalcLib ; fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
Fctecho () {
  ### ----------------------------------------------------------------
  # fonction d'affichage du parametre a l'ecran et dans le fichier FicLog
  # Usage : Fctecho "MESSAGE de test"
  # Param : 1) "Le message a afficher"
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  # si le flag est postionner on traite les logs
  if [ "${WQUIET}" != "oui" ]
  then
     # si le flag est postionner on traite les logs
     if [ "${WLOG}" = "oui" ]
     then
        if [ -z "${FicLog}" ]
        then
           echo "$1"
        else
           echo "$1" | tee -a "${FicLog}"
        fi
    else
       echo "$1"
    fi
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEcHo () {
  ### ----------------------------------------------------------------
  # fonction d'affichage du parametre a l'ecran et dans le fichier FicLog
  # Usage : FctEcHo "I" "MESSAGE de test"
  # Param : 1) "Le type de message: I=info, W=Warning, E=Erreur, D=Debug"
  # Param : 2) "Le message a afficher"
  ### ----------------------------------------------------------------
  # Algo  :
  #   si       le type de message est une erreur on affiche le message
  #   sinon si le type de message est un debug et qu'on est en mode debug, on affiche le message
  #   sinon si le message est a vide on affiche le type de message
  #   sinon si le flag Quiet n'est pas actif, on affiche le     
  #   dans tous les cas on sort sans erreur
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  if   [ "${1}" = "E" ]                         ; then Fctecho "$2"
  elif [ "${1}" = "D" ]
  then
     if [ "${WDEBUG}" = "oui" ]
     then
        echo "__Debug->$2"
     fi
  elif [ -z "${2}" ]                            ; then Fctecho "$1"
  else
                                                       Fctecho "$2"
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctEchoDateHeure () {
  ### ----------------------------------------------------------------
  # fonction d'affichage date et heure a l'ecran et dans le fic log
  # Usage : FctEchoDateHeure (1) test.log
  # Param : 1) Le fichier log
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  if [ -z "${FicLog}" ]
  then
     FctEcHo "D" "..FctEchoDateHeure "
  else
     FctEcHo "D" "..FctEchoDateHeure fichier log ${FicLog} ____________________"
  fi
  MaDateHeure=$(date '+..  DATE HEURE: %d/%m/%Y %H:%M:%S')
  FctEcHo "${MaDateHeure}"

  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctGestCodeRetour_0 () {
  ### ----------------------------------------------------------------
  # fonction d'unification des codes retour Vers l'ordonnanceur
  # Usage : FctGestCodeRetour_0
  #         avec les variables
  #         ${CODE_RETOUR} ${RepLog} ${MESSAGE_OK} ${MESSAGE_KO}
  # Param : aucun
  # Variable utilisé :
  #         la variable CODE_RETOUR
  #         la variable FicLog
  #         la variable MESSAGE_OK
  #         la variable MESSAGE_KO
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  # Declaration des variables locales de la fonction
  RetCode=0
  NomFct="..FctGestCodeRetour_0"

  # Affichage si debugage
   FctEcHo "D" "..Variables d appel de ${NomFct}"
   FctEcHo "D" "..  Le CODE_RETOUR             :<${CODE_RETOUR}>"
   FctEcHo "D" "..  Le FicLog                  :<${FicLog}>"
   FctEcHo "D" "..  Le message OK              :<${MESSAGE_OK}>"
   FctEcHo "D" "..  Le message KO              :<${MESSAGE_KO}>"

  case ${CODE_RETOUR} in
       0) Fctecho  OK
          Fctecho "${MESSAGE_OK}"
          RetCode=0
          ;;
       *) Fctecho ABORT
          Fctecho "${MESSAGE_KO}"
          Fctecho "..Code retour : ${CODE_RETOUR}"
          RetCode=1
          ;;
  esac

   FctEcHo "D" "..${NomProg}:Fin de la procedure "
  # si le flag est postionner on traite les logs
 if [ "${WLOG}" = "oui" ]
  then
     Fctecho ".. Vous trouverez cette Log d'execution dans le fichier"
     Fctecho ".. ${FicLog}"
  fi
  FctEchoDateHeure
  FctEcHo "D" "..Fin de ${NomFct}"
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctUsage () {
  ### ---------------------------------------------------
  # fonction d'affichage de l'aide simple a l'utilisation
  ### ---------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  # Declaration des variables locales de la fonction
  NomFct="..FctUsage"
  echo "Fonction: ${WTitre}"
  echo "          ${WLigne1}"
  echo "          ${WLigne2}"
  echo "          ${WLigne3}"
  echo "Usage   : ${Wusage}"
  echo ""
  echo "Exemple1: ${WExemple1}"
  echo "Exemple2: ${WExemple2}"
  echo "Exemple3: ${WExemple3}"
  echo " "
  echo "Aide    : --help pour voir les options"
  echo " "
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctTransl_0 () {
  ### ----------------------------------------------------------------
  # fonction de Translate de chaine pour retirer les accents
  # Param : 1) La chaine a traduire
  ### ----------------------------------------------------------------
  # a verifier ne fonctionne pas
  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctTransl_0"
  #FctVerifNbParam $# 1 "${NomFct}"
  #if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" "..Variables d'appel de ${NomFct}"
  FctEcHo "D" "..  La chaine a traduire       :<$1>"
  echo $1 |tr 'àâäçéèêïîôöùû' 'aaaceeeiioouu'
  return 1
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctDeGzip_0 () {
  ### ----------------------------------------------------------------
  # fonction de decompression d'un fichier vers un autre emplacemment
  # Param : 1) Le fichier entree
  # Param : 2) Le fichier sortie
  # Appel : fct_gzip ft.log.gz ft.log
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  # Declaration des variables locales de la fonction
  RetCode=0
  NomFct="..FctDeGzip_0"
  #FctVerifNbParam $# 2 "${NomFct}"
  #if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctVerifNbParam $# 2 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi  
  FctEcHo "D" "..Variables d'appel de de ${NomFct}"
  FctEcHo "D" "..  Fichier entree             :<$1>"
  FctEcHo "D" "..  Fichier sortie             :<$2>"
  gzip -cd  $1 > $2
  RetCode=$?
  return ${RetCode}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifFichierExiste_0(){
  ### -----------------------------------------------
  # Fonction : Verification de l'existence du fichier passe en parametre
  # Param : 1) Le fichier
  # Usage    : FctVerifFichierExiste_0 LeFichier
  # Option   : Si FicLog exite on ecrit dans le fichier
  # Option   : Quiet=oui
  ### -----------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifFichierExiste_0"
  #FctVerifNbParam $# 1 "${NomFct}"
  #if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  WFctNomFic=$(basename "$1")
  WFctDirFic=$(dirname  "$1")
  FctEcHo "D" $WFctNomFic
  FctEcHo "D" $WFctDirFic
  #
  if [ "${WFctDirFic}" = "." ]
  then
     FctEcHo "I" ".. repertoire courant : $PWD"
  else
     FctEcHo "I" ".. repertoire du fichier  : ${WFctDirFic}"
     if [ ! -d  "${WFctDirFic}" ]
     then
        Fctecho warning
        FctEcHo "E" ".. le Repertoire ${WFctDirFic} existe pas"
        return ${RC_Repertoire_Inexistant}
     fi
  fi
  #
  if [ -e  "$1" ]
  then
     Fctecho ".. le fichier $1 existe"
     return ${RC_Fichier_Existe}
  else
     Fctecho warning
     Fctecho ".. le fichier $1 n'existe pas"
     return ${RC_Fichier_Inexistant}
  fi
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifExt_0 () {
  ### ----------------------------------------------------------------
  # fonction : verification de l'extension du fichier
  #            Si le fichier existe, suppression du tar et dezip du tgz
  # Usage    : FctVerifFicTgz  LeFichier.tar.gz
  # Param    : 1) Le nom du fichier
  # Rend     : a) FCTNomFic Le nom du fichier sans extension
  #          : b) FCTExt1   La premiere extension du fichier
  #          : c) FCTExt2   Le deuxieme extension du fichier (si elle existe)
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifExt_0"
  #FctVerifNbParam $# 1 "${NomFct}"
  #if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" "NomFic=${1}"
  FCTNomFic=${1%%.*}
  FCTExt1=${1#*.}
  FCTExt2=${1##*.}
  if [ "${FCTExt1}" = "${FCTExt2}" ]
  then
     FCTExt2=""
  fi

  FctEcHo "D" "FCTNomFic=${FCTNomFic}"
  FctEcHo "D" "FCTExt1  =${FCTExt1}"
  FctEcHo "D" "FCTExt2  =${FCTExt2}"

  return 0
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifFicGzTgzEtDezip_0 () {
  ### ----------------------------------------------------------------
  # fonction : verification de l'existence du fichier Tgz
  #            Si le fichier existe, suppression du tar et dezip du tgz
  # Usage    : FctVerifFicTgz  LeFichierTgzSansLExtensionTgz
  # Param    : 1) Le fichier tgz sans l'extension .tgz
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifFicGzTgzEtDezip_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" "Verification de l existence du fichier tgz : ${1}.tgz"
  FctPasAPas
  if [ ! -s "${1}.tgz"  -a ! -s "${1}.tar.gz" ]
  then
     FctEcHo "E" ".. les fichiers ${1}.tgz et ${1}.tar.gz n existe pas ou sont vide"
  else
     FctEcHo "D" ".. le fichier ${1} existe"
     if [ -s "${1}.tar"   ]
     then
        FctEcHo "D" "..Suppression du fichier ${1}.tar avant dezip"
        FctPasAPas
        rm -f ${1}.tar
     fi
     # Si le fichier existe est n'est pas vide alors on le decompresse
     if [ -s "${1}.tgz"  ]
     then
        FctEcHo "D" "..Decompression du fichier tgz :  ${1}.tgz"
        FctPasAPas
        gzip -d  ${1}.tgz
        if [ $? != 0 ] ; then FctEcHo "E" "..Erreur de dezip" ; exit 1 ; fi
     elif [ -s "${1}.tar.gz"  ]
     then
        FctEcHo "D" "..Decompression du fichier tgz :  ${1}.tar.gz"
        FctPasAPas
        gzip -d  ${1}.tar.gz
        if [ $? != 0 ] ; then FctEcHo "E" "..Erreur de dezip" ; exit 1 ; fi
     fi
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifFicTarEtDetar_0 () {
  ### ----------------------------------------------------------------
  # fonction : verification de l'existence du fichier Tar
  #            Si le fichier existe, suppression du dmp et detar du tar
  # Usage    : FctVerifFicTar  LeFichierTarrSansLExtensionTar
  # Param    : 1) Le fichier tar sans l'extension .tar
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifFicTarEtDetar_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" "..Verification de l existence du fichier tar : ${1}.tar"
  FctPasAPas
  if [ ! -s "${1}.tar" ]
  then
     FctEcHo "E" "..le fichier ${1}.tar n existe pas"
  else
     # Si le fichier existe est n'est pas vide alors on le detare
     FctEcHo "D" "..le fichier ${1}.tar existe"
     FctEcHo "D" "..Suppression du fichier dump avant detar (s il existe)"
     FctPasAPas
     rm -f ${1}
     FctEcHo "D" "..Decompression du fichier dump :  ${1}.tar"
     FctPasAPas
     tar -xvf ${1}.tar # > /dev/null 2>&1
     if [ $? != 0 ] ; then FctEcHo "E" "..Erreur de detar "; exit 1 ; fi
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifFicGzEtDezip_0 () {
  ### ----------------------------------------------------------------
  # fonction : verification de l'existence du fichier Gz
  #            Si le fichier existe, suppression du dmp et dezip du gz
  # Usage    : FctVerifFicGz  LeFichierGzSansLExtensionGz
  # Param    : 1) Le fichier gz sans l'extension .gz
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifFicGzEtDezip_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" "..Verification de l existence du fichier gz : ${1}.gz"
  FctPasAPas
  if [ ! -s "${1}.gz" ]
  then
     FctEcHo "E" "..le fichier ${1}.gz n existe pas"
  else
     # Si le fichier existe est n'est pas vide alors on le dezippe
     FctEcHo "D" "..le fichier ${1}.gz existe"
     FctEcHo "D" "..Suppression du fichier dump avant dezip (s il existe)"
     FctPasAPas
     rm -f ${1}
     FctEcHo "D" "..Decompression du fichier gz :  ${1}.gz"
     FctPasAPas
     gzip -d ${1}.gz
     if [ $? != 0 ] ; then FctEcHo "E" "..Erreur de dezip"; exit 1 ; fi
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifFicDmp_0 () {
  ### ----------------------------------------------------------------
  # fonction : verification de l'existence du fichier Dmp
  #            Si le fichier existe, Changement des droits du fic=666
  # Usage    : FctVerifFicDmp_0  LeFichierDmpSansLExtensionDmp
  # Param    : 1) Le fichier dmp avec l'extension .dmp
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifFicDmp_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" "..Verification de l existence du fichier dmp : ${1}"
  FctPasAPas
  if [ ! -s "${1}" ]
  then
     FctEcHo "E" "..le fichier ${1} n existe pas"
  else
     # Si le fichier existe est n'est pas vide alors on le dezippe
     FctEcHo "D" "..le fichier ${1} existe"
     FctPasAPas
     FctEcHo "D" "..Changement des droits du fichier ${1}"
     chmod 666  ${1}
     if [ $? != 0 ] ; then FctEcHo "E" "..Erreur de changement des droits du fichier ${1}" ; exit 1 ; fi
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctCreateRepertoire_0 () {
  ### ----------------------------------------------------------------
  # fonction : Creation d'un repertoire s'il n'existe pas
  #            Sinon il lui change la date
  # Usage    : FctCreateRepertoire_0
  # Param    : 1) Le nom de la variable Repertoire
  # Param    : 2) le Repertoire
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctCreateRepertoire_0"
  FctVerifNbParam $# 2 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  if [ -z "$2" ] ; then FctEchOra "D" "${NomFct}: Arret sur abort vide"                             ; else WFArretSurAbort=$2 ; fi

  FctEcHo "D" ".... Creation ${1}   =${2}"
  mkdir -p ${2}
  if [ $? -ne 0 ]
  then
     FctEcHo "E" ERREUR
     FctEcHo "E" "sur creation repertoire ${2}"
     CODE_RETOUR=1
  else
     chmod 777 ${2}
     touch ${2}
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctCreateRepertoires_0 () {
  ### ----------------------------------------------------------------
  # fonction : Creation d'un repertoire s'il n'existe pas
  # Usage    : FctCreateRepertoires_0
  # Param    : 1) le Repertoire
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctCreateRepertoires_0"
  #FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  if [ -z "$1" ] ; then FctEchora "D" ".${Decallage}${NomFct}: Erreur Nom Repertoire vide"; return ${RC_ErrParam} ; else WFNomRepertoire=$1      ; fi

  FctEcHo "D" ".... Verification ${WFNomRepertoire}"
  FctVerifRepertoire_0 ${WFNomRepertoire}
  if [ $? = ${RC_Repertoire_Inexistant} ]
  then 
     FctEcHo "D" ".${Decallage}Creation ${WFNomRepertoire}"
     mkdir -p ${1}
     if [ $? -ne 0 ]
     then
        FctEcHo "E" ".${Decallage}ERREUR sur creation repertoire ${WFNomRepertoire}"
        CODE_RETOUR=1
     else
       FctEcHo "X" ".${Decallage}Creation ${WFNomRepertoire} OK"
     fi
  fi
  return ${RC_OK}
}


# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifRepertoire_0 () {
  ### ----------------------------------------------------------------
  # fonction : Verification de l'existence du repertoire passe en parametre
  # Usage    : FctVerifRepertoire_0 Repertoire
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifRepertoire_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  if [ ! -d "${1}" ]
  then
     FctEcHo "D" ".."
     FctEcHo "D" "${Decallage} Le repertoire ${1} n existe pas "
     return ${RC_Repertoire_Inexistant}
  else
     return ${RC_OK}
  fi
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifEtCreationRep_0 () {
  ### ----------------------------------------------------------------
  # fonction : Creation du repertoire passe en parametre si necessaire
  # Usage    : FctVerifEtCreationRep_0 Repertoire Proprio Groupe DroitsNum
  # Param    : 1) Le Repertoire
  # Param    : 2) Le proprietaire 
  # Param    : 3) Le groupe
  # Param    : 4) Les droits en numerique (777)
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifEtCreationRep_0"
  FctVerifNbParam $# 4 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  FctEcHo "D" ".. Param Le Repertoire           = <$1>"
  FctEcHo "D" ".. Param Le proprietaire         = <$2>"
  FctEcHo "D" ".. Param Le groupe               = <$3>"
  FctEcHo "D" ".. Param Les droits en numerique = <$4>"
  if [ ! -d "${1}" ]
  then
     FctEcHo "D" ".."
     FctEcHo "D" "${Decallage} Creation du repertoire ${1}"
     mkdir -p ${1}
     chown ${2}:${3} ${1}
     chmod ${4}      ${1}
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifEtCreateRep_0 () {
  ### ----------------------------------------------------------------
  # fonction : Demande la creation d'un repertoire s'il n'existe pas
  # Usage    : FctVerifEtCreateRep_0
  # Param    : 1) Le Repertoire
  # Param    : 2) Variable de forcage = force pour éviter les questions
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifEtCreateRep_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  #if [ "${2}" = "force" ]
  #  ls -tlr ${1}  || mkdir -p ${1}
  #  return $?
  #fi
  if [ ! -d "${1}" ]
  then
     FctEcHo "X" "Repertoire non existant :<${1}>. Creation "
     mkdir -p "${1}"
  else
     FctEcHo "X" "Repertoire existant :<${1}>"
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifListeVersionOracle_0 () {
  ### ----------------------------------------------------------------
  # fonction : Verification que version Oracle en parametre est bien dans la liste : 11.2.0, 12.1.0, 12.2.0
  # Usage    : FctVerifListeVersionOracle_0
  # Param    : 1) La version Oracle
  ### ----------------------------------------------------------------
  
  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifListeVersionOracle_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  if [ "${1}" != "11.2.0" -a \
       "${1}" != "12.1.0" -a \
	   "${1}" != "12.2.0" ]
  then
     Fctecho "ABORT"
     Fctecho "Erreur la version Oracle <${1}> n_est pas dans la liste 11.2.0, 12.1.0, 12.2.0"
     exit ${RC_ErreurParam}
  fi
  FctEcHo "D" "${Decallage}.Version Oracle=${1} "
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifServeurOracle_0 () {
  ### ----------------------------------------------------------------
  # fonction : Verification que le serveur est bien un serveur oracle
  # Usage    : FctVerifServeurOracle_0
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifServeurOracle_0"
  WFNomServeur=$(hostname -s)
  FctEcHo "D" "WFNomServeur=${WFNomServeur}"
  if                [ "${WFNomServeur}" != "bdoratec1" ] ; then
     if             [ "${WFNomServeur}" != "bdoraref1" ] ; then
        if          [ "${WFNomServeur}" != "bdorapub1" ] ; then
           if       [ "${WFNomServeur}" != "bdoradev4" ] ; then
              if    [ "${WFNomServeur}" != "bdoradev3" ] ; then
                  FctEcHo "E" "ABORT"
                  FctEcHo "E" "Ce programme ne fonctionne que sur un serveur oracle, et non de ${WFNomServeur}"
                  exit ${RC_Serveur_Non_Oracle}
              fi
           fi
        fi
     fi
  fi
  FctEcHo "D" "${WFNomServeur} est un serveur oracle"
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifServeurOracleDeRef_0 () {
  ### ----------------------------------------------------------------
  # fonction : Verification que le serveur passé en parametre est bien le serveur oracle de reference : bdoratec
  # Usage    : FctVerifServeurOracleDeRef_0
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifServeurOracleDeRef_0"
  WFNomServeur=$(hostname -s)
  if [ "${WFNomServeur}" != "bdoratec1" ]
  then
     FctEcHo "E" "ABORT"
     FctEcHo "E" "Ce programme ne fonctionne que sur le serveur bdoratec1, et non de ${WNomServeur}"
     exit ${RC_Serveur_Non_Oracle}
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctMoveFicSupervisionDansHisto_0 () {
  ### ----------------------------------------------------------------
  # fonction : Deplacement des anciens fichiers resultats de la supervision dans le repertoire historique
  # Usage    : FctMoveFicSupervisionDansHisto_0
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctMoveFicSupervisionDansHisto_0"
  FctEcHo "D" ".. ${NomFct}"
  FicResult="/database/backup/supervision/${dat_traitement}_${WTitre}_${ORACLE_SID}.res"
  RepHisto="/database/backup/supervision/historique"
  mv /database/backup/supervision/*${WTitre}_${ORACLE_SID}.res ${RepHisto}

}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctExecSqlSupervision_0 () {
  ### ----------------------------------------------------------------
  # fonction : Execution d'un sql de supervision
  # Usage    : FctExecSqlSupervision_0
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  WOptionSql=$1
  NomFct="..FctExecSqlSupervision_0"
  FctEcHo "D" ".. ${NomFct}"
  FctEcHo "D" ".. ${NomFct} sqlplus / as sysdba  @/home/oracle/BD_scripts/v0/supervision/sql/${WTitre}.sql ${ORACLE_SID} /database/backup/supervision ${dat_traitement} ${WOptionSql}"
  NLS_LANi=FRENCH_FRANCE.UTF8 ${ORACLE_HOME}/bin/sqlplus "/ as sysdba"  @/home/oracle/BD_scripts/v0/supervision/sql/${WTitre}.sql ${ORACLE_SID} /database/backup/supervision ${dat_traitement} ${WOptionSql}

  FctEcHo     "${Decallage}.Sql executé"

  FctVerifFicSupervision_0 "/database/backup/supervision/${dat_traitement}_${WTitre}_${ORACLE_SID}.res"

  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifFicSupervision_0 () {
  ### ----------------------------------------------------------------
  # fonction : Verification d'un fichier resultat de supervision
  # Usage    : FctVerifFicSupervision_0
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifFicSupervision_0"
  FctVerifNbParam $# 1 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  WFctNomRepFic=$1

  FctEcHo "D" ".. Param Fichier supervision     = <${WFctNomRepFic}>"
  if [ -e "${WFctNomRepFic}" ]
  then
    FctEcHo     "${Decallage}.Fichier resultat corectement généré:"
    FctEcHo     "${Decallage}.-->${WFctNomRepFic}"
  else
    FctAfficheATTENTION_0 
    FctEcHo     "${Decallage}.Fichier resultat         non généré:${WFctNomRepFic}"
    exit 1 
  fi
  if [ -s "${WFctNomRepFic}" ]
  then
    FctAfficheATTENTION_0 
    FctEcHo     "${Decallage}.remonté d'alerte dans ${WFctNomRepFic} "
  else
    FctEcHo     "${Decallage}.Pas de remonte d'alerte"
    cat ${WFctNomRepFic}
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctVerifParamObligatoire_0 () {
  ### ----------------------------------------------------------------
  # fonction : Verification d'un parametre obligatoire
  # Usage    : FctVerifParamObligatoire_0 carParametre valParametre
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctVerifParamObligatoire_0"
  FctVerifNbParam $# 2 "${NomFct}" ; if [ $? != 0 ] ; then return ${RC_ErreurParam} ; fi
  WFctCarParam=$1
  WFctValParam=$2

  FctEcHo "D" ".. Car Param     = <${WFctCarParam}>"
  FctEcHo "D" ".. Nom Param     = <${WFctValParam}>"

  if [ -z "${WFctValParam}" ]
  then
    FctAfficheATTENTION_0
    FctEcHo     "${Decallage}....L_option Obligatoire -${WFctCarParam} n_est pas renseigne <${WFctValParam}>"
    FctEcHo     "${Decallage}..${WLigne3}"
    exit ${RC_ErreurParam}
  fi
  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctAfficheATTENTION_0 () {
  ### ----------------------------------------------------------------
  # fonction : Affichage d_un gros ATTENTION
  # Usage    : FctAfficheATTENTION_0
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctAfficheATTENTION_0"
  FctEcHo     "${Decallage}.    #    ####### ####### ####### #     # ####### ####### ####### #     #" 
  FctEcHo     "${Decallage}.   # #      #       #    #       ##    #    #       #    #     # ##    #" 
  FctEcHo     "${Decallage}.  #   #     #       #    #       # #   #    #       #    #     # # #   #" 
  FctEcHo     "${Decallage}. #     #    #       #    #####   #  #  #    #       #    #     # #  #  #" 
  FctEcHo     "${Decallage}. #######    #       #    #       #   # #    #       #    #     # #   # #" 
  FctEcHo     "${Decallage}. #     #    #       #    #       #    ##    #       #    #     # #    ##" 
  FctEcHo     "${Decallage}. #     #    #       #    ####### #     #    #    ####### ####### #     #" 
  FctEcHo     "${Decallage}. "

  return ${RC_OK}
}

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
FctGestionCodeRetour() {
  ### ----------------------------------------------------------------
  # fonction : Gestion du code retour
  # Usage    : FctGestionCodeRetour
  # Utilise  : les variables        ${CODE_RETOUR} ${MESSAGE_OK} ${MESSAGE_KO} ${MESSAGE_WARNING}
  ### ----------------------------------------------------------------

  let NB_APPEL_MGScritpLib=NB_APPEL_MGScritpLib+1
  NomFct="..FctGestionCodeRetour"

  if   [ "${CODE_RETOUR}" = 0 ]
  then
    FctEcHo "${Decallage}${MESSAGE_OK}"
  elif  [ "${CODE_RETOUR}" = 4 ]
  then
    FctEcHo "${Decallage}${MESSAGE_WARNING}"
    CODE_RETOUR=0
  else
    FctEcHo "${Decallage}${MESSAGE_KO}"
  fi

  return ${CODE_RETOUR}
}

#-------------------------------------#
# Fin de la librairie de fonction KSH #
#-------------------------------------#

# ┌─┐┌─┐┌┐┌┌─┐┌┬┐┬┌─┐┌┐┌
# ├┤ │ │││││   │ ││ ││││
# └  └─┘┘└┘└─┘ ┴ ┴└─┘┘└┘
Fctecho "${Decallage} librairie ${RepToolsLib}/MGScriptLib.sh Chargé"

# Fin du script
