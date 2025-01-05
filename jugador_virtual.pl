:- ensure_loaded('func_aux.pl').
:- ensure_loaded('tablero.pl').
:- ensure_loaded('jugador.pl').

% Estrategia del jugador virtual
jugador_virtual(Tablero, Jugador, MovimientoSeleccionado) :-
    movimientos_validos(Tablero, Jugador, Movimientos),
    maplist(evaluar_movimiento(Tablero, Jugador), Movimientos, Puntuaciones),
    max_member(_-MovimientoSeleccionado, Puntuaciones).

% Encuentra movimientos válidos (celdas vacías)
movimientos_validos(Tablero, Jugador, Movimientos) :-
    findall((X, Y), (nth0(X, Tablero, Fila), nth0(Y, Fila, empty)), Movimientos).

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

% Bonificación por ocupar esquinas
ajustar_por_esquinas((X, Y), Bonus) :-
    (   esquina(X, Y) -> Bonus = 100 ; Bonus = 0).

esquina(0, 0).
esquina(0, 7).
esquina(7, 0).
esquina(7, 7).

% Penalización por bordes peligrosos inmediatos a esquinas
ajustar_por_bordes_peligrosos((X, Y), Penalizacion) :-
    (   borde_peligroso(X, Y) -> Penalizacion = 50 ; Penalizacion = 0).

borde_peligroso(0, 1).
borde_peligroso(1, 0).
borde_peligroso(1, 1).
borde_peligroso(0, 6).
borde_peligroso(1, 6).
borde_peligroso(1, 7).
borde_peligroso(6, 0).
borde_peligroso(6, 1).
borde_peligroso(7, 1).
borde_peligroso(6, 6).
borde_peligroso(6, 7).
borde_peligroso(7, 6).
