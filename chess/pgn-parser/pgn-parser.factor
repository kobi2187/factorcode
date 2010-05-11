USING: accessors arrays fry general-utils grouping hashtables
io.encodings.utf8 io.files kernel math regexp sequences
splitting strings ;
IN: chess.pgn-parser

! pgn manual parser 
! from pgn text to pgn-game object.
! enbf might be much easier, just don't know how to program pegs yet

: filter-index ( seq pred: ( item -- ? ) -- seq' )
    '[ @ [ drop f ] unless ] map-index sift ; inline

TUPLE: pgn-game meta-info moves score ;

: <pgn-game> ( moves score -- pgn-game )
    pgn-game new 
    swap >>score
    swap >>moves ;

: parse-moves ( move-text -- moves )    
    R/ \s?\d+\./ re-split harvest [ >string ] map ;
    
: meta-info ( text -- hash )
    R/ \[.*\]/ all-matching-subseqs 
    [ rest but-last " " split1 
        [ CHAR: " = ] trim [ f ] when-empty    2array
    ] map >hashtable ;

: moves-and-score ( text -- moves score )
    "  " split1 [ parse-moves ] dip ;

: double-line-split ( text -- slices )
    R/ (\r\n|\n){2}/ re-split ;
    
    
: parse-pgn ( text -- pgn-game )
    "\n\n" split1
    [ meta-info ] [ moves-and-score ] bi* <pgn-game> swap >>meta-info ;

    
! for parsing files with many pgn's:
    
: pgn-pairs ( text -- pairs )    ! pairs of meta-info and moves.
    double-line-split
    dup length odd? [ rest ] when 2 <groups> ;

: pair>pgn ( pair -- 1-pgn-text ) ! make them into one pgn, which we know how to parse.
    first2 "\n\n" glue trim-spaces ;
    
: parse-pgns ( alltext -- pgn-games )
    pgn-pairs [ pair>pgn ] map
    [ parse-pgn ] map ;
    
: parse-pgn-file ( file-path -- pgn-games )
    utf8 file-contents parse-pgns ;
    
    
    