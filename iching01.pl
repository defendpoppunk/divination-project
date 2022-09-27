%iching01.pl
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

%TRIGRAM INFO
%trigramBasicInfo(Number, Lines, EnglishName, PinyinName, ChineseName).
%https://en.wikipedia.org/wiki/Bagua#Trigrams
trigramBasicInfo(1, [yang, yang, yang], 'the Creative',  'qián', '乾').
trigramBasicInfo(2, [yang, yang, yin ], 'the Joyous',    'duì',  '兌').
trigramBasicInfo(3, [yang, yin,  yang], 'the Clinging',  'lí',   '離').
trigramBasicInfo(4, [yang, yin,  yin ], 'the Arousing',  'zhèn', '震').
trigramBasicInfo(5, [yin,  yang, yang], 'the Gentle',    'xùn',  '巽').
trigramBasicInfo(6, [yin,  yang, yin ], 'the Abysmal',   'kǎn',  '坎').
trigramBasicInfo(7, [yin,  yin,  yang], 'Keeping Still', 'gèn',  '艮').
trigramBasicInfo(8, [yin,  yin,  yin ], 'the Receptive', 'kūn',  '坤').

isTrigramNumber(TriNum) :-
    betweenCheckInteger(1, 8, TriNum).

trigramLines(TriNum, Lines) :-
    trigramBasicInfo(TriNum, Lines, _, _, _).
trigramEnglishName(TriNum, EnglishName) :-
    trigramBasicInfo(TriNum, _, EnglishName, _, _).
trigramPinyinName(TriNum, PinyinName) :-
    trigramBasicInfo(TriNum, _, _, PinyinName, _).
trigramChineseName(TriNum, ChineseName) :-
    trigramBasicInfo(TriNum, _, _, _, ChineseName).
trigramCharacter(TriNum, Character) :-
    isTrigramNumber(TriNum),
    CharCode is 9775 + TriNum,
    char_code(Character, CharCode).

%HEXAGRAM INFO
%hexagramBasicInfo(Number, LowerTrigam, UpperTrigram, EnglishName, 
%                  PinyinName, ChineseName).
%https://en.wikipedia.org/wiki/Hexagram_(I_Ching)#Lookup_table
hexagramBasicInfo(01, 1, 1, 'Force',                 'qián',     '乾').
hexagramBasicInfo(43, 1, 2, 'Displacement',          'guài',     '夬').
hexagramBasicInfo(14, 1, 3, 'Great Possessing',      'dàyǒu',    '大有').
hexagramBasicInfo(34, 1, 4, 'Great Invigorating',    'dàzhuàng', '大壯').
hexagramBasicInfo(09, 1, 5, 'Small Harvest',         'xiǎoxù',   '小畜').
hexagramBasicInfo(05, 1, 6, 'Attending',             'xū',       '需').
hexagramBasicInfo(26, 1, 7, 'Great Accumulating',    'dàchù',    '大畜').
hexagramBasicInfo(11, 1, 8, 'Pervading',             'tài',      '泰').

hexagramBasicInfo(10, 2, 1, 'Treading',              'lǚ',       '履').
hexagramBasicInfo(58, 2, 2, 'Open',                  'duì',      '兌').
hexagramBasicInfo(38, 2, 3, 'Polarising',            'kuí',      '睽').
hexagramBasicInfo(54, 2, 4, 'Converting the Maiden', 'guīmèi',   '歸妹').
hexagramBasicInfo(61, 2, 5, 'Inner Truth',           'zhōngfú',  '中孚').
hexagramBasicInfo(60, 2, 6, 'Articulating',          'jié',      '節').
hexagramBasicInfo(41, 2, 7, 'Diminishing',           'sǔn',      '損').
hexagramBasicInfo(19, 2, 8, 'Nearing',               'lín',      '臨').

hexagramBasicInfo(13, 3, 1, 'Concording People',     'tóngrén',  '同人').
hexagramBasicInfo(49, 3, 2, 'Skinning',              'gé',       '革').
hexagramBasicInfo(30, 3, 3, 'Radiance',              'lí',       '離').
hexagramBasicInfo(55, 3, 4, 'Abounding',             'fēng',     '豐').
hexagramBasicInfo(37, 3, 5, 'Dwelling People',       'jiārén',   '家人').
hexagramBasicInfo(63, 3, 6, 'Already Fording',       'jìjì',     '既濟').
hexagramBasicInfo(22, 3, 7, 'Adorning',              'bì',       '賁').
hexagramBasicInfo(36, 3, 8, 'Intelligence Hidden',   'míngyí',   '明夷').

hexagramBasicInfo(25, 4, 1, 'Innocence',             'wúwàng',   '無妄').
hexagramBasicInfo(17, 4, 2, 'Following',             'suí',      '隨').
hexagramBasicInfo(21, 4, 3, 'Gnawing Bite',          'shìhé',    '噬嗑').
hexagramBasicInfo(51, 4, 4, 'Shake',                 'zhèn',     '震').
hexagramBasicInfo(42, 4, 5, 'Augmenting',            'yì',       '益').
hexagramBasicInfo(03, 4, 6, 'Sprouting',             'zhūn',     '屯').
hexagramBasicInfo(27, 4, 7, 'Swallowing',            'yí',       '頤').
hexagramBasicInfo(24, 4, 8, 'Returning',             'fù',       '復').

hexagramBasicInfo(44, 5, 1, 'Coupling',              'gòu',      '姤').
hexagramBasicInfo(28, 5, 2, 'Great Exceeding',       'dàguò',    '大過').
hexagramBasicInfo(50, 5, 3, 'Holding',               'dǐng',     '鼎').
hexagramBasicInfo(32, 5, 4, 'Persevering',           'héng',     '恆').
hexagramBasicInfo(57, 5, 5, 'Ground',                'xùn',      '巽').
hexagramBasicInfo(48, 5, 6, 'Welling',               'jǐng',     '井').
hexagramBasicInfo(18, 5, 7, 'Correcting',            'gǔ',       '蠱').
hexagramBasicInfo(46, 5, 8, 'Ascending',             'shēng',    '升').

hexagramBasicInfo(06, 6, 1, 'Arguing',               'sòng',     '訟').
hexagramBasicInfo(47, 6, 2, 'Confining',             'kùn',      '困').
hexagramBasicInfo(64, 6, 3, 'Before Completion',     'wèijì',    '未濟').
hexagramBasicInfo(40, 6, 4, 'Deliverance',           'jiě',      '解').
hexagramBasicInfo(59, 6, 5, 'Dispersing',            'huàn',     '渙').
hexagramBasicInfo(29, 6, 6, 'Gorge',                 'kǎn',      '坎').
hexagramBasicInfo(04, 6, 7, 'Enveloping',            'méng',     '蒙').
hexagramBasicInfo(07, 6, 8, 'Leading',               'shī',      '師').

hexagramBasicInfo(33, 7, 1, 'Retiring',              'dùn',      '遯').
hexagramBasicInfo(31, 7, 2, 'Conjoining',            'xián',     '咸').
hexagramBasicInfo(56, 7, 3, 'Sojourning',            'lǚ',       '旅').
hexagramBasicInfo(62, 7, 4, 'Small Exceeding',       'xiǎoguò',  '小過').
hexagramBasicInfo(53, 7, 5, 'Infiltrating',          'jiàn',     '漸').
hexagramBasicInfo(39, 7, 6, 'Limping',               'jiǎn',     '蹇').
hexagramBasicInfo(52, 7, 7, 'Bound',                 'gèn',      '艮').
hexagramBasicInfo(15, 7, 8, 'Humbling',              'qiān',     '謙').

hexagramBasicInfo(12, 8, 1, 'Obstruction',           'pǐ',       '否').
hexagramBasicInfo(45, 8, 2, 'Clustering',            'cuì',      '萃').
hexagramBasicInfo(35, 8, 3, 'Prospering',            'jìn',      '晉').
hexagramBasicInfo(16, 8, 4, 'Providing-For',         'yù',       '豫').
hexagramBasicInfo(20, 8, 5, 'Viewing',               'guàn',     '觀').
hexagramBasicInfo(08, 8, 6, 'Grouping',              'bǐ',       '比').
hexagramBasicInfo(23, 8, 7, 'Stripping',             'bāo',      '剝').
hexagramBasicInfo(02, 8, 8, 'Field',                 'kūn',      '坤').

isHexagramNumber(HexNum) :-
    betweenCheckInteger(1, 64, HexNum).

hexagramTrigrams(HexNum, LowerTriNum, UpperTriNum) :-
    hexagramBasicInfo(HexNum, LowerTriNum, UpperTriNum, _, _, _).
hexagramEnglishName(HexNum, EnglishName) :-
    hexagramBasicInfo(HexNum, _, _, EnglishName, _, _).
hexagramPinyinName(HexNum, PinyinName) :-
    hexagramBasicInfo(HexNum, _, _, _, PinyinName, _).
hexagramChineseName(HexNum, ChineseName) :-
    hexagramBasicInfo(HexNum, _, _, _, _, ChineseName).
hexagramCharacter(HexNum, Character) :-
    isHexagramNumber(HexNum),
    CharCode is 19903 + HexNum,
    char_code(Character, CharCode).

%lineProbabilities(Method, OldYinProb, YoungYinProb, OldYangProb, 
%                  YoungYangProb).
%https://en.wikipedia.org/wiki/I_Ching_divination
lineProbabilities(coins, 2, 6, 2, 6).
lineProbabilities(stalks, 1, 7, 3, 5).
lineProbabilities(card, 0, 8, 0, 8).

randomLine(Method, Line) :-
    lineProbabilities(Method, OldYinProb, YoungYinProb, OldYangProb, _),
    random_between(1, 16, RandVal),
    (   
        (   
            RandVal =< OldYinProb,
            Line = oldyin
        );
        (   
            RandVal > OldYinProb,
            RandVal =< OldYinProb + YoungYinProb,
            Line = youngyin
        );
        (   
            RandVal > OldYinProb + YoungYinProb,
            RandVal =< OldYinProb + YoungYinProb + OldYangProb,
            Line = oldyang
        );
        (   
            RandVal > OldYinProb + YoungYinProb + OldYangProb,
            Line = youngyang
        )
    ).

randomHexagramLines(Method, HexagramLines) :-
    randomLine(Method, Line1),
    randomLine(Method, Line2),
    randomLine(Method, Line3),
    randomLine(Method, Line4),
    randomLine(Method, Line5),
    randomLine(Method, Line6),
    HexagramLines = [Line1, Line2, Line3, Line4, Line5, Line6].

hexagramCastLineStaticLine(CastLine, StaticLine) :-
    nth0(Index, [oldyin, youngyin, oldyang, youngyang], CastLine),
    nth0(Index, [yin, yin, yang, yang], StaticLine).
hexagramCastLineTransformedLine(CastLine, TransformedLine) :-
    nth0(Index, [oldyin, youngyin, oldyang, youngyang], CastLine),
    nth0(Index, [youngyang, youngyin, youngyin, youngyang], TransformedLine).

hexagramTrigramLines([Line1, Line2, Line3, Line4, Line5, Line6], 
                     [Line1, Line2, Line3], [Line4, Line5, Line6]).
    

