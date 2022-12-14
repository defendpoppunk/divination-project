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

%lists all integers between Low & High. fails if List is partial
rangeList(Num, Num, [Num]) :-
    integer(Num).
rangeList(Low, High, [Low | Tail]) :-
    integer(Low),
    integer(High),
    NewLow is Low + 1,
    NewLow =< High,
    rangeList(NewLow, High, Tail).
rangeList(Low, High, [Low | Tail]) :-
    integer(Low),
    var(High),
    NewLow is Low + 1,
    rangeList(NewLow, High, Tail),
    NewLow =< High.

%ZODIAC
%zodiacSignBasicInfo(House, Sign, Symbol, Gloss).
zodiacSignBasicInfo(1,  aries,       '♈︎', 'ram').
zodiacSignBasicInfo(2,  taurus,      '♉︎', 'bull').
zodiacSignBasicInfo(3,  gemini,      '♊︎', 'twins').
zodiacSignBasicInfo(4,  cancer,      '♋︎', 'crab').
zodiacSignBasicInfo(5,  leo,         '♌︎', 'lion').
zodiacSignBasicInfo(6,  virgo,       '♍︎', 'maiden').
zodiacSignBasicInfo(7,  libra,       '♎︎', 'scales').
zodiacSignBasicInfo(8,  scorpio,     '♏︎', 'scorpion').
zodiacSignBasicInfo(9,  sagittarius, '♐︎', 'archer').
zodiacSignBasicInfo(10, capricorn,   '♑︎', 'goat').
zodiacSignBasicInfo(11, aquarius,    '♒︎', 'water-bearer').
zodiacSignBasicInfo(12, pisces,      '♓︎', 'fish').

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
    zodiacSignBasicInfo(House, _, _, _).
isZodiacSign(Sign) :- 
    zodiacSignBasicInfo(_, Sign, _, _).
isZodiacSymbol(Symbol) :- 
    zodiacSignBasicInfo(_, _, Symbol, _).
isZodiacGloss(Gloss) :-
    zodiacSignBasicInfo(_, _, _, Gloss).
isZodiacPolarity(Polarity) :-
    Polarity = positive;
    Polarity = negative.
isZodiacDecan(Decan) :- 
    betweenCheckInteger(1, 36, Decan).
isZodiacQuadrant(Quadrant) :-
    betweenCheckInteger(1, 4, Quadrant).

zodiacSignHouse(Sign, House) :- 
    zodiacSignBasicInfo(House, Sign, _, _).
zodiacSignSymbol(Sign, Symbol) :- 
    zodiacSignBasicInfo(_, Sign, Symbol, _).
zodiacSignGloss(Sign, Gloss) :- 
    zodiacSignBasicInfo(_, Sign, _, Gloss).
zodiacPlanetSymbol(Planet, Symbol) :- 
    planetBasicInfo(Planet, Symbol, _).
zodiacSignDecans(Sign, Decans) :- 
    zodiacSignHouse(Sign, House),
    Decan1 is 3 * House - 2,
    Decan2 is 3 * House - 1,
    Decan3 is 3 * House,
    Decans = [Decan1, Decan2, Decan3].
zodiacSignDecan(Sign, Decan) :-
    zodiacSignDecans(Sign, Decans),
    member(Decan, Decans).
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
zodiacSignPolarity(Sign, Polarity) :-
    zodiacSignHouse(Sign, House),
    Idx is (House - 1) mod 2,
    nth0(Idx, [positive, negative], Polarity).
zodiacSignOpposite(Sign, OppositeSign) :-
    zodiacSignHouse(Sign, House),
    OppositeHouse is (House + 5) mod 12 + 1,
    zodiacSignHouse(OppositeSign, OppositeHouse).
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

%PLANET ESSENTIAL DIGNITIES
%planetDomicile(Planet, Sign).
planetDomicile(sun,     leo).
planetDomicile(moon,    cancer).
planetDomicile(mercury, gemini).
planetDomicile(mercury, virgo).
planetDomicile(venus,   libra).
planetDomicile(venus,   taurus).
planetDomicile(mars,    aries).
planetDomicile(mars,    scorpio).
planetDomicile(jupiter, sagittarius).
planetDomicile(jupiter, pisces).
planetDomicile(saturn,  capricorn).
planetDomicile(saturn,  aquarius).

%planetExaltation(Planet, Sign).
planetExaltation(sun,     aries).
planetExaltation(moon,    taurus).
planetExaltation(mercury, virgo).
planetExaltation(venus,   pisces).
planetExaltation(mars,    capricorn).
planetExaltation(jupiter, cancer).
planetExaltation(saturn,  libra).

planetDetriment(Planet, Sign) :-
    planetDomicile(Planet, DomicileSign),
    zodiacSignOpposite(DomicileSign, Sign).
planetFall(Planet, Sign) :-
    planetExaltation(Planet, ExaltationSign),
    zodiacSignOpposite(ExaltationSign, Sign).

%planetSignDignity(Planet, Sign, Dignity).
planetSignDignity(Planet, Sign, domicile) :-
    planetDomicile(Planet, Sign).
planetSignDignity(Planet, Sign, exaltation) :-
    planetExaltation(Planet, Sign).
planetSignDignity(Planet, Sign, detriment) :-
    planetDetriment(Planet, Sign).
planetSignDignity(Planet, Sign, fall) :-
    planetFall(Planet, Sign).
planetSignDignity(Planet, Sign, none) :-
    \+ planetDomicile(Planet, Sign),
    \+ planetExaltation(Planet, Sign),
    \+ planetDetriment(Planet, Sign),
    \+ planetFall(Planet, Sign).

zodiacDecanDignity(Decan, Dignity) :-
    zodiacDecanPlanet(Decan, Planet),
    zodiacSignDecan(Sign, Decan),
    planetSignDignity(Planet, Sign, Dignity).

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
tarotNumberSuitPlanet(Number, Suit, Planet) :-
    isTarotNumber(Number),
    zodiacDecanPlanet(Decan, Planet),
    tarotNumberSuitDecan(Number, Suit, Decan).
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
%tarotTrumpPathOrder(TrumpPathScheme, PathOrder).
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

%tarotTrumpNames(TrumpNameScheme, NameOrder).
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
tarotTrumpNames(goldendawn, ['the fool', 
                             'the magician', 
                             'the high priestess', 
                             'the empress', 
                             'the emperor', 
                             'the hierophant',
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
                             'the blasted tower', 
                             'the star',
                             'the moon', 
                             'the sun', 
                             'judgement',
                             'the universe']).
tarotTrumpNames(marseilles, ['the fool', 
                             'the juggler', 
                             'the popess', 
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

tarotTrumpNumberName(TrumpNameScheme, TrumpNumber, Name) :-
    tarotTrumpNames(TrumpNameScheme, Names),
    nth0(TrumpNumber, Names, Name).

isTarotTrump(Number) :-
    betweenCheckInteger(0, 21, Number).
isTarotTrumpPathScheme(TrumpPathScheme) :-
    tarotTrumpPathOrder(TrumpPathScheme, _).

tarotTrumpPath(TrumpPathScheme, TrumpNumber, Path) :-
    isSefirotPath(Path),
    isTarotTrump(TrumpNumber),
    isTarotTrumpPathScheme(TrumpPathScheme),
    tarotTrumpPathOrder(TrumpPathScheme, Order),
    Idx is Path - 1,
    nth0(Idx, Order, TrumpNumber).

%TRUMP ZODIAC INFO
%tarotTrumpZodiacSign(TrumpId, Sign).
tarotTrumpZodiacSign(emperor,    aries).
tarotTrumpZodiacSign(hierophant, taurus).
tarotTrumpZodiacSign(lovers,     gemini).
tarotTrumpZodiacSign(chariot,    cancer).
tarotTrumpZodiacSign(strength,   leo).
tarotTrumpZodiacSign(hermit,     virgo).
tarotTrumpZodiacSign(justice,    libra).
tarotTrumpZodiacSign(death,      scorpio).
tarotTrumpZodiacSign(temperance, sagittarius).
tarotTrumpZodiacSign(devil,      capricorn).
tarotTrumpZodiacSign(star,       aquarius).
tarotTrumpZodiacSign(moon,       pisces).

%tarotTrumpZodiacPlanet(TrumpId, Planet).
tarotTrumpZodiacPlanet(magician,  mercury).
tarotTrumpZodiacPlanet(priestess, moon).
tarotTrumpZodiacPlanet(empress,   venus).
tarotTrumpZodiacPlanet(fortune,   jupiter).
tarotTrumpZodiacPlanet(tower,     mars).
tarotTrumpZodiacPlanet(sun,       sun).
tarotTrumpZodiacPlanet(world,  saturn).

%tarotTrumpElement(TrumpId, Element).
tarotTrumpElement(fool,      air).
tarotTrumpElement(hangedman, water).
tarotTrumpElement(judgement, fire).

%tarotTrumpOrder(Scheme, Order).
tarotTrumpOrder(rws,         [fool, magician, priestess, empress, emperor, hierophant, lovers, chariot, strength,
                             hermit, fortune, justice, hangedman, death, temperance, devil, tower, star,
                             moon, sun, judgement, world]).
tarotTrumpOrder(traditional, [fool, magician, priestess, empress, emperor, hierophant, lovers, chariot, justice,
                             hermit, fortune, strength, hangedman, death, temperance, devil, tower, star,
                             moon, sun, judgement, world]).

tarotTrumpNumberTrumpId(Scheme, TrumpNumber, TrumpId) :-
    tarotTrumpOrder(Scheme, TrumpOrder),
    nth0(TrumpNumber, TrumpOrder, TrumpId).
tarotTrumpNumberZodiacSign(Scheme, TrumpNumber, Sign) :-
    tarotTrumpNumberTrumpId(Scheme, TrumpNumber, TrumpId),
    tarotTrumpZodiacSign(TrumpId, Sign).
tarotTrumpNumberZodiacPlanet(Scheme, TrumpNumber, Planet) :-
    tarotTrumpNumberTrumpId(Scheme, TrumpNumber, TrumpId),
    tarotTrumpZodiacPlanet(TrumpId, Planet).
tarotTrumpNumberElement(Scheme, TrumpNumber, Element) :-
    tarotTrumpNumberTrumpId(Scheme, TrumpNumber, TrumpId),
    tarotTrumpElement(TrumpId, Element).

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
tarotNumberCardDecan([Suit, Number], Decan) :-
    tarotNumberSuitDecan(Number, Suit, Decan).

%TAROT INDICES
tarotMinotSuitOrderByIndex([wands, cups, swords, pentacles]).
tarotMinorValOrderByIndex([ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
                          princess, prince, queen, king]).

%tarotCardIndex([Suit, Val], Index).
tarotCardIndex([trump, Val], Index) :-
    betweenCheckInteger(1, 22, Index),
    isTarotTrump(Val),
    Index is Val + 1.
tarotCardIndex([Suit, Val], Index) :-
    betweenCheckInteger(23, 78, Index),
    tarotMinotSuitOrderByIndex(SuitOrder),
    tarotMinorValOrderByIndex(ValOrder),
    nth0(SuitIndex, SuitOrder, Suit),
    nth0(ValIndex, ValOrder, Val),
    Index is 23 + (SuitIndex * 14) + ValIndex.

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

tarotCardListStringList(CardList, StrList) :-
    maplist(tarotCardString, CardList, StrList).



%MISC
%TODO: organize
zodiacDecanList(List) :-
    rangeList(1, 36, List).
tarotListNumCardByDecan(List) :-
    zodiacDecanList(DecanList),
    maplist(tarotNumberCardDecan, List, DecanList).
zodiacQuadrantList(List) :-
    rangeList(1, 4, List).
tarotIndexList(List) :-
    rangeList(1, 78, List).
tarotListCardByIndex(List) :-
    tarotIndexList(IndexList),
    maplist(tarotCardIndex, List, IndexList).

tarotNumberCardZodiacDignity(Card, Dignity) :-
    tarotNumberCardDecan(Card, Decan),
    zodiacDecanDignity(Decan, Dignity).
tarotNumberCardZodiacSign(Card, Sign) :-
    tarotValSuitCard(Number, Suit, Card),
    tarotNumberSuitSign(Number, Suit, Sign).
tarotNumberCardZodiacPlanet(Card, Planet) :-
    tarotValSuitCard(Number, Suit, Card),
    tarotNumberSuitPlanet(Number, Suit, Planet).
tarotNumberCardZodiacPolarity(Card, Polarity) :-
    tarotNumberCardZodiacSign(Card, Sign),
    zodiacSignPolarity(Sign, Polarity).
tarotNumberCardZodiacModality(Card, Modality) :-
    tarotNumberCardZodiacSign(Card, Sign),
    zodiacSignModality(Sign, Modality).
tarotNumberCardZodiacTriplicity(Card, Triplicity) :-
    tarotNumberCardZodiacSign(Card, Sign),
    zodiacSignTriplicity(Sign, Triplicity).
tarotNumberCardZodiacInfo(Card, Sign, Planet, Polarity, Modality, 
                          Triplicity, Dignity) :-
    tarotNumberCardZodiacSign(Card, Sign),
    tarotNumberCardZodiacPlanet(Card, Planet),
    tarotNumberCardZodiacPolarity(Card, Polarity),
    tarotNumberCardZodiacModality(Card, Modality),
	tarotNumberCardZodiacTriplicity(Card, Triplicity),
    tarotNumberCardZodiacDignity(Card, Dignity).

tarotTrumpCardZodiacSign(TrumpOrderScheme, Card, Sign) :-
    tarotValSuitCard(TrumpNumber, trump, Card),
    tarotTrumpNumberZodiacSign(TrumpOrderScheme, TrumpNumber, Sign).
tarotTrumpCardZodiacPlanet(TrumpOrderScheme, Card, Planet) :-
    tarotValSuitCard(TrumpNumber, trump, Card),
    tarotTrumpNumberZodiacPlanet(TrumpOrderScheme, TrumpNumber, Planet).

tarotNumberCardZodiacTrumps(TrumpOrderScheme, Card, SignTrumpCard, PlanetTrumpCard) :-
    tarotNumberCardZodiacSign(Card, Sign),
    tarotNumberCardZodiacPlanet(Card, Planet),
    tarotTrumpCardZodiacSign(TrumpOrderScheme, SignTrumpCard, Sign),
    tarotTrumpCardZodiacPlanet(TrumpOrderScheme, PlanetTrumpCard, Planet).

tarotTrumpCardName(TrumpNameScheme, Card, Name) :-
    tarotValSuitCard(TrumpNumber, trump, Card),
    tarotTrumpNumberName(TrumpNameScheme, TrumpNumber, Name).




