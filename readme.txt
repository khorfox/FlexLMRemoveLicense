Prerequisiti: 
1- l'interprete perl deve essere presente nel sistema
2- la shell lancia.sh deve avere i permessi di esecuzione

Lo script permette di cancellare le sessione attive da più di un ora presenti su flexlm.

La shell lancia.sh:
esegue il comando lmstat -a salvandone il risultato nel file temp.lst,
attiva lo script analizza.pl passandogli due parametri: il nome del file da analizzare (temp.lst) e l'intervallo (espresso in ore) oltre il quale una sessione va rimossa
lo script genera il file comandi.sh contenenente le istruzioni di rimozione delle sessioni
la shell lancia comandi.sh per effettuare la cancellazione delle sessioni