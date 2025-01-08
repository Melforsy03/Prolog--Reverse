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

    sub_string(Line, 0, 1, _, "1"),   
    sub_string(Line, 1, 1, _, Jugador_txt),
    sub_string(Line, 2, 1, _, X_txt),         
    sub_string(Line, 3, 1, _, Y_txt),  
    
    number_string(Jugador, Jugador_txt),  
    number_string(X, X_txt),                  
    number_string(Y, Y_txt),   
                   
    open('ireverse/in.txt', read, StreamIn),       
    write(StreamOut, '0'),                    
    close(StreamOut).            

escribir_out(Matriz, Error) :-
    open('ireverse/out.txt', read, StreamIn),
    write(Stream, '1 '),  % Comienza con un 1 para indicar que es una respuesta válida
    write(Stream, Error),
    escribir_matriz(Stream, Matriz),
    close(Stream).

escribir_matriz(_, []) :- nl.  % Cuando se haya procesado toda la matriz, termina con un salto de línea.
escribir_matriz(Stream, [H|T]) :-
    convertir(H, X),
    write(Stream, X),
    escribir_matriz(Stream, T).

convertir(H, X) :-
    ( 
        H == empty -> 
        X is 0
    ;   
        H == black -> 
        X is 1
    ;   
        H == white -> 
        X is 2
    ).

escribir_end(Jugador, Puntuacion) :-
    open('ireverse/end.txt', read, StreamIn),
    write(Stream, '1 '),  % Comienza con un 1 para indicar que es una respuesta válida
    write(Stream, Jugador),
    write(Stream, Puntuacion),
    escribir_matriz(Stream, Matriz),
    close(Stream).

        
poner_cero(Tipo) :-
( 
    Tipo == 1 -> 
    open('ireverse/start.txt', write, StreamOut),       
    write(StreamOut, '0'),                    
    close(StreamOut)
;   
    Tipo == 2 -> 
    open('ireverse/in.txt', write, StreamIn),       
    write(StreamOut, '0'),                    
    close(StreamOut)
;   
    Tipo == 3 -> 
    open('ireverse/out.txt', write, StreamIn),       
    write(StreamOut, '0'),                    
    close(StreamOut)
;
    Tipo == 4 -> 
    open('ireverse/end.txt', write, StreamIn),       
    write(StreamOut, '0'),                    
    close(StreamOut)
).
    