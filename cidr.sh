# Finding all the open ports for each ip in CIDR
# Run httpx on all the ip's found with their respective ports.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cexit() {
    echo -e "${RED}[!] Script interrupted. Exiting...${NC}"
    exit "$1"
}

trap 'cexit 1' SIGINT;

if [ -z "$1" ] || [ "$#" -ne 1 ]; then
    echo -e "${GREEN}Usage: bash $0 <input_file>${NC}"
    cexit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is not present in the directory.${NC}"
    cexit 1
fi

if [ ! -s "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is empty.${NC}"
    cexit 1
fi
if [ ! -r "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is not readable.${NC}"
    cexit 1
fi

echo -e "${YELLOW}[!] Finding open ports on all the ip's.${NC}";
sudo masscan -iL "$input_file" -p1-65535 --rate=10000000 | anew masscan.txt > /dev/null || cexit $?;
echo -e "${GREEN}[*] Result is stored to masscan.txt${NC}";
echo -e "${GREEN}[**]" $(cat masscan.txt | wc -l)" ip's found with open ports.${NC}";
cat masscan.txt | cut -d " " -f6 | sed 's/n//g' | sed 's/^ *\|\ *$//g' | sed 's/$/:/' | tee -a ip_add.txt > /dev/null || cexit $?;
cat masscan.txt | cut -d "/" -f1 | tee -a port.txt > /dev/null || cexit $?;

echo -e "${YELLOW}[!] httpx is running on all the ip's found with respective ports.${NC}";
paste ip_add.txt port.txt | sed 's/\t//g' | httpx -silent -sc -td -cl | tee -a httpx_ip.txt || cexit $?;

rm ip_add.txt port.txt;
echo -e "${GREEN}[*] httpx result is stored in httpx_ip.txt${NC}";
echo -e "${GREEN}[**]" $(cat httpx_ip.txt | wc -l)" ip's giving any response on browser.${NC}";

