:- ensure_loaded('func_aux.pl').

% Tablero inicial
inicializar_tablero([
    [empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, white, black, empty, empty, empty],
    [empty, empty, empty, black, white, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty]
]).

% Actualizaciones del tablero (nuevas piezas y capturas).

actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero) :-
    actualiza_celda(Tablero, X, Y, Jugador, TableroConPieza),
    actualiza_capturas(TableroConPieza, Jugador, X, Y, NuevoTablero).

actualiza_celda(Tablero, X, Y, Jugador, NuevoTablero) :-
    nth0(X, Tablero, Fila, _),
    reemplazar(Fila, Y, Jugador, NuevaFila),
    reemplazar(Tablero, X, NuevaFila, NuevoTablero).

reemplazar([_|T], 0, Elem, [Elem|T]).
reemplazar([H|T], I, Elem, [H|R]) :-
    I > 0,
    I1 is I - 1,
    reemplazar(T, I1, Elem, R).

actualiza_capturas(Tablero, Jugador, X, Y, NuevoTablero) :-
    direcciones(Direcciones),
    actualiza_en_direcciones(Tablero, Jugador, X, Y, Direcciones, NuevoTablero).

actualiza_en_direcciones(Tablero, _, _, _, [], Tablero).
actualiza_en_direcciones(Tablero, Jugador, X, Y, [(DX, DY)|Resto], TableroFinal) :-
    actualiza_en_una_direccion(Tablero, Jugador, X, Y, DX, DY, TableroParcial),
    actualiza_en_direcciones(TableroParcial, Jugador, X, Y, Resto, TableroFinal).

actualiza_en_una_direccion(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    (   
        pieza_oponente(Tablero, Jugador, X1, Y1) ->  
        capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero)
    ;   
        NuevoTablero = Tablero
    ).