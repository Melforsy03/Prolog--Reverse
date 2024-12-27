:- ensure_loaded('tablero.pl').
:- ensure_loaded('func_aux.pl').


% Juego principal
jugar :-
    inicializar_tablero(Tablero),
    imprimir_tablero(Tablero),
    write('Comienza el juego. Jugador black empieza.'), nl,
    turno_juego(Tablero, black).

% Manejo de turnos
turno_juego(Tablero, Jugador) :-
    (   
        write('Turno de: '), write(Jugador), nl,
        solicitar_movimiento(Tablero, Jugador, X, Y),
        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        imprimir_tablero(NuevoTablero),

        oponente(Jugador, OtroJugador),
        quedan_movimientos(NuevoTablero),
        turno_juego(NuevoTablero, OtroJugador)
    ;   
        write('No quedan movimientos disponibles.'), nl,
        fin_juego(Tablero)
    ).

% Cambiar turno
oponente(black, white).
oponente(white, black).

solicitar_movimiento(Tablero, Jugador, X, Y) :-
    write('Introduce las coordenadas (X e Y como números entre 0 y 7): '), nl,
    read(X),  % coordenada X ingresada por el jugador
    read(Y),  % coordenada Y ingresada por el jugador
    (   
        movimiento_valido(Tablero, X, Y) ->  % Valida si (X, Y) es un movimiento válido
        true
    ;   
        write('Movimiento inválido. Intenta de nuevo.'), nl,
        solicitar_movimiento(Tablero, Jugador, X, Y)  % Pide nuevamente la entrada si es inválida
    ).

quedan_movimientos(Tablero) :-
    member(Fila, Tablero),       
    member(empty, Fila).       
    
fin_juego(Tablero):-
    write('Fin del juego. Calculando puntuación...'), nl,
    imprimir_tablero(Tablero),

    contar_piezas(Tablero, black, PuntuacionBlack),
    contar_piezas(Tablero, white, PuntuacionWhite),
    write('Puntuación final:'), nl,
    write('Black: '), write(PuntuacionBlack), nl,
    write('White: '), write(PuntuacionWhite), nl,
    (   
        PuntuacionBlack > PuntuacionWhite ->
        write('¡Black gana!')
    ;   
        PuntuacionWhite > PuntuacionBlack ->
        write('¡White gana!')
    ;   
        write('¡Es un empate!')
    ).



