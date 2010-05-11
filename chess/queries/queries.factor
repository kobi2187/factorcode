USING: 
chess.common-resource chess.util
chess.engine.piece.targets

accessors combinators fry kernel sequences ;
IN: chess.queries

! ============== piece queries =================

: all-player-pieces ( player -- positions )
    color>> positions ;

: get-pieces ( player predicate: ( pos -- ? )  -- positions )
    [ all-player-pieces ] dip '[ piece>> @ ] filter ; inline

: get-king ( player -- king-pos )
    [ king? ] get-pieces first ;

: get-pawns ( player -- pawns-pos )
    [ pawn? ] get-pieces ;
    
: get-rooks ( player -- rooks-pos )
    [ rook? ] get-pieces ;

: right-rook  ( player -- rook-pos )
    get-rooks [ piece>> initial-xy>> [ { 1 8 } = ] [ { 8 1 } = ] bi or ] filter first ;
    
: left-rook  ( player -- rook-pos )
    get-rooks [ piece>> initial-xy>> [ { 1 1 } = ] [ { 8 8 } = ] bi or ] filter first ;

! ========== game related queries ===============
: whose-turn ( -- white/black ) ! TODO: simplify by using game moves length. (not sure this word is even used.)
    GAME who-played-last>> 
    {
        { f       [ +white+ ] } ! game begins
        { +black+ [ +white+ ] } ! black -> white
        { +white+ [ +black+ ] } ! white -> black
    } case ;




: reachable? ( attacker-pos attacked-pos -- ? )   
    swap valid-targets member? ;    
    