:- ensure_loaded('jugador.pl').
:-ensure_loaded('func_aux.pl').
% Lógica del jugador virtual medio (elige el movimiento que maximiza la ganancia inmediata)
jugador_medio(Tablero, Jugador, (X, Y)) :-
    movimientos_validos(Tablero, Jugador, Movimientos),
    findall((X, Y, Ganancia), (member((X, Y), Movimientos), calcular_ganancia(Tablero, Jugador, X, Y, Ganancia)), MovimientosConGanancia),
    max_ganancia(MovimientosConGanancia, (X, Y, _)).


% Encuentra el movimiento con la máxima ganancia
max_ganancia([Movimiento], Movimiento).
max_ganancia([(X1, Y1, G1), (X2, Y2, G2) | Movimientos], MaxMovimiento) :-
    (   G1 >= G2 ->
        max_ganancia([(X1, Y1, G1) | Movimientos], MaxMovimiento)
    ;   max_ganancia([(X2, Y2, G2) | Movimientos], MaxMovimiento)
    ).


% Calcula la ganancia de un movimiento (número de fichas capturadas)
calcular_ganancia(Tablero, Jugador, X, Y, Ganancia) :-
    findall((DX, DY), direccion(DX, DY), Direcciones),
    calcular_ganancia_direcciones(Tablero, Jugador, X, Y, Direcciones, 0, Ganancia).

calcular_ganancia_direcciones(_, _, _, _, [], Ganancia, Ganancia).
calcular_ganancia_direcciones(Tablero, Jugador, X, Y, [(DX, DY) | Direcciones], GananciaAcumulada, Ganancia) :-
    calcular_ganancia_direccion(Tablero, Jugador, X, Y, DX, DY, GananciaDireccion),
    NuevaGananciaAcumulada is GananciaAcumulada + GananciaDireccion,
    calcular_ganancia_direcciones(Tablero, Jugador, X, Y, Direcciones, NuevaGananciaAcumulada, Ganancia).

% Calcula la ganancia en una dirección específica
calcular_ganancia_direccion(Tablero, Jugador, X, Y, DX, DY, Ganancia) :-
    oponente(Jugador, Oponente),
    contar_fichas_en_direccion(Tablero, X, Y, DX, DY, Oponente, 0, Ganancia).

contar_fichas_en_direccion(Tablero, X, Y, DX, DY, Oponente, Contador, Ganancia) :-
    NX is X + DX,
    NY is Y + DY,
    nth0(NX, Tablero, Fila),
    nth0(NY, Fila, Celda),
    (   Celda == Oponente ->
        NuevoContador is Contador + 1,
        contar_fichas_en_direccion(Tablero, NX, NY, DX, DY, Oponente, NuevoContador, Ganancia)
    ;   Celda == Jugador ->
        Ganancia = Contador
    ;   Ganancia = 0
    ).

% Direcciones posibles en el tablero
direccion(-1, -1).
direccion(-1, 0).
direccion(-1, 1).
direccion(0, -1).
direccion(0, 1).
direccion(1, -1).
direccion(1, 0).
direccion(1, 1).

% Encuentra el oponente del jugador
oponente(black, white).
oponente(white, black).