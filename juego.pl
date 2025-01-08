:- ensure_loaded('tablero.pl').
:- ensure_loaded('func_aux.pl').
:- ensure_loaded('jugador.pl').
:- ensure_loaded('visual.pl').
:- ensure_loaded('jugador_virtual.pl').
:- ensure_loaded('jugador_facil.pl').
:- ensure_loaded('jugador_medio.pl').

% Juego principal
inicio :-
    (
        leer_start(Opcion, Dificultad),
        inicializar_tablero(Tablero),
        jugar(Opcion, Dificultad, Tablero).
    ;
        sleep(1),
        inicio
    ).

jugar(Opcion, Dificultad, Tablero) :-
    (
        leer_in(Jugador, X, Y),
        (   
            Opcion == 1 -> turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad)
        ;   
            Opcion == 2, Jugador == 1 -> turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad)
        ;
            Opcion == 2, Jugador == 2 -> turno_juego_virtual(Tablero, Jugador, Opcion, Dificultad)
        )
    ;
        sleep(1),
        inicio
    ).

% Manejo de turnos
turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad) :-
    (   
        movimiento_valido(Tablero, X, Y),
        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        quedan_movimientos(NuevoTablero),
        escribir_out(NuevoTablero),
        jugar(Opcion, Dificultad, NuevoTablero),
       
    ;   
        % Alerta ('No quedan movimientos disponibles.'), nl,
        fin_juego(Tablero)
    ).

% Manejo de turnos contra jugador virtual
turno_juego_virtual(Tablero, Jugador , Opcion, Dificultad) :-
    (  
        ( 
            Dificultad == 1 -> 
            jugador_facil(Tablero, Jugador , (X, Y)),
        ;   
            Dificultad == 2 -> 
            jugador_medio(Tablero, Jugador ,(X, Y)),
        ;   
            Dificultad == 3 -> 
            jugador_virtual(Tablero, Jugador ,(X, Y)),
        ),

        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        quedan_movimientos(NuevoTablero),
        escribir_out(NuevoTablero),
        jugar(Opcion, Dificultad, NuevoTablero),
    ;   
        % Alerta('No quedan movimientos disponibles.'), nl,
        fin_juego(Tablero)
    ).

quedan_movimientos(Tablero) :-
    member(Fila, Tablero),       
    member(empty, Fila).       
    
fin_juego(Tablero):-

    contar_piezas(Tablero, black, PuntuacionBlack),
    contar_piezas(Tablero, white, PuntuacionWhite),

    escribir_out(Tablero),
    (   
        PuntuacionBlack > PuntuacionWhite ->
        escribir_end(1, PuntuacionBlack)
    ;   
        PuntuacionWhite > PuntuacionBlack ->
        escribir_end(2, PuntuacionWhite)
    ;   
        escribir_end(3, PuntuacionBlack)
    ).



