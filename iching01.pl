%hexagramBasicInfo(Number, LowerTrigam, UpperTrigram, EnglishName, 
%                  PinyinName, ChineseName).
hexagramBasicInfo(01, 1, 1, 'Force', 'qián', '乾').
hexagramBasicInfo(43, 1, 2, 'Displacement', 'guài', '夬').
hexagramBasicInfo(14, 1, 3, 'Great Possessing', 'dàyǒu', '大有').
hexagramBasicInfo(34, 1, 4, 'Great Invigorating', 'dàzhuàng', '大壯').
hexagramBasicInfo(09, 1, 5, 'Small Harvest', 'xiǎoxù', '小畜').
hexagramBasicInfo(05, 1, 6, 'Attending', 'xū', '需').
hexagramBasicInfo(26, 1, 7, 'Great Accumulating', 'dàchù', '大畜').
hexagramBasicInfo(11, 1, 8, 'Pervading', 'tài', '泰').
hexagramBasicInfo(10, 2, 1, '', '', '履').
hexagramBasicInfo(58, 2, 2, '', '', '兌').
hexagramBasicInfo(38, 2, 3, '', '', '睽').
hexagramBasicInfo(54, 2, 4, '', '', '歸妹').
hexagramBasicInfo(61, 2, 5, '', '', '中孚').
hexagramBasicInfo(60, 2, 6, '', '', '節').
hexagramBasicInfo(41, 2, 7, '', '', '損').
hexagramBasicInfo(19, 2, 8, '', '', '臨').
hexagramBasicInfo(13, 3, 1, '', '', '同人').
hexagramBasicInfo(49, 3, 2, '', '', '革').
hexagramBasicInfo(30, 3, 3, '', '', '離').
hexagramBasicInfo(55, 3, 4, '', '', '豐').
hexagramBasicInfo(37, 3, 5, '', '', '家人').
hexagramBasicInfo(63, 3, 6, '', '', '既濟').
hexagramBasicInfo(22, 3, 7, '', '', '賁').
hexagramBasicInfo(36, 3, 8, '', '', '明夷').
hexagramBasicInfo(25, 4, 1, '', '', '無妄').
hexagramBasicInfo(17, 4, 2, '', '', '隨').
hexagramBasicInfo(21, 4, 3, '', '', '噬嗑').
hexagramBasicInfo(51, 4, 4, '', '', '震').
hexagramBasicInfo(42, 4, 5, '', '', '益').
hexagramBasicInfo(03, 4, 6, 'Sprouting', 'zhūn', '屯').
hexagramBasicInfo(27, 4, 7, '', '', '頤').
hexagramBasicInfo(24, 4, 8, '', '', '復').
hexagramBasicInfo(44, 5, 1, '', '', '姤').
hexagramBasicInfo(28, 5, 2, '', '', '大過').
hexagramBasicInfo(50, 5, 3, '', '', '鼎').
hexagramBasicInfo(32, 5, 4, '', '', '恆').
hexagramBasicInfo(57, 5, 5, '', '', '巽').
hexagramBasicInfo(48, 5, 6, '', '', '井').
hexagramBasicInfo(18, 5, 7, '', '', '蠱').
hexagramBasicInfo(46, 5, 8, '', '', '升').
hexagramBasicInfo(06, 6, 1, '', '', '訟').
hexagramBasicInfo(47, 6, 2, '', '', '困').
hexagramBasicInfo(64, 6, 3, '', '', '未濟').
hexagramBasicInfo(40, 6, 4, '', '', '解').
hexagramBasicInfo(59, 6, 5, '', '', '渙').
hexagramBasicInfo(29, 6, 6, '', '', '坎').
hexagramBasicInfo(04, 6, 7, '', '', '蒙').
hexagramBasicInfo(07, 6, 8, '', '', '師').
hexagramBasicInfo(33, 7, 1, '', '', '遯').
hexagramBasicInfo(31, 7, 2, '', '', '咸').
hexagramBasicInfo(56, 7, 3, '', '', '旅').
hexagramBasicInfo(62, 7, 4, '', '', '小過').
hexagramBasicInfo(53, 7, 5, '', '', '漸').
hexagramBasicInfo(39, 7, 6, '', '', '蹇').
hexagramBasicInfo(52, 7, 7, '', '', '艮').
hexagramBasicInfo(15, 7, 8, '', '', '謙').
hexagramBasicInfo(12, 8, 1, '', '', '否').
hexagramBasicInfo(45, 8, 2, '', '', '萃').
hexagramBasicInfo(35, 8, 3, '', '', '晉').
hexagramBasicInfo(16, 8, 4, '', '', '豫').
hexagramBasicInfo(20, 8, 5, '', '', '觀').
hexagramBasicInfo(08, 8, 6, '', '', '比').
hexagramBasicInfo(23, 8, 7, '', '', '剝').
hexagramBasicInfo(02, 8, 8, 'Field', 'kūn', '坤').

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

randomHexagram(Method, Hexagram) :-
    randomLine(Method, Line1),
    randomLine(Method, Line2),
    randomLine(Method, Line3),
    randomLine(Method, Line4),
    randomLine(Method, Line5),
    randomLine(Method, Line6)
    Hexagram = [Line1, Line2, Line3, Line4, Line5, Line6].

hexagramTrigrams([Line1, Line2, Line3, Line4, Line5, Line6], 
                   [Line1, Line2, Line3],  [Line4, Line5, Line6]).
