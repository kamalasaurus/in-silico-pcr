#!/bin/bash
#SBATCH --job-name=primerjinn_in_silico
#SBATCH --output=slurm_%A_%a.out
#SBATCH --error=slurm_%A_%a.err
#SBATCH --time=02:00:00            # adjust runtime as needed
##SBATCH --array=1-10               # adjust to the number of primer pairs you want to run
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G

# Load Singularity module if required by your system
module load singularity

# Define paths
PRIMER_FILE="/vast/kr3059/in-silico-pcr/inputs/primers.tsv"      # primers.tsv: each line has forward<tab>reverse
FASTA="/vast/kr3059/in-silico-pcr/inputs/target.fasta"           # your large FASTA file
SINGULARITY_IMAGE="/vast/kr3059/primerjinn.sif"  # your PrimerJinn Singularity image
OUTPUT_DIR="/vast/kr3059/outputs"           # output directory for result files


# Extract the current line from the primer file corresponding to the array index
#line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "${PRIMER_FILE}")
# If your file is tab-separated with forward and reverse primers:
#forward=$(echo "$line" | cut -f1)
#reverse=$(echo "$line" | cut -f2)

forward="GGATGGATACGCCCGGTAAC"
reverse="GACGTTGACCATCATCGGGT"

echo "Task ${SLURM_ARRAY_TASK_ID}: Forward primer: $forward, Reverse primer: $reverse"

# Run PrimerJinn in silico PCR using the extracted primer pair.
# (Adjust the command-line options to match PrimerJinn's usage.)
singularity exec \
    -B "${OUTPUT_DIR}":/data/results \
    -B "${FASTA}":/data/assembly.fasta \
    ${SINGULARITY_IMAGE} \
    primerJinn --forward "$forward" --reverse "$reverse" --fasta /data/assembly.fasta \
    > "${OUTPUT_DIR}/output_${SLURM_ARRAY_TASK_ID}.txt"

echo "Task ${SLURM_ARRAY_TASK_ID} complete. Results in ${OUTPUT_DIR}/output_${SLURM_ARRAY_TASK_ID}.txt"
