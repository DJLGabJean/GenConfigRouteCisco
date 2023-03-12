#!/bin/bash


function checkFile {
    if [ -f LEMAIRE_cisco.txt ]; then
        echo "Le fichier LEMAIRE_cisco.txt existe déjà!"
        echo ""
        rm -f LEMAIRE_cisco.txt
        return 1
    else
        echo "Le fichier LEMAIRE_cisco.txt n'existe pas!"
        echo ""
        return 0
    fi
}


function domainLookup {
    rep=""
    while [[ $rep != "o"  && $rep != "O"  && $rep != "n"  && $rep != "N" ]]; do
        read -p "Voulez-vous activer le no ip domain-lookup (o/n): " rep

        if [[ $rep == "o" || $rep == "O" ]]; then
            echo "Activation de no ip domain-lookup
configure terminal
no ip domain-lookup
end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            no ip domain-lookup >> /dev/null 2>&1
            end >> /dev/null 2>&1

            return 1
        elif [[ $rep == "n" || $rep == "N" ]]; then
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "ip domain-lookup" >> LEMAIRE_cisco.txt
            echo "end\\n" >> LEMAIRE_cisco.txt
            echo ""

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
            echo ""

            configure terminal >> /dev/null 2>&1
            clock set timezone UTC 0 >> /dev/null 2>&1
            end >> /dev/null 2>&1

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
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "hostname $hostname" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            hostname $hostname >> /dev/null 2>&1
            end >> /dev/null 2>&1

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
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "banner motd $banniere" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            banner motd $banniere >> /dev/null 2>&1
            end >> /dev/null 2>&1

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

    if [ -n "$mdpCons" ]; then
        echo "configure terminal
line console 0
password $mdpCons
login
end" >> LEMAIRE_cisco.txt
        configure terminal >> /dev/null 2>&1
        line console 0 >> /dev/null 2>&1
        password $mdpCons >> /dev/null 2>&1
        login >> /dev/null 2>&1
        end >> /dev/null 2>&1
        echo "Votre mot de passe: $mdpCons"
        echo ""
    else
        echo "Votre mot de passe est vide!"
    fi

    read -p "Entrez un mot de passe pour le mode privilégié: " mdpPrive

    if [ -n "$mdpPrive" ]; then
        echo "configure terminal
enable secret $mdpPrive
exit" >> LEMAIRE_cisco.txt

        echo "Votre mot de passe pour le mode privilégié: $mdpPrive"
        echo ""
    else
        echo "Votre mot de passe pour le mode privilégié est vide!"
    fi

    while true; do
        read -p "Donner une ligne pour le port console virtuel entre 0 et 15: " portVty

        if [[ ! "$portVty" =~ ^[0-9]{1,2}$ ]]; then
            echo "Votre port console virtuel doit être comprise entre 0 et 15!"
        else
            read -p "Entrez un mot de passe pour le mode vty: " mdpVty

            if [ -n "$mdpVty" ]; then
                echo "configure terminal
line vty $portVty
password $mdpVty
login
end" >> LEMAIRE_cisco.txt
                configure terminal >> /dev/null 2>&1
                line vty $portVty >> /dev/null 2>&1
                password $mdpVty >> /dev/null 2>&1
                login >> /dev/null 2>&1
                end >> /dev/null 2>&1
                echo "Votre port console virtuel: $portVty"
                echo "Votre mot de passe pour le mode vty: $mdpVty"
                echo ""
                return 1
            else
                echo "Votre mot de passe pour le mode vty est vide!"
            fi
        fi
    done
}



checkFile
domainLookup
dateConfig
hostnameConfig
bannerConfig
mdpsConfig
echo "Ce n'est pas encore pas fini, payer pour avoir la suite en extension eheh"




# while $fin
#     while $etp1
#         while $etp2
#             while $etp3

fin=0

# while [ $fin != 1 ]
# do
#     etp1=0

#     while [ $etp1 != 1 ]
#     do
#         etp2=0

#         while [ $etp2 != 1 ]
#         do
#             etp3=0

#             while [ $etp3 != 1 ]
#             do
#                 # Instructions
#             done
#         done
#     done
# done