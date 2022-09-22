%tarot01.pl
%runs on https://swish.swi-prolog.org/ only
%TODO: update to work on desktop swi prolog
%TODO: clean up categories & separate into multiple files

%UTILITY
betweenCheckInteger(Low, High, Value) :-
    (   
        var(Value);
    	integer(Value)
    ),
    between(Low, High, Value).

%ZODIAC
%zodiacSignBasicInfo(House, Sign, Symbol, Gloss, Ruler).
zodiacSignBasicInfo(1,  aries,       '♈︎', 'ram',          mars).
zodiacSignBasicInfo(2,  taurus,      '♉︎', 'bull',         venus).
zodiacSignBasicInfo(3,  gemini,      '♊︎', 'twins',        mercury).
zodiacSignBasicInfo(4,  cancer,      '♋︎', 'crab',         moon).
zodiacSignBasicInfo(5,  leo,         '♌︎', 'lion',         sun).
zodiacSignBasicInfo(6,  virgo,       '♍︎', 'maiden',       mercury).
zodiacSignBasicInfo(7,  libra,       '♎︎', 'scales',       venus).
zodiacSignBasicInfo(8,  scorpio,     '♏︎', 'scorpion',     mars).
zodiacSignBasicInfo(9,  sagittarius, '♐︎', 'archer',       jupiter).
zodiacSignBasicInfo(10, capricorn,   '♑︎', 'goat',         saturn).
zodiacSignBasicInfo(11, aquarius,    '♒︎', 'water-bearer', saturn).
zodiacSignBasicInfo(12, pisces,      '♓︎', 'fish',         jupiter).

%planetBasicInfo(Planet, Symbol, Connection).
planetBasicInfo(moon,    '☽︎', ancient).
planetBasicInfo(mercury, '☿', ancient).
planetBasicInfo(venus,   '♀', ancient).
planetBasicInfo(sun,     '☉︎', ancient).
planetBasicInfo(mars,    '♂', ancient).
planetBasicInfo(jupiter, '♃', ancient).
planetBasicInfo(saturn,  '♄', ancient).
planetBasicInfo(uranus,  '⛢', modern).
planetBasicInfo(neptune, '♆', modern).
planetBasicInfo(pluto,   '♇', modern).

isZodiacHouse(House) :- 
    zodiacSignBasicInfo(House, _, _, _, _).
isZodiacSign(Sign) :- 
    zodiacSignBasicInfo(_, Sign, _, _, _).
isZodiacSymbol(Symbol) :- 
    zodiacSignBasicInfo(_, _, Symbol, _, _).
isZodiacGloss(Gloss) :-
    zodiacSignBasicInfo(_, _, _, Gloss, _).
isZodiacRuler(Ruler) :- 
    zodiacSignBasicInfo(_, _, _, _, Ruler).
isZodiacDecan(Decan) :- 
    betweenCheckInteger(1, 36, Decan).
isZodiacQuadrant(Quadrant) :-
    betweenCheckInteger(1, 4, Quadrant).

zodiacSignHouse(Sign, House) :- 
    zodiacSignBasicInfo(House, Sign, _, _, _).
zodiacSignSymbol(Sign, Symbol) :- 
    zodiacSignBasicInfo(_, Sign, Symbol, _, _).
zodiacSignGloss(Sign, Gloss) :- 
    zodiacSignBasicInfo(_, Sign, _, Gloss, _).
zodiacSignRuler(Sign, Ruler) :- 
    zodiacSignBasicInfo(_, Sign, _, _, Ruler).
zodiacSignDecans(Sign, Decans) :- 
    zodiacSignHouse(Sign, House),
    Decan1 is 3 * House - 2,
    Decan2 is 3 * House - 1,
    Decan3 is 3 * House,
    Decans = [Decan1, Decan2, Decan3].
zodiacSignQuadrant(Sign, Quadrant) :- 
    zodiacSignHouse(Sign, House),
    Quadrant is (House - 1) div 3.
zodiacSignTriplicity(Sign, Triplicity) :-
    zodiacSignHouse(Sign, House),
    Idx is (House - 1) mod 4,
    nth0(Idx, [fire, earth, air, water], Triplicity).
zodiacSignModality(Sign, Modality) :-
    zodiacSignHouse(Sign, House),
    Idx is (House - 1) mod 3,
    nth0(Idx, [cardinal, fixed, mutable], Modality).
zodiacDecanPlanet(Decan, Planet) :-
    isZodiacDecan(Decan),
    Idx is (Decan - 1) mod 7,
    nth0(Idx, [mars, sun, venus, mercury, moon, saturn, jupiter], Planet).
zodiacDecanQuadrant(Decan, Quadrant) :-
    isZodiacDecan(Decan),
    isZodiacQuadrant(Quadrant),
    Quadrant is (Decan - 1) div 9 + 1.
zodiacNextDecan(Decan, NextDecan) :-
    isZodiacDecan(Decan),
    isZodiacDecan(NextDecan),
    NextDecan is Decan mod 36 + 1.

%TAROT BASICS
%tarotSuitBasicInfo(Suit, FrenchSuit, Symbol, FrenchSymbol, Element).
tarotSuitBasicInfo(wands,     clubs,    '|', '♣', fire).
tarotSuitBasicInfo(cups,      hearts,   '⊔', '♥', water).
tarotSuitBasicInfo(swords,    spades,   '†', '♠', air).
tarotSuitBasicInfo(pentacles, diamonds, '⍟', '♦', earth).

isTarotNumber(Number) :-
    betweenCheckInteger(2, 10, Number).
isTarotMinorSuit(Suit) :-
    tarotSuitBasicInfo(Suit, _, _, _, _).
isTarotCourt(Court) :-
    member(Court, [king, queen, prince, princess]).

tarotSuitSymbol(Suit, Symbol) :-
    tarotSuitBasicInfo(Suit, _, Symbol, _, _).
tarotSuitElement(Suit, Element) :-
    tarotSuitBasicInfo(Suit, _, _, _, Element).
tarotNumberSuitDecan(Number, Suit, Decan) :-
    isTarotNumber(Number),
    isTarotMinorSuit(Suit),
    isZodiacDecan(Decan),
    Number is (Decan - 1) mod 9 + 2,
    zodiacSignDecans(Sign, Decans),
    member(Decan, Decans),
    zodiacSignTriplicity(Sign, Triplicity),
    tarotSuitElement(Suit, Triplicity).
tarotNumberSuitSign(Number, Suit, Sign) :-
    isTarotNumber(Number),
    zodiacSignDecans(Sign, Decans),
    tarotNumberSuitDecan(Number, Suit, Decan),
    member(Decan, Decans).
tarotNumberSuitPlanet(Number, Suit, Sign) :-
    isTarotNumber(Number),
    zodiacSignDecans(Sign, Decans),
    tarotNumberSuitDecan(Number, Suit, Decan),
    member(Decan, Decans).
tarotAceSuitQuadrant(Suit, Quadrant) :-
    isZodiacQuadrant(Quadrant),
    Idx is Quadrant - 1,
    nth0(Idx, [pentacles, wands, cups, swords], Suit).
tarotPrincessSuitQuadrant(Suit, Quadrant) :-
    tarotAceSuitQuadrant(Suit, Quadrant).
tarotDecanAceSuit(Decan, Suit) :-
    isZodiacDecan(Decan),
    isTarotMinorSuit(Suit),
    zodiacDecanQuadrant(Decan, Quadrant),
    tarotAceSuitQuadrant(Suit, Quadrant).
tarotDecanPrincessSuit(Decan, Suit) :-
    tarotDecanAceSuit(Decan, Suit).
tarotDecanCourtSuit(Decan, Court, Suit) :-
    isTarotCourt(Court),
    isZodiacDecan(Decan),
    isTarotMinorSuit(Suit),
    Court \= princess,
    Idx1 is Decan div 3 mod 3,
    nth0(Idx1, [queen, prince, king], Court),
    Idx2 is Decan div 3 mod 4,
    nth0(Idx2, [wands, pentacles, swords, cups], Suit).

tarotNumberSuitRulingAce(Number, Suit, AceSuit) :-
    isTarotNumber(Number),
    isTarotMinorSuit(Suit),
    isTarotMinorSuit(AceSuit),
    tarotNumberSuitDecan(Number, Suit, Decan),
    zodiacDecanQuadrant(Decan, Quadrant),
    tarotAceSuitQuadrant(AceSuit, Quadrant).
tarotNumberSuitRulingPrincess(Number, Suit, PrincessSuit) :-
    tarotNumberSuitRulingAce(Number, Suit, PrincessSuit).
tarotNumberSuitRulingCourt(Number, Suit, Court, CourtSuit) :-
    isTarotNumber(Number),
    isTarotMinorSuit(Suit),
    isTarotMinorSuit(CourtSuit),
    isTarotCourt(Court),
    tarotNumberSuitDecan(Number, Suit, Decan),
    tarotDecanCourtSuit(Decan, Court, CourtSuit).
tarotNumberSuitNextByDecan(Number, Suit, NextNumber, NextSuit) :-
    zodiacNextDecan(Decan, NextDecan),
    tarotNumberSuitDecan(Number, Suit, Decan),
    tarotNumberSuitDecan(NextNumber, NextSuit, NextDecan).
tarotNumberSuitPrevByDecan(Number, Suit, PrevNumber, PrevSuit) :-
    tarotNumberSuitNextByDecan(PrevNumber, PrevSuit, Number, Suit).
tarotNumberSuitAdjacentByDecan(Number, Suit, AdjNumber, AdjSuit) :-
    tarotNumberSuitNextByDecan(Number, Suit, AdjNumber, AdjSuit);
    tarotNumberSuitPrevByDecan(Number, Suit, AdjNumber, AdjSuit).
    
%SEFIROT PATHS
%sefirotPathBasicInfo(Path, Node1, Node2, Name, Letter).
sefirotPathBasicInfo(1,  1, 2,  'aleph',  'א').
sefirotPathBasicInfo(2,  1, 3,  'beth',   'ב').
sefirotPathBasicInfo(3,  1, 6,  'gimel',  'ג').
sefirotPathBasicInfo(4,  2, 3,  'daleth', 'ד').
sefirotPathBasicInfo(5,  2, 6,  'heh',    'ה').
sefirotPathBasicInfo(6,  2, 4,  'vav',    'ו').
sefirotPathBasicInfo(7,  3, 6,  'zain',   'ז').
sefirotPathBasicInfo(8,  3, 5,  'cheth',  'ח').
sefirotPathBasicInfo(9,  4, 5,  'teth',   'ט').
sefirotPathBasicInfo(10, 4, 6,  'yod',    'י').
sefirotPathBasicInfo(11, 4, 7,  'kaph',   'כ'). 
sefirotPathBasicInfo(12, 5, 6,  'lamed',  'ל').  
sefirotPathBasicInfo(13, 5, 8,  'mem',    'מ').
sefirotPathBasicInfo(14, 6, 7,  'nun',    'נ'). 
sefirotPathBasicInfo(15, 6, 9,  'samekh', 'ס').
sefirotPathBasicInfo(16, 6, 8,  'ayin',   'ע').
sefirotPathBasicInfo(17, 7, 8,  'peh',    'פ').
sefirotPathBasicInfo(18, 7, 9,  'tzaddi', 'צ').  
sefirotPathBasicInfo(19, 7, 10, 'qoph',   'ק'). 
sefirotPathBasicInfo(20, 8, 9,  'resh',   'ר').
sefirotPathBasicInfo(21, 8, 10, 'shin',   'ש').
sefirotPathBasicInfo(22, 9, 10, 'tau',    'ת').

isSefirotPath(Path) :-
    betweenCheckInteger(1, 22, Path).
isSefirotNode(Node) :-
    betweenCheckInteger(1, 10, Node).

sefirotConnects(Node1, Node2, Path) :-
    isSefirotPath(Path),
    isSefirotNode(Node1),
    isSefirotNode(Node2),
    (   
        sefirotPathBasicInfo(Path, Node1, Node2, _, _);
        sefirotPathBasicInfo(Path, Node2, Node1, _, _)
    ).

%TAROT TRUMPS
%tarotTrumpPathOrder(Scheme, PathOrder).
tarotTrumpPathOrder(yetzirah, [0, 21, 10, 16, 4, 5, 6, 7, 8, 9, 19, 11,
                                 12, 13, 14, 15, 3, 17, 18, 1, 20, 2]).
tarotTrumpPathOrder(mathers,  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
                                 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]).
tarotTrumpPathOrder(crowley,  [0, 1, 2, 3, 4, 5, 6, 7, 11, 9, 10, 8,
                                 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]).

%tarotTrumpNumerals(Numerals).
tarotTrumpNumerals(['∅', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 
                      'VIII', 'IX', 'X', 'XI', 'XII', 'XIII', 'XIV', 'XV', 
                      'XVI', 'XVII', 'XVIII', 'XIX', 'XX', 'XXI']).

%tarotTrumpNames(Scheme, NameOrder).
tarotTrumpNames(rws,        ['the fool', 
                              'the magician', 
                              'the high priestess', 
                              'the empress', 
                              'the emperor', 
                              'the hierophant',
                              'the lovers', 
                              'the chariot', 
                              'strength',
                              'the hermit', 
                              'wheel of fortune', 
                              'justice',
                              'the hanged man', 
                              'death', 
                              'temperance',
                              'the devil', 
                              'the tower', 
                              'the star',
                              'the moon', 
                              'the sun', 
                              'judgement',
                              'the world']).
tarotTrumpNames(marseilles, ['the fool', 
                              'the juggler', 
                              'the high popess', 
                              'the empress', 
                              'the emperor', 
                              'the pope',
                              'the lovers', 
                              'the chariot', 
                              'justice',
                              'the hermit', 
                              'the wheel of fortune', 
                              'strength',
                              'the hanged man', 
                              'death', 
                              'temperance',
                              'the devil', 
                              'the house of god', 
                              'the star',
                              'the moon', 
                              'the sun', 
                              'judgement',
                              'the world']).
tarotTrumpNames(thoth,      ['the fool', 
                              'the magus', 
                              'the priestess', 
                              'the empress', 
                              'the emperor', 
                              'the hierophant',
                              'the lovers', 
                              'the chariot', 
                              'adjustment',
                              'the hermit', 
                              'the wheel of fortune', 
                              'lust',
                              'the hanged man', 
                              'death', 
                              'art',
                              'the devil', 
                              'the tower', 
                              'the star',
                              'the moon', 
                              'the sun', 
                              'the aeon',
                              'the universe']).

isTarotTrump(Number) :-
    betweenCheckInteger(0, 21, Number).
isTarotTrumpPathScheme(Scheme) :-
    tarotTrumpPathOrder(Scheme, _).

tarotTrumpPath(Scheme, TrumpNumber, Path) :-
    isSefirotPath(Path),
    isTarotTrump(TrumpNumber),
    isTarotTrumpPathScheme(Scheme),
    tarotTrumpPathOrder(Scheme, Order),
    Idx is Path - 1,
	nth0(Idx, Order, TrumpNumber).


%SEFIROT NODES
%sefirotNodeBasicInfo(Node, Name, HebrewName)
sefirotNodeBasicInfo(1,  'the crown',     'kether').
sefirotNodeBasicInfo(2,  'wisdom',        'chokmah').
sefirotNodeBasicInfo(3,  'understanding', 'binah').
sefirotNodeBasicInfo(4,  'mercy',         'chesod').
sefirotNodeBasicInfo(5,  'strength',      'geburah').
sefirotNodeBasicInfo(6,  'beauty',        'tiphareth').
sefirotNodeBasicInfo(7,  'victory',       'netzach').
sefirotNodeBasicInfo(8,  'splendor',      'hod').
sefirotNodeBasicInfo(9,  'foundation',    'yesod').
sefirotNodeBasicInfo(10, 'kingdom',       'malkuth').

%tarotSefirotNode(Val, Node).
tarotSefirotNode(ace, 1).
tarotSefirotNode(king, 2).
tarotSefirotNode(queen, 3).
tarotSefirotNode(prince, 6).
tarotSefirotNode(princess, 10).
tarotSefirotNode(Number, Number) :-
    isTarotNumber(Number),
    isSefirotNode(Number).

%TAROT CARDS
%tarotValSuitCard(Val, Suit, Card).
%Suit includes "trump", unlike isTarotMinorSuit
tarotValSuitCard(Val, trump, [trump, Val]) :-
    isTarotTrump(Val).
tarotValSuitCard(ace, Suit, [Suit, ace]) :-
    isTarotMinorSuit(Suit).
tarotValSuitCard(Court, Suit, [Suit, Court]) :-
    isTarotMinorSuit(Suit),
	isTarotCourt(Court).
tarotValSuitCard(Number, Suit, [Suit, Number]) :-
    isTarotMinorSuit(Suit),
	isTarotNumber(Number).
tarotCardVal(Card, Val) :-
    tarotValSuitCard(Val, _, Card).
tarotCardSuit(Card, Suit) :-
    tarotValSuitCard(_, Suit, Card).

isTarotVal(Val) :-
    tarotValSuitCard(Val, _, _).
isTarotCard([Suit, Val]) :-
    tarotValSuitCard(_, _, [Suit, Val]).
isTarotMajorCard([trump, Val]) :-
    isTarotTrump(Val).
isTarotCourtCard([Suit, Court]) :-
    isTarotMinorSuit(Suit),
    isTarotCourt(Court).
isTarotAceCard([Suit, ace]) :-
    isTarotMinorSuit(Suit).
isTarotNumberCard([Suit, Number]) :-
    isTarotMinorSuit(Suit),
    isTarotNumber(Number).
isTarotMinorCard([Suit, Val]) :-
    isTarotCourtCard([Suit, Val]);
    isTarotAceCard([Suit, Val]);
    isTarotNumberCard([Suit, Val]).

%TAROT INFERENCES
tarotConnectingPathIgnoreSuit(Card1, Card2, Path) :-
    isTarotMinorCard(Card1),
    isTarotMinorCard(Card2),
    isSefirotPath(Path),
    tarotCardVal(Card1, Val1),
    tarotCardVal(Card2, Val2),
    tarotSefirotNode(Val1, Node1),
    tarotSefirotNode(Val2, Node2),
    sefirotConnects(Node1, Node2, Path).
tarotConnectingTrumpIgnoreSuit(Scheme, Card1, Card2, [trump, TrumpNumber]) :-
    isTarotMinorCard(Card1),
    isTarotMinorCard(Card2),
    isTarotMajorCard([trump, TrumpNumber]),
    tarotConnectingPathIgnoreSuit(Card1, Card2, Path),
    tarotTrumpPath(Scheme, TrumpNumber, Path).

tarotCardRulingPrincess([Suit, Number], [PrincessSuit, princess]) :-
    tarotNumberSuitRulingPrincess(Number, Suit, PrincessSuit).
tarotCardRulingAce([Suit, Number], [AceSuit, ace]) :-
    tarotNumberSuitRulingAce(Number, Suit, AceSuit).
tarotCardRulingCourt([Suit, Number], [CourtSuit, Court]) :-
	tarotNumberSuitRulingCourt(Number, Suit, Court, CourtSuit).


%STRING CONVERSION
%tarotValAbbreviation(Val, Abbr).
tarotValAbbreviation(Court, Abbr) :-
    isTarotCourt(Court),
    nth0(Idx, [king, queen, prince, princess], Court),
    nth0(Idx, ['Kg.', 'Qn.', 'Pe.', 'Ps.'], Abbr).
tarotValAbbreviation(ace, 'A.').
tarotValAbbreviation(Number, Abbr) :-
    isTarotNumber(Number),
    number_string(Number, Abbr).

tarotCardString([Suit, Val], CardStr) :-
    isTarotMinorCard([Suit, Val]),
    tarotSuitSymbol(Suit, Symbol),
    tarotValAbbreviation(Val, Abbr),
    string_concat(Abbr, ' ', Str1),
    string_concat(Str1, Symbol, CardStr).
tarotCardString([trump, Val], CardStr) :-
    isTarotMajorCard([trump, Val]),
    tarotTrumpNumerals(Numerals),
    nth0(Val, Numerals, CardStr).












