#!/bin/bash

# Function to validate if input is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Check if the partition number is provided as a command-line argument
if [ -z "$1" ]; then
    # Prompt for the partition number if not provided
    read -p "Enter the partition number: " partition_number
else
    partition_number=$1
fi

# Validate the partition number
if ! is_number "$partition_number"; then
    echo "Error: A valid partition number (numeric value) must be provided."
    exit 1
fi

# Attempt to find the root file system device and resize the root partition.
root_device=$(lsblk -no pkname $(findmnt -n -o SOURCE /))
root_device="/dev/${root_device}"
# Resize the partition.
echo "e
${partition_number}

w" | fdisk ${root_device}
resize2fs ${root_device}${partition_number}
