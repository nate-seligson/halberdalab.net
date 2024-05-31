#!/bin/bash

echo "var preset1 = [];" > data.preset1.js
i=0
for f in *.png; do
	echo -n "preset1[$i] = 'data:image/png;base64," >> data.preset1.js
	base64 $f | tr -d '\n' >> data.preset1.js
	echo "';" >> data.preset1.js
	i=`expr $i + 1`
	echo $i
done
