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

ARGSU=" ${multi-read-correct} ${library-type} ${library-norm-method} ${frag-len-mean} ${frag-len-std-dev} ${max-mle-iterations} ${compatible-hits-norm} ${num-frag-count-draws} ${num-frag-assign-draws} ${max-frag-multihits} ${no-effective-length-correction} ${no-length-correction} ${label} ${min-isoform-fraction} ${pre-mrna-fraction} ${max-intron-length} ${junc-alpha} ${small-anchor-fraction} ${min-frags-per-transfrag} ${overhang-tolerance} ${max-bundle-length} ${max-bundle-frags} ${min-intron-length} ${trim-3-avgcov-thresh} ${trim-3-dropoff-fract} ${max-multiread-fraction} ${overlap-radius} ${no-faux-reads} ${overhang-tolerance-3} ${intron-overhang-tolerance} "
ALIGNEDU="${aligned_reads}"
GTFU="${GTF}"
GUIDEU="${GTF-guide}"
MASKU="${mask-file}"
BIASU="${frag-bias-correct}"
INPUTSU="${ALIGNEDU}, ${GTFU}, ${GUIDEU}, ${MASKU}, ${BIASU}"
echo "Files with aligned reads is " "${ALIGNEDU}"
echo "GTF file, if provided, is " "${GTFU}"
echo "GTF guide file, if provided, is " "${GTF-guide}"
echo "Mask file, if provided, is " "${MASKU}"
echo "FASTA file, if provided, is " "${BIASU}"
echo "Input file(s) are " "${INPUTSU}"
echo "Arguments are " "${ARGSU}"

CMDLINEARG="cufflinks ${ARGSU} "

if [ -n "${GTF}" ]
  then
    CMDLINEARG+="--GTF ${GTFU} "
fi
if [ -n "${GTF-guide}" ]
  then
    CMDLINEARG+="--GTF-guide ${GUIDEU} "
fi
if [ -n "${mask-file}" ]
  then
    CMDLINEARG+="--mask-file ${MASKU} "
fi
if [ -n "${frag-bias-correct}" ]
  then
    CMDLINEARG+="--frag-bias-correct ${BIASU} "
fi

CMDLINEARG+="--output-dir output --num-threads 16 --no-update-check ${ALIGNEDU} "

echo ${CMDLINEARG};

chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/cufflinks:v2.2.1 >> lib/condorSubmitEdit.htc ######
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc #####
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
echo transfer_output_files = output >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/cufflinks/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
