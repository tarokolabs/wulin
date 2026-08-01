s=$(cat /tmp/diphead.txt | cut -d ',' -f10- | tr ',' ' ')
[ "$s" == "" ] && exit 1

[ -f opendata/dip/seaport.list ] && rm opendata/dip/seaport.list && rm opendata/dip/airport.list
c=1
for x in `echo $s`
do
  [ "$c" == "200" ] && break
  echo $x | grep '港' &>/dev/null
  if [ "$?" == "0" ]; then 
     echo "$c $x" >> opendata/dip/seaport.list
  else
     echo "$c $x" >> opendata/dip/airport.list
  fi
  c=$(( $c+3 ))
done 

echo "[機場 : airport.list]"
cat opendata/dip/airport.list
echo""
echo "[港口 : seaport.list]"
cat opendata/dip/seaport.list
