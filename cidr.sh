# Finding all the open ports for each ip in CIDR
# Run httpx on all the ip's found with their respective ports.

if [ -z "$1" ] || [ "$#" -ne 1 ]; then
    echo "Usage: bash $0 <input_file>"
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo "Error: The specified input file '$input_file' is not present in the directory."
    exit 1
fi

if [ ! -s "$input_file" ]; then
    echo "Error: The specified input file '$input_file' is empty."
    exit 1
fi

if [ ! -r "$input_file" ]; then
    echo "Error: The specified input file '$input_file' is not readable."
    exit 1
        fi

echo "[!] Finding open ports on all the ip's"
sudo masscan $input_file -p1-65535 --rate=10000000 | anew ip1.txt /dev/null;
cat ip1.txt | cut -d "o" -f5 | sed 's/n//g' | sed 's/^ *\|\ *$//g' | sed 's/$/:/' | tee -a ip_add.txt /dev/null;
cat ip1.txt | cut -d "/" -f1 | cut -d ' ' -f4 | tee -a port.txt /dev/null;

echo "[!] httpx is running on all the ip's found with respective ports"
paste ip_add.txt port.txt | sed 's/\t//g' | httpx -silent -sc -td -cl | tee -a httpx_ip.txt;

rm ip_add.txt port.txt ip1.txt;
echo "[*] httpx result is stored to httpx_ip.txt"
