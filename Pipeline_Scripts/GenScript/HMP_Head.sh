./Dada2Pipe.sh ../../Config/dada2/HmpDada2.txt high &
./UsearchPipe.sh ../../Config/unoise/medUsearch.txt high &
./DeblurPipeP.sh ../../Config/deblur/HMPdeblur.txt high &
wait
./Dada2Pipe.sh ../../Config/dada2/HmpDada2.txt med &
./UsearchPipe.sh ../../Config/unoise/medUsearch.txt med &
./DeblurPipeP.sh ../../Config/deblur/HMPdeblur.txt med &
wait
./Dada2Pipe.sh ../../Config/dada2/HmpDada2.txt low &
./UsearchPipe.sh ../../Config/unoise/medUsearch.txt low &
./DeblurPipeP.sh ../../Config/deblur/HMPdeblur.txt low &
wait
