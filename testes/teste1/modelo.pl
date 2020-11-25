% enunciado : https://drive.google.com/file/d/1M6FQDD_HJWKtgUomMQEmBR5xxZEuyunW/view?usp=sharing

:-use_module(library(lists)).

% participant(Id,Age,Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

% performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

% exercicio 1
madeItThrough(Participant):-
  performance(Participant, List),
  member(120, List).

/*
  % exercicio 2
  +Participants - lista de participantes
  +JuriMember   - index do juri de 1 até E 
  -Times        - Lista do tempo que o jurimember demorou até carregar no botão para o participante
  -Total        - Total de tempo na lista Times
*/
juriTimes([], _, [], 0). % caso base para quando não existem mais participantes.
juriTimes([Participant|Resto], JuriMember, [Tempo|RestoTempo], Total):-
  juriTimes(Resto, JuriMember, RestoTempo, Total1),
  performance(Participant, List),
  nth1(JuriMember, List, Tempo),
  Total is (Total1 + Tempo).

% exercicio 3
patientJuri(JuriMember):-
  performance(X, List1),
  nth1(JuriMember, List1, 120),
  performance(Y, List2),
  X \= Y,
  nth1(JuriMember, List2, 120).

% exercicio 4
bestParticipant(P1, P2, P):-
  performance(P1, TimesP1),
  performance(P2, TimesP2),
  sumlist(TimesP1, SumP1),
  sumlist(TimesP2, SumP2),
  SumP1 > SumP2,
  P = P1.
bestParticipant(P1, P2, P):-
  performance(P1, TimesP1),
  performance(P2, TimesP2),
  sumlist(TimesP1, SumP1),
  sumlist(TimesP2, SumP2),
  SumP1 < SumP2,
  P = P2.

% exercicio 5
allPerfs:-
  performance(P, Tempos),
  participant(P, _, Performance),
  format('~d:~s:~q\n', [P, Performance, Tempos]),
  fail.
allPerfs.

% exercicio 6
nSuccessfulParticipants(T) :-
  setof(
    _Participant, 
    (
      performance(_Participant, TimesList),
      no_click_of_button(TimesList)
    ), 
    Total),
length(Total,T).

no_click_of_button([]).
no_click_of_button([120|Tail]):- no_click_of_button(Tail).

% exercicio 7
juriFans(JuriFansList):-
	findall(
    Participant-Juris, 
    (
      performance(Participant, Times),
      findall(Juri, (nth1(Juri, Times, 120)), Juris)
    ), 
    JuriFansList).

% given
eligibleOutcome(Id,Perf,TT):-
  performance(Id,Times),
  madeItThrough(Id),
  participant(Id,_,Perf),
  sumlist(Times,TT).

% exercicio 8
nextPhase(N, Participants):-
	length(Participants, N),
	setof(TT-Participant-Perf, (eligibleOutcome(Participant, Perf, TT)), AllReversed),
	reverse(AllReversed, All),
	append(Participants, _, All).
