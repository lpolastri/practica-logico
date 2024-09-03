% --------------------------------
% PUNTO 1
% --------------------------------

turno(dodain, lunes, 9, 15).
turno(dodain, miercoles, 9, 15).
turno(dodain, viernes, 9, 15).

turno(lucas, martes, 10, 20).

turno(juanC, sabado, 18, 22).
turno(juanC, domingo, 18, 22).

turno(juanFdS, jueves, 10, 20).
turno(juanFdS, viernes, 12, 20).

turno(leoC, lunes, 14, 18).
turno(leoC, miercoles, 14, 18).

turno(martu, miercoles, 23, 24).

turno(vale, Dia, HoraInicio, HoraFin) :-
    turno(dodain, Dia, HoraInicio, HoraFin).

turno(vale, Dia, HoraInicio, HoraFin) :-
    turno(juanC, Dia, HoraInicio, HoraFin).

% --------------------------------
% PUNTO 2
% --------------------------------

quienAtiende(Persona, Dia, Hora) :-
    turno(Persona, Dia, HoraInicio, HoraFin),
    between(HoraInicio, HoraFin, Hora).

% --------------------------------
% PUNTO 3
% --------------------------------

foreverAlone(Persona, Dia, Hora) :-
    quienAtiende(Persona, Dia, Hora),
    not((quienAtiende(OtraPersona, Dia, Hora), Persona \= OtraPersona)).

% --------------------------------
% PUNTO 4
% --------------------------------

combinatoriaPersonas([], []).
combinatoriaPersonas([Persona|RestoPersonas], [Persona|Personas]) :-
    combinatoriaPersonas(RestoPersonas, Personas).
combinatoriaPersonas([_|RestoPersonas], Personas) :-
    combinatoriaPersonas(RestoPersonas, Personas).

posibilidadAtencion(Dia, Personas) :-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), ListaPersonas),
    combinatoriaPersonas(ListaPersonas, Personas).


% --------------------------------
% PUNTO 5
% --------------------------------

venta(dodain, dia(10, 8), [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
venta(dodain, dia(12, 8), [bebidas(alcoholicas, 8), bebidas(noAlcoholicas, 1), golosinas(10)]).
venta(martu, dia(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, dia(11, 8), [golosinas(600)]).
venta(lucas, dia(18, 8), [bebidas(noAlcoholicas, 2), cigarrillos([derby])]).

ventaImportante(golosinas(Precio)) :-
    Precio > 100.

ventaImportante(cigarrillos(Marcas)) :-
    length(Marcas, Cantidad),
    Cantidad > 2.

ventaImportante(bebidas(alcoholicas, _)).

ventaImportante(bebidas(_, Cantidad)) :-
    Cantidad > 5.

vendedor(Persona) :-
    distinct(Persona, venta(Persona, _, _)).

personaSuertuda(Persona) :-
    vendedor(Persona),
    forall(venta(Persona, _, [Venta|_]), ventaImportante(Venta)).
    


