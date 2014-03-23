(** Модуль «Дата и время» *)

(** {4 Типы данных} *)

type t                       (* Тип-носитель *)
type tz =                    (* Тип времени *)
  | Local                    (* местное *)
  | UTC                      (* мировое *)
  | UTC_ of int              (* UTC + n *)

type weekday = Mon | Tue | Wen | Thu | Fri | Sat | Sun


(** {6 Конструирование}  *)

val make: ?zone:tz -> year:int -> month:int -> day:int ->
  ?hour:int -> ?min:int -> ?sec:float -> unit -> t
(** [make year month day_of_month] создаёт время, соответствующее
    указанной дате. Опционально можно указать время суток. По
    умолчанию, используется местное время. *)


val create: tz -> int -> int -> int -> int -> int -> float -> t
(**[create tz y mon d h m s] *)

val of_local: int -> int -> int -> int -> int -> float -> t
(** [of_local y mon d h m s]  создаёт объект,
   проинициализированный переданными годом [y], месяцем [mon], днём
   [d] и местным временем  [h:m:s].
*)

val of_utc:   int -> int -> int -> int -> int -> float -> t
(** [of_utc y mon d h m s]  *)

val of_time: float -> t
(** [of_time t]  создаёт объект, проиницилизированный количеством
   секунд, прошедших с 00:00:00 UTC, Jan. 1, 1970 *)

val of_string: ?zone:tz -> string -> t
(** [of_string "YYYY-MM-DD HH-MM-SS.sss"] *)

val now: unit -> t
(** [now ()]  возвращает объект, проиницилизированный текущим
   времем *)


(** {6 Операции} *)

val duration: t -> t -> float
(** [duration t t']  возвращает количество секунд, прошедшее от
   момента времени t до момента t'*)

val after: float -> t -> t
(** [after duration time] возвращает время, которое наступит по
    прошествии [duration] секунд с момента времени [time]  *)

val (+): t -> float -> t
val (-): t -> t -> float

val compare: t -> t -> int
(** Задаёт порядок. *)

val start_of_day: tz -> t -> t
(** [start_of_day zone time] возвращает время, соответствующее началу
    суток в часовом поясе [zone] к которым принадлежит время [time] *)

val weekday: tz -> t -> weekday

val minute: t -> int
val second: t -> int
val hour: ?zone:tz -> t -> int
val day: t -> int
val month: t -> int
val year: t -> int


(** {6 Преобразования}   *)
val to_float: t -> float
(** [to_float t]  возвращает количество секунд, прошедших с 00:00:00
   UTC, Jan. 1, 1970 *)

val gmtime_to_tm: t -> Unix.tm

val strftime: ?zone:tz -> string -> t -> string
(** [strftime fmt t]  формирует строку, представляющую время [t] в
    соответствии с заданным форматом [fmt].
    Формат представляет собой строку-шаблон в которой переменные
    заменяются на соотвествующие им значения. Переменная  начинается в
    символа ['$'] и продолжается последовательностью алфавитных
    знаков. Принимается следующий набор переменных:
    - ["$y"]  год;
    - ["$M"]  месяц;
    - ["$d"]  день месяца;
    - ["$h"]  час суток;
    - ["$m"]  минута в часе;
    - ["$s"]  секунда (целое);
    - ["$S"]  секунда (вещественное);
    - ["$ms"]  миллисекунда от начала секунды (целое);
    - ["$mS"]  миллисекунда от начала секунды (вещественное);

   Пример:

   [strftime "$h:$m:$s of $y:$M:$d"]
*)

val string_of_weekday: weekday -> string

(** Интервалы времени. *)
module Interval : Interval.S with type e = t

(** Операторы  *)
include Ops.TotallyOrdered with type t := t









