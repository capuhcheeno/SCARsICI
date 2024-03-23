#!/bin/sh
##########################################################################
# create the combined demographic files with the filename appended as the last column
# NOTE the demographic file formats are in two versions
# We will call the file format before 2014 Q3 version A and everything from 2014 Q3 onwards, version B
#
# LTS Computing LLC
##########################################################################

# Base directory for files
base_dir="ascii"

# Initialize arrays for Version A and B file prefixes
version_a_prefixes=( "demo12q4" "DEMO13Q1" "DEMO13Q2" "DEMO13Q3" "DEMO13Q4" "DEMO14Q1" "DEMO14Q2" )
version_b_prefixes=( "DEMO14Q3" "DEMO14Q4" "DEMO15Q1" "DEMO15Q2" "DEMO15Q3" "DEMO15Q4" "DEMO16Q1" "DEMO16Q2" "DEMO16Q3" "DEMO16Q4" "DEMO17Q1" "DEMO17Q2" "DEMO17Q3" "DEMO17Q4" "DEMO18Q1" "DEMO18Q2" "DEMO18Q3" "DEMO18Q4" "DEMO19Q1" "DEMO19Q2" "DEMO19Q3" "DEMO19Q4" "DEMO20Q1" "DEMO20Q2" "DEMO20Q3" "DEMO20Q4" "DEMO21Q1" "DEMO21Q2" "DEMO21Q3" "DEMO21Q4" "DEMO22Q1" "DEMO22Q2" "DEMO22Q3" "DEMO22Q4" "DEMO23Q1" "DEMO23Q2" "DEMO23Q3" "DEMO23Q4" )

process_file() {
    thefilename="${base_dir}/${1}.txt"
    # Determine version based on filename
    if [[ "${1}" < "DEMO14Q3" ]]; then
        # Version A
        sed 's/\r$//' "${thefilename}" | sed '1 s/$/ filename/' | sed "2,\$ s|\$| ${thefilename}|" > "${base_dir}/${1}_with_filename.txt"
    else
        # Version B and beyond
        sed 's/\r$//' "${thefilename}" | sed '1d' | sed "1,\$ s|\$| ${thefilename}|" > "${base_dir}/${1}_with_filename.txt"
    fi
}

# Process Version A files
for prefix in "${version_a_prefixes[@]}"; do
    process_file "$prefix"
done

# Process Version B files
for prefix in "${version_b_prefixes[@]}"; do
    process_file "$prefix"
done

# Concatenate all version A and B files into their respective single files for loading
cat "${base_dir}"/*_with_filename.txt > "${base_dir}/all_demo_data_with_filename.txt"
