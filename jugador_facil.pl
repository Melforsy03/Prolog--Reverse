:- ensure_loaded('func_aux.pl').
:- ensure_loaded('jugador.pl').

 jugador_facil(Tablero, Jugador, (X, Y)) :-
    movimientos_validos(Tablero, Jugador, Movimientos),
    (   Movimientos \= [] ->
        length(Movimientos, Len),
        random_between(0, Len, Index),
        nth1(Index, Movimientos, (X, Y))
    ;   write('No hay movimientos válidos disponibles.'), nl, fail).

