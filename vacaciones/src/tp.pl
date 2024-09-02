% --------------------------------
% PUNTO 1
% --------------------------------

vacaciones(dodain, pehuenia).
vacaciones(dodain, sanMartin).
vacaciones(dodain, esquel).
vacaciones(dodain, sarmiento).
vacaciones(dodain, camarones).
vacaciones(dodain, playasDoradas).

vacaciones(alf, bariloche).
vacaciones(alf, sanMartin).
vacaciones(alf, elBolson).

vacaciones(nico, marDelPlata).

vacaciones(vale, calafate).
vacaciones(vale, elBolson).

vacaciones(martu, Lugar) :-
    vacaciones(nico, Lugar).

vacaciones(martu, Lugar) :-
    vacaciones(alf, Lugar).

/* 
El no definir los casos de Carlos, y particularmente el de Juan, se debe a que prolog es un lenguaje
de universo cerrado, por lo que no hace falta definir aquello que se sabe que es falso, y directamente
no puede definirse aquello que no sabe. 
*/

% --------------------------------
% PUNTO 2
% --------------------------------

persona(Persona) :-
    distinct(Persona, vacaciones(Persona, _)).

atracciones(esquel, parqueNacional(losArceles)).
atracciones(esquel, excursion(trochita)).
atracciones(esquel, excursion(trevelin)).

atracciones(pehuenia, cerro(bateaMahuida, 2000)).
atracciones(pehuenia, cuerpoAgua(moquehue, puedePescar, 14)).
atracciones(pehuenia, cuerpoAgua(alumine, puedePescar, 19)).

atracciones(marDelPlata, playa(4)).

atraccionCopada(cerro(_, Altura)) :-
    Altura > 2000.

atraccionCopada(cuerpoAgua(_, puedePescar, _)).

atraccionCopada(cuerpoAgua(_, _, Temperatura)) :-
    Temperatura > 20.

atraccionCopada(excursion(Nombre)) :-
    atom_length(Nombre, Longitud),
    Longitud > 7.    

atraccionCopada(playa(DiferenciaMareas)) :-
    DiferenciaMareas < 5.

atraccionCopada(parqueNacional(_)).

vacacionesCopadas(Persona) :-
    persona(Persona),
    forall(vacaciones(Persona, Lugar), (atracciones(Lugar, Atraccion), atraccionCopada(Atraccion))).

% --------------------------------
% PUNTO 3
% --------------------------------

noSeCruzan(Persona1, Persona2) :-
    persona(Persona1),
    persona(Persona2),
    Persona1 \= Persona2,
    forall(vacaciones(Persona1, Lugar), not(vacaciones(Persona2, Lugar))).

% --------------------------------
% PUNTO 4
% --------------------------------

costoVida(sarmiento, 100).
costoVida(esquel, 150).
costoVida(pehuenia, 180).
costoVida(sanMartin, 150).
costoVida(camarones, 135).
costoVida(playasDoradas, 170).
costoVida(bariloche, 140).
costoVida(calafate, 240).
costoVida(elBolson, 145).
costoVida(marDelPlata, 140).

destinoGasolero(Lugar) :-
    costoVida(Lugar, Costo),
    Costo < 160.

vacacionesGasoleras(Persona) :-
    persona(Persona),
    forall(vacaciones(Persona, Lugar), destinoGasolero(Lugar)).

% --------------------------------
% PUNTO 5
% --------------------------------

itinerariosPosibles(Persona, Itinerario) :-
    persona(Persona),
    findall(Lugar, vacaciones(Persona, Lugar), ListaLugares),
    permutation(ListaLugares, Itinerario).