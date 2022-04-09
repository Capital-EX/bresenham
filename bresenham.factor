! Copyright (C) 2022 Capital Ex.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays combinators fry io kernel locals math math.parser
math.vectors namespaces ranges sequences sequences.deep
sequences.generalizations ;
IN: bresenham

<PRIVATE

: (?reverse-iter) ( i n -- -i? -n? )
   dup 0 < [ [ neg ] bi@ ] when ; inline 

: ?reverse-iter ( iter -- iter )
    dup [ first2 (?reverse-iter) ] [ 2 set-firstn ] bi ;

: <bresenham-iter> ( p0 p1 -- bresenham-iter )
    swap [ - ] 2map { 1 } prepend ?reverse-iter ;

: >y0,y1 ( p0 p1 -- y0 y1 )
    [ second ] bi@ ; inline

: last2 ( seq -- 2nd-last 1st-last ) 
    2 tail* first2 ;

: lo-or-hi? ( p0 p1 -- ? )
    vs- vabs [ second ] [ first ] bi < ;

: compute-d ( d0 d1 -- d )
    [ 2 * ] [ - ] bi* ;

: next-d ( bresenham-iter d -- d' )
    dup 0 > 
    [ [ last2 - ] [ neg compute-d ] bi* ] 
    [ [ second  ] [ neg compute-d ] bi* ] if ;

: next-x ( x bresenham-iter d -- x' )
    0 > [ first + ] [ drop ] if ;

:: next-plot ( d x bresenham-iter -- d x'  )
    bresenham-iter d next-d x bresenham-iter d next-x ;

:: compute-point ( d x y bresenham-iter -- d' x' {x,y} )
     d x bresenham-iter next-plot x y 2array ;

:: d ( _ _ bresenham-iter -- d )
    bresenham-iter last2 compute-d ;

:: start-point ( p0 _ _ -- start-point )
    p0 first ;

:: stride ( p0 p1 _ -- stride )
    p0 p1 >y0,y1 [a..b] ;

:: point-generator ( _ _ bresenham-iter -- quot )
    [ bresenham-iter compute-point ] ;

: (setup-bresenham) ( p0 p1 -- d start-point stride quot  )
    2dup <bresenham-iter> { 
        [ d ] [ start-point ] [ stride ] [ point-generator ]
    } 3cleave ;

: ?reverse-components ( xy0 xy1 -- ?yx0 ?yx1 )
    2dup lo-or-hi? [ [ reverse ] bi@ ] when ;

: setup-bresenham ( p0 p1 -- d start-point stride quot ) 
    2dup >y0,y1 > [ swap ] when (setup-bresenham) ;

: ?reverse-each-xy ( quot p0 p1 -- quot' )
    lo-or-hi? [ [ reverse ] compose ] when ;

: compute-bresenham ( d start-point stride quot -- points )
    '[ _ call( x x x -- x x x ) ] map 2nip ;

PRIVATE>

: bresenham ( p0 p1 -- points )
    [ ?reverse-components setup-bresenham ] 
    [ ?reverse-each-xy compute-bresenham ] 2bi ;
