#!/bin/sh

URL="https://rest.uniprot.org/uniprotkb/stream?compressed=false&format=fasta&includeIsoform=true&query=(proteome:UP000005640)%20AND%20(reviewed:true)"
curl -o ./tools/references/library.fasta $URL
