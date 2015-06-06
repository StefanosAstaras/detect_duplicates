#detect_duplicates

Note: detect_duplicates is not finished yet and doesn't work.

This Ruby script recursively searches your filesystem for duplicate files using 
simple MD5 hashing. How it works:

* It prints some crude progress details on the console.

* The results are written on dup_log.txt (no actual deletions take place).
You will be informed early if such a file happens to exist in your top folder
already.

* By default, it doesn't actually calculate the MD5 hash from entire files. Very 
large files are rarer but take a lot of time to hash, so it makes sense to read
only a portion of each file. The downside is that large, lightly variating files
will possibly come up as false positives.

* To avoid some of the aforementioned false positives, the script inserts file
size information. This means that the actual calculated MD5 hashes may be
different than what other programs calculate. This is not an issue, though, as
the absolute individual MD5 hash of each file is not relevant in itself.

* You can control its behavior with command line arguments. Or you can drop it
in the top folder you want to recursively search and double click (default way).