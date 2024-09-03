% --------------------------------
% PARTE 1 - SOMBRERO SELECCIONADOR
% --------------------------------

casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).

sangre(harry, mestizo).
sangre(draco, pura).
sangre(hermione, impura).

sangre(neville, pura).
sangre(luna, pura).

caracteristica(harry, coraje).
caracteristica(harry, amistad).
caracteristica(harry, orgullo).
caracteristica(harry, inteligencia).
caracteristica(draco, orgullo).
caracteristica(draco, inteligencia).
caracteristica(hermione, responsabilidad).
caracteristica(hermione, orgullo).
caracteristica(hermione, inteligencia).

caracteristica(neville, responsabilidad).
caracteristica(neville, coraje).
caracteristica(neville, amistad).

caracteristica(luna, amistad).
caracteristica(luna, inteligencia).
caracteristica(luna, responsabilidad).

odiariaIr(harry, slytherin).
odiariaIr(draco, hufflepuff).

casaBusca(gryffindor, coraje).
casaBusca(slytherin, orgullo).
casaBusca(slytherin, inteligencia).
casaBusca(ravenclaw, inteligencia).
casaBusca(ravenclaw, responsabilidad).
casaBusca(hufflepuff, amistad).

mago(Mago) :-
    sangre(Mago, _).

% PUNTO 1

casaPermiteEntrar(Casa, Mago) :-
    casa(Casa),
    Casa \= slytherin,
    mago(Mago).

casaPermiteEntrar(slytherin, Mago) :-
    sangre(Mago, TipoSangre),
    TipoSangre \= impura.

% PUNTO 2

caracterApropiado(Mago, Casa) :-
    casa(Casa),
    mago(Mago),
    forall(casaBusca(Casa, Caracteristica), caracteristica(Mago, Caracteristica)).

% PUNTO 3

magoPodriaQuedar(hermione, gryffindor).
magoPodriaQuedar(Mago, Casa) :-
    caracterApropiado(Mago, Casa),
    casaPermiteEntrar(Casa, Mago),
    not(odiariaIr(Mago, Casa)).

% PUNTO 4

amistoso(Mago) :-
    caracteristica(Mago, amistad).

todosAmistosos(Magos) :-
    forall(member(Mago, Magos), amistoso(Mago)).

cadenaDeCasas([_]).
cadenaDeCasas([Mago1,Mago2|RestoMagos]) :-
    Mago1 \= Mago2,
    magoPodriaQuedar(Mago1, Casa),
    magoPodriaQuedar(Mago2, Casa),
    cadenaDeCasas([Mago2|RestoMagos]).

cadenaDeAmistades(Magos) :-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).

% --------------------------------
% PARTE 2 - LA COPA DE LAS CASAS
% --------------------------------

accion(harry, fueraDeCama).
accion(hermione, irA(tercerPiso)).
accion(hermione, irA(seccionRestrigidaBiblioteca)).
accion(harry, irA(bosque)).
accion(harry, irA(tercerPiso)).

accion(ron, buenaAccion(ganarPartidaAjedrezMagico, 50)).
accion(hermione, buenaAccion(salvarAmigos, 50)).
accion(harry, buenaAccion(ganarAVoldemort, 60)).

accion(hermione, respondio(dondeBezoar, 20, snape)).
accion(hermione, respondio(comoLevitarPluma, 25, flitwick)).

malaAccion(fueraDeCama, 50).
malaAccion(irA(bosque), 50).
malaAccion(irA(seccionRestrigidaBiblioteca), 10).
malaAccion(irA(tercerPiso), 75).

esDe(hermione, gryffindor). 
esDe(ron, gryffindor). 
esDe(harry, gryffindor). 
esDe(draco, slytherin). 
esDe(luna, ravenclaw). 

% PUNTO 1.a

alumno(Alumno) :-
    esDe(Alumno, _).

esCasa(Casa) :-
    distinct(Casa, esDe(_, Casa)).

buenAlumno(Alumno) :-
    alumno(Alumno),
    forall(accion(Alumno, Accion), not(malaAccion(Accion, _))).

% PUNTO 1.b

accionRecurrente(Accion) :-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \= Mago2.

% PUNTO 2

puntosAccion(Accion, Puntos) :-
    malaAccion(Accion, P),
    Puntos is P * -1.

puntosAccion(buenaAccion(_, Puntos), Puntos).

puntosAccion(respondio(_, Puntos, Profesor), Puntos) :-
    Profesor \= snape.

puntosAccion(respondio(_, PuntosPregunta, snape), Puntos) :-
    Puntos is PuntosPregunta / 2.

puntosAlumno(Alumno, Puntos) :-
    accion(Alumno, Accion),
    puntosAccion(Accion, Puntos).

puntajeTotalCasa(Casa, Puntaje) :-
    esCasa(Casa),
    findall(Puntos, (esDe(Alumno, Casa), puntosAlumno(Alumno, Puntos)), ListaPuntos),
    sumlist(ListaPuntos, Puntaje).
    
% PUNTO 3

casaGanadoraCopa(Casa) :-
    puntajeTotalCasa(Casa, Puntos),
    forall((puntajeTotalCasa(OtraCasa, OtrosPuntos), OtraCasa \= Casa), Puntos >= OtrosPuntos).