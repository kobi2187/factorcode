USING: accessors arrays chess.common-resource chess.engine.move
chess.engine.movement chess.engine.rules chess.queries
chess.util combinators combinators.smart fry kernel math
sequences unicode.case ;
IN: chess.engine.piece





: <pawn>    ( -- pawn ) pawn new ;
: <king>    ( -- king ) king new ;
: <queen>   ( -- queen ) queen new ;
: <bishop>  ( -- bishop ) bishop new ;
: <rook>    ( -- rook ) rook new ;
: <knight>  ( -- knight ) knight new ;


ERROR: unknown-piece char ;

: (char>piece) ( char -- piece )
    >lower
    {
        { [ dup CHAR: p = ] [ drop <pawn> ]   }
        { [ dup CHAR: k = ] [ drop <king> ]   }
        { [ dup CHAR: r = ] [ drop <rook> ]   }
        { [ dup CHAR: s = ] [ drop <knight> ] }
        { [ dup CHAR: b = ] [ drop <bishop> ] }
        { [ dup CHAR: q = ] [ drop <queen> ]  }
        { [ dup CHAR: - = ] [ drop f ]  } ! empty spot
        [ unknown-piece ]
    } case ;

: char>piece ( char -- piece )
! character determines color and piece type.
    [ upper? [ +black+ ] [ +white+ ] if ] keep ! -- color char
    (char>piece) ! color piece
    dup [ swap >>color ] [ 2drop f ] if ;

: sift-same-color ( positions color -- positions' )
    over empty? [ drop ] [
        '[ piece-color _ = not ] filter
    ] if ;

: empty-cell? ( chess-position -- ? )
    piece>> f = ;
: until-blocked ( position quot -- positions )
    [ calc>actual dup
            [ empty-cell? ]   ! move until this condition doesn't hold.
            [ drop f ] if
    ] ! board bounds are an f position, then we check for an f piece.
    swap collect-until ;


: until-blocked- ( position quot -- positions )
    until-blocked but-last ;

: first-move? ( piece -- ? )
    number-of-moves>> 0 = ;

: opposite-colored-piece? ( orig-pos target-pos -- ? )
    [ piece-color ] bi@ opposite-color = ;



: positions>moves ( src targets -- moves )
    [ <move> ] with map ;

: piece's-valid-moves ( piece -- moves )
    valid-targets positions>moves ;

: walk-targets ( piece -- seq )
    valid-targets [ piece>> f = ] filter ;

: walk-moves ( piece -- seq )
    walk-targets positions>moves ;

: eat-targets ( piece -- seq )
    [ valid-targets ] keep color>> opposite-color '[ piece-color _ = ] filter ;

: eat-moves ( piece -- seq )
    eat-targets positions>moves ;



