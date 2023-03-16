#!/bin/bash

# Création du fichier de configuration pour un routeur ou un switch

function createConfigFile {
    while true; do
        read -p "Voulez-vous configurer un routeur ou un switch (r/s) ? " file
        case "$file" in
            r|R)
                fileName="router.txt"
                device="routeur"
                ;;
            s|S)
                fileName="switch.txt"
                device="switch"
                ;;
            *)
                echo "Veuillez répondre par (r)outeur ou par (s)witch!"
                continue
                ;;
        esac

        if [[ -f "$fileName" ]]; then
            echo -e "Le fichier $fileName existe déjà!"
            read -p "Voulez-vous le supprimer (o/n): " rep
            case "$rep" in
                o|O)
                    rm "$fileName"
                    touch "$fileName"
                    return 1
                    ;;
                n|N)
                    return 0
                    ;;
                *)
                    echo "Veuillez répondre par (O)ui ou par (N)on!"
                    ;;
            esac

        else
            echo "Création du fichier de configuration pour un $device"
            touch "$fileName"
            return 0
        fi
    done
}

function questionOuiNon() {
    local question=$1
    local response
    while true; do
        read -p "$question " response
        case $response in
            [oO]) return 0 ;;
            [nN]) return 1 ;;
            *) echo "Veuillez répondre par [o]ui ou [n]on!" ;;
        esac
    done
}

############################################################################################################

# Configuration du routeur ou du switch

function domainLookup {
        echo "";
        questionOuiNon "Voulez-vous activer le no ip domain-lookup (o/n): " rep

        if [[ $rep == "o" || $rep == "O" ]]; then
            echo "Activation de no ip domain-lookup"
            echo "configure terminal
no ip domain-lookup
end" >> $fileName
            echo ""
            return 1

        else
            echo "Activation de ip domain-lookup"
            echo "configure terminal 
ip domain-lookup 
end" >> $fileName
            echo ""
            return 0
        fi
}


function dateConfig {
        questionOuiNon "Voulez-vous activer la date et l'heure identique du système Linux au routeur Cisco (o/n): " date

        if [[ $date =~ ^[Oo]$ ]]; then
            echo "Activation de la date et heure identique" 
            echo "configure terminal
clock set timezone UTC 0 
end" >> $fileName
            echo ""
            return 1

        else
            echo "Désactivation de la date et heure identique"
            echo ""
            return 0
        fi
}


function hostnameConfig {
    hostname=""
    while [[ ! $hostname =~ ^[a-zA-Z][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]$ ]]; do
        read -p "Entrez le nom d'hôte: " hostname

        if [[ $hostname =~ ^[a-zA-Z][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]$ ]]; then
            echo "configure terminal
hostname $hostname
end" >> $fileName
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
    while [[ ! $banniere =~ ^\#.{0,30}\#$ ]]; do
        read -p "Entrez une bannière pour votre routeur: " banniere

        if [[ $banniere =~ ^\#.{0,20}\#$ ]]; then
"configure terminal
banner motd $banniere
end" >> $fileName
            echo "Le format de la bannière est correct!"
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
end" >> $fileName
        echo "Votre mot de passe: $mdpCons"
        echo ""
    else
        echo "Votre mot de passe est vide!"
    fi

    read -p "Entrez un mot de passe pour le mode privilégié: " mdpPrive
    if [ -n $mdpPrive ]; then
        echo "configure terminal
enable secret $mdpPrive
exit" >> $fileName
        echo "Votre mot de passe pour le mode privilégié: $mdpPrive"
        echo ""
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
end" >> $fileName
                echo "Votre port console virtuel: $portVty"
                echo "Votre mot de passe pour le mode vty: $mdpVty"
                echo ""
                return 1
            else
                echo "Votre mot de passe pour le mode vty est vide!"
            fi
        fi
    done
    return 0
}

function encryptMdps {
        questionOuiNon "Voulez-vous chiffrer les mots de passe (o/n): " encrypt

        if [[ $encrypt == "o" || $encrypt == "O" ]]; then
            echo "Activation du chiffrement des mots de passe"
            echo "configure terminal
service password-encryption
end" >> $fileName
            echo ""
            return 1

        else
            echo "Chiffrement des mots de passe non activé"
            echo ""
            return 0
        fi
}


function vlanConfig {
    read -p "Entrez une adresse IP: " ip
    while [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
        read -p "Entrez une adresse IP valide: " ip
    done

    read -p "Entrez un masque de sous-réseau (longueur de préfixe, entre 8 et 32): " prefixLength
    while (( prefixLength < 8 || prefixLength > 32 )); do
        read -p "Entrez un masque de sous-réseau valide: " prefixLength
    done

    subnet_mask_binary=$(printf "%*s" "${prefixLength}" "1" | tr ' ' '0')
    echo "configure terminal
interface vlan 1
ip address $ip $subnet_mask_binary
no shutdown
end" >> $fileName
    echo ""
}

function sshConfig {
    questionOuiNon "Voulez-vous activer le SSH (o/n): " activateSSH
    if [[ $activateSSH =~ ^[Oo]$ ]]; then
        read -p "Entrez le nom de domaine: " domainName
        while (( modulus != 1024 && modulus != 2048 )); do
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
end" >> $fileName

        echo "Activation de la connexion SSH"
        return 1
    else
        echo "Connexion SSH non activée"
        echo ""
        return 0
    fi
}

function interfaceIP {
    echo "show ip interface brief" >> $fileName
    return 1
}

############################################################################################################

# Appels des fonctions (affichage du menu)

createConfigFile
domainLookup
dateConfig
hostnameConfig
bannerConfig
mdpsConfig
encryptMdps
vlanConfig
sshConfig
interfaceIP
