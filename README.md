# Matching-of-candidates-on-positions
Attraverso questo studio si vuole trovare la disposizione di candidati e posizioni che restituiscando il maggior punteggio per poter assegnare i vari dipendenti alle relative posizioni, utilizzando una regressione lineare per vedere l'influenza di ogni candidato sullo score finale.


La prima parte dello sviluppo ha richiesto una generazione di candidati e posizioni a cui è stato assegnato un relativo punteggio, poi sono state generate tutte le possibili permutazioni per avere le varie combinazioni. A queste combinazioni è stato assegnato uno score calcolato attraverso il punteggio dei vari candidati nelle relative posizioni, a questo punto è stato sviluppato un modello di regressione lineare utilizzando lo score come variabile dipendente e la posizione dei candidati come variabile indipendente.
Attraverso la regressione lineare è stato analizzato come la posizione dei vari candidati influisse sul punteggio finale della combinazione.


Lo studio è stato sviluppato utilizzando R Studio e Python
