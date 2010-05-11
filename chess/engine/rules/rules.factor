USING: accessors arrays kernel math math.vectors   sequences shuffle
chess.common-resource chess.queries
chess.engine.move chess.engine.piece.targets
chess.engine.movement
chess.util ;

IN: chess.engine.rules

! castling:

! castling is only allowed if king hasn't moved, if relevant rook hasn't moved,
! and if the road between them is clear.
: castling-allowed? ( king rook -- ? )
    [
        [ piece-moved? not ] bi@ and  ! both haven't yet moved
        [ positions(a,b) road-clear? ] ! road is clear between them
        ! and third: the road is not threatened. TODO
    ] 2bi and ;

: right-castling-allowed? ( player -- ? )
    [ get-king ] [ right-rook ] bi castling-allowed? ;

: left-castling-allowed? ( player -- ? )
    [ get-king ] [ left-rook ] bi castling-allowed? ;



: right-castling-target ( player -- target-pos )
    color>> +white+ = 7 1 <position> 3 8 <position> ? ; ! g1 or c8
: left-castling-target ( player -- target-pos )
    color>> +white+ = 3 1 <position> 7 8 <position> ? ; ! c1 or g8
: castling-src ( player -- target-pos )
    color>> +white+ = 5 1 <position> 5 8 <position> ? ; ! g1 or c8

: right-castling-move ( player -- move )
    [ castling-src ] [ right-castling-target ] bi <move> ;

: left-castling-move ( player -- move )
    [ castling-src ] [ left-castling-target ] bi <move> ;

: double-move? ( move -- ? )
    [ piece>> pawn? ]
    [
        [ from>> ] [ to>> ] bi  [ y>> ] bi@ - abs 2 =
    ] bi and ;

ERROR: you-can't-have-half-cells-as-position ;

: middle-position ( pos1 pos2 -- pos )
    [ [ x>> ] [ y>> ] bi 2array ] bi@ vavg ! { 5 2 } { 5 4 } -> { 5 3 }
    dup [ integer? ] all? [ you-can't-have-half-cells-as-position ] unless
    first2 <position> ;

: enpassant-location ( -- target/f )
    GAME moves>> last dup double-move?  ! is the last move a double move?
    [
        [ from>> ] [ to>> ] bi middle-position
    ] [ drop f ] if ;
    
! TODO fix this, according to the simpler pawn solution that I implemented.
: maybe-enpassant ( my-position -- enpassant/f )
    enpassant-location dup !    was there an enpassant move?  my-pos position/f
    [
        tuck reachable? [ drop f ] unless   ! if reachable -> enpassant-pos, otherwise f.
    ] [ 2drop f ] if  ;