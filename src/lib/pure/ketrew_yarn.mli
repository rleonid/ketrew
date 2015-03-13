(**************************************************************************)
(*  Copyright 2015, Sebastien Mondet <seb@mondet.org>                     *)
(*                                                                        *)
(*  Licensed under the Apache License, Version 2.0 (the "License");       *)
(*  you may not use this file except in compliance with the License.      *)
(*  You may obtain a copy of the License at                               *)
(*                                                                        *)
(*      http://www.apache.org/licenses/LICENSE-2.0                        *)
(*                                                                        *)
(*  Unless required by applicable law or agreed to in writing, software   *)
(*  distributed under the License is distributed on an "AS IS" BASIS,     *)
(*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       *)
(*  implied.  See the License for the specific language governing         *)
(*  permissions and limitations under the License.                        *)
(**************************************************************************)

(** Implementation of the {!LONG_RUNNING} API asking Aapache Yarn
    for resources, using {!Ketrew_daemonize} to “keep” the process group
    together. *)

(** This module implements {!Ketrew_long_running.LONG_RUNNING} plugin-API.
*)


(** The “standard” plugin-API. *)
include Ketrew_long_running.LONG_RUNNING

open Ketrew_gen_yarn_v0

val distributed_shell_program :
  ?hadoop_bin:string ->
  ?distributed_shell_shell_jar:string ->
  container_memory:[ `GB of int | `Raw of string ] ->
  timeout:[ `Raw of string | `Seconds of int ] ->
  application_name:string ->
  Ketrew_program.t ->
  [> `Distributed_shell of
       Distributed_shell_parameters.t * Ketrew_program.t ]
(** Create a value [`Distributed_shell _] to feed to {!create}.

    Defaults:

    - [hadoop_bin]: ["hadoop"].
    - [distributed_shell_shell_jar]:
    ["/opt/cloudera/parcels/CDH/lib/hadoop-yarn/hadoop-yarn-applications-distributedshell.jar"]
    (which seems to be the default installation path when using Cloudera-manager).

*)

val create :
  ?host:Ketrew_host.t ->
  ?daemonize_using:[ `Nohup_setsid | `Python_daemon ] ->
  ?daemon_start_timeout: float ->
  [ `Distributed_shell of Distributed_shell_parameters.t * Ketrew_program.t
  | `Yarn_application of Ketrew_program.t ] ->
  [> `Long_running of string * string ]
(** Create a “long-running” {!Ketrew_target.build_process} (run parameters
    are already serialized).

    - [?host]: the “login” node of the Yarn cluster (default: localhost).
    - [?daemonize_using]: how to daemonize the process that calls and
      waits-for the application-manager (default: [`Python_daemon]).
    - [?daemon_start_timeout]: 

*)

