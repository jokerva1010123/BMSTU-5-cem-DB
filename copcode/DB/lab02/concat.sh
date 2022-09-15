#!/bin/bash

output=queries.sql

>| $output

for filename in $(ls query*.sql); do
	cat $filename >> $output
	echo $'\n' >> $output
done
