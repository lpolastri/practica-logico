integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

% --------------------------------
% PUNTO 1
% --------------------------------

buenaBase(Grupo) :-
    integrante(Grupo, Integrante1, Instrumento1),
    integrante(Grupo, Integrante2, Instrumento2),
    Integrante1 \= Integrante2,
    instrumento(Instrumento1, ritmico),
    instrumento(Instrumento2, armonico).

% --------------------------------
% PUNTO 2
% --------------------------------

nivelInstrumentoIntegrante(Integrante, Grupo, Nivel) :-
    integrante(Grupo, Integrante, Instrumento),
    nivelQueTiene(Integrante, Instrumento, Nivel).

seDestaca(Integrante, Grupo) :-
    nivelInstrumentoIntegrante(Integrante, Grupo, Nivel),
    forall((nivelInstrumentoIntegrante(OtroIntegrante, Grupo, OtroNivel), OtroIntegrante \= Integrante), Nivel >= 2 + OtroNivel).

% --------------------------------
% PUNTO 3
% --------------------------------

grupo(vientosDelEste, bigband).
grupo(sophieTrio, formacionParticular([contrabajo, guitarra, violin])).
grupo(jazzmin, formacionParticular([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio, ensamble(3)).

% --------------------------------
% PUNTO 4
% --------------------------------

leSirve(formacionParticular(Formacion), Instrumento) :-
    member(Instrumento, Formacion).

leSirve(bigband, bateria).
leSirve(bigband, bajo).
leSirve(bigband, piano).

leSirve(ensamble(_), _).

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, bigband),
    instrumento(Instrumento, melodico(viento)).

hayCupo(Instrumento, Grupo) :-
    grupo(Grupo, TipoGrupo),
    leSirve(TipoGrupo, Instrumento),
    not(integrante(Grupo, _, Instrumento)).

% --------------------------------
% PUNTO 5
% --------------------------------

nivelEsperadoGrupo(bigband, 1).
nivelEsperadoGrupo(ensamble(Nivel), Nivel).

nivelEsperadoGrupo(formacionParticular(Formacion), Nivel) :-
    length(Formacion, CantidadInstrumentos),
    Nivel is 7 - CantidadInstrumentos.

puedeIncorporarse(Persona, Instrumento, Grupo) :-
    hayCupo(Instrumento, Grupo),
    nivelQueTiene(Persona, Instrumento, Nivel),
    not(integrante(Grupo, Persona, Instrumento)),
    grupo(Grupo, TipoGrupo),
    nivelEsperadoGrupo(TipoGrupo, NivelEsperado),
    Nivel >= NivelEsperado.

% --------------------------------
% PUNTO 6
% --------------------------------

seQuedoEnBanda(Persona) :-
    nivelQueTiene(Persona, _, _),
    not(puedeIncorporarse(Persona, _, _)),
    not(integrante(_, Persona, _)).

% --------------------------------
% PUNTO 7
% --------------------------------

puedeTocar(Grupo) :-
    grupo(Grupo, bigband),
    buenaBase(Grupo),
    findall(Integrante, integrante(Grupo, Integrante, melodico(viento)), Integrantes),
    length(Integrantes, CantidadIntegrantes),
    CantidadIntegrantes >= 5.


puedeTocar(Grupo) :-
    grupo(Grupo, formacionParticular(Formacion)),
    forall(member(Instrumento, Formacion), integrante(Grupo, _, Instrumento)).

% --------------------------------
% PUNTO 8
% --------------------------------

puedeTocar(Grupo) :-
    grupo(Grupo, ensamble(_)),
    buenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).