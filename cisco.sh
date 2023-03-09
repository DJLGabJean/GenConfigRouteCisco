#!/bin/bash

function domainLookup {
    while $rep 
    read -p "Voulez-vous activer le no ip domain-lookup (o/n)" rep
    if $rep = "o" || "O"  then
        echo "no ip domain-lookup activé"
        exit
    else if $rep = "n" || "N" then
        echo "no ip domain-lookup désactivé"
        exit
    else
        echo "Veuillez répondre par (O)ui ou par (N)on!"
    fi
    return $rep
}

