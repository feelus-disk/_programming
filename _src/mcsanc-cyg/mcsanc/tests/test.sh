#!/bin/bash
# run: test.sh pid
calc() {
bc <<EOF
    $1
EOF
}
TEST_HOME=$(cd $(dirname $0) && pwd)
( cd $TEST_HOME/pids/$1/; rm *check*;../../../src/mcsanc )
for i in born brdq virt soft hard; do
  SIGMA=$( grep "$i" $TEST_HOME/pids/$1/mcsanc-test-output.txt | line | \
     sed 's/\s\+/ /g' | cut -d' ' -f5 )
  ERROR=$( grep "$i" $TEST_HOME/pids/$1/mcsanc-test-output.txt | line | \
     sed 's/\s\+/ /g' | cut -d' ' -f6 )
#  echo $SIGMA $ERROR
  SIGMA_CHECK=$( grep "$i" $TEST_HOME/pids/$1/mcsanc-check-output.txt | line | \
     sed 's/\s\+/ /g' | cut -d' ' -f5 )
  ERROR_CHECK=$( grep "$i" $TEST_HOME/pids/$1/mcsanc-check-output.txt | line | \
     sed 's/\s\+/ /g' | cut -d' ' -f6 )
  A1=`calc "$SIGMA-$ERROR"`
  B1=`calc "$SIGMA+$ERROR"`
  A2=`calc "$SIGMA_CHECK-$ERROR_CHECK"`
  B2=`calc "$SIGMA_CHECK+$ERROR_CHECK"`
if [ `calc "(($A1 <= $A2 && $B1 > $A2 ) || ($A2 <= $A1 && $B2 > $A1))"` == 0 ]; then
  echo $i test failed!
else 
  echo $i test succsess.
fi
done
