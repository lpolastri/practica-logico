personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).

pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

caracteristicas(vincent, [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules, [tieneCabeza, muchoPelo]).
caracteristicas(marvin, [negro]).

% --------------------------------
% PUNTO 1
% --------------------------------

esPeligroso(Personaje) :-
    personaje(Personaje, mafioso(maton)).
esPeligroso(Personaje) :-
    personaje(Personaje, ladron(Roba)),
    member(licorerias, Roba).
esPeligroso(Personaje) :-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

% --------------------------------
% PUNTO 2
% --------------------------------

seRelacionan(Personaje, OtroPersonaje) :-
    pareja(Personaje, OtroPersonaje).
seRelacionan(Personaje, OtroPersonaje) :-
    amigo(Personaje, OtroPersonaje).

duoTemible(Personaje, OtroPersonaje) :-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje),
    seRelacionan(Personaje, OtroPersonaje).

% --------------------------------
% PUNTO 3
% --------------------------------

estaEnProblemas(Personaje) :-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    encargo(Jefe, Personaje, cuidar(OtroPersonaje)),
    pareja(Jefe, OtroPersonaje).
estaEnProblemas(Personaje) :-
    encargo(_, Personaje, buscar(OtroPersonaje, _)),
    personaje(OtroPersonaje, boxeador).
estaEnProblemas(butch).

% --------------------------------
% PUNTO 4
% --------------------------------

tieneCerca(Personaje, OtroPersonaje) :-
    amigo(Personaje, OtroPersonaje).
tieneCerca(Personaje, OtroPersonaje) :-
    trabajaPara(Personaje, OtroPersonaje).

sanCayetano(Personaje) :-
    distinct(Personaje, tieneCerca(Personaje, _)),
    forall(tieneCerca(Personaje, OtroPersonaje), encargo(Personaje, OtroPersonaje, _)).

% --------------------------------
% PUNTO 5
% --------------------------------

cantidadEncargos(Personaje, Cantidad) :-
    findall(Tarea, encargo(_, Personaje, Tarea), ListaTareas),
    length(ListaTareas, Cantidad).

tieneMasEncargos(Personaje, OtroPersonaje) :-
    cantidadEncargos(Personaje, Cantidad),
    cantidadEncargos(OtroPersonaje, OtraCantidad),
    Cantidad > OtraCantidad.

masAtareado(Personaje) :-
    distinct(Personaje, encargo(_, Personaje, _)),
    forall((encargo(_, OtroPersonaje, _), OtroPersonaje \= Personaje), tieneMasEncargos(Personaje, OtroPersonaje)).

% --------------------------------
% PUNTO 6
% --------------------------------

nivelRespeto(actriz(Peliculas), Nivel) :-
    length(Peliculas, CantidadPelis),
    Nivel is CantidadPelis / 10.

nivelRespeto(mafioso(capo), 20).
nivelRespeto(mafioso(resuelveProblemas), 10).
nivelRespeto(mafioso(maton), 1).

dignoDeRespeto(Personaje) :-
    personaje(Personaje, Actividad),
    nivelRespeto(Actividad, Nivel),
    Nivel > 9.

personajesRespetables(ListaPersonajes) :-
    findall(Personaje, dignoDeRespeto(Personaje), ListaPersonajes).

% --------------------------------
% PUNTO 7
% --------------------------------

interactua(Personaje, cuidar(Personaje)).
interactua(Personaje, ayudar(Personaje)).
interactua(Personaje, buscar(Personaje, _)).

interactuaCon(Personaje, Tarea) :-
    interactua(Personaje, Tarea).
interactuaCon(OtroPersonaje, Tarea) :-
    interactua(Personaje, Tarea),
    amigo(OtroPersonaje, Personaje).

hartoDe(Personaje, OtroPersonaje) :-
    encargo(_, Personaje, Tarea),
    interactuaCon(OtroPersonaje, Tarea),
    forall(encargo(_, Personaje, OtraTarea), interactuaCon(OtroPersonaje, OtraTarea)).

% --------------------------------
% PUNTO 8
% --------------------------------

duoDiferenciable(Personaje, OtroPersonaje) :-
    seRelacionan(Personaje, OtroPersonaje),
    caracteristicas(Personaje, Caracteristicas),
    caracteristicas(OtroPersonaje, OtrasCaracteristicas),
    member(Caracteristica, Caracteristicas),
    not(member(Caracteristica, OtrasCaracteristicas)).
