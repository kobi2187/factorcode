USING: accessors chess.engine fry io kernel locals  
prettyprint sequences ;
IN: chess.client

: print-board ( game -- )
    board>> 8 <groups> >array . ;


M: human request-move ( -- move )
    player-before-move [ name>> ] [ color>> ] bi
    "(" ")" surround " " glue ", " append print
    "Please enter your move" print
    readln ;

ERROR: promotion-invalid char ;

M: human choose-promotion ( -- char )
    "Please choose a promotion among [q]-queen, [r]-rook, [b]-bishop, [s]-knight" print
    readln >lower first
    dup "qrbs" member? [ promotion-invalid ] unless ;

: get-valid-move ( game -- move )
    '[ dup _ swap valid-move? [ print ] dip ] ! move ?
    [ drop request-move ] do until ;



: announce-result ( -- )
    "hooray, someone won!" print ;

: start-game ( -- )
    new-local-game
    dup '[
    [ _ over?>> ]
    [ _
        [ print-board ]
        [ get-valid-move add-move ]
        [ process-new-condition drop ] tri
    ] until
    ] call
    announce-result ;