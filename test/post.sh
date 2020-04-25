URL="http://127.0.0.1:8070/custom/p5/generic/document"
ACCEPT="accept: application/json" 
CTYPYE="Content-Type: multipart/form-data"
DATA="data={ \"author\": \"Johann Sebastian Bach\", \"title\": \"Wohltemperiertes Klavier C-Dur\" }" 
FILE="file=@wtk01.pdf;type=application/pdf"

function post_bundle() {

for i in $(seq 1 $1) 
do
	echo "curl"
	DATA="data={ \"index\":\"${i}\", \"author\": \"Johann Sebastian Bach\", \"title\": \"Wohltemperiertes Klavier C-Dur\" }"
    (x=$(curl -s -X POST ${URL} -H "${ACCEPT}" -H "${CTYPE}" -F "${DATA}" -F "${FILE}")) 
done 
}

for i in {1..50}
do 
  post_bundle 20  
done 

echo "uploadsd initialized"
wait 
echo "done"
#for i in {1..1000}
#do
#DATA="data={ \"index\":\"${i}\", \"author\": \"Johann Sebastian Bach\", \"title\": \"Wohltemperiertes Klavier C-Dur\" }"
#(x=$(curl -s -X POST ${URL} -H "${ACCEPT}" -H "${CTYPE}" -F "${DATA}" -F "${FILE}")) &
#done 
#echo "uploads initialized"
#wait 
#echo "done"
