#!/bin/bash
# favorannotator_v1.0.0
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://documentation.dnanexus.com/developer for tutorials on how
# to modify this file.

main() {

    echo "Value of outfile: '$outfile'"
    echo "Value of gds_file: '$gds_file'"
    echo "Value of chromosome: '$chromosome'"
    echo "Value of use_compression: '$use_compression'"

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    if [ -n "$gds_file" ]
    then
        dx download "$gds_file" -o gds_file.gds &
    gds_file2="gds_file.gds"
    else
    gds_file2="NO_GDS_FILE"
    fi

    echo "Installing xsv"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env
    cargo install xsv

    echo "Rscript --vanilla favorannotator.R $outfile $gds_file2 $chromosome $use_compression"
    dx-docker run -v /home/dnanexus/:/home/dnanexus/ -w /home/dnanexus/ zilinli/staarpipeline:0.9.6 Rscript --vanilla favorannotator.R $outfile $gds_file2 $chromosome $use_compression
    mkdir -p out/results
    mv ${outfile}.gds out/results
    dx-upload-all-outputs
}
