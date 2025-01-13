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
        write('Se leyo start, empieza el juego'), nl,
        poner_ceroS(),
        write('Se puso el cero'), nl,
        inicializar_tablero(Tablero),
        write('imprimir_tablero'), nl,
        imprimir_tablero(Tablero), nl,
        write('llamar a jugar'), nl,
        jugar(Opcion, Dificultad, Tablero)
    ;
        write(' No Se leyo start'), nl,
        sleep(1),
        write('llamar a inicio'), nl, 
        inicio()
    ).

jugar(Opcion, Dificultad, Tablero) :-
    (   
        write('leer_in'), nl, 
        leer_in(JugadorIn, X, Y),
        write('asignar_color, segun el jugador'), nl, 
        asignar_color(JugadorIn, Jugador),
        write('poner_cero en IN'), nl, 
        poner_ceroI()
    ->  
        (   
            write('Se leyo in y se puso cero'), nl,
            Opcion == 0 ->  
            write('turno_juego al humano'), nl, 
            turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad)
        ;   
            Opcion == 1, JugadorIn == 1 ->  
            write('turno_juego al humano'), nl, 
            turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad)
        ;   
            Opcion == 1, JugadorIn == 2 ->  
            write('turno_juego a la IA'), nl, 
            turno_juego_virtual(Tablero, Jugador, Opcion, Dificultad)
        )
    ;   
        write('No Se leyo in'), nl, 
        sleep(1),
        write('llamar a jugar'), nl,
        jugar(Opcion, Dificultad, Tablero)
    ).


% Manejo de turnos
turno_juego(Tablero, Jugador, X, Y, Opcion, Dificultad) :-
    (   
        movimiento_valido(Tablero, X, Y),
        write('el mov es valido'), nl,
        write('actualizando tablero'), nl
    ->  
        actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
        (   
            write('tablero actualizado'), nl,
            write('ver si quedan mov'), nl, 
            quedan_movimientos(NuevoTablero),
            write('imprimir_tablero, qedan mov'), nl,
            imprimir_tablero(NuevoTablero), nl
        ->  
            write('Se va a escribir un out'), nl,
            escribir_out(NuevoTablero, 0),
            write('llamar a jugar'), nl,
            jugar(Opcion, Dificultad, NuevoTablero)
        ;   
            write('fin_juego, no quedan mov'), nl, 
            fin_juego(NuevoTablero)
        )
        
    ;   % OUT ERROR
        write('Error, mov invalido'), nl,
        escribir_out(Tablero, 1),
        write('llamar a jugar'), nl,
        jugar(Opcion, Dificultad, Tablero)
    ).


% Manejo de turnos contra jugador virtual
turno_juego_virtual(Tablero, Jugador , Opcion, Dificultad) :-
    ( 
        Dificultad == 0 -> 
        write('jugador_facil'), nl,
        jugador_facil(Tablero, Jugador , (X, Y)),
        write('ya jugo la IA'), nl
            
    ;   
        Dificultad == 1 -> 
        write('jugador_medio'), nl,
        jugador_medio(Tablero, Jugador ,(X, Y)),
        write('ya jugo la IA'), nl
    ;   
        Dificultad == 2 -> 
        write('jugador_dificil'), nl,
        jugador_virtual(Tablero, Jugador ,(X, Y)),
        write(' ya jugo la IA'), nl
    ),

    write('actualizar_tablero'), nl,
    actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero),
    imprimir_tablero(NuevoTablero),
    write('ver si quedan_movimientos'), nl,
    (
        quedan_movimientos(NuevoTablero)  ->
        write('Se va a escribir en out, quedan mov'), nl,
        escribir_out(NuevoTablero, 0),
        write('llamar a jugar'), nl,
        jugar(Opcion, Dificultad, NuevoTablero)
    ;   
        % Alerta('No quedan movimientos disponibles.'), nl,
        write('fin_juego, no quedan mov, si no jugo la IA entonces dio falso'), nl, 
        fin_juego(NuevoTablero)
    ).

quedan_movimientos(Tablero) :-
    member(Fila, Tablero),       
    member(empty, Fila).       
    
fin_juego(Tablero):-
    write('contar_piezas'), nl,
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
    inicio().

asignar_color(Jugador, Color) :-
    (Jugador =:= 1 -> Color = black; Color = white).

