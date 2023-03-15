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