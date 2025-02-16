#!/bin/bash
#SBATCH --job-name=primerjinn_in_silico
#SBATCH --output=slurm_%A_%a.out
#SBATCH --error=slurm_%A_%a.err
#SBATCH --time=02:00:00            # adjust runtime as needed
##SBATCH --array=1-10               # adjust to the number of primer pairs you want to run
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G
#SBATCH --account=pr_162_general

# Load Singularity module if required by your system
module load singularity/3.7.4

# Define paths
PRIMER_FILE="/scratch/kms9971/in-silico-pcr/inputs/primers.txt"      # primers.tsv: each line has forward<tab>reverse
FASTA="/scratch/kms9971/positive_control_PCR/NODE_9998_length_1843_cov_1.782998"           # your large FASTA file
SINGULARITY_IMAGE="/scratch/kms9971/primerjinn_latest.sif"  # your PrimerJinn Singularity image
OUTPUT_DIR="/scratch/kms9971/in-silico-pcr/outputs"           # output directory for result files

#positive_control_PCR/NODE_9998_length_1843_cov_1.782998

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
    -B /scratch/kms9971/in-silico-pcr/inputs:/data/inputs/:rw \
    -B "${OUTPUT_DIR}":/data/outputs:rw \
    -B "${FASTA}":/data/assembly.fasta:rw \
    ${SINGULARITY_IMAGE} \
    PCRinSilico --primer_seq /data/inputs/primers.txt --input_file /data/assembly.fasta --output /data/outputs/output

echo "Task ${SLURM_ARRAY_TASK_ID} complete. Results in ${OUTPUT_DIR}/output_${SLURM_ARRAY_TASK_ID}.txt"
