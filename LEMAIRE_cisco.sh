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
            echo "Activation de no ip domain-lookup"
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "no ip domain-lookup" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt
            echo ""

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
    while [[ ! $hostname =~ ^SW-UL-([0-9]{1,2})+$  ]]; do
        read -p "Entrez le nom d'hôte: " hostname

        if [[ $hostname =~ ^SW-UL-([0-9]{1,2})+$ ]]; then
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
    fin=0
    read -p "Entrez un mot de passe pour la console: " mdpCons

    while [[ $fin != 1 ]]; do

        if [ $mdpCons -gt 0 ]; then
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "line console 0" >> LEMAIRE_cisco.txt
            echo "password $mdpCons" >> LEMAIRE_cisco.txt
            echo "login" >> LEMAIRE_cisco.txt
            echo "end" >> LEMAIRE_cisco.txt

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

        if [ $mdpPrive -gt 0 ]; then
            echo "configure terminal" >> LEMAIRE_cisco.txt
            echo "enable secret $mdpPrive" >> LEMAIRE_cisco.txt
            echo "exit" >> LEMAIRE_cisco.txt

            configure terminal >> /dev/null 2>&1
            enable secret $mdpPrive >> /dev/null 2>&1
            exit >> /dev/null 2>&1

            echo "Votre mot de passe pour le mode privilégié: $mdpCons"
            echo ""
        else
            echo "Votre mot de passe pour le mode privilégié est vide!"
        fi

        portVty=""
        mdpVty=""
        while [[ ! $portVty =~ ^[0-15]$ ]]; do
            read -p "Donner une ligne pour le port console virtuel entre 0 et 15: " portVty 
            read -p "Entrez un mot de passe pour le mode vty: " mdpVty

            if [[ $portVty =~ ^[0-15]$ ]]; then
                if [ $mdpVty -gt 0 ]; then
                    echo "configure terminal" >> LEMAIRE_cisco.txt
                    echo "line vty $portVty" >> LEMAIRE_cisco.txt
                    echo "password $mdpVty" >> LEMAIRE_cisco.txt
                    echo "login" >> LEMAIRE_cisco.txt
                    echo "end" >> LEMAIRE_cisco.txt

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
            else
                echo "Votre port console virtuel doit etre comprise entre 0 et 15!"
            fi
        done
    done
    return $fin=1
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