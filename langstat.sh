#!/bin/bash
echo -e "\nBienvenue dans le programme $USER"

#Fonction aide du programme
aide(){
echo -e "\n---------Aide du programme --------"
echo -e '\nUtilisation : .\langstat.sh fichier [--option]'
echo "fichier : parametre obligatoire de type fichier"
echo -e "Option :--recherche pour rechercher un mot"
echo -e "Option :--pendu pour jouer au pendu "
echo -e "\n---------Fin aide------------------"
sleep 5
}

#Fonction et variable pour consulter l'aide
reponse=''
consulterAide(){
read -p "Voulez vous consulter l'aide ? 1-Oui 2-Non " reponse
while [ $reponse != '1' ] && [ $reponse != '2' ]
    do
	read -p  "Erreur : Tappez 1-Oui ou 2-Non" reponse
    done
if [ $reponse = '1' ];then
    aide
fi
}


#Erreur : trop de paramètres entrées, on invite a consulter l'aide au programme
if [ $# -gt 2 ];then
	echo "Erreur : Trop de parametres ! "
	consulterAide
exit
fi

#Recuperer valeur $1 affecteur a varible fichier
fichier="$1"
let "compteur = 0 "
#Invite a ressaisir le chemin du fichier
#Si parametre est vide , c est un dossier , fichier vide , repertoire
while [ -z "$fichier" -o ! -e "$fichier" -o -d "$fichier" -o ! -s "$fichier" -o ! -r "$fichier" ]
do
#on va verifier si le fichier dico.txt existe dans le repertoire courant
trouveDico=$( find -name dico.txt | wc -l )

if [ $trouveDico -ge 1 ] && [ "$compteur" = "0" ]
then
echo "Un fichier dico.txt a été trouvé dans le repertoire courant: "
find -name dico.txt
let "compteur= compteur + 1 "

fi
if [ -z "$fichier" ];then 
	echo "Erreur : le premier paramètre est vide"
elif [ ! -e "$fichier" ];then
	echo "Erreur :Le fichier n'existe pas "
	fichier=''
elif [ -d "$fichier" ];then
	echo "Erreur : Le fichier est un repertoire "
	fichier=''
elif [ ! -s "$fichier" -o ! -r "$fichier" ];then
	echo "Erreur:Le fichier est vide ou inaccessible en lecture"
	fichier=''
fi

read -p 'Merci d indiquer le chemin du fichier à traiter : ' fichier
done

#Creation du fichier et du tableau contenant l alphabet
>statLettres.txt
alphabet=('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z')

for letter in ${alphabet[@]}
do
#substituion de commande pour recuperer le nombre de fois ou la lettre apparait dans un mot
occurences=$(grep -i $letter $fichier | wc -l)

#On inscrit le resultat dans le fichier statLettres.txt
echo  "$occurences - $letter" >>statLettres.txt
done

#Affichage du resultat et Tri du fichier statLettres.txt
echo -e "\nTri decroissant de la présence des lettres dans les mots du dictionnaire"
sort -nr statLettres.txt 
#Fonction rercherche
recherche(){
read -p 'Tappez le mot que vous rercherchez : ' mot
        nbreMotTrouve=$(grep -Ei ^$mot$ $fichier | wc -l)
        nbreMotDebut=$(grep -Ei ^$mot $fichier | wc -l)
        if [ $nbreMotTrouve -ge 1 ];then
            echo "Mot(s) trouvé(s) : "
            grep -Ein $mot $fichier  
        elif [ $nbreMotDebut -ge 1 ] ;then
            echo "Il y a $nbreMotDebut  mot(s) débutant par $mot : "
            grep -Ein ^$mot $fichier
        else
            echo -e "\nAucune correspondance a été trouvée "
        fi

}
#Si Le deuxieme parametre existe
if [ $2 ];then
    
    if [ "$2" = "--recherche" ];then
	echo -e "\n-------------- MENU RECHERCHE ----------------"
	reponseRecherche="oui"
	while [ "$reponseRecherche" = "oui" ]
	  do
	    recherche
            read -p 'Voulez vous effectuer une nouvelle recherche :Entrez  "oui" ou autre touche pour quitter ' reponseRecherche
	  done
       echo -e  "\n-------------- FIN MENU RECHERCHE ------------"
     elif [ "$2" = "--pendu" ];then
       echo -e "\n-------------- JEU DU PENDU ---------------" 
      ./pendu.sh $fichier
       echo -e "\n-------------- FIN PARTIE -----------------"
     else
       echo "ERREUR : OPTION INCONNUE !"
       consulterAide
    fi
fi



