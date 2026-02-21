# Exercise 00 — Mount Points & RAM Disks

> **Summary:** Understand how Linux connects storage to directories, and build
> your own version of `03_create-ramdisk.sh` from scratch.
>
> **OS:** Ubuntu 22 (your VM)

---

## Chapter 1: The Big Picture — Everything is a File

In Linux, **everything** is accessed through the filesystem tree, starting at `/`.

But here's the thing — your filesystem tree is **not** a single disk. It's made
up of **multiple storage sources** stitched together at different points.

Think of it like a bookshelf:

- The **shelf** is the directory tree (`/`, `/home`, `/mnt`, etc.)
- The **books** are storage devices (hard drives, USB sticks, RAM, network shares)
- **Mounting** = placing a book on a specific shelf

When you "mount" a device to a directory, that directory becomes the **gateway**
to that device's contents.

---

## Chapter 2: Exercises

### Ex00 — Explore your current mounts

**Goal:** See what's already mounted on your system.

Run the following commands and **write down what you observe** in a file called
`answers.txt` (create it in this exercise directory):

```bash
# 1. Show all current mounts (there will be many)
mount

# 2. Show only the ones that matter (real disks)
lsblk

# 3. Show disk space usage in human-readable format
df -h

# 4. Read the file that defines what gets mounted at boot
cat /etc/fstab
```

**Questions (answer in `answers.txt`):**

1. What is the device mounted at `/` (your root filesystem)? (hint: look at `lsblk`)
2. How many entries are in your `/etc/fstab`?
3. What does the `df -h` output tell you about each mounted filesystem?

---

### Ex01 — Mount a directory manually

**Goal:** Understand mount and unmount with a real directory.

```bash
# 1. Create two directories
mkdir -p /tmp/ex01_source
mkdir -p /tmp/ex01_target

# 2. Create a file in the source
echo "I am the source" > /tmp/ex01_source/hello.txt

# 3. Mount source ON TOP OF target (bind mount)
sudo mount --bind /tmp/ex01_source /tmp/ex01_target

# 4. Check if you can see the file through the target
cat /tmp/ex01_target/hello.txt

# 5. Create a new file from the target side
echo "Written from target" > /tmp/ex01_target/new_file.txt

# 6. Check: does it appear in source?
ls /tmp/ex01_source/

# 7. Unmount
sudo umount /tmp/ex01_target

# 8. Check target again — what happened?
ls /tmp/ex01_target/
```

**Questions (answer in `answers.txt`):** 4. After step 6, did `new_file.txt` appear in `/tmp/ex01_source/`? Why? 5. After step 8, what's inside `/tmp/ex01_target/`? Why? 6. In your own words, what does "mounting" mean?

---

### Ex02 — What is `tmpfs`?

**Goal:** Understand the `tmpfs` filesystem (the filesystem used in ramdisks).

`tmpfs` is a special filesystem that lives **entirely in RAM**. It doesn't touch
any physical disk. This makes it:

- ⚡ **Extremely fast** (RAM speed vs disk speed)
- 💨 **Volatile** — data is lost on reboot
- 📦 **Size-limited** — you allocate a fixed amount of RAM to it

```bash
# 1. Create a mount point
sudo mkdir -p /mnt/my_ramdisk

# 2. Mount a 64MB tmpfs
sudo mount -t tmpfs -o size=64M tmpfs /mnt/my_ramdisk

# 3. Verify it exists
df -h /mnt/my_ramdisk

# 4. Write a file to it
echo "I live in RAM!" > /mnt/my_ramdisk/test.txt
cat /mnt/my_ramdisk/test.txt

# 5. Check: how much space did it use?
df -h /mnt/my_ramdisk

# 6. Clean up
sudo umount /mnt/my_ramdisk
sudo rmdir /mnt/my_ramdisk
```

**Questions (answer in `answers.txt`):** 7. What is the "type" of filesystem shown by `df` for your ramdisk? 8. What would happen to `/mnt/my_ramdisk/test.txt` if you rebooted without
unmounting? Why? 9. If your computer has 8GB of RAM and you create a `size=1G` tmpfs, does it
immediately consume 1GB of RAM? (hint: research "tmpfs lazy allocation")

---

### Ex03 — Understanding `/etc/fstab`

**Goal:** Learn the format of `/etc/fstab` — the file that makes mounts survive
reboots.

`/etc/fstab` is a simple text file. Each line has **6 fields**:

```
<device>  <mount_point>  <type>  <options>  <dump>  <fsck>
```

| Field         | Meaning                                                        |
| ------------- | -------------------------------------------------------------- |
| `device`      | What to mount (a disk like `/dev/sda1`, or `tmpfs`, or a UUID) |
| `mount_point` | Where to mount it (a directory)                                |
| `type`        | Filesystem type (`ext4`, `tmpfs`, `nfs`, etc.)                 |
| `options`     | Mount options (comma-separated)                                |
| `dump`        | `0` = don't back up (almost always `0`)                        |
| `fsck`        | `0` = don't filesystem-check at boot                           |

Here is the line from the ramdisk script:

```
tmpfs /mnt/ramdisk tmpfs nodev,nosuid,noexec,nodiratime,size=1G 0 0
```

**Questions (answer in `answers.txt`):** 10. Break down each of the 6 fields in the line above and explain what each means. 11. What do these mount options do? (research each one): - `nodev` - `nosuid` - `noexec` - `nodiratime` 12. Why are these security options important for a ramdisk that stores monitoring
data? 13. What does `mount -a` do? Why is it useful after editing `/etc/fstab`?

---

### Ex04 — Build your own ramdisk script

**Goal:** Write your own version of `03_create-ramdisk.sh` **from scratch**.

Create a script called `my_ramdisk.sh` in this exercise directory. It must:

1. Accept **two arguments**: mount point path and size (e.g., `./my_ramdisk.sh /mnt/test 128M`)
2. Validate that exactly 2 arguments are provided. Print usage if not.
3. Create the mount point directory if it doesn't exist.
4. Check if an entry for that mount point already exists in `/etc/fstab`:
   - If **no** → append a new tmpfs entry
   - If **yes** → update the existing entry with the new size
5. Mount everything from fstab (`mount -a`)
6. Print the result using `df -h`

**Bonus:**

- Add a `--remove` flag that unmounts and removes the fstab entry.
- Add input validation (size must end in `M` or `G`, path must be absolute).

**Evaluation:**

- Your script must be **idempotent** (running it twice produces the same result).
- Must handle errors gracefully (no crashes, no raw stack traces).
- Must work on your Ubuntu VM.

---

## Chapter 3: How this connects to SemaFor

Now that you understand mount points, here's the full picture:

```
┌──────────────────────────────────────────────────┐
│                  Your Ubuntu VM                  │
│                                                  │
│  ┌──────────────┐     ┌───────────────────────┐  │
│  │   Conky       │────▶│  /mnt/ramdisk (tmpfs) │  │
│  │  (Desktop     │reads│                       │  │
│  │   Overlay)    │     │  - cpu_stats.txt      │  │
│  └──────────────┘     │  - gpu_stats.txt      │  │
│                        │  - k8s_status.txt     │  │
│  ┌──────────────┐     │                       │  │
│  │  SemaFor      │────▶│  (Written every few   │  │
│  │  Services     │write│   seconds by scripts) │  │
│  └──────────────┘     └───────────────────────┘  │
│                                                  │
│  Why RAM?  → Fast I/O, no disk wear,             │
│              data is disposable anyway            │
└──────────────────────────────────────────────────┘
```

The ramdisk is a **scratchpad**. SemaFor services write live metrics to it.
Conky reads them and displays them on your desktop. Since the data refreshes
every few seconds, there's no reason to involve a physical disk.

---

## Submission

Your exercise directory should contain:

```
exercises/00_mount-points/
├── subject.md          (this file)
├── answers.txt         (your answers to all 13 questions)
└── my_ramdisk.sh       (your script from Ex04)
```

Good luck! 🚀
