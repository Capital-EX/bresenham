! Copyright (C) 2022 Capital Ex.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays combinators fry io kernel locals math math.parser
namespaces ranges sequences sequences.deep
sequences.generalizations ;
IN: bresenham

<PRIVATE

: (?reverse-iter) ( i n -- -i? -n? )
   dup 0 < [ [ neg ] bi@ ] when ; inline 

: ?reverse-iter ( iter -- iter )
    dup [ first2 (?reverse-iter) ] [ 2 set-firstn ] bi ;

: <bresenham-iter> ( p0 p1 -- bresenham-iter )
    swap [ - ] 2map { 1 } prepend ?reverse-iter ;

: >x0,x1 ( p0 p1 -- x0 x1 )
    [ first ] bi@ ; inline

: >y0,y1 ( p0 p1 -- y0 y1 )
    [ second ] bi@ ; inline

: last2 ( seq -- 2nd-last 1st-last ) 
    2 tail* first2 ;

: lo-or-hi? ( p0 p1 -- ? )
    [ >y0,y1 - abs ] [ >x0,x1 - abs ] 2bi < ;

: (compute-d) ( d0 d1 -- d )
    [ 2 * ] [ - ] bi* ;

: compute-d ( bresenham-iter -- d )
    last2 (compute-d) ;

: (next-d) ( d bresenham-iter -- d' )
    swap dup 0 > 
    [ [ last2 - ] [ neg (compute-d) ] bi* ] 
    [ [ second  ] [ neg (compute-d) ] bi* ] if ;

: next-d ( d x|y bresenham-iter -- d' )
    nip (next-d) ;

: (next-x|y) ( x|y bresenham-iter d -- x'|y' )
    0 > [ first + ] [ drop ] if ;

: next-x|y ( d x|y bresenham-iter -- 'x|y' )
    pick (next-x|y) nip ;

: next-plot ( d x|y bresenham-iter -- d x'|y'  )
    [ next-d ] [ next-x|y ] 3bi ;

: (compute-point) ( d x|y y|x bresenham-iter -- d' x'|y' {x,y} )
    '[ drop _ next-plot ] [ 2array nip ] 3bi ;

: d ( _ _ bresenham-iter -- d )
    2nip compute-d

: start-point ( p0 _ _ -- start-point )
     2drop first

: stride ( p0 p1 _ -- stride )
     drop >y0,y1 [a..b]

: compute-point ( _ _ bresenham-iter -- quot )
    2nip '[ _ (compute-point) ]

: (setup-bresenham) ( p0 p1 -- d start-point stride quot  )
    2dup <bresenham-iter> { 
        [ d ] [ start-point ] [ stride ] [ compute-point ]
    } 3cleave ;

: ?reverse-components ( p0 p1 -- p0' p1' )
    2dup lo-or-hi? [ [ reverse ] bi@ ] when ;

: setup-bresenham ( u v -- d start-point [a..b] quot ) 
    2dup >y0,y1 > [ swap ] when (setup-plot) ;

: ?reverse-each-xy ( quot p0 p1 -- quot )
    lo-or-hi? [ [ reverse ] compose ] when ;

: compute-bresenham ( d start-point [a..b] quot -- points )
    '[ _ call( x x x -- x x x ) ] map 2nip ;

PRIVATE>



!
! I have no idea why I went through the trouble of writing
! bresenham like this, but I did. This was very hard to write.
! 

: bresenham ( u v -- points )
    [ ?reverse-components setup-bresenham ] 
    [ ?reverse-each-xy compute-bresenham ] 2bi ;

