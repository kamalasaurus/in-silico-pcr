#!/bin/bash
#SBATCH --job-name=primer3_job
#SBATCH --output=slurm_%A_%a.out
#SBATCH --error=slurm_%A_%a.err
#SBATCH --time=01:00:00            # Adjust based on expected runtime
#SBATCH --array=1-20               # 20 input files (one per array task)
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=64G                   # Adjust memory as needed

# Load the Singularity module if required on your HPC
module load singularity

# Define directories
# INPUT_DIR contains Primer3 input files (e.g., primer3_input_1.txt, primer3_input_2.txt, ...)
# OUTPUT_DIR is where the Primer3 output files will be written.
INPUT_DIR="/vast/kr3059/in-silico-pcr/inputs"
OUTPUT_DIR="/vast/kr3059/in-silico-pcr/outputs"

# Singularity image containing primer3_core
SINGULARITY_IMAGE="/vast/kr3059/primer3-image_latest.sif"

# Define input and output files based on the SLURM array index
INPUT_FILE="${INPUT_DIR}/primer3_input_${SLURM_ARRAY_TASK_ID}.txt"
OUTPUT_FILE="${OUTPUT_DIR}/primer3_output_${SLURM_ARRAY_TASK_ID}.txt"

echo "Processing input file: ${INPUT_FILE}"

# Execute primer3_core inside the Singularity container.
# Bind the input and output directories so they are accessible inside the container.
singularity exec -B "${INPUT_DIR}":/data/inputs \
                 -B "${OUTPUT_DIR}":/data/outputs \
                 "${SINGULARITY_IMAGE}" \
                 primer3_core < /data/inputs/$(basename ${INPUT_FILE}) > /data/outputs/$(basename ${OUTPUT_FILE})

echo "Task ${SLURM_ARRAY_TASK_ID} complete. Output written to ${OUTPUT_FILE}"
