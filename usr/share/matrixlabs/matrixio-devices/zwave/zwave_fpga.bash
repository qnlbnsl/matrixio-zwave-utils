#!/bin/bash

P4DETECT=$(grep "Pi 4" /sys/firmware/devicetree/base/model)

function try_program() {
  if [ -n "$P4DETECT" ]; 
  then 
	  CABLE=sysfsgpio_creator
  else
	  CABLE=matrix_creator
  fi

  echo 18 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value
  sleep 0.1
  xc3sprog -c $CABLE /usr/share/matrixlabs/matrixio-devices/zwave/blob/zwave.bit -p 1 > /dev/null 2> /dev/null
}


count=0
while [  $count -lt 10 ]; do
  try_program
  if [ $? -eq 0 ];then
        echo "*** FPGA programmed!"
        exit 0
   fi
  let count=count+1
done
echo "**** Could not program FPGA"
exit 1

