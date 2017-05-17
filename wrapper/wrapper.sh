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

function addcommaspace {
  echo `echo ${1} | sed -e 's/ /, /g'`
}

function addcomma {
  echo `echo ${1} | sed -e 's/ /,/g'`
}


rmthis=`ls`
echo ${rmthis}

ARGSU=" ${labels} ${FDR} ${multi-read-correct} ${no-js-tests} ${time-series} ${library-type} ${dispersion-method} ${library-norm-method} ${frag-len-mean} ${frag-len-std-dev} ${min-alignment-count} ${max-mle-iterations} ${total-hits-norm} ${max-bundle-frags} ${num-frag-count-draws} ${num-frag-assign-draws} ${max-frag-multihits} ${min-reps-for-js-test} ${no-effective-length-correction} ${no-length-correction} "
TRANSCRIPTU="${transcripts}"
MASKU="${mask-file}"
CONTRASTU="${contrast-file}"
FRAGBIASU="${frag-bias-correct}"
SAMPLES1U=`addcommaspace "${samples1}"`
CMD1=`addcomma "${samples1}"`
SAMPLES2U=`addcommaspace "${samples2}"`
CMD2=`addcomma "${samples2}"`
SAMPLES3U=`addcommaspace "${samples3}"`
CMD3=`addcomma "${samples3}"`
SAMPLES4U=`addcommaspace "${samples4}"`
CMD4=`addcomma "${samples4}"`
SAMPLES5U=`addcommaspace "${samples5}"`
CMD5=`addcomma "${samples5}"`
SAMPLES6U=`addcommaspace "${samples6}"`
CMD6=`addcomma "${samples6}"`
SAMPLES7U=`addcommaspace "${samples7}"`
CMD7=`addcomma "${samples7}"`
SAMPLES8U=`addcommaspace "${samples8}"`
CMD8=`addcomma "${samples8}"`
SAMPLES9U=`addcommaspace "${samples9}"`
CMD9=`addcomma "${samples9}"`
SAMPLES10U=`addcommaspace "${samples10}"`
CMD10=`addcomma "${samples10}"`
SAMPLES11U=`addcommaspace "${samples11}"`
CMD11=`addcomma "${samples11}"`
SAMPLES12U=`addcommaspace "${samples12}"`
CMD12=`addcomma "${samples12}"`
SAMPLES13U=`addcommaspace "${samples13}"`
CMD13=`addcomma "${samples13}"`
SAMPLES14U=`addcommaspace "${samples14}"`
CMD14=`addcomma "${samples14}"`
SAMPLES15U=`addcommaspace "${samples15}"`
CMD15=`addcomma "${samples15}"`
SAMPLES16U=`addcommaspace "${samples16}"`
CMD16=`addcomma "${samples16}"`
INPUTSU="${TRANSCRIPTU}, ${MASKU}, ${CONTRASTU}, ${FRAGBIASU}, ${SAMPLES1U}, ${SAMPLES2U}, ${SAMPLES3U}, ${SAMPLES4U}, ${SAMPLES5U}, ${SAMPLES6U}, ${SAMPLES7U}, ${SAMPLES8U}, ${SAMPLES9U}, ${SAMPLES10U}, ${SAMPLES11U}, ${SAMPLES12U}, ${SAMPLES13U}, ${SAMPLES14U}, ${SAMPLES15U}, ${SAMPLES16U}"
echo "Transcript files is " "${TRANSCRIPTU}"
echo "Mask file, if provided, is " "${MASKU}"
echo "Contrast file, if provided, is " "${CONTRASTU}"
echo "FASTA file for correction, if provided, is " "${FRAGBIASU}"
echo "Sample files, divided by condition, are " "${SAMPLES1U}""/""${SAMPLES2U}""/""${SAMPLES3U}""/""${SSAMPLES4U}""/""${SAMPLES5U}""/""${SAMPLES6U}""/""${SAMPLES7U}""/""${SAMPLES8U}""/""${SAMPLES9U}""/""${SAMPLES10U}""/""${SSAMPLES11U}""/""${SAMPLES12U}""/""${SAMPLES13U}""/""${SAMPLES14U}""/""${SAMPLES15U}""/""${SAMPLES16U}"
echo "Arguments are " "${ARGSU}"

# check number of labels is the same as inputs, if given

CMDLINEARG="cuffdiff ${ARGSU} "

if [ -n "${mask-file}" ]
  then
    CMDLINEARG+="--mask-file ${MASKU} "
fi
if [ -n "${contrast-file}" ]
  then
    CMDLINEARG+="--contrast-file ${CONTRASTU} "
fi
if [ -n "${frag-bias-correct}" ]
  then
    CMDLINEARG+="--frag-bias-correct ${FRAGBIASU} "
fi

CMDLINEARG+="--output-dir output --num-threads 16 --no-update-check ${TRANSCRIPTU} ${CMD1} ${CMD2} ${CMD3} ${CMD4} ${CMD5} ${CMD6} ${CMD7} ${CMD8} ${CMD9} ${CMD10} ${CMD11} ${CMD12} ${CMD13} ${CMD14} ${CMD15} ${CMD16}"

echo ${CMDLINEARG};

chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  cyverseuk/cufflinks:v2.2.1 >> lib/condorSubmitEdit.htc ######
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc #####
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
echo transfer_output_files = output >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/cuffdiff/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
