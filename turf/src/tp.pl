% --------------------------------
% PUNTO 1
% --------------------------------

jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

caballoLeGusta(botafogo, baratucci).
caballoLeGusta(botafogo, Jockey) :-
    jockey(Jockey, _, Peso),
    Peso < 52.

caballoLeGusta(oldMan, Jockey) :-
    jockey(Jockey, _, _),
    atom_length(Jockey, Letras),
    Letras > 7.

caballoLeGusta(energica, Jockey) :-
    jockey(Jockey, _, _),
    not(caballoLeGusta(botafogo, Jockey)).

caballoLeGusta(matBoy, Jockey) :-
    jockey(Jockey, Altura, _),
    Altura > 170.

stud(elTute, [valdivieso, falero]).
stud(lasHormigas, [lezcano]).
stud(elCharabon, [leguisamo, baratucci]).

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).
gano(oldMan, granPremioRepublica).
gano(oldMan, campeonatoPalermoDeOro).
gano(matBoy, granPremioCriadores).

% --------------------------------
% PUNTO 2
% --------------------------------

prefiereMasDeUnJockey(Caballo) :-
    caballo(Caballo),
    caballoLeGusta(Caballo, Jockey1),
    caballoLeGusta(Caballo, Jockey2),
    Jockey1 \= Jockey2.

% --------------------------------
% PUNTO 3
% --------------------------------

caballoAborreceA(Caballo, Stud) :-
    caballo(Caballo),
    stud(Stud, Jockeys),
    forall(member(Jockey, Jockeys), not(caballoLeGusta(Caballo, Jockey))).

% --------------------------------
% PUNTO 4
% --------------------------------

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

ganoPremioImportante(Caballo) :-
    gano(Caballo, Premio),
    premioImportante(Premio).

jockeyPiolin(Jockey) :-
    jockey(Jockey, _, _),
    forall(ganoPremioImportante(Caballo), caballoLeGusta(Caballo, Jockey)).

% --------------------------------
% PUNTO 5
% --------------------------------

salioPrimero(Caballo, [Caballo | _]).
salioSegundo(Caballo, [_ | [Caballo | _]]).

apuestaGanadora(ganador(Caballo), Resultado) :-
    salioPrimero(Caballo, Resultado).

apuestaGanadora(segundo(Caballo), Resultado) :-
    salioPrimero(Caballo, Resultado).

apuestaGanadora(segundo(Caballo), Resultado) :-
    salioSegundo(Caballo, Resultado).

apuestaGanadora(exacta(Caballo1, Caballo2)) :-
    salioPrimero(Caballo1, Resultado),
    salioSegundo(Caballo2, Resultado).

apuestaGanadora(imperfecta(Caballo1, Caballo2)) :-
    salioPrimero(Caballo1, Resultado),
    salioSegundo(Caballo2, Resultado).

apuestaGanadora(imperfecta(Caballo1, Caballo2)) :-
    salioPrimero(Caballo2, Resultado),
    salioSegundo(Caballo1, Resultado).

% --------------------------------
% PUNTO 6
% --------------------------------

crin(botafogo, tordo).
crin(oldMan, alazan).
crin(energica, ratonero).
crin(matBoy, palomino).
crin(yatasto, pinto).

color(tordo, negro).
color(alazan, marron).
color(ratonero, gris).
color(ratonero, negro).
color(palomino, marron).
color(palomino, blanco).
color(pinto, blanco).
color(pinto, marron).

combinacionesCaballos([], []).
combinacionesCaballos([Caballo|CaballosPosibles], [Caballo|Caballos]) :-
    combinacionesCaballos(CaballosPosibles, Caballos).
combinacionesCaballos([_|CaballosPosibles], Caballos) :-
    combinacionesCaballos(CaballosPosibles, Caballos).

posibleCompraCaballos(Color, Caballos) :-
    color(_, Color),
    findall(Caballo, (crin(Caballo, Crin), color(Crin, Color)), CaballosPosibles),
    combinacionesCaballos(CaballosPosibles, Caballos),
    Caballos \= [].