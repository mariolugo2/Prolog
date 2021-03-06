﻿
:- dynamic conocido/1.


conocimiento('FELIZ',
['es fin de semana', 'tienes dinero']).
conocimiento('AVERGONZADO',
['no tienes dinero','es fin de semana']).
conocimiento('TRISTE',
['tienes que ir ala escuela','y no es fin de semana']).
conocimiento('ALEGRE',
['tienes algun examen','estudiaste','pasate la materia de prolog']).
conocimiento('PREOCUPADO',
['hay fiesta hoy', 'no estudiaste para el examen','reprobaste materias']).



consulta:-
 haz_preguntas(X),
 escribe_estado_animo(X),
 ofrece_explicacion_animo(X),
 limpia.

consulta:-
 write('No hay suficiente conocimiento para saber tu estado de animo.'),
 clean_scratchpad.

haz_preguntas(Animo):-
 obten_hipotesis_y_Preguntas(Animo, ListaDePreguntas),
 prueba_presencia_de(Animo, ListaDePreguntas).

obten_hipotesis_y_Preguntas(Animo, ListaDePreguntas):-
 conocimiento(Animo, ListaDePreguntas).

prueba_presencia_de(Animo, []).
prueba_presencia_de(Animo, [Head | Tail]):- prueba_verdad_de(Animo, Head),
 prueba_presencia_de(Animo, Tail).

prueba_verdad_de(Animo, Pregunta):- conocido(Pregunta).

prueba_verdad_de(Animo, Pregunta):- not(conocido(is_false(Pregunta))),
 pregunta_sobre(Animo, Pregunta, Reply), Reply = si.

pregunta_sobre(Animo, Pregunta, Reply):- write(' '),
 write(Pregunta), write('? '),
 read(Respuesta), process(Animo, Pregunta, Respuesta, Reply).

process(Animo, Pregunta, si, si):- asserta(conocido(Pregunta)).

process(Animo, Pregunta, no, no):- asserta(conocido(is_false(Pregunta))).

process(Animo, Pregunta, porque, Reply):- nl,
 write('Estoy investigando tu estado de animo siguiente: '),
 write(Animo), write('.'), nl, write('Para esto necesito saber si '),
 write(Pregunta), write('.'), nl, pregunta_sobre(Animo, Pregunta, Reply).

process(Animo, Pregunta, Respuesta, Reply):- Respuesta \== no,
 Respuesta \== si, Respuesta \== porque, nl,
 write('Debes contestar si, no o porque.'), nl,
 pregunta_sobre(Animo, Pregunta, Reply).

escribe_estado_animo(Animo):- write('Tu estado de animo es: '),
 write(Animo), write('.'), nl.

ofrece_explicacion_animo(Animo):-
pregunta_si_necesita_explicacion(Respuesta),
 actua_consecuentemente(Animo, Respuesta).

pregunta_si_necesita_explicacion(Respuesta):-
 write('Quieres saber porque tu estado de animo? '),
 read(RespuestaUsuario),
 asegura_respuesta_si_o_no(RespuestaUsuario, Respuesta).


asegura_respuesta_si_o_no(si, si).

asegura_respuesta_si_o_no(no, no).

asegura_respuesta_si_o_no(_, Respuesta):- write('Debes contestar si o no.'),
 pregunta_si_necesita_explicacion(Respuesta).

actua_consecuentemente(Animo, no).

actua_consecuentemente(Animo, si):- conocimiento(Animo, ListaDePreguntas),
 write('Tu estado de animo es porque : '), nl,
 escribe_lista_de_Preguntas(ListaDePreguntas).

escribe_lista_de_Preguntas([]).

escribe_lista_de_Preguntas([Head | Tail]):-
 write(Head), nl, escribe_lista_de_Preguntas(Tail).
limpia:- retract(conocido(X)), fail.

limpia.

conocido(_):- fail.

not(X):- X,!,fail.
not(_).
