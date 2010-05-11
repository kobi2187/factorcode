USING: chess.pgn-parser math sequences tools.test ;
IN: chess.pgn-parser.pgn-parser-tests

[ t ] [ "C:/downloads/chess-games/Adams.pgn" parse-pgn-file length 0 > ] unit-test
[ t ] [ "C:/downloads/chess-games/Alburt.pgn" parse-pgn-file length 0 > ] unit-test


