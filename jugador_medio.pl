:- ensure_loaded('jugador.pl').
:- ensure_loaded('func_aux.pl').
:- ensure_loaded('tablero.pl').

% Estrategia del jugador virtual
jugador_medio(Tablero, Jugador, MovimientoSeleccionado) :-
    movimientos_validos(Tablero, Jugador, Movimientos),
    maplist(evaluar_movimiento(Tablero, Jugador), Movimientos, Puntuaciones),
    seleccionar_mejores_puntuaciones(Puntuaciones, MejoresPuntuaciones),
    min_member(_-MovimientoSeleccionado, MejoresPuntuaciones).


% Evalúa cada movimiento
evaluar_movimiento(Tablero, Jugador, Movimiento, Puntaje-Movimiento) :-
    simular_movimiento(Tablero, Movimiento, Jugador, NuevoTablero),
    calcular_puntaje(NuevoTablero, Jugador, Puntaje).

% Simula el tablero después de un movimiento
simular_movimiento(Tablero, (X, Y), Jugador, NuevoTablero) :-
    actualiza_tablero(Tablero, Jugador, X, Y, NuevoTablero).

% Calcula el puntaje basado en la diferencia de piezas
calcular_puntaje(Tablero, Jugador, Puntaje) :-
    contar_piezas(Tablero, Jugador, PiezasJugador),
    oponente(Jugador, OtroJugador),
    contar_piezas(Tablero, OtroJugador, PiezasOponente),
    Puntaje is PiezasJugador - PiezasOponente.

% Selecciona las mejores puntuaciones (las más altas)
seleccionar_mejores_puntuaciones(Puntuaciones, MejoresPuntuaciones) :-
    maplist(arg(1), Puntuaciones, Puntajes),
    max_list(Puntajes, MaxPuntaje),
    findall(Puntaje-Movimiento, (member(Puntaje-Movimiento, Puntuaciones), Puntaje =:= MaxPuntaje), MejoresPuntuaciones).

% Encuentra el oponente del jugador
oponente(black, white).
oponente(white, black).