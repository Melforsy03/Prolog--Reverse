direcciones([(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (-1, 1), (1, -1)]).

% Verificar movimiento válido

es_movimiento_valido(Tablero, Jugador, X, Y) :-
    movimiento_valido(Tablero, X, Y),
    direcciones(Direcciones),
    puede_capturar(Tablero, Jugador, X, Y, Direcciones).

% Determina si un movimiento es válido
movimiento_valido(Tablero, X, Y) :-
    dentro_del_tablero(X, Y),
    celda_vacia(Tablero, X, Y).

% Verifica si al menos una dirección captura fichas
puede_capturar(Tablero, Jugador, X, Y, [(DX, DY)|_]) :-
    puede_capturar_en_direccion(Tablero, Jugador, X, Y, DX, DY).
puede_capturar(Tablero, Jugador, X, Y, [_|Resto]) :-
    puede_capturar(Tablero, Jugador, X, Y, Resto).

puede_capturar_en_direccion(Tablero, Jugador, X, Y, DX, DY) :-
    X1 is X + DX,
    Y1 is Y + DY,
    pieza_oponente(Tablero, Jugador, X1, Y1),
    buscar_fin_captura(Tablero, Jugador, X1, Y1, DX, DY).

buscar_fin_captura(Tablero, Jugador, X, Y, DX, DY) :-
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    (   celda_ocupada(Tablero, Jugador, X1, Y1)
    ;   pieza_oponente(Tablero, Jugador, X1, Y1),
        buscar_fin_captura(Tablero, Jugador, X1, Y1, DX, DY)
    ).

% Verificar si una celda está ocupada por el oponente
pieza_oponente(Tablero, Jugador, X, Y) :-
    oponente(Jugador, Oponente),
    celda_ocupada(Tablero, Oponente, X, Y).

% Verificar si una celda está ocupada por el jugador actual
celda_ocupada(Tablero, Jugador, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, Jugador).

dentro_del_tablero(X, Y) :-
    integer(X), integer(Y), % Asegúrate de que X e Y sean números
    X >= 0, X < 8, Y >= 0, Y < 8.

celda_vacia(Tablero, X, Y) :-
    nth0(X, Tablero, Fila),
    nth0(Y, Fila, empty).

captura(Tablero, Jugador, X, Y,[], NuevoTablero).
captura(Tablero, Jugador, X, Y,[(DX, DY)|Resto], NuevoTablero):-
    capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero),
    captura(Tablero, Jugador, X, Y, Resto, NuevoTablero).

capturar(Tablero, Jugador, X, Y, DX, DY, NuevoTablero) :-
    X1 is X + DX,
    Y1 is Y + DY,
    dentro_del_tablero(X1, Y1),
    pieza_oponente(Tablero, Jugador, X1, Y1),
    actualiza_celda(Tablero, X1, Y1, Jugador, TableroParcial),
    capturar(TableroParcial, Jugador, X1, Y1, DX, DY, NuevoTablero).
capturar(Tablero, _, _, _, _, _, Tablero).


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


% Encuentra el elemento máximo basado en el primer componente del par.
max_member(Valor-Movimiento, Pares) :-
    max_member(Pares, Valor-Movimiento).

max_member([Valor-Movimiento], Valor-Movimiento). 
max_member([Valor1-Mov1, Valor2-Mov2 | Resto], Maximo) :-
    (Valor1 >= Valor2 ->
        max_member([Valor1-Mov1 | Resto], Maximo)
    ;
        max_member([Valor2-Mov2 | Resto], Maximo)
    ).

% Obtiene la lista de todos los movimientos válidos para un jugador
movimientos_validosH(Tablero, Jugador, Movimientos) :-
    encontrar_movimientos(Tablero, Jugador, 0, Movimientos).

% Recorre el tablero y encuentra todos los movimientos válidos
encontrar_movimientos(Tablero, Jugador, FilaActual, Movimientos) :-
    length(Tablero, N), % Obtén el tamaño del tablero (asumimos cuadrado)
    (FilaActual < N ->
        nth0(FilaActual, Tablero, Fila), % Obtiene la fila actual
        encontrar_en_fila(Fila, Tablero, Jugador, FilaActual, 0, MovimientosFila),
        FilaSiguiente is FilaActual + 1,
        encontrar_movimientos(Tablero, Jugador, FilaSiguiente, MovimientosResto),
        append(MovimientosFila, MovimientosResto, Movimientos)
    ; 
        Movimientos = [] % Cuando no quedan filas por procesar
    ).

% Recorre una fila específica para encontrar movimientos válidos
encontrar_en_fila([], _, _, _, _, []). % Caso base: fila vacía
encontrar_en_fila([Celda|Resto], Tablero, Jugador, Fila, Columna, Movimientos) :-
    (   
        es_movimiento_valido(Tablero, Jugador, Fila, Columna) ->
        Movimientos = [(Fila, Columna)|MovimientosResto]
    ; 
        Movimientos = MovimientosResto
    ),
    ColumnaSiguiente is Columna + 1,
    encontrar_en_fila(Resto, Tablero, Jugador, Fila, ColumnaSiguiente, MovimientosResto).
