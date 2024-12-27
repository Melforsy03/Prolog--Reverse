
% Verificar movimiento válido

movimiento_valido(Tablero, X, Y) :-
    dentro_del_tablero(X, Y),
    celda_vacia(Tablero, X, Y).

dentro_del_tablero(X, Y) :-
    integer(X), integer(Y), % Asegúrate de que X e Y sean números
    X >= 0, X < 8, Y >= 0, Y < 8.

celda_vacia(Tablero, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, empty).


% Contar piezas
contar_piezas([], _, 0).
contar_piezas([Fila|Resto], Jugador, Total) :-
    contar_piezas_fila(Fila, Jugador, ConteoFila),
    contar_piezas(Resto, Jugador, ConteoResto),
    Total is ConteoFila + ConteoResto.

contar_piezas_fila([], _, 0).
contar_piezas_fila([Jugador|Resto], Jugador, Total) :-
    contar_piezas_fila(Resto, Jugador, ConteoResto),
    Total is ConteoResto + 1.
contar_piezas_fila([_|Resto], Jugador, Total) :-
    contar_piezas_fila(Resto, Jugador, Total).

