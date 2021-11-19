library(targets)
library(tarchetypes)
library(babelwhale)

# Set babelwhale backend for running containers
# (here, we are using Docker, not Singularity)
set_default_config(create_docker_config())

# Define workflow
list(
	# Download example fastq files
	tar_file(
		read_1, { 
			download.file(
				url = c("https://raw.githubusercontent.com/OpenGene/fastp/master/testdata/R1.fq"),
				destfile = "R1.fq")
			"R1.fq"
		}
	),
	tar_file(
		read_2, { 
			download.file(
				url = c("https://raw.githubusercontent.com/OpenGene/fastp/master/testdata/R2.fq"),
				destfile = "R2.fq")
			"R2.fq"
		}
	),
	# Clean the fastq file with fastp
	tar_file(
		cleaned_fasta_file, {
			babelwhale::run(
				# Name of docker image, with tag specifying version
				"quay.io/biocontainers/fastp:0.23.1--h79da9fb_0",
				# Command to run
				command = "fastp",
				# Arguments to the command
				args = c(
					# fastq input files
					"-i", paste0("/wd/", read_1), 
					"-I", paste0("/wd/", read_2), 
					# fastq output files
					"-o", "/wd/R1_trim.fq",
					"-O", "/wd/R2_trim.fq",
					# trim report file
					"-h", "/wd/trim_report.html"),
				# Volume mounting specification
				volumes = paste0(getwd(), ":/wd/")
			)
			c("R1_trim.fq", "R2_trim.fq", "trim_report.html")
		}
	)
)

# The workflow can be run with:
# targets::tar_make()