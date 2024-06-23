# Backups

## B2 setup

The setup for the Backblaze B2 backups are based on [this write-up](https://scribe.rip/@benjamin.ritter/how-to-do-ransomware-resistant-backups-properly-with-restic-and-backblaze-b2-e649e676b7fa) (I recommend skipping to the TL;DR).

### Bucket creation

1. [Install the Backblaze CLI tools](https://www.backblaze.com/docs/cloud-storage-command-line-tools)
2. Create an [application key](https://secure.backblaze.com/app_keys.htm) with permissions to create buckets and other keys (I recommend creating temporary keys for this by setting a short expiration time) and authenticate with it

```sh
b2 account authorize [applicationKeyId] [applicationKey]
```

3. Create a new bucket with lifecycle rules:

```sh
b2 bucket create --default-server-side-encryption SSE-B2 --lifecycle-rule '{"daysFromHidingToDeleting": 30, "daysFromUploadingToHiding": null, "fileNamePrefix": ""}' [bucket-name] allPrivate
```

4. Create an application key with limited access to your specific bucket (I like to use the same key name as the bucket name):

```sh
b2 key create --bucket [bucket-name] [key-name] listBuckets,listFiles,readFiles,writeFiles
```

5. Take note of the key ID and its value that are outputted after running the previous command, you will need them to configure autorestic

In case of ransomware, lost data on the bucket can be restored using [this software](https://github.com/viltgroup/bucket-restore).
