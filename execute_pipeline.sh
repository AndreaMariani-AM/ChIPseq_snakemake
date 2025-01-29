# Usage --> ./execute_pipeline.sh  <tmp_dir> [rules] (tmp_dir is mandatory, used defined directory to store fastq files merged.
# rules name can be nothing or a rule defined in the snakefile without wildcards in the input files)

# Check if tmp_dir argument is provided, if not print usage
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <tmp_dir> [the_rest...]"
  echo " 	<tmp_dir> : Please specifiy a name for the temporary directory, e.g. .snakemake_chip"
  exit 1
fi

mkdir -p results/.clusterLogs
snakemake -j 1 --unlock

# allow multiple runs on the same dir.
# Check if tmp dir exists, if it exists use it again, otherwise update it

# get the first CL supplied argument
tmp_dir="$1"
to_check=/hpcscratch/ieo/${USER}/${tmp_dir}

if [ -d "$to_check" ]; then
	echo "tmp_dir already exists, using this directory: $tmp_dir"
else
	echo "directory doesn't exist, creating it: $tmp_dir"
fi
# shfit so the rules go to the profile
shift

nohup snakemake --config tmp=/hpcscratch/ieo/${USER}/${tmp_dir} --profile workflow/snakemake_profile "$@" &>> results/snakemake.log&
