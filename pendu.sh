#!/bin/bash

jouerPendu(){
#Variable pour compter le nombre de mots du dico.txt
nombreMots=$(wc -l $1 | cut -d' ' -f 1)
#Nombre tiré au hasard 
nbreRandom=$(($RANDOM*$nombreMots/32767+1))

#Option : servira d'option pour la commande sed
option=$(echo $nbreRandom)
option="$option""p"
#Grace a la commande sed on pourra obtenir le mot
#Exemple : sed -n 2p "dico.txt" Prend la 2 eme ligne 
motAtrouver=$(sed -n $option $1)

#Compter le nombre de lettres et  transformer le mot en " - - - - - - - -"
nbreLettresMotatrouver=${#motAtrouver}
pendu=$(echo $motAtrouver | tr "[A-Z]" "-")
#Creation 2 tableau : array contiendra le mot a chercher et arrayPendu mot sous forme "- - -"
#identique :variable pour comparer le contenu des 2 tableaux
array=()
arrayPendu=()
identique="0"
#Transformer les strings en tableaux
for i in `seq 0 $(($nbreLettresMotatrouver-1))`;
    do
	j=$(($i+1))
	array[$i]=`(echo $motAtrouver | cut -c $j-$j)`
	arrayPendu[$i]=`(echo $pendu | cut -c $j-$j)`
    done

#Fonction pour comparer les 2 tableaux
comparerPenduMot(){
identique="1"
for k in `seq 0 ${#array[@]}`
do
  if [ "${array[$k]}" != "${arrayPendu[$k]}" ];then
    identique="0"

    break
  fi
done
}

#echo "Affichage du nombre de lettres et du tableau 
echo -e "\nMot à trouver de "$(($nbreLettresMotatrouver - 1))" lettres : ${arrayPendu[@]}"

let "nbreChance = 9"
echo "Vous avez $nbreChance tentatives "

#Tant que le joueur a des tentatives
while [ $nbreChance -gt 0 ]
    do
    	comparerPenduMot
	if [ $identique = "1" ];then
	    echo -e "\nBRAVO ! VOUS AVEZ GAGNE !!!"
            break;
        fi
	read -p "Tappez une lettre majuscule :  " lettre
	lettrePresence=$(echo $motAtrouver | grep $lettre)
	if [ "$?" -eq 0 ];then
	    
            for k in `seq 0 ${#array[@]}`
 		do
  		  if [ "${array[$k]}" = "$lettre" ];then
  		  arrayPendu[$k]=${array[$k]}
 	fi

		done
  else 
	let "nbreChance = nbreChance -1"
	echo -e "\nNbre de coups restant : $nbreChance"


	fi
	echo ${arrayPendu[@]}

	done
 
if [ $nbreChance -eq 0 ];then
echo -e "\nDOMMAGE ! VOUS AVEZ PERDU "
echo "Le mot à trouver était ${array[@]}"
fi
}

reponsePendu="oui"

	while [ $reponsePendu = "oui" ]
	 do
		jouerPendu $1
		read -p "Voulez vous rejouer au pendu : tappez (oui) ou autre touche pour quitter " reponsePendu		
        done
