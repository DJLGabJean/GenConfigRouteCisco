# function createConfigFile {
#     while true; do
#         read -p "Voulez-vous configurer un routeur ou un switch (r/s) ? " file
#         case "$file" in
#             r|R)
#                 file_name="router.txt"
#                 device="routeur"
#                 ;;
#             s|S)
#                 file_name="switch.txt"
#                 device="switch"
#                 ;;
#             *)
#                 echo "Veuillez répondre par (R)outeur ou par (S)witch!"
#                 continue
#                 ;;
#         esac

#         if [[ -f "$file_name" ]]; then
#             echo -e "Le fichier $file_name existe déjà!\n"
#             read -p "Voulez-vous le supprimer (o/n): " rep
#             case "$rep" in
#                 o|O)
#                     rm "$file_name"
#                     touch "$file_name"
#                     return 1
#                     ;;
#                 n|N)
#                     return 0
#                     ;;
#                 *)
#                     echo "Veuillez répondre par (O)ui ou par (N)on!"
#                     ;;
#             esac
#         else
#             echo "Création du fichier de configuration pour un $device"
#             touch "$file_name"
#             return 0
#         fi
#     done
# }



# ask_yes_or_no_question() {
#     local question=$1
#     local response
#     while true; do
#         read -p "$question (oui/non) " response
#         case $response in
#             [oO][uU][iI]|[yY][eE][sS]) return 0 ;;
#             [nN][oO]|[nN]) return 1 ;;
#             *) echo "Veuillez répondre par oui ou non." ;;
#         esac
#     done
# }


## Example for encrypt a password with asterisks:

# msg2=$(echo "$msg" | tr -c -d '*')