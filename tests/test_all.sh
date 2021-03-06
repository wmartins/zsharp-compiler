#!/bin/bash
# Authors:
# ========
# @author Italo Lobato Qualisoni 	- 12104861-5 - 		<italo.qualisoni@acad.pucrs.br>
# @author Lorenzo Kniss 		- 12111541-4 - 		<lorenzo.kniss@acad.pucrs.br>
# @author William Henrihque Martins 	- 12104965-4 - 		<william.henrihque@acad.pucrs.br>

# Description:
# ============
# This file is a tester for some files located at the sample directory
printf "\n=============== Executing tests ===============\n"
cd ../dist
for f in ../samples/* 
do
  printf "\n"
  ff=$(basename "$f")
  if [[ $ff = "AllProdsWithErrors.zs" ]]; then
	printf "Testing [$ff] - this file must NOT compile"
  else
	printf "Testing [$ff] - this file must compile"
  fi
  java Parser ../samples/$f
  printf "$r"
done
