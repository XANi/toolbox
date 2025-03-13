## Copy GPT partition layout then randomize UUIDs

    # sgdisk /dev/nvme3n1 -R /dev/nvme4n1
    The operation has completed successfully.
    # sgdisk -G /dev/nvme4n1
    The operation has completed successfully.
