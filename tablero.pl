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

imprimir_tablero([]).
imprimir_tablero([Fila|Resto]) :-
    write(Fila), nl,
    imprimir_tablero(Resto).

% Actualizar el tablero después de un movimiento
actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero) :-
    actualiza_celda(Tablero, X, Y, Jugador, TableroConPieza),
    direcciones(Direcciones),
    write('actulizar capturas'), nl,
    captura_en_direcciones(TableroConPieza, Jugador, X, Y, Direcciones, NuevoTablero).

captura_en_direcciones(Tablero, _, _, _, [], Tablero).
captura_en_direcciones(Tablero, Jugador, X, Y, [(DX, DY)|Resto], TableroFinal) :-
    write('capturara en direccion'), nl,
    capturar_en_direccion(Tablero, Jugador, X, Y, DX, DY, TableroParcial),
    captura_en_direcciones(TableroParcial, Jugador, X, Y, Resto, TableroFinal).

capturar_en_direccion(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    (   
        pieza_oponente(Tablero, Jugador, X1, Y1) ->
        capturar_fichas(Tablero, Jugador, X1, Y1, DX, DY, NuevoTablero)
    ;   
        NuevoTablero = Tablero
    ).

capturar_fichas(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    write('captura de fichas'), nl,
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    (   
        celda_ocupada(Tablero, Jugador, X1, Y1) ->
        actualiza_celda(Tablero, X, Y, Jugador, NuevoTablero)
    ;   
        pieza_oponente(Tablero, Jugador, X1, Y1),
        actualiza_celda(Tablero, X, Y, Jugador, TableroParcial),
        capturar_fichas(TableroParcial, Jugador, X1, Y1, DX, DY, NuevoTablero)
    ).


actualiza_celda(Tablero, X, Y, Jugador, NuevoTablero) :-
    write('actualizar celda'), nl,
    nth0(X, Tablero, Fila, _),
    reemplazar(Fila, Y, Jugador, NuevaFila),
    reemplazar(Tablero, X, NuevaFila, NuevoTablero).

reemplazar([_|T], 0, Elem, [Elem|T]):- write('remplazar primera celda'), nl.
reemplazar([H|T], I, Elem, [H|R]) :-
    write('remplazar celda'), nl,
    I > 0,
    I1 is I - 1,
    reemplazar(T, I1, Elem, R).
