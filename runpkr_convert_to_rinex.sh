#!/bin/bash
 
 # Preparer par Renaldo Sauveur
 # ce script permet d'aller dans tous les sous repertoires du repertoire en cours et de convertir en .tgd tous les fichiers .T02 de format (1808020100I.T02). Ensuite de convertir en rinex ces fichiers .tgd.
 
 
 # Il faut modifier l'annee (2019) et le nom de la station (PAPR) en fonction de .........


echo Entrer le nom de la station GPS en majuscule, exemple PAPR : 
read varname                        # permet de lire l'input de l'utilisateur
echo Vous avez entrer: $varname


 
echo Entrer l annee , exemple 2020 :
read varyear                        # permet de lire l'input de l'utilisateur
echo Vous avez entrer: $varyear



 
for voic in $(find * -mindepth 2 -maxdepth 2 -type f );do
		echo 'moving to file ' $voic
        
		 runpkr00 -d -g $voic  
         rm $voic
				 
done  
echo 'Au revoir'

yr=$varyear


 for voic in $(find * .tgd -mindepth 2 -maxdepth 2) ;do echo $voic
        echo 'moving to file ' $voic
        
        
        
        #va chercher le mois de la date
        my=$( echo $voic | awk '{print substr($1,09,2)}')
             echo $my
             
        #va chercher le jour de la date     
        dy=$( echo $voic | awk '{print substr($1,11,2)}')
             echo $dy
        
        
        # va chercher la semaine GPS
        gpsw=$(doy  $yr $my $dy |  tail -n2 | head -n1 | awk '{print $3}' )
           
        
        echo $gpsw
        
        teqc -tr d +C2 +L5 -O.dec 30 -O.ag "CNIGS" -O.o "CNIGS" -O.mo $varname   -week $gpsw $voic > "${voic/.tgd}"
         
        
        rm $voic
         
done  
echo 'Au revoir'
  



  #Boucle pour aller chercher les repertoires journaliers
    
 
 
 for da in '01' '02' '03' '04'  '05' '06' '07' '08' '09' '10' '11' '12'   ;do
 
 # verification si le repertoire de la station existe ou pas        
     if [ -e $da ]    
 
 # si le repertoire journalier existe alors il fait la conversion
     then

        cd $da
        
                
                 echo 'moving to repertoire' $da
                 
         for voic in '01' '02' '03' '04'  '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' '29' '30' '31';do 
         
         # verification si le repertoire du journalier existe ou pas
               if [ -e $voic ]
        
         # si le repertoire journalier existe alors il fait la conversion  
               then
               
                    cd $voic 
                    echo 'moving to site' $voic
                    
                   # for file in $(find * -type f );do
            
                    teqc +obs +  -tbin 1d $varname  $(find * -type f )
                    
                    #done
                    
                    cd ../
               
               else
                   #si le repertoire n'existe pas alors il passe au repertoire journalier suivant   
                   echo  'Le repertoire' $voic 'nexiste pas'
               fi
                    
         done
          
        cd ../
     else 
         #si le repertoire n'existe pas alors il passe au repertoire journalier suivant   
         echo  'Le repertoire' $da 'nexiste pas'
        
     fi

 done

 echo 'Au revoir'

