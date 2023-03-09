#!/bin/bash

function domainLookup {
    rep=""
    while [[ $rep != "o"  && $rep != "O"  && $rep != "n"  && $rep != "N" ]]; do
        read -p "Voulez-vous activer le no ip domain-lookup (o/n): " rep

        if [[ $rep == "o" || $rep == "O" ]]; then
            echo "Activation de no ip domain-lookup"
            configure terminal
            no ip domain-lookup
            end
            return $rep
        elif [[ $rep == "n" || $rep == "N" ]]; then
            echo "Désactivation de no ip domain-lookup"
            configure terminal
            ip domain-lookup
            end
            return $rep
        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done 
    return $rep
}

function dateConfig {
    date=""
    while [[ $date != "o" && $date != "O" && $date != "n" && $date != "N" ]]; do
        read -p "Voulez-vous activer la date et l'heure identique du système Linux et du routeur Cisco (o/n): " date

        if [[ $date == "o" || $date == "O" ]]; then
            echo "Activation de la date et heure identique"
            configure terminal
            clock set timezone UTC 0
            end
            return $date
        elif [[ $date == "n" || $date == "N" ]]; then
            echo "Désactivation de la date et heure identique"
            return $date
        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done
    return $date
}

function hostnameConfig {
    hostname=""
    while [[ ! $hostname =~ ^SW_UL_[0-9]+$ ]]; do
        read -p "Entrez le nom d'hôte: " hostname

        if [[ $hostname =~ ^SW_UL_[0-9]+$ ]]; then
            configure terminal
            hostname $hostname
            end
            echo "Le format du nom d'hôte est correct!"
            return $hostname
        else
            echo "Le format du nom d'hôte est incorrect!"
        fi
    done
    return $hostname
}

function banniereConfig {
    banniere=""
    while [[ ! $banniere =~ ^\#.{0,20}\#$ ]]; do
        read -p "Entrez une bannière pour votre routeur: " banniere

        if [[ $banniere =~ ^\#.{0,20}\#$ ]]; then
            configure terminal
            banner motd $banniere
            end
            echo "Le format de la bannière est correct!"
            return $banniere
        else
            echo "Le format de la bannière est incorrect!"
        fi
    done
    return $banniere
}


domainLookup
dateConfig
hostnameConfig
banniereConfig




