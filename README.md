# c1dr
Let's find all the working ip's in the CIDR range by finding their respective open ports.

# Installation
`git clone https://github.com/hackruler/c1dr.git`

`cd c1dr`

# Usage

`bash cidr.sh -l <path to cidr file> [options]`

#Example

![image](https://github.com/hackruler/c1dr/assets/82742964/89ce1de4-0280-471c-b4e5-6a788e7f0600)



# More effectively you can use this like...

After Installation

**Make an alias using this-**

Append this command in .zshrc file or .bashrc file

`chmod +x <file path>/cidr.sh`

`alias cidr='bash <path to file>/c1dr/cidr.sh`

And then type this command to save...

`source ~/.bashrc` Or `source ~/.zshrc`

Then you can use this as...

`cidr -l <domain file path> [options]`

# Example

![image](https://github.com/hackruler/c1dr/assets/82742964/954bc6a5-27bc-4d8c-a684-25836af978b5)


