USING: accessors arrays assocs chess.common-resource
combinators combinators.short-circuit fry kernel locals make
math math.order math.ranges random sequences sets ;
IN: chess.util


: xy>index ( x y -- i )
    [ 1 - ] bi@ 8 * + ;

: index>xy ( i -- x y )
    8 /mod [ 1 + ] bi@ ;

: position>index ( position -- i )
    [ x>> ] [ y>> ] bi xy>index ;

: last-1 ( seq -- elt ) [ length 2 - ] [ nth ] bi ; ! unsafe -- sequence must have atleast 2 items.

: final-row ( color -- n )
    {
        { +white+ [ 8 ] }
        { +black+ [ 1 ] }
    } case ;

: get-other-item ( item1 seq -- item2 )
    [ 1array ] dip diff first ;


: choose-colors ( -- white/black black/white )
    +white+ +black+ 2array
    dup random suffix members first2 ;


:: straight-line? ( pos1 pos2 -- ? )
    pos1 [ x>> ] [ y>> ] bi :> ( x1 y1 )
    pos2 [ x>> ] [ y>> ] bi :> ( x2 y2 )
    y2 y1 - abs :> dy
    x2 x1 - abs :> dx
    { [ dy 0 = ] [ dx 0 = ] [ dx dy = ] } 0|| ;

ERROR: not-a-straight-line ;



: positions[a,b] ( pos1 pos2 -- seq )
    2dup straight-line? [ not-a-straight-line ] unless
    [
        [ [ x>> ] bi@ [a,b] ]
        [ [ y>> ] bi@ [a,b] ]
    ] 2bi zip ; inline

: positions(a,b) ( pos1 pos2 -- seq )
    positions[a,b] rest but-last ; inline

! position [ 1 up ] until-blocked

: collect-until ( x pred quot -- xs )
    [
        [ [ dup ] prepose ] dip [ dup , ] compose until
    ] { } make ; inline

: collect-until- ( x pred quot -- xs )
    collect-until but-last ; inline

: road-clear? ( positions-seq -- ? )
    [ piece>> ] map sift empty? ;

: piece-color ( chess-position -- color )
    piece>> color>> ;

: piece-moved? ( piece -- ? )
    number-of-moves>> 0 > ;



: white? ( chess-position -- ? )
    piece-color +white+ = ;

: black? ( chess-position -- ? )
    piece-color +black+ = ;

: current-board ( -- board )
    GAME board>> ;

: get-board-cell ( calculated-position board -- actual-position/f )
    [ position>index ] dip ?nth ;

: calc>actual ( calculated-position -- actual-position/f )
    current-board get-board-cell ;

: positions ( color -- seq )
    [ current-board chess-positions>> ] dip '[ piece-color _ = ] filter ;



: opposite-color ( color -- other-color )
     { +white+ +black+ } get-other-item ;

: players ( -- player1 player2 )
    GAME [ player1>> ] [ player2>> ] bi ;

: opposite-player ( player -- other-player )
    players 2array get-other-item ;


: played-last ( -- color )
    GAME moves>> length 2 mod 1 = +white+ +black+ ? ;

! TODO: check usages to determine if game tuple can be simplified using played-last.
: player-after-move ( -- player )
    GAME who-played-last>> ;

: player-before-move ( -- player )
    GAME who-played-last>> opposite-player ;

: color>player ( color -- player )
    [ players 2array ] dip '[ color>> _ = ] filter first ;

: within-board-bounds ( positions -- positions' )
    [ [ x>> ] [ y>> ] bi [ 1 8 between? ] bi@ and ] filter ;

        

    