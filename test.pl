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

% Direcciones posibles
direcciones([(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (-1, 1), (1, -1)]).

% Verificar movimiento válido
movimiento_valido(Tablero, Jugador, X, Y) :-
    dentro_del_tablero(X, Y),
    celda_vacia(Tablero, X, Y),
    captura(Tablero, Jugador, X, Y).

% Verificar si la posición está dentro del tablero
dentro_del_tablero(X, Y) :-
    integer(X), integer(Y), % Asegúrate de que X e Y sean números
    X >= 0, X < 8, Y >= 0, Y < 8.

% Verificar si una celda está vacía
celda_vacia(Tablero, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, empty).


% Verificar si una celda está ocupada por el jugador
celda_ocupada(Tablero, Jugador, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, Jugador).

% Colocar una pieza y actualizar el tablero
colocar_pieza(Tablero, Jugador, X, Y, NuevoTablero) :-
    movimiento_valido(Tablero, Jugador, X, Y),
    actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero).

% Actualizar el tablero después de colocar una pieza
actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero) :-
    actualiza_celda(Tablero, X, Y, Jugador, TableroConPieza),
    actualiza_capturas(TableroConPieza, Jugador, X, Y, NuevoTablero).

% Actualizar celdas capturadas
actualiza_capturas(Tablero, Jugador, X, Y, NuevoTablero) :-
    direcciones(Direcciones),
    actualiza_en_direcciones(Tablero, Jugador, X, Y, Direcciones, NuevoTablero).

% Actualizar capturas en todas las direcciones
actualiza_en_direcciones(Tablero, _, _, _, [], Tablero).
actualiza_en_direcciones(Tablero, Jugador, X, Y, [(DX, DY)|Resto], TableroFinal) :-
    actualiza_en_una_direccion(Tablero, Jugador, X, Y, DX, DY, TableroParcial),
    actualiza_en_direcciones(TableroParcial, Jugador, X, Y, Resto, TableroFinal).

% Actualizar capturas en una dirección específica
actualiza_en_una_direccion(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    (   pieza_oponente(Tablero, Jugador, X1, Y1),
        busca_extremo(Tablero, Jugador, X1, Y1, DX, DY)
    ->  capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero)
    ;   NuevoTablero = Tablero
    ).

% Capturar piezas en una dirección
capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    pieza_oponente(Tablero, Jugador, X1, Y1),
    actualiza_celda(Tablero, X1, Y1, Jugador, TableroParcial),
    capturar(TableroParcial, Jugador, X1, Y1, DX, DY, NuevoTablero).
capturar(Tablero, _, _, _, _, _, Tablero).

% Actualizar una celda
actualiza_celda(Tablero, X, Y, Jugador, NuevoTablero) :-
    nth0(X, Tablero, Fila, _),
    reemplazar(Y, Jugador, Fila, NuevaFila),
    reemplazar(X, NuevaFila, Tablero, NuevoTablero).

% Reemplazar un elemento en una lista
reemplazar(_, Elemento, Lista, NuevaLista) :-
    same_length(Lista, NuevaLista),
    append(Prefix, [_|Suffix], Lista),
    append(Prefix, [Elemento|Suffix], NuevaLista).

% Cambiar turno
oponente(black, white).
oponente(white, black).

% Calcular puntuación
calcular_puntuacion(Tablero) :-
    contar_piezas(Tablero, black, PuntuacionBlack),
    contar_piezas(Tablero, white, PuntuacionWhite),
    write('Puntuación final:'), nl,
    write('Black: '), write(PuntuacionBlack), nl,
    write('White: '), write(PuntuacionWhite), nl,
    (   PuntuacionBlack > PuntuacionWhite ->
        write('¡Black gana!')
    ;   PuntuacionWhite > PuntuacionBlack ->
        write('¡White gana!')
    ;   write('¡Es un empate!')
    ).

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

% Juego principal
jugar :-
    inicializar_tablero(Tablero),
    imprimir_tablero(Tablero),
    write('Comienza el juego. Jugador black empieza.'), nl,
    turno_juego(Tablero, black).

% Manejo de turnos
turno_juego(Tablero, Jugador) :-
    (   movimientos_disponibles(Tablero, Jugador) ->
        write('Turno de: '), write(Jugador), nl,
        solicitar_movimiento(Tablero, Jugador, X, Y),
        colocar_pieza(Tablero, Jugador, X, Y, NuevoTablero),
        imprimir_tablero(NuevoTablero),
        oponente(Jugador, OtroJugador),
        turno_juego(NuevoTablero, OtroJugador)
    ;   oponente(Jugador, OtroJugador),
        (   movimientos_disponibles(Tablero, OtroJugador) ->
            write('Jugador '), write(Jugador), write(' no tiene movimientos válidos. Pasando turno.'), nl,
            turno_juego(Tablero, OtroJugador)
        ;   write('Fin del juego. Calculando puntuación...'), nl,
            calcular_puntuacion(Tablero)
        )
    ).

% Solicitar movimiento
solicitar_movimiento(Tablero, Jugador, X, Y) :-
    findall((X1, Y1), movimiento_valido(Tablero, Jugador, X1, Y1), Movimientos),
    (   Movimientos \= [] ->
        write('Movimientos válidos para '), write(Jugador), write(': '), write(Movimientos), nl,
        write('Introduce las coordenadas (X e Y como números entre 0 y 7): '), nl,
        read(X),
        read(Y),
        (   integer(X), integer(Y), member((X, Y), Movimientos) ->
            true
        ;   write('Movimiento inválido. Intenta de nuevo.'), nl,
            solicitar_movimiento(Tablero, Jugador, X, Y)
        )
    ;   write('No hay movimientos válidos disponibles. Pasando turno.'), nl,
        fail
    ).
captura(Tablero, Jugador, X, Y) :-
    direcciones(Direcciones),
    member((DX, DY), Direcciones),
    busca_captura(Tablero, Jugador, X, Y, DX, DY).

busca_captura(Tablero, Jugador, X, Y, DX, DY) :-
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    pieza_oponente(Tablero, Jugador, X1, Y1),
    busca_extremo(Tablero, Jugador, X1, Y1, DX, DY).

pieza_oponente(Tablero, Jugador, X, Y) :-
    dentro_del_tablero(X, Y),
    oponente(Jugador, Oponente),
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, Oponente).

busca_extremo(Tablero, Jugador, X, Y, DX, DY) :-
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    (   celda_ocupada(Tablero, Jugador, X1, Y1)
    ->  true
    ;   pieza_oponente(Tablero, Jugador, X1, Y1),
        busca_extremo(Tablero, Jugador, X1, Y1, DX, DY)
    ).

movimientos_disponibles(Tablero, Jugador) :-
    between(0, 7, X),
    between(0, 7, Y),
    movimiento_valido(Tablero, Jugador, X, Y), !.
