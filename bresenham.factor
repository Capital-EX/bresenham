! Copyright (C) 2022 Capital Ex.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fry io kernel math math.parser namespaces ranges
sequences sequences.deep syntax locals ;
IN: bresenham

<PRIVATE

: >x0,x1 ( p0 p1 -- x0 x1 )
    [ first ] bi@ ; inline

: >y0,y1 ( p0 p1 -- y0 y1 )
    [ second ] bi@ ; inline

: reverse-line? ( yi dy -- -yi? -dy? )
   dup 0 < [ [ neg ] bi@ ] when ; inline 

:: (plot-line-lo) ( x0 y0 x1 y1 -- points )
    x1 x0 y1 y0 [ - ] 2bi@ 
        :> dy :> dx
    1 dy reverse-line?
        :> dy :> yi
    dy 2 * dx - :> D!
    y0          :> y! 
    x0 x1 [a..b] [
        y 2array
        D 0 > [ y yi + D 2 dy dx - * + ]  [ y D 2 dy * + ] if
        D! y!
    ] map ;

:: (plot-line-hi) ( x0 y0 x1 y1 -- seq )
    x1 x0 y1 y0 [ - ] 2bi@ 
        :> dy :> dx
    1 dx reverse-line? 
        :> dx :> xi
    dx 2 * dy - :> D! 
    x0          :> x! 
    y0 y1 [a..b] [
        x swap 2array
        D 0 > [ x xi + D 2 dx dy - * + ]  [ x D 2 dx * + ] if
        D! x!
    ] map ;

: plot-line-lo ( u v -- seq )
    [ first2 ] bi@ (plot-line-lo) ;

: plot-line-hi ( u v -- seq )
    [ first2 ] bi@ (plot-line-hi) ;

: lo-or-hi? ( u v -- ? )
    [ >y0,y1 - abs ] [ >x0,x1 - abs ] 2bi < ;

: plot-hi ( u v -- points )
    2dup >y0,y1 > [ swap plot-line-hi ] [ plot-line-hi ] if ;

: plot-lo ( u v -- points )
    2dup >x0,x1 > [ swap plot-line-lo ] [ plot-line-lo ] if ;

PRIVATE>

: bresenham ( u v -- points )
    2dup lo-or-hi? [ plot-lo ] [ plot-hi ] if ; 