% --------------------------------
% PUNTO 1
% --------------------------------

puestoComida(hamburguesas, 2000).
puestoComida(panchoConPapas, 1500).
puestoComida(lomitosCompletos, 2500).
puestoComida(caramelos, 0).

atraccionTranquila(autitosChocadores).
atraccionTranquila(casaEmbrujada).
atraccionTranquila(laberinto).
atraccionTranquila(tobogan, chicos).
atraccionTranquila(calesita, chicos).

atraccionIntensa(barcoPirata, 14).
atraccionIntensa(tazasChinas, 6).
atraccionIntensa(simulador3D, 2).

montaniaRusa(abismoMortal, 3, 134).
montaniaRusa(paseoBosque, 0, 45).

atraccionAcuatica(torpedoSalpicon, 9, 3).
atraccionAcuatica(esperoQueHayasTraidoUnaMudaDeRopa, 9, 3).

visitante(euseibio, 80, 3000, 50, 0).
visitante(carmela, 80, 0, 0, 0).
visitante(pablo, 20, 1500, 25, 25).
visitante(romero, 12, 2000, 0, 50).

grupo(viejitos, euseibio).
grupo(viejitos, carmela).
grupo(viejitos, romero).

% --------------------------------
% PUNTO 2
% --------------------------------

indiceBienestar(Visitante, Indice) :-
    visitante(Visitante, _, _, Hambre, Aburrimiento),
    Indice is Hambre + Aburrimiento.

bienestarVisitante(Visitante, Estado) :-
    indiceBienestar(Visitante, Indice),
    grupo(_, Visitante),
    Indice is 0, 
    Estado = felicidadPlena.

bienestarVisitante(Visitante, Estado) :-
    indiceBienestar(Visitante, Indice),
    not(grupo(_, Visitante)),
    Indice is 0, 
    Estado = podriaEstarMejor.

bienestarVisitante(Visitante, Estado) :-
    indiceBienestar(Visitante, Indice),
    between(1, 50, Indice),
    Estado = podriaEstarMejor.

bienestarVisitante(Visitante, Estado) :-
    indiceBienestar(Visitante, Indice),
    between(51, 99, Indice),
    Estado = necesitaEntretenerse.

bienestarVisitante(Visitante, Estado) :-
    indiceBienestar(Visitante, Indice),
    Indice >= 100,
    Estado = seQuiereIrACasa.

% --------------------------------
% PUNTO 3
% --------------------------------

esChico(Visitante) :-
    visitante(Visitante, Edad, _, _, _),
    Edad < 13.

satisfaceVisitante(Visitante, hamburguesas) :-
    visitante(Visitante, _, _, Hambre, _),
    Hambre < 50.

satisfaceVisitante(Visitante, panchoConPapas) :-
    esChico(Visitante).

satisfaceVisitante(Visitante, caramelos) :-
    visitante(Visitante, _, Dinero, _, _),
    forall((puestoComida(Comida, Precio), Comida \= caramelos), Dinero < Precio).

visitantePuedePagar(Visitante, Precio) :-
    visitante(Visitante, _, Dinero, _, _),
    Dinero >= Precio.

satisfaceGrupo(Grupo, Comida) :-
    distinct(Grupo, grupo(Grupo, _)),
    puestoComida(Comida, Precio),
    forall((grupo(Grupo, Visitante)), (visitantePuedePagar(Visitante, Precio), satisfaceVisitante(Visitante, Comida))).

% --------------------------------
% PUNTO 4
% --------------------------------

accesoAtraccionTranquila(Visitante, Atraccion) :-
    esChico(Visitante),
    atraccionTranquila(Atraccion, chicos).

accesoAtraccionTranquila(Visitante, Atraccion) :-
    grupo(Grupo, Visitante),
    grupo(Grupo, OtroVisitante),
    Visitante \= OtroVisitante,
    esChico(OtroVisitante),
    atraccionTranquila(Atraccion, chicos).

accesoAtraccionTranquila(Visitante, Atraccion) :-
    visitante(Visitante, _, _, _, _),
    atraccionTranquila(Atraccion).

montaniaPeligrosa(Visitante, MotaniaRusa) :-
    bienestarVisitante(Visitante, Estado),
    Estado \= necesitaEntretenerse,
    not(esChico(Visitante)),
    montaniaRusa(MotaniaRusa, GirosMontania, _),
    forall((montaniaRusa(Nombre, Giros, _), MotaniaRusa \= Nombre), (GirosMontania >= Giros)).

montaniaPeligrosa(Visitante, MotaniaRusa) :-
    esChico(Visitante),
    montaniaRusa(MotaniaRusa, _, Segundos),
    Segundos > 60.

puedeComprarComida(Visitante, Comida) :-
    puestoComida(Comida, Precio),
    visitantePuedePagar(Visitante, Precio).

lluviaHamburguesas(Visitante, AtraccionIntensa) :-
    atraccionIntensa(AtraccionIntensa, Coeficiente),
    Coeficiente > 10,
    puedeComprarComida(Visitante, hamburguesas).

lluviaHamburguesas(Visitante, MontaniaRusa) :-
    montaniaPeligrosa(Visitante, MontaniaRusa),
    puedeComprarComida(Visitante, hamburguesas).

lluviaHamburguesas(Visitante, tobogan) :-
    accesoAtraccionTranquila(Visitante, tobogan),
    puedeComprarComida(Visitante, hamburguesas).

% --------------------------------
% PUNTO 5
% --------------------------------

esMes(Mes) :-
    between(1, 12, Mes).

mesAbierto(MesInicio, MesFin, Mes) :-
    MesInicio > MesFin,
    CotaInferior is MesInicio - 1,
    CotaSuperior is MesFin + 1,
    not(between(CotaSuperior, CotaInferior, Mes)).

mesAbierto(MesInicio, MesFin, Mes) :-
    MesFin > MesInicio,
    between(MesInicio, MesFin, Mes).

accesoAtraccionAcuatica(Mes, Atraccion) :-
    atraccionAcuatica(Atraccion, MesInicio, MesFin),
    mesAbierto(MesInicio, MesFin, Mes).

opcionesEntretenimiento(Visitante, Mes, Opciones) :-
    esMes(Mes),
    visitante(Visitante, _, _, _, _),
    findall(Comida, puedeComprarComida(Visitante, Comida), Comidas),
    findall(AtraccionTranquila, accesoAtraccionTranquila(Visitante, AtraccionTranquila), AtraccionesTranquilas),
    findall(AtraccionIntensa, atraccionIntensa(AtraccionIntensa, _), AtraccionesIntensas),
    findall(MontaniaRusa, (montaniaRusa(MontaniaRusa, _, _), not(montaniaPeligrosa(Visitante, MontaniaRusa))), MontaniasRusas),
    findall(AtraccionAcuatica, accesoAtraccionAcuatica(Mes, AtraccionAcuatica), AtraccionesAcuaticas),
    flatten([Comidas, AtraccionesTranquilas, AtraccionesIntensas, MontaniasRusas, AtraccionesAcuaticas], Opciones).