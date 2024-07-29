#!/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if httpx is installed
if ! command_exists httpx; then
    echo "Error: httpx is not installed. Please install it and try again."
    exit 1
fi

# Check if GNU Parallel is installed
if ! command_exists parallel; then
    echo "Error: GNU Parallel is not installed. Please install it and try again."
    exit 1
fi

read -p "Enter name of the file that contains scope: " input_file
output_file_prefix=".urls_chunk"
output_suffix="_no_redir.txt"
merged_output_file="scope_no_redir.txt"
lines_per_chunk=500

process_url() {
    url="$1"
    response=$(httpx -silent -location -nc -u "$url")
    if echo "$response" | grep -qP "\[\]"; then
        echo "$url"
    fi
}
export -f process_url

rm -f ${output_file_prefix}_* ${output_file_prefix}_*${output_suffix} "$merged_output_file"

split -l "$lines_per_chunk" "$input_file" "${output_file_prefix}_"

for chunk in ${output_file_prefix}_*; do
    output_file="${chunk}${output_suffix}"

    > "$output_file"
    ( 
        start_time=$(date +%s)
        echo "Started the process for the chunk $chunk"
        parallel --will-cite process_url :::: "$chunk" > "$output_file"
        end_time=$(date +%s)
        execution_time=$((end_time - start_time))
        echo "Chunk $chunk execution time: $execution_time seconds"
    ) &
done

wait

cat ${output_file_prefix}_*${output_suffix} > "$merged_output_file"
rm ${output_file_prefix}_*
