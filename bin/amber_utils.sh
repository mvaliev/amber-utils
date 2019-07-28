#!/bin/bash
source ~/bin/utils.sh


function get_hostname()
{
  local HOSTNAME
  local machine
  HOSTNAME=$(hostname) 
  case $HOSTNAME in
      glogin*)
         machine="cascade"
         ;;
      WE35255) 
         machine="macbook"
         ;;
      *) 
         machine="unknown"
         ;;
  esac
  echo $machine

}
function task_info()
{

USAGE=$(cat <<-END
--------------------------------------------
AMBER $task simulation 
--------------------------------------------
Topology:             $parmfile_in
Coordinates:          $coordfile_in
Run directory:        $rundir
Input file:           ${INPUTFILE}

END
)
case $task in
opt*)
USAGE+=$(cat <<-END

Optimization cycles:  $opt_cycles
END
)
;;
dyn*)
USAGE+=$(cat <<-END

Simulation time:      $mdtime ps
Timestep:             $mdstepsize
Number of steps:      $mdsteps
Target temperature:   $temp_target K
END
)
;;
eq*)
USAGE+=$(cat <<-END

Simulation time:      $mdtime ps
Timestep:             $mdstepsize
Number of steps:      $mdsteps
Starting temperature: $temp_start K
Target temperature:   $temp_target K

END
)
;;
esac
USAGE+=$(cat <<-END

Number of nodes:       $nodes
Runtime requested:     $runtime min
Account:               $account 
END
)
echo "$USAGE"
}

function task_to_parfile()
{
  local task="$@"
  local PARFILE
  

  PARFILE=""
  PARFILE+="coordfile_in=$coordfile_in \n"
  PARFILE+="parmfile_in=$parmfile_in \n"
  PARFILE+="template_folder=$template_folder \n"
  PARFILE+="template=$template \n"
  PARFILE+="nodes=$nodes \n"
  PARFILE+="runtime=$runtime \n"
  PARFILE+="account=$account \n"
  [ -z "$selection" ] ||   PARFILE+="selection=\"$selection\" \n"



  case $task in
    equil*)
      PARFILE+="mdstepsize=$mdstepsize \n"
      PARFILE+="mdtime=$mdtime \n"
      PARFILE+="temp_target=$temp_target \n"
      PARFILE+="temp_start=$temp_start \n"
      ;;
     dyn*)
      PARFILE+="mdstepsize=$mdstepsize \n"
      PARFILE+="mdtime=$mdtime \n"
      PARFILE+="temp_target=$temp_target \n"
      ;;
    opt*)
      PARFILE+="opt_cycles=$opt_cycles \n"
      ;;
  esac

  echo -e $PARFILE

}

function template_to_task()
{
  local template="$@"
  local task

  case $template in
      opt*)
         task="optimization"
         ;;
      equil*) 
         task="equilibration"
         ;;
      dyn*) 
         task="dynamics"
         ;;
      *) 
         echo "cannot identify template "$template
         exit 1
         ;;
   esac
   echo $task

}

function task_to_template()
{
  local task="$@"
  local template

  case $task in
      opt*)
         template="optimization-0.amt"
         ;;
      equil*) 
         template="equilibration-0.amt"
         ;;
      dyn*) 
         template="dynamics-0.amt"
         ;;
      *) 
         echo "unknown "$task
         exit 1
         ;;
   esac
   echo $template

}

function task_to_prefix()
{
  local task="$@"
  local prefix

  case $task in
      opt*)
         prefix='opt'
         ;;
      equil*) 
         prefix='eq'
         ;;
      dyn*) 
         prefix='dyn'
         ;;
      *) 
         echo "unknown "$task
         exit 1
         ;;
   esac
   echo $template

}


