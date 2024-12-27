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

% Imprimir el tablero fila por fila
imprimir_tablero([]).
imprimir_tablero([Fila|Resto]) :-
    write(Fila), nl,
    imprimir_tablero(Resto).

direcciones([(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (-1, 1), (1, -1)]).

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

% Verificar si el oponente ocupa la celda
pieza_oponente(Tablero, Jugador, X, Y) :-
    dentro_del_tablero(X, Y),
    oponente(Jugador, Oponente),
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, Oponente).

capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    pieza_oponente(Tablero, Jugador, X1, Y1),
    actualiza_celda(Tablero, X1, Y1, Jugador, TableroParcial),
    capturar(TableroParcial, Jugador, X1, Y1, DX, DY, NuevoTablero).
capturar(Tablero, _, _, _, _, _, Tablero).



