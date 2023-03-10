#!/bin/bash


function checkFile {
    if [ -f LEMAIRE_cisco.txt ]; then
        echo "Le fichier LEMAIRE_cisco.txt existe déjà!"
        rm -f LEMAIRE_cisco.txt
        return 1
    else
        echo "Le fichier LEMAIRE_cisco.txt n'existe pas!"
        return 0
    fi
}

function domainLookup {
    rep=""
    while [[ $rep != "o"  && $rep != "O"  && $rep != "n"  && $rep != "N" ]]; do
        read -p "Voulez-vous activer le no ip domain-lookup (o/n): " rep

        if [[ $rep == "o" || $rep == "O" ]]; then
            echo "Activation de no ip domain-lookup"
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "no ip domain-lookup" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            no ip domain-lookup >> /dev/null 2>&1
            end >> /dev/null 2>&1

            return 1
        elif [[ $rep == "n" || $rep == "N" ]]; then
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "ip domain-lookup" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            ip domain-lookup >> /dev/null 2>&1
            end >> /dev/null 2>&1

        return 0
        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done 
    return 0
}

function dateConfig {
    date=""
    while [[ $date != "o" && $date != "O" && $date != "n" && $date != "N" ]]; do
        read -p "Voulez-vous activer la date et l'heure identique du système Linux et du routeur Cisco (o/n): " date

        if [[ $date == "o" || $date == "O" ]]; then
            echo "Activation de la date et heure identique" 
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "clock set timezone UTC 0" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            clock set timezone UTC 0 >> /dev/null 2>&1
            end >> /dev/null 2>&1

            return 1
        elif [[ $date == "n" || $date == "N" ]]; then
            echo "Désactivation de la date et heure identique"
            return 0
        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done
    return 0
}

function hostnameConfig {
    hostname=""
    while [[ ! $hostname =~ ^SW_UL_[0-9]+$ ]]; do
        read -p "Entrez le nom d'hôte: " hostname

        if [[ $hostname =~ ^SW_UL_[0-9]+$ ]]; then
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "hostname $hostname" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            hostname $hostname >> /dev/null 2>&1
            end >> /dev/null 2>&1

            echo "Le format du nom d'hôte est correct!"
            return 1
        else
            echo "Le format du nom d'hôte est incorrect!"
        fi
    done
    return 0
}

function bannerConfig {
    banniere=""
    while [[ ! $banniere =~ ^#.{0,20}\#$ ]]; do
        read -p "Entrez une bannière pour votre routeur: " banniere

        if [[ $banniere =~ ^\#.{0,20}\#$ ]]; then
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "banner motd $banniere" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            banner motd $banniere >> /dev/null 2>&1
            end >> /dev/null 2>&1

            echo "Le format de la bannière est correct!"
            echo "Votre bannière: $banniere"
            return 1
        else
            echo "Le format de la bannière est incorrect!"
        fi
    done
    return 0
}


checkFile
domainLookup
dateConfig
hostnameConfig
bannerConfig




