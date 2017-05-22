#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

ARGSU=" ${min-isoform-fraction} "
TOMERGEU=`echo ${to-merge} | sed -e 's/ /, /g'`
for word in ${to-merge}
  do
    echo ${word} >> assembly_list.txt
  done
GTFU="${GTF}"
FASTAU="${FASTA}"
INPUTSU="${TOMERGEU}, ${GTFU}, ${FASTAU}"
echo "GTF files to merge are " "${TOMERGEU}"
echo "GTF reference annotation, if provided, is " "${GTFU}"
echo "Genomic reference, if provided, is " "${FASTAU}"
echo "FASTA file, if provided, is " "${BIASU}"
echo "Input file(s) are " "${INPUTSU}"
echo "Arguments are " "${ARGSU}"

CMDLINEARG="cuffmerge ${ARGSU} -o output --num-threads 16 "

if [ -n "${GTFU}" ]
  then
    CMDLINEARG+="--ref-gtf ${GTFU} "
fi
if [ -n "${FASTAU}" ]
  then
    CMDLINEARG+="--ref-sequence ${FASTAU} "
fi

CMDLINEARG+=" assembly_list.txt"

echo ${CMDLINEARG};

chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/cufflinks:v2.2.1python >> lib/condorSubmitEdit.htc ######
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc #####
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, assembly_list.txt, launch.sh >> lib/condorSubmitEdit.htc
echo transfer_output_files = output >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/cuffmerge/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
