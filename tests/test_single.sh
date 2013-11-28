#!/bin/bash
# Authors:
# ========
# @author Italo Lobato Qualisoni - [MATRÍCULA] - <italo.qualisoni@acad.pucrs.br>
# @author Lorenzo Kniss 		- 12111541-4 - 		<lorenzo.kniss@acad.pucrs.br>
# @author William Henrihque Martins - 12104861-5 - <william.henrihque@acad.pucrs.br>
# Description:
# ============
# This file is a tester for some files located at the sample directory
printf "\n=============== Executing tests ===============\n"
cd dist
java Parser ../samples/$1
