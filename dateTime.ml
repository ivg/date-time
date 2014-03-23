open Unix

type tz = Local | UTC | UTC_ of int
type weekday = Mon | Tue | Wen | Thu | Fri | Sat | Sun

let of_time t = t
let to_float t = t

let utc_local_offset t =
  let loc,utc = localtime t, gmtime t in
  let off = loc.tm_hour - utc.tm_hour in
  if off < -12 then off + 24 else off


let string_of_weekday = function
  | Mon -> "Mon"
  | Tue -> "Tue"
  | Wen -> "Wen"
  | Thu -> "Thu"
  | Fri -> "Fri"
  | Sat -> "Sat"
  | Sun -> "Sun"

let of_local y mon d h m s =
  let f,s = modf s in
  let tm = {
    tm_sec = int_of_float s;
    tm_min = m;
    tm_hour = h;
    tm_mday = d;
    tm_mon = mon - 1;
    tm_year = y - 1900;
    (* следущие поля будут проигнорированы: *)
    tm_wday = 0;
    tm_yday = 0;
    tm_isdst = false;
  } in
  let r,tm = mktime tm in
  r +. f

let of_utc y mon d h m s =
  let t = of_local y mon d h m s in
  of_local y mon d (h + utc_local_offset t) m s

let of_utc_ off y mon d h m s = of_utc y mon d (h-off) m s

let create zone year month day hour min sec =
  let f = match zone with
    | Local -> of_local
    | UTC   -> of_utc
    | UTC_ n -> of_utc_ n in
  f year month day hour min sec


let make ?(zone=Local) ~year ~month ~day
    ?(hour=0) ?(min=0) ?(sec=0.) () =
  create zone year month day hour min sec

let compare = compare

let duration t t' = t' -. t

let now  = gettimeofday
let after dt t = dt +. t

let gmtime_to_tm = gmtime

let tm_of_time s = function
  | UTC   ->  Unix.gmtime s
  | Local ->  Unix.localtime s
  | UTC_ n -> let s = Unix.gmtime s in
              {s with tm_hour = s.tm_hour + n}

let tm_of_datetime t zone =
  let f,s = modf t in
  tm_of_time s zone

let strftime ?(zone=Local) fmt t =
  let f,s = modf t in
  let t = tm_of_time s zone in
  let b = Buffer.create 32 in
  let to_str i = if i > 9
    then string_of_int i
    else "0" ^ (string_of_int i) in
  let to_Str = string_of_float in
  let sub = function
    | "y" -> to_str (t.tm_year + 1900)
    | "M" -> to_str (t.tm_mon + 1)
    | "d" -> to_str t.tm_mday
    | "h" -> to_str t.tm_hour
    | "m" -> to_str t.tm_min
    | "s" -> to_str t.tm_sec
    | "S" -> to_Str ((float_of_int t.tm_sec) +. f)
    | "ms" -> to_str (int_of_float (f *. 1e3))
    | "mS" -> to_Str (f *. 1e3)
    | s    -> invalid_arg ("strftime: unknown variable $" ^ s) in
  Buffer.add_substitute b sub fmt;
  Buffer.contents b



let hour ?(zone=Local) t =
  let {tm_hour} = tm_of_datetime t zone in tm_hour

let minute t = let {tm_min} = tm_of_datetime t Local in tm_min
let second t = let {tm_sec} = tm_of_datetime t Local in tm_sec
let day t = let {tm_mday} = tm_of_datetime t Local in tm_mday
let year t = let {tm_year} = tm_of_datetime t Local in tm_year + 1900
let month t= let {tm_mon} = tm_of_datetime t Local in tm_mon + 1


let of_string ?(zone=Local) str =
  Scanf.sscanf str "%d%_c%d%_c%d%_c%d%_c%d%_c%f"
    begin match zone with
      | Local -> of_local
      | UTC -> of_utc
      | UTC_ n -> of_utc_ n
    end

let day_correction zone time =
  let t = Unix.gmtime time in
  let offset = match zone with
    | UTC -> 0
    | UTC_ n -> n
    | Local -> utc_local_offset time in
  match t.tm_hour + offset with
    | h when h > 24 ->  1
    | h when h <  0 -> -1
    | _             ->  0

let start_of_day zone time =
  let t = Unix.gmtime time in
  let day_offset = day_correction zone time in
  create zone (t.tm_year+1900) (t.tm_mon+1) (t.tm_mday + day_offset)
    0 0 0.

let weekday zone time =
  let weekday_of_int = function
    | 0 -> Sun
    | 1 -> Mon
    | 2 -> Tue
    | 3 -> Wen
    | 4 -> Thu
    | 5 -> Fri
    | 6 -> Sat
    | _ -> failwith "weekday" in
  let t = Unix.gmtime time in
   weekday_of_int ((t.tm_wday + day_correction zone time + 6) mod 6)

module ComparableTime = struct
  type t = float
  let compare = compare
end

module Interval = Interval.Make(ComparableTime)
include Field.R
module Ordered : Ops.TotallyOrdered with type t := float =
  Ops.MakeOrdered(struct
    type t = float
    let (=) = (=)
    let (<) = (<)
end)

include Ordered

let (+) = (+.)
let (-) = (-.)









