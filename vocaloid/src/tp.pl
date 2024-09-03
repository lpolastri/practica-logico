% --------------------------------
% PARTE 1
% --------------------------------

vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).
vocaloid(seeU, cancion(novemberRain, 5)).
vocaloid(seeU, cancion(nightFever, 5)).

% PUNTO 1

cantante(Cantante) :-
    distinct(Cantante, vocaloid(Cantante, _)).

duracion(cancion(_, Duracion), Duracion).

tiempoCancion(Cantante, Duracion) :-
    vocaloid(Cantante, Cancion),
    duracion(Cancion, Duracion).

tiempoTotalCanciones(Cantante, DuracionTotal) :-
    findall(Duracion, tiempoCancion(Cantante, Duracion), DuracionCanciones),
    sum_list(DuracionCanciones, DuracionTotal).

cantaVariasCanciones(Cantante) :-
    vocaloid(Cantante, Cancion1),
    vocaloid(Cantante, Cancion2),
    Cancion1 \= Cancion2.

cantanteNovedoso(Cantante) :-
    cantaVariasCanciones(Cantante),
    tiempoTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal < 15.

% PUNTO 2

cantanteAcelerado(Cantante) :-
    cantante(Cantante),
    not((tiempoCancion(Cantante, Duracion), Duracion > 4)).

% --------------------------------
% PARTE 2
% --------------------------------

% PUNTO 1

concierto(mikuExpo, usa, 2000, gigante(2, 6)).
concierto(magicalMirai, jpn, 3000, gigante(3, 10)).
concierto(vocalektVisions, usa, 1000, mediano(9)).
concierto(mikuFest, arg, 100, pequenio(4)).

% PUNTO 2

cantidadCanciones(Cantante, Cantidad) :-
    findall(Cancion, vocaloid(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

cumpleRequisitosConcierto(Cantante, gigante(CantidadMinimaCanciones, DuracionTotalMinima)) :-
    tiempoTotalCanciones(Cantante, DuracionTotal),
    cantidadCanciones(Cantante, CantidadCanciones),
    CantidadCanciones >= CantidadMinimaCanciones,
    DuracionTotal >= DuracionTotalMinima.

cumpleRequisitosConcierto(Cantante, mediano(DuracionTotalMaxima)) :-
    tiempoTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal =< DuracionTotalMaxima.

cumpleRequisitosConcierto(Cantante, pequenio(DuracionCancion)) :-
    tiempoCancion(Cantante, Duracion),
    Duracion >= DuracionCancion.

puedeParticipar(Cantante, Concierto) :-
    cantante(Cantante),
    concierto(Concierto, _, _, Requisitos),
    cumpleRequisitosConcierto(Cantante, Requisitos).

puedeParticipar(hatsuneMiku, Concierto) :-
    concierto(Concierto, _, _, _).

% PUNTO 3

famaConcierto(Cantante, Fama) :-
    puedeParticipar(Cantante, Concierto),
    concierto(Concierto, _, Fama, _).

famaTotal(Cantante, FamaTotal) :-
    cantante(Cantante),
    findall(Fama, famaConcierto(Cantante, Fama), ListaFama),
    sum_list(ListaFama, FamaTotal).

nivelDeFama(Cantante, NivelFama) :-
    famaTotal(Cantante, FamaTotal),
    cantidadCanciones(Cantante, CantidadCanciones),
    NivelFama is CantidadCanciones * FamaTotal.

vocaloidMasFamoso(Cantante) :-
    nivelDeFama(Cantante, NivelFama),
    forall(nivelDeFama(_, OtroNivelFama), NivelFama >= OtroNivelFama).

% PUNTO 4

conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

conocido(Cantante, Conocido) :- 
    conoce(Cantante, Conocido).

conocido(Cantante, Conocido) :- 
    conoce(Cantante, OtroCantante), 
    conocido(OtroCantante, Conocido).

unicoParticipante(Cantante, Concierto) :-
    puedeParticipar(Cantante, Concierto),
    not((conocido(Cantante, OtroCantante), puedeParticipar(OtroCantante, Concierto))).    