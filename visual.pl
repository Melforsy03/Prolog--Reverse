:- ensure_loaded('tablero.pl').
:- ensure_loaded('juego.pl').

leer_start(Opcion, Dificultad):- 
    open('ireverse/start.txt', read, StreamIn),         
    read_line_to_string(StreamIn, Line),      
    close(StreamIn),

    sub_string(Line, 0, 1, _, "1"), 
    sub_string(Line, 1, 1, _, Opcion_txt),         
    sub_string(Line, 2, 1, _, Dificultad_txt),  
       
    number_string(Opcion, Opcion_txt),                  
    number_string(Dificultad, Dificultad_txt).

leer_in(Jugador, X, Y) :-
    open('ireverse/in.txt', read, StreamIn),         
    read_line_to_string(StreamIn, Line),      
    close(StreamIn),     

    (
        sub_string(Line, 0, 1, _, "1")
    ->
        sub_string(Line, 1, 1, _, Jugador_txt),
        sub_string(Line, 2, 1, _, X_txt),         
        sub_string(Line, 3, 1, _, Y_txt),  
    
        number_string(Jugador, Jugador_txt),  
        number_string(X, X_txt),                  
        number_string(Y, Y_txt)
    ;
        sub_string(Line, 0, 1, _, "2")
    ->
        poner_ceroI(),
        inicio()
    ).            

escribir_out(Matriz, Error) :-
    write('transformar la matriz'), nl,
    transformar_tablero(Matriz, Matriz_Out),
    imprimir_tablero(Matriz_Out),

    (   catch(open('ireverse/out.txt', write, Stream), 
               E, 
               (   
                    write('Error al abrir el archivo: '), 
                    write(E), nl, 
                    fail
                ))  
    ->  % Si la apertura fue exitosa
        (   Error == 0
        ->  write(Stream, '1')
        ;   
            write(Stream, '2')
        ),
        escribir_matriz(Stream, Matriz_Out),
        close(Stream)
    ;   % Si no se pudo abrir el archivo
        write('No se pudo abrir el archivo.'), nl
    ).


escribir_matriz(_, []) :- !.  % Cuando no hay más filas, termina.
escribir_matriz(Stream, [Fila|Resto]) :-
    escribir_fila(Stream, Fila),  % Escribe la fila sin salto de línea.
    escribir_matriz(Stream, Resto).  % Continúa con el resto de la matriz.

escribir_fila(_, []) :- !.  % Cuando no hay más elementos en la fila, termina.
escribir_fila(Stream, [H|T]) :-
    write(Stream, H),  % Escribe el número sin espacio ni salto.
    escribir_fila(Stream, T).

% Predicado principal
transformar_tablero(MatrizOriginal, MatrizTransformada) :-
    reemplazar_valores(MatrizOriginal, MatrizTransformada).

% Reemplaza valores en una lista de listas (matriz)
reemplazar_valores([], []).
reemplazar_valores([Fila | Resto], [FilaReemplazada | RestoReemplazado]) :-
    reemplazar_fila(Fila, FilaReemplazada),    % Reemplaza los valores en la fila actual
    reemplazar_valores(Resto, RestoReemplazado). % Llama recursivamente al resto de la matriz

% Reemplaza valores en una fila
reemplazar_fila([], []). 
reemplazar_fila([empty | Resto], [0 | RestoReemplazado]) :- 
    reemplazar_fila(Resto, RestoReemplazado). % Reemplaza empty por 0
reemplazar_fila([black | Resto], [1 | RestoReemplazado]) :- 
    reemplazar_fila(Resto, RestoReemplazado). % Reemplaza black por 1
reemplazar_fila([white | Resto], [2 | RestoReemplazado]) :- 
    reemplazar_fila(Resto, RestoReemplazado). % Reemplaza white por 2


escribir_end(Jugador, Puntuacion) :-
    open('ireverse/end.txt', write, Stream),
    write(Stream, '1'),  % Comienza con un 1 para indicar que es una respuesta válida
    write(Stream, Jugador),
    write(Stream, Puntuacion),
    escribir_matriz(Stream, Matriz),
    close(Stream).

poner_ceroS() :-
    open('ireverse/start.txt', write, StreamOut),       
    write(StreamOut, '0'),                    
    close(StreamOut).

poner_ceroI() :-
    open('ireverse/in.txt', write, StreamOut),       
    write(StreamOut, '0'),                    
    close(StreamOut).
