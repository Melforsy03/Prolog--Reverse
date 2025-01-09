direcciones([(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (-1, 1), (1, -1)]).

% Verificar movimiento válido

es_movimiento_valido(Tablero, Jugador, (X, Y)) :-
    movimiento_valido(Tablero, X, Y),
    direcciones(Direcciones),
    captura(Tablero, Jugador, X, Y, Direcciones, NuevoTablero).

movimiento_valido(Tablero, X, Y) :-
    dentro_del_tablero(X, Y),
    celda_vacia(Tablero, X, Y).

dentro_del_tablero(X, Y) :-
    integer(X), integer(Y), % Asegúrate de que X e Y sean números
    X >= 0, X < 8, Y >= 0, Y < 8.

celda_vacia(Tablero, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, empty).


% Verificar si el oponente ocupa la celda

pieza_oponente(Tablero, Jugador, X, Y) :-
    dentro_del_tablero(X, Y),
    oponente(Jugador, Oponente),
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, Oponente).

captura(Tablero, Jugador, X, Y,[], NuevoTablero).
captura(Tablero, Jugador, X, Y,[(DX, DY)|Resto], NuevoTablero):-
    capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero),
    captura(Tablero, Jugador, X, Y, Resto, NuevoTablero).

capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    pieza_oponente(Tablero, Jugador, X1, Y1),
    actualiza_celda(Tablero, X1, Y1, Jugador, TableroParcial),
    capturar(TableroParcial, Jugador, X1, Y1, DX, DY, NuevoTablero).
capturar(Tablero, _, _, _, _, _, Tablero).


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


% Encuentra el elemento máximo basado en el primer componente del par.
max_member(Valor-Movimiento, Pares) :-
    max_member(Pares, Valor-Movimiento).

max_member([Valor-Movimiento], Valor-Movimiento). 
max_member([Valor1-Mov1, Valor2-Mov2 | Resto], Maximo) :-
    (Valor1 >= Valor2 ->
        max_member([Valor1-Mov1 | Resto], Maximo)
    ;
        max_member([Valor2-Mov2 | Resto], Maximo)
    ).
