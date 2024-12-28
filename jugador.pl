:- ensure_loaded('func_aux.pl').
:- ensure_loaded('tablero.pl').

oponente(black, white).
oponente(white, black).

jugador_aleatorio(Tablero, Jugador, MovimientoSeleccionado) :-
    movimientos_validos(Tablero, Jugador, Movimientos),
    random_member(MovimientoSeleccionado, Movimientos).

movimientos_validos(Tablero, Jugador, Movimientos) :- 
    findall(Movimiento, es_movimiento_valido(Tablero, Jugador, Movimiento), Movimientos).

random_member(Lista, Elemento) :-
    length(Lista, Longitud),
    Longitud > 0,
    random(0, Longitud, Indice), 
    nth0(Indice, Lista, Elemento).



jugador_heuristico(Tablero, Jugador, MovimientoSeleccionado) :-
    movimientos_validos(Tablero, Jugador, Movimientos),
    maplist(evaluar_movimiento(Tablero, _, Jugador), Movimientos, Valores),
    max_member(ValorMax, Valores),
    nth0(Indice, Valores, ValorMax),
    nth0(Indice, Movimientos, MovimientoSeleccionado).

evaluar_movimiento(Tablero, Movimiento, Jugador, Valor) :-
    simular_movimiento(Tablero, Movimiento, Jugador, NuevoTablero),
    calcular_puntaje(NuevoTablero, Jugador, Valor).

simular_movimiento(Tablero, Movimiento, Jugador, NuevoTablero) :-
    realizar_movimiento(Tablero, Movimiento, Jugador, NuevoTablero).

realizar_movimiento(Tablero, Movimiento, Jugador, NuevoTablero) :-
    capturar_fichas(Tablero, Movimiento, Jugador, TableroIntermedio),
    colocar_ficha(TableroIntermedio, Movimiento, Jugador, NuevoTablero).

capturar_fichas(Tablero, (X, Y), Jugador, TableroIntermedio) :-
    direcciones(Direcciones),
    actualiza_en_direcciones(Tablero, Jugador, X, Y, Direcciones, TableroIntermedio).

colocar_ficha(TableroIntermedio, (X, Y), Jugador, NuevoTablero) :-
    actualiza_celda(TableroIntermedio, X, Y, Jugador, NuevoTablero).

calcular_puntaje(Tablero, Jugador, Puntaje) :-
    contar_piezas(Tablero, Jugador, FichasJugador),
    oponente(Jugador, OtroJugador),
    contar_piezas(Tablero, OtroJugador, FichasOponente),
    Puntaje is FichasJugador - FichasOponente.
