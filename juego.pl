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
        leer_start(Opcion, Dificultad)
    ->
        poner_cero(1),
        write('Se leyo start, empieza el juego'), nl,
        inicializar_tablero(Tablero),
        jugar(Opcion, Dificultad, Tablero)
    ;
        write(' No Se leyo start'), nl,
        sleep(1),
        inicio()
    ).

jugar(Opcion, Dificultad, Tablero) :-
    (   
        leer_in(Jugador, X, Y),
        poner_cero(2)
    ->  
        (   
            write('Se leyo in'), nl,
            Opcion == 1
        ->  turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad)
        ;   
            Opcion == 2, Jugador == 1
        ->  turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad)
        ;   
            Opcion == 2, Jugador == 2
        ->  turno_juego_virtual(Tablero, Jugador, Opcion, Dificultad)
        )
    ;   
        write('No Se leyo in'), nl, 
        sleep(1),
        inicio()
    ).


% Manejo de turnos
turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad) :-
    (   
        movimiento_valido(Tablero, X, Y)
    ->  
        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        (   
            quedan_movimientos(NuevoTablero)
        ->  
            escribir_out(NuevoTablero, 0),
            poner_cero(3),
            jugar(Opcion, Dificultad, NuevoTablero)
        ;   
            fin_juego(NuevoTablero)
        )
    ;   % OUT ERROR
        write('Error en el mov'), nl,
        escribir_out(NuevoTablero, 1),
        poner_cero(3)
    ).


% Manejo de turnos contra jugador virtual
turno_juego_virtual(Tablero, Jugador , Opcion, Dificultad) :-
    (  
        ( 
            Dificultad == 1 -> 
            jugador_facil(Tablero, Jugador , (X, Y))
        ;   
            Dificultad == 2 -> 
            jugador_medio(Tablero, Jugador ,(X, Y))
        ;   
            Dificultad == 3 -> 
            jugador_virtual(Tablero, Jugador ,(X, Y))
        ),

        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        quedan_movimientos(NuevoTablero),
        escribir_out(NuevoTablero, 0),
        poner_cero(0),
        jugar(Opcion, Dificultad, NuevoTablero)
    ;   
        % Alerta('No quedan movimientos disponibles.'), nl,
        write('Se acabo el juego'), nl,
        fin_juego(Tablero)
    ).

quedan_movimientos(Tablero) :-
    member(Fila, Tablero),       
    member(empty, Fila).       
    
fin_juego(Tablero):-

    contar_piezas(Tablero, black, PuntuacionBlack),
    contar_piezas(Tablero, white, PuntuacionWhite),

    escribir_out(Tablero, 0),
    (   
        PuntuacionBlack > PuntuacionWhite ->
        escribir_end(1, PuntuacionBlack)
    ;   
        PuntuacionWhite > PuntuacionBlack ->
        escribir_end(2, PuntuacionWhite)
    ;   
        escribir_end(3, PuntuacionBlack)
    ),
    poner_cero(3).



