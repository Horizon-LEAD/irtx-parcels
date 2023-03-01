#!/bin/bash


#Set fonts
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

function show_usage () {
    echo -e "${BOLD}Basic usage:${NORM} entrypoint.sh [-vh] FIN_PERSONS FIN_HOMES SEED SCALING OUT_PATH"
}

FIN_PERSONS=${leftovers[0]}
FIN_HOMES=${leftovers[1]}
SEED=${leftovers[2]}
SCALING=${leftovers[3]}
OUT_PATH=${leftovers[4]}

function show_help () {
    echo -e "${BOLD}eentrypoint.sh${NORM}: Runs the Parcels Model"\\n
    show_usage
    echo -e "\n${BOLD}Required arguments:${NORM}"
    echo -e "${REV}FIN_PERSONS${NORM}\t the InfluxDB container name"
    echo -e "${REV}FIN_HOMES${NORM}\t the InfluxDB dump directory"
    echo -e "${REV}SEED${NORM}\t the InfluxDB dump directory"
    echo -e "${REV}SCALING${NORM}\t the InfluxDB dump directory"
    echo -e "${REV}OUT_PATH${NORM}\t the InfluxDB dump directory"\\n
    echo -e "${BOLD}Optional arguments:${NORM}"
    echo -e "${REV}-v${NORM}\tSets verbosity level"
    echo -e "${REV}-h${NORM}\tShows this message"
    echo -e "${BOLD}Examples:${NORM}"
    echo -e "entrypoint.sh -v persons.xlsx homes.gpkg 1234 0.1 ./output/"
}

##############################################################################
# GETOPTS                                                                    #
##############################################################################
# A POSIX variable
# Reset in case getopts has been used previously in the shell.
OPTIND=1

# Initialize vars:
verbose=0

# while getopts
while getopts 'hv' OPTION; do
    case "$OPTION" in
        h)
            show_help
            kill -INT $$
            ;;
        v)
            verbose=1
            ;;
        ?)
            show_usage >&2
            kill -INT $$
            ;;
    esac
done

shift "$(($OPTIND -1))"

leftovers=(${@})
FIN_PERSONS=${leftovers[0]}
FIN_HOMES=${leftovers[1]}
SEED=${leftovers[2]}
SCALING=${leftovers[3]}
OUT_PATH=${leftovers[4]}

##############################################################################
# Input checks                                                               #
##############################################################################
if [ ! -d "${OUT_PATH}" ]; then
     echo -e "Give a ${BOLD}valid${NORM} output directory\n"; show_usage; exit 1
fi

##############################################################################
# Execution                                                                  #
##############################################################################
papermill /srv/app/src/generate-parcels.ipynb /dev/null \
    ${FIN_PERSONS} \
    ${FIN_HOMES} \
    ${SEED} \
    ${SCALING} \
    ${OUT_PATH}
