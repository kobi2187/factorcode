USING: accessors chess.common-resource chess.engine.movement
combinators.short-circuit fry kernel lexer math math.parser
math.ranges prettyprint strings ;
FROM: sequences => first second third fourth length member?
first4 suffix! ;
IN: chess.engine.move



: <move> ( src target -- move )
    move new
    swap >>to
    swap >>from ;

! TODO: add MOVE: e2e4 style commands. validation and converting to move tuple.

ERROR: bad-move-syntax input-string ;
: move-syntax-ok? ( string -- ? )
    {
        [ length 4 = ]
        [
            [ first  ] [ third ] bi CHAR: a CHAR: h [a,b] '[ _ member? ] bi@ and
        ]
        [
            [ second ] [ fourth ] bi [ 1string string>number ] bi@ 8 [1,b] '[ _ member? ] bi@ and
        ]
    } 1&& ;

: (make-a-move) ( ok-string -- move )
    first4 swapd [ [ 96 - ] bi@ ] [ [ 48 - ] bi@ ] 2bi* swapd
    [ <position> ] 2bi@ <move> ;

: >move ( string -- move/* )
    dup move-syntax-ok? [ (make-a-move) ] [ bad-move-syntax ] if ;

SYNTAX: MOVE: scan >move suffix! ; ! TODO: does it work?!
