herramientasRequeridas(ordenarCuarto, [[aspiradora(100), escoba], trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% --------------------------------
% PUNTO 1
% --------------------------------

herramienta(egon, aspiradora(200)).
herramienta(egon, trapeador).
herramienta(peter, trapeador).
herramienta(winston, varitaNeutrones).

% --------------------------------
% PUNTO 2
% --------------------------------

satisfaceNecesidadHerramienta(Integrante, Herramienta) :-
    herramienta(Integrante, Herramienta).

satisfaceNecesidadHerramienta(Integrante, aspiradora(PotenciaRequerida)) :-
    herramienta(Integrante, aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida).

satisfaceNecesidad(Persona, HerramientasReemplazables):-
	member(Herramienta, HerramientasReemplazables),
	satisfaceNecesidad(Persona, Herramienta).

% --------------------------------
% PUNTO 3
% --------------------------------

integrante(Integrante) :-
    distinct(Integrante, herramienta(Integrante, _)).

puedeRealizarTarea(Integrante, Tarea) :-
    satisfaceNecesidadHerramienta(Integrante, varitaNeutrones),
    herramientasRequeridas(Tarea, _).

puedeRealizarTarea(Integrante, Tarea) :-
    integrante(Integrante),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), satisfaceNecesidadHerramienta(Integrante, Herramienta)).

% --------------------------------
% PUNTO 4
% --------------------------------

precio(ordenarCuarto, 100).
precio(limpiarTecho, 200).
precio(cortarPasto, 50).
precio(limpiarBanio, 300).
precio(encerarPisos, 150).

tareaPedida(pablo, ordenarCuarto, 50).
tareaPedida(romero, limpiarBanio, 40).
tareaPedida(juan, encerarPisos, 55).

cliente(Cliente) :-
    distinct(Cliente, tareaPedida(Cliente, _, _)).

precioTarea(Cliente, Dinero) :-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, Precio),
    Dinero is Precio * Metros.

cobroCliente(Cliente, Dinero) :-
    cliente(Cliente),
    findall(DineroTarea, precioTarea(Cliente, DineroTarea), ListaDinero),
    sum_list(ListaDinero, Dinero).

% --------------------------------
% PUNTO 5
% --------------------------------

tareaCompleja(limpiarTecho).
tareaCompleja(Tarea) :-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, CantidadHerramientas),
    CantidadHerramientas > 2.

integranteDispuesto(ray, Cliente) :-
    not(tareaPedida(Cliente, limpiarTecho, _)).

integranteDispuesto(winston, Cliente) :-
    cobroCliente(Cliente, Dinero),
    Dinero > 500.

integranteDispuesto(egon, Cliente) :-
    not((tareaPedida(Cliente, Tarea, _), tareaCompleja(Tarea))).

integranteDispuesto(peter, _).

aceptaPedido(Integrante, Cliente) :-
    integrante(Integrante),
    cliente(Cliente),
    integranteDispuesto(Integrante, Cliente),
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizarTarea(Integrante, Tarea)).
