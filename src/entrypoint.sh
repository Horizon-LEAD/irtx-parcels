#!/bin/bash

#Set fonts
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

curdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function show_usage () {
    echo -e "${BOLD}Basic usage:${NORM} entrypoint.sh [-vh] PERSONS HOMES OUT_PATH"
}

function show_help () {
    echo -e "${BOLD}entrypoint.sh${NORM}: Runs the Parcels Model"\\n
    show_usage
    echo -e "\n${BOLD}Required arguments:${NORM}"
    echo -e "${REV}PERSONS${NORM}\t the persons csv input file"
    echo -e "${REV}HOMES${NORM}\t the homes gpkg input file"
    echo -e "${REV}OUT_PATH${NORM}\t the output path"\\n
    echo -e "${BOLD}Optional arguments:${NORM}"
    echo -e "${REV}-v${NORM}\tSets verbosity level"
    echo -e "${REV}-h${NORM}\tShows this message"
    echo -e "${BOLD}Examples:${NORM}"
    echo -e "entrypoint.sh -v ./sample-data/input/persons.csv ./sample-data/input/homes.gpkg ./sample-data/output/"
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
persons=${leftovers[0]}
homes=${leftovers[1]}
out_path=${leftovers[2]%/}

##############################################################################
# Input checks                                                               #
##############################################################################
if [ ! -f "${persons}" ]; then
    echo -e "Give a ${BOLD}valid${NORM} persons file path\n"; show_usage; exit 1
fi
if [ ! -f "${homes}" ]; then
    echo -e "Give a ${BOLD}valid${NORM} homes file path\n"; show_usage; exit 1
fi

if [ ! -d "${out_path}" ]; then
     echo -e "Give a ${BOLD}valid${NORM} output directory\n"; show_usage; exit 1
fi

##############################################################################
# Execution                                                                  #
##############################################################################
papermill ${curdir}/generate-parcels.ipynb /dev/null \
    -pfin_persons ${persons} \
    -pfin_homes ${homes} \
    -pseed ${SEED:-1234} \
    -pscaling ${SCALING:-0.1} \
    -poutput_path ${OUT_PATH}
