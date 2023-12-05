# c1dr
Let's find all the working ip's in the CIDR range by finding their respective open ports.

# Installation
`git clone https://github.com/hackruler/openip.git`

`cd openip`

# Usage

`bash openip.sh -l <path to cidr file> [options]`



# More effectively you can use this like...

After Installation

**Make an alias using this-**

`chmod +x <file path>/openip.sh`

Append this command in .zshrc file or .bashrc file

`alias openip='bash <path to file>/openip/openip.sh`

And then type this command to save...

`source ~/.bashrc` Or `source ~/.zshrc`

Then you can use this as...

`openip -l <domain file path> [options]`



