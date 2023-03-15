#!/bin/bash

function checkFile {
    if [ -f switch.txt ]; then
        echo "Le fichier switch.txt existe déjà!"
        echo ""
        rm -f switch.txt
        return 1

    else
        echo "Le fichier switch.txt n'existe pas!"
        echo ""
        return 0
    fi
}

function domainLookup {
    rep=""
    while [[ $rep != "o"  && $rep != "O"  && $rep != "n"  && $rep != "N" ]]; do
        read -p "Voulez-vous activer le no ip domain-lookup (o/n): " rep

        if [[ $rep == "o" || $rep == "O" ]]; then
            echo "Activation de no ip domain-lookup"
            echo "configure terminal
no ip domain-lookup
end" >> switch.txt
            echo ""
            return 1

        elif [[ $rep == "n" || $rep == "N" ]]; then
            echo "Activation de ip domain-lookup"
            echo "configure terminal 
ip domain-lookup 
end" >> switch.txt
            echo ""
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
        read -p "Voulez-vous activer la date et l'heure identique du système Linux au routeur Cisco (o/n): " date

        if [[ $date == "o" || $date == "O" ]]; then
            echo "Activation de la date et heure identique" 
            echo "configure terminal
clock set timezone UTC 0 
end" >> switch.txt
            echo ""
            return 1

        elif [[ $date == "n" || $date == "N" ]]; then
            echo "Désactivation de la date et heure identique"
            echo ""
            return 0

        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done
    return 0
}


function hostnameConfig {
    hostname=""
    while [[ ! $hostname =~ ^[a-zA-Z][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]$ ]]; do
        read -p "Entrez le nom d'hôte: " hostname

        if [[ $hostname =~ ^[a-zA-Z][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]$ ]]; then
            echo "configure terminal
hostname $hostname
end" >> switch.txt
            echo "Le format du nom d'hôte est correct!"
            echo ""
            return 1

        else
            echo "Le format du nom d'hôte est incorrect!"
        fi
    done
    return 0
}


function bannerConfig {
    banniere=""
    while [[ ! $banniere =~ ^\#.{0,20}\#$ ]]; do
        read -p "Entrez une bannière pour votre routeur: " banniere

        if [[ $banniere =~ ^\#.{0,20}\#$ ]]; then
"configure terminal
banner motd $banniere
end" >> switch.txt
            echo "Le format de la bannière est correct!"
            echo "Votre bannière: $banniere"
            echo ""
            return 1

        else
            echo "Le format de la bannière est incorrect!"
            echo "Vous devez avoir une bannière de ce format: [#]message[#]"
        fi
    done
    return 0
}


function mdpsConfig {
    read -p "Entrez un mot de passe pour la console: " mdpCons

    if [ -n $mdpCons ]; then
        echo "configure terminal
line console 0
password $mdpCons
login
end" >> switch.txt
        # mdpCons=$(echo "$mdpCons" | tr -c -d '*')
        # echo "Votre mot de passe: $mdpCons"
        # echo ""
    else
        echo "Votre mot de passe est vide!"
    fi

    read -p "Entrez un mot de passe pour le mode privilégié: " mdpPrive
    if [ -n $mdpPrive ]; then
        echo "configure terminal
enable secret $mdpPrive
exit" >> switch.txt
        # mdpPrive=$(echo "$mdpPrive" | tr -c -d '*')
        # echo "Votre mot de passe pour le mode privilégié: $mdpPrive"
        # echo ""
    else
        echo "Votre mot de passe pour le mode privilégié est vide!"
    fi

    while [[ $portVty < 0 || $portVty > 15 ]]; do
        read -p "Donner une ligne pour le port console virtuel entre 0 et 15: " portVty
        if [[ $portVty < 0 || $portVty > 15 ]]; then
            echo "Votre port console virtuel doit être comprise entre 0 et 15!"
        else
            read -p "Entrez un mot de passe pour le mode vty: " mdpVty
            if [ -n $mdpVty ]; then
                echo "configure terminal
line vty $portVty
password $mdpVty
login
end" >> switch.txt
                # mdpVty=$(echo "$mdpVty" | tr -c -d '*')
                echo "Votre port console virtuel: $portVty"
                # echo "Votre mot de passe pour le mode vty: $mdpVty"
                # echo ""
                return 1
            else
                echo "Votre mot de passe pour le mode vty est vide!"
            fi
        fi
    done
    return 0
}

function encryptMdps {
    while [[ $encrypt != "o" && $encrypt != "O" && $encrypt != "n" && $encrypt != "N" ]]; do
        read -p "Voulez-vous chiffrer les mots de passe (o/n): " encrypt

        if [[ $encrypt == "o" || $encrypt == "O" ]]; then
            echo "Activation du chiffrement des mots de passe"
            echo "configure terminal
service password-encryption
end" >> switch.txt
            echo ""
            return 1

        elif [[ $encrypt == "n" || $encrypt == "N" ]]; then
            echo "Chiffrement des mots de passe non activé"
            echo ""
            return 0

        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done
}


function vlanConfig {
    ip=""
    while [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
        read -p "Entrez une adresse IP: " ip

        if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            echo "configure terminal
interface vlan 1
ip address $ip
no shutdown
end" >> switch.txt
            echo "Votre adresse IP: $ip"
            echo ""
            return 1

        else
            echo "Votre adresse IP est incorrecte!"
        fi
    done
    return 0
}

function sshConfig {
    activateSSH=""
    while [[ $activateSSH != "o" && $activateSSH != "O" && $activateSSH != "n" && $activateSSH != "N" ]]; do
        read -p "Voulez-vous activer le SSH (o/n): " activateSSH

        if [[ $activateSSH == "o" || $activateSSH == "O" ]]; then
            read -p "Entrez le nom de domaine: " domainName
            while [[ $modulus != 1024 && $modulus != 2048 ]]; do
                read -p "Entrez le modulus (1024 ou 2048 bits): " modulus
            done
            read -p "Entrez le nom d'utilisateur pour la connexion SSH: " sshUsername
            read -p "Entrez le mot de passe pour la connexion SSH: " sshPassword
            echo ""
            echo "configure terminal
ip domain-name $domainName
crypto key generate rsa modulus $modulus
username $sshUsername privilege 15 secret $sshPassword
line vty 0 4
transport input ssh
login local
exit
end" >> switch.txt
            # sshUsername=$(echo "$sshUsername" | tr -c -d '*')
            # sshPassword=$(echo "$sshPassword" | tr -c -d '*')
            echo "Activation de la connexion SSH"
            # echo "Les paramètres du SSH sont les suivants:"
            echo "Nom de domaine: $domainName"
            echo "Modulus: $modulus bits"
            # echo "Nom d'utilisateur pour la connexion SSH: $sshUsername"
            # echo "Mot de passe pour la connexion SSH: $sshPassword"
            return 1
        
        elif [[ $activateSSH == "n" || $activateSSH == "N" ]]; then
            echo "Connexion SSH non activée"
            echo ""
            return 0

        else
            echo "Veuillez répondre par (O)ui ou par (N)on!"
        fi
    done
    return 0
}

function interfaceIP {
    echo "show ip interface brief" >> switch.txt
    return 1
}


checkFile
domainLookup
dateConfig
hostnameConfig
bannerConfig
mdpsConfig
encryptMdps
vlanConfig
sshConfig
interfaceIP

