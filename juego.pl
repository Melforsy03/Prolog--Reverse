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
    repeat,
    write('Introduce las coordenadas (X e Y como números entre 0 y 7): '), nl,
    read_line_to_string(user_input, InputX),
    number_string(X, InputX),
    read_line_to_string(user_input, InputY),
    number_string(Y, InputY),
    (   
        movimiento_valido(Tablero, X, Y) ->  % Valida si (X, Y) es un movimiento válido
            !
        ;   
            write(''), nl,
            fail
    ;   
        write('Movimiento inválido. Intenta de nuevo.'), nl,
        fail
    ).

quedan_movimientos(Tablero) :-
    member(Fila, Tablero),       
    member(empty, Fila).       
    
fin_juego(Tablero):-
    write('Fin del juego. Calculando puntuación...'), nl,

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



