# This config file uses ruby's hash notation which can be very similar to JSON.

CONFIG = {
  # 'systemd-boot' and 'grub' available.
  # Set this to `false` if you do not want a bootloader set up.
  bootloader: 'systemd-boot',

  # Only kernels from the official repository are allowed
  # which are: linux, linux-hardened, linux-lts, linux-zen
  kernel: 'linux',

  hostname: 'yetanotherarch',
  keymap: 'us',
  locale: 'en_US',
  timezone: 'Etc/UTC',

  users: [],
  wheel_users: ['user_name'],
  sudo_for_wheel: true,

  packages: ['vim', 'base-devel', 'networkmanager'],

  systemctl_enable: ['NetworkManager'],

  partitioning: {
    auto: true,

    # Put the disk name, not a partition name.
    disk: '',
    filesystem: 'btrfs',

    # Set this to `false` if you do not want any swap partition.
    swap: '8GiB',
  },
  # Use the partitioning below for manual partitioning.
  # You will then need to create file systems on the partitions as well.
  #
  #partitioning: {
  #  auto: false,
  #  boot: '',
  #  root: '',
  #},

  # Add a password with the user name as the key.
  passwords: {
    root: '',
    user_name: '',
  },

  # Uncomment and write contensts to the aur hash(object)
  # if you want aur packages installed automatically.
  #
  #aur: {
  #  # A user of this name is created if not exists already.
  #  # sudo is configured for the user so they can use pacman without as root
  #  # without password.
  #  build_user: 'aur_builder',
  #
  #  packages: [],
  #},
}
