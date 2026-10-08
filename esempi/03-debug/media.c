/*
 * Esercizio di debug: il programma dovrebbe stampare 2.5, ma stampa 2.0.
 *
 * 1. Clicca a sinistra del numero di riga 17 per mettere un breakpoint (pallino rosso).
 * 2. Premi F5: il programma si ferma sul breakpoint.
 * 3. Usa F10 (passo successivo) e guarda le variabili nel pannello a sinistra.
 * 4. Trova l'errore e correggilo.
 */
#include <stdio.h>

int main(void) {
    int voti[] = {1, 2, 3, 4};
    int n = 4;
    int somma = 0;

    for (int i = 0; i < n; i++) {
        somma += voti[i];
    }

    double media = somma / n;
    printf("Media: %.1f\n", media);
    return 0;
}
