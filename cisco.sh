#!/bin/bash


# function domainLookup {
#     rep : string
#     while [$rep != "o" || "O" || "n" || "N"] do
#         read -p "Voulez-vous activer le no ip domain-lookup (o/n)" rep

#         if $rep = "o" || "O"  
#         then
#             configure terminal
#             no ip domain-lookup
#             end
#             # echo "ip domain-lookup activé"
#             return $rep
#         else if $rep = "n" || "N" 
#         then
#             configure terminal
#             ip domain-lookup
#             end
#             # echo "ip domain-lookup désactivé"
#             return $rep
#         else
#             echo "Veuillez répondre par (O)ui ou par (N)on!"
#         fi
#     done 
#     return $rep
# }

# function dateConfig {
#     while $date; do
#         read -p "Voulez-vous activer la date et l'heure identique du système linux et du routeur cisco (o/n)" date

#         if $date = "o" || "O"  
#         then
#             clock set timezone UTC 0
#             end
#         elif $date = "n" || "N" 
#         then
#             echo "Date et heure identique désactivé"
#         else
#             echo "Veuillez répondre par (O)ui ou par (N)on!"
#         fi
#         done
#     return $date
# }

# function hostnameConfig {
#     while $hostname; do
#         read -p "Entrez le nom d'hôte: " hostname

#         if [$hostname =~ SW_UL_[0-9]] 
#         then
#             echo "Le format du nom d'hôte est correct!"
#         elif
#         then
#             echo "Le format du nom d'hôte est incorrect!"
#         else 
#             echo "Veuillez entrer un nom d'hôte valide!"
#         fi
#         done
#     return $hostname
# }

#!/bin/bash

function domainLookup {
    rep=""
    while [[ $rep != "o"  && $rep != "O"  && $rep != "n"  && $rep != "N" ]]; do
        read -p "Voulez-vous activer le no ip domain-lookup (o/n) " rep

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
        read -p "Voulez-vous activer la date et l'heure identique du système Linux et du routeur Cisco (o/n) " date

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
            echo "Le format du nom d'hôte est correct!"
        else
            echo "Le format du nom d'hôte est incorrect!"
        fi
    done
    return $hostname
}

# function banniereConfig {

# }

domainLookup
dateConfig
hostnameConfig



