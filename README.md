# in-silico-pcr

For a set of primers, we want to see if they match any regions in a large multi-fasta file for metagenomic analysis.

To do this we are:

1. Creating a Dockerfile that generates an image for primerJinn to run on the cluster.
2. Authoring a slurm script that can run this tool in an arrayed manner in an HPC environment.
3. Collecting other command line methods into commands.txt to regenerate the pipeline.

For the pipeline itself:

1. Create a tsv file of our primer pairs (primers.txt)
2. Create an index of our fasta file for fast access
3. We want to run our slurm script to match our primer pairs against our fasta.
4. We want to filter amplicons from 250-600 basepair matches.


## Notes

It appears primerJinn's tool to match primers just expects a list of single primers, not forward reverse pairs.  It combines them iteratively against your fasta to return your matches of various lengths.  You can determine your forward and reverse pair from there.

More generally, the primers should be estimated from highly conserved areas.  primerJinn has a primer creation tool.

Currently there are consensus sequences for some contaminant proteins.  I think clustalo -> MEME to generate a logo will generate a more stable probabilistic view of motifs.  Then it's easier to pick out highly conserved regions for the primers.

```
clustalo -i gene_sequences.fasta -o alignment.aln --force
meme alignment.aln -oc meme_out -dna -nmotifs 3 -minw 6 -maxw 25
```
