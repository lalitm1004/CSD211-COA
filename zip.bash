read -p "enter target > " target
target=$(printf "%02d" $target)

rm -rf submissions/*;

filename="2310110164.txt"
archivename="2310110164.tar.gz"

for file in worksheet-$target/*.asm; do
    base_name=$(basename "$file" .asm)
    echo -e "\n\n----------$base_name----------" >> "submissions/$filename"
    cat $file >> "submissions/$filename"
done

cat "SAMPLE_README.txt" >> "submissions/README.txt"

read -n 1 -s -r -p "make any changes to files and then press any key to continue >"
echo ""

tar -czf "submissions/$archivename" submissions/*.txt
tar -ztvf "submissions/$archivename";

rm submissions/*.txt;