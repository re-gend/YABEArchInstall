# YABE Arch Install
```
__    __    _
\ \  / /   / \
 \ \/ /   /`_ \
  |  |   / | |`\
  |__|  /_/   \_\
_______   ______
|  __  \ |  ____)
| |__| / | |__
| |__| \ |  __)
|______/ |______)
```
Yet Another Biased, Experienced users' Arch Install

YABE Arch Install is a ruby script for installing Arch Linux quickly.

# Main Features

## One intuitive yet powerful configuration file

YABE Arch Install uses one file for various configurations
from hostname, locale and packages to install,
extending to partitioning, bootloader, daemons to enable and more.

## Ease of custom automated install

Due to the single-config-file nature of YABE Arch Install, it is very easy to
create customized install scripts based on it.
You simply have to create your own configuration for YABE Arch Install that you
can easily grab in the archiso, with perhaps some code that fetches and runs
YABE Arch Install with your configuration.

# How To Use

## Acknowledgements before using

### Difficulty
YABE Arch Install is designed for users who understand the basics of Arch Linux
/ other Linux installation process. It will be best to try a manual
installation of a Linux distribution like Arch before using this.

### Dangers

There is no certainty that YABE Arch Install will work as intended. You should
have important data backed up on multiple devices and/or on a cloud service.\
Also, YABE Arch Install operates very closely to the operating system, and is
not designed to be robust against injections. Any "correct" values will cause
no harms, but please input data in the correct format.\
Finally, one should not trust the brief check that takes place before
installation. The check only covers some configurations that can be checked
simply.

## Step-by-step guide

There can be many ways to fetch the install script and installing, but simply
cloning the git repository and running the script is one of the most simplest
ways.

Let us download the pacman database and update before installing packages.\
`pacman -Syu`

Then, install git to be able to clone the repository.\
`pacman -S git`

Clone this repository.\
`git clone https://github.com/re-gend/YABEArchInstall.git`

`cd` into the project directory. Otherwise, the script will not work.\
`cd YABEArchInstall`

Edit the config.rb file to your liking. Or, you can provide a different path to
the configuration file with the -c or the --config option.\
`vim config.rb`

As YABE Arch install is made using ruby, the ruby interpreter is needed.\
`pacman -S ruby`

Run the main script. use the -h option to see what options are available.\
`./main`

# Configurations

The configuration file is designed to be self-explanatory, but if you are
confused about anything, you may refer to this section.

* `bootloader`\
  The name of a bootloader to use, or `false` to not configure one.
  Currently, 'systemd-boot' and 'grub' are supported.

* `kernel`\
  The name of the kernel to use. Only accepts kernel packages in the
  official repository, which are: Linux, Linux-hardened, Linux-lts, Linux-zen.

* `hostname`\
  The name to identify your computer.

* `keymap`\
  A valid Linux keymap.

* `locale`\
  A locale in the form of *language_territory* like en_US.
  The UTF-8 standard is used for the codeset.

* `timezone`\
  A timezone in the form *Reigion/City*.

* `users`\
  An array of usernames to be created.
  If you want to create administrator accounts, use wheel_users instead.

* `wheel_users`\
  An array of usernames to be created in the group wheel.

* `sudo_for_wheel`\
  A boolean value, when set to `true`, will configure sudo so that group wheel
  can use sudo by entering their passwords.

* `packages`\
  An array of packages that would be installed.
  Note that very common packages such as vim, base-devel and more are not
  provided by default for maximum customizability.

* `systemctl_enable`\
  An array of daemons that would be enabled by systemctl.

## `partitioning`

* `auto`\
  Accepts `true` or `false`. This determines which values the program will use
  as configuration when partitioning.

  Using `true` provides opinionated partitioning on a whole disk with 512MiB of
  EFI partition, root partiiton, and then an optional swap partition of
  configurable size.

  Using `false` allows you to manually partition and fill in their names,
  which allows custom size and locations for all partitions.

### When `auto` is `true`

* `disk`\
  A path to the disk for installation. Eg. "/dev/nvme0n1".
	Be careful not to put a name of a partition, as that would result in an
	undefined behaviour.

* `filesystem`\
  The name of filesystem that the root partition will be formatted to.
	It is good to note that this value goes into the `mkfs` command if there is
  any trouble.

* `swap`\
  Accepts either `false` or a valid partition size for the swap partition. 
  No swap is created if `false` is passed.

### When `auto` is `false`

* `boot`\
  The partition where the bootloader will be installed if one is specified.
  When the bootloader is `false`, this will be ignored.

* `root`\
  The partition for the root filesystem.

## `passwords`

Add a key for any users you would want a password for, and set the value as the
password you want.

## `aur`

When the aur hash(object) is present in the configuration, YABE Arch Install
tries to install packages automatically in multiple steps.

* `build_user`\
  A user of this name is created if not exists already.
  sudo is configured for this user so they can use pacman as root without
  pasword.

* `packages`\
  An array of AUR packages that would be installed.
