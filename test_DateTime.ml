open OUnit
open Printf
open DateTime

let start_of_unix  = of_time 0.
let start_of_unix' = of_utc 1970 1 1 0 0 0.

let t1  = of_utc   2013 06 05 06 15 0. 
let t1' = of_local 2013 06 05 10 15 0.
let t2  = of_utc   2013 02 05 06 15 0. 
let t2' = of_local 2013 02 05 10 15 0.
let t3  = of_utc   2011 02 05 06 15 0. 
let t3' = of_local 2011 02 05 09 15 0.
let t4  = of_utc   2011 06 04 22 15 0. 
let t4' = of_local 2011 06 05 02 15 0.

let d1  = of_utc    2013 06 05 00 00 0. 
let d1' = start_of_day UTC t1

let d2t = of_utc    2013 06 05 02 00 0. 
let d2s = start_of_day UTC d2t
let d2e = of_utc    2013 06 05 00 00 0. 

let d3t = of_utc    2013 06 05 22 00 0. 
let d3s = start_of_day UTC d3t
let d3e = of_utc    2013 06 05 00 00 0. 

let d4t = of_local    2013 06 05 02 00 0. 
let d4s = start_of_day Local d4t
let d4e = of_local    2013 06 05 00 00 0. 

let d5t = of_local    2013 06 05 22 00 0. 
let d5s = start_of_day Local d5t
let d5e = of_local    2013 06 05 00 00 0. 


let d6t = create (UTC_ 2)    2013 06 05 02 00 0. 
let d6s = start_of_day (UTC_ 2) d6t
let d6e = create (UTC_ 2)    2013 06 05 00 00 0. 

let d7t = create (UTC_ 2)    2013 06 05 22 00 0. 
let d7s = start_of_day (UTC_ 2) d7t
let d7e = create (UTC_ 2)   2013 06 05 00 00 0. 


let d8t = create (UTC_ ~-2)    2013 06 05 02 00 0. 
let d8s = start_of_day (UTC_ ~-2) d8t
let d8e = create (UTC_ ~-2)    2013 06 05 00 00 0. 

let d9t = create (UTC_ ~-2)    2013 06 05 22 00 0. 
let d9s = start_of_day (UTC_ ~-2) d9t
let d9e = create (UTC_ ~-2)    2013 06 05 00 00 0. 

let h2  = duration d2s d2t /. 3600.
let h2' = 2.

let h3  = duration d3s d3t /. 3600.
let h3' = 22.

let h4  = duration d4s d4t /. 3600.
let h4' = 2.

let h5  = duration d5s d5t /. 3600.
let h5' = 22.


let h6  = duration d6s d6t  /. 3600.
let h6' = 2.

let h7  = duration d7s d7t /. 3600.
let h7' = 22.

let h8  = duration d8s d8t  /. 3600.
let h8' = 2.

let h9  = duration d9s d9t /. 3600.
let h9' = 22.


let suite =
  "DateTime ">::: [
    "of_utc" >:: 
      (fun () -> assert_equal start_of_unix start_of_unix');
    "local(msk) vs. utc (current summer time)" >::
      (fun () -> assert_equal t1 t1');
    "local(msk) vs. utc (current «winter» time)" >::
      (fun () -> assert_equal t2 t2');
    "local(msk) vs. utc (premedeved «winter» time)" >::
      (fun () -> assert_equal t3 t3');
    "local(msk) vs. utc (premedeved summer time)" >::
      (fun () -> assert_equal t4 t4');
    "start of day/1" >::
      (fun () -> assert_equal d1 d1');
    "start of day/2" >::
      (fun () -> assert_equal d2s d2e);
    "start of day/3" >::
      (fun () -> assert_equal d3s d3e);
    "start of day/4" >::
      (fun () -> assert_equal d4s d4e);
    "start of day/5" >::
      (fun () -> assert_equal d5s d5e);
    "start of day/6" >::
      (fun () -> assert_equal d6s d6e);
    "start of day/7" >::
      (fun () -> assert_equal d7s d7e);
    "start of day/6" >::
      (fun () -> assert_equal d7s d7e);
    "start of day/8" >::
      (fun () -> assert_equal d8s d8e);
    "start of day/9" >::
      (fun () -> assert_equal d9s d9e);
    "hour of day/2" >::
      (fun () -> assert_equal h2 h2');
    "hour of day/3" >::
      (fun () -> assert_equal h3 h3');
    "hour of day/4" >::
      (fun () -> assert_equal h4 h4');
    "hour of day/5" >::
      (fun () -> assert_equal h5 h5');
    "hour of day/6" >::
      (fun () -> assert_equal h6 h6');
    "hour of day/7" >::
      (fun () -> assert_equal h7 h7');
    "hour of day/8" >::
      (fun () -> assert_equal h8 h8');
    "hour of day/9" >::
      (fun () -> assert_equal h9 h9');
    "weekday/1" >::
      (fun () -> assert_equal Wen (weekday UTC d1));
    "weekday/2" >::
      (fun () -> assert_equal Wen (weekday UTC d2t));
    "weekday/3" >::
      (fun () -> assert_equal Wen (weekday UTC d3t));
    "weekday/4" >::
      (fun () -> assert_equal Wen (weekday Local d4t));
    "weekday/5" >::
      (fun () -> assert_equal Wen (weekday Local d5t));
    "weekday/6" >::
      (fun () -> assert_equal Wen (weekday (UTC_ 2) d6t));
    "weekday/7" >::
      (fun () -> assert_equal Wen (weekday (UTC_ 2) d7t));
    "weekday/8" >::
      (fun () -> assert_equal Wen (weekday (UTC_ ~-2) d8t));
    "weekday/9" >::
      (fun () -> assert_equal Wen (weekday (UTC_ ~-2) d9t));
     
    
]


















