#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_help() {
    echo "   Usage: bash openip.sh [options]"
    echo ""
    echo "   Options:"
    echo "   -h                          Help Menu"
    echo "   -l <input file>             Specify the CIDR file you want to scan."
    echo "   -p <input ports>            Specify the ports you want to scan (e.g., -p80,443 or -p1-65535)."
    echo "                               If not specified, it will scan for default ports."
    echo "   -r <define rate>            Rate for scanning (Default rate = 1000)"
    echo "   -o <output file>            Specify the output file."

    exit 0
}

cexit() {
    echo -e "${RED}[!] Script interrupted. Exiting...${NC}"
    exit "$1"
}

trap 'cexit 1' SIGINT;

default_rate="1000"

default_ports="66,80,81,443,445,457,1080,1100,1241,1352,1433,1434,1521,1944,2301,3000,3128,3306,4000,4001,4002,4100,5000,5001,5432,5800,5801,5802,6346,6347,7001,7002,8080,8443,8888,30821" 

while getopts ":l:p:o:r:h" opt; do
    case $opt in
        l)
            input_file="$OPTARG"
            ;;
        p)
            custom_ports="$OPTARG"
            ;;
        o)
            output_file="$OPTARG" 
            ;;
        r) 
            rate_input="$OPTARG"
            ;;
        h)
            show_help
            ;;             
        \?)
            echo -e "${RED}Invalid option.${NC}"
            show_help
            ;;
    esac
done

if [ -z "$input_file" ]; then
    # Check if input is coming from a pipe
    if [ -p /dev/stdin ]; then
        input_file="/dev/stdin"
    else
        echo -e "${RED}Error: No input file specified.${NC}"
        show_help
    fi
fi

{ 
    [ -z "$rate_input" ] && 
    custom_rate="$default_rate" || 
    custom_rate="$rate_input"; 
}

{ 
    [ -z "$custom_ports" ] && 
    ports_option="-p$default_ports" || 
    ports_option="-p$custom_ports"; 
}

# Do not check for the presence of the file when input is from a pipe
if [ "$input_file" != "/dev/stdin" ] && [ ! -f "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is not present in the directory.${NC}"
    exit 0
fi

if [ "$input_file" != "/dev/stdin" ] && [ ! -s "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is empty.${NC}"
    exit 0
fi

if [ "$input_file" != "/dev/stdin" ] && [ ! -r "$input_file" ]; then
    echo -e "${RED}Error: The specified input file '$input_file' is not readable.${NC}"
    exit 0
fi

echo -e "${YELLOW}[!] Finding open ports on all the IP's.${NC}"

sudo masscan -iL "$input_file" "$ports_option" --rate="$custom_rate" | awk '{print $6 ":" $4}' | sed 's/\/tcp//g' | { [ -z "$output_file" ] && cat || tee "$output_file" > /dev/null; };

{
    [ -z "$output_file" ] && 
    echo -e "${GREEN}[*] ........... SCRIPT ENDED .................${NC}" ||
    echo -e "${GREEN}[**]" $(cat "$output_file" | wc -l)" IP's found with open port.${NC}"
}
