require_relative 'config'

def check_some_config
  errors = []

  # Checks if the bootloader is valid.
  unless CONFIG[:bootloader] == false ||
    CONFIG[:bootloader] =~ /(systemd-boot|grub)/
    errors << "Bootloader #{CONFIG[:bootloader]} is not supported."
  end

  # If the bootloader is specified, check that the boot mode is UEFI.
  `ls /sys/firmware/efi/efivars`
  if CONFIG[:bootloader] && !$?.success?
    errors << 'In order for a bootloader to be configured, you must be in'\
      ' UEFI mode. It does not seem like you have booted in UEFI mode.'
  end

  # Checks if the kernel is valid.
  unless CONFIG[:kernel] =~ /linux(-(hardened|lts|zen))?/
    errors << "#{CONFIG[:kernel]} does not seem like a valid kernel"\
      ' in the official repository.'
  end

  # Checks if the keymap is valid.
  unless `localectl list-keymaps`.split("\n").include? CONFIG[:keymap]
    errors << "#{CONFIG[:keymap]} is not a valid keymap."
  end
  
  # Checks if the timezone is valid.
  unless File.exist? "/usr/share/zoneinfo/#{CONFIG[:timezone]}"
    errors << "#{CONFIG[:timezone]} is not a valid timezone."
  end

  # Assert that sudo_for_wheel is boolean.
  case CONFIG[:sudo_for_wheel]
  when TrueClass, FalseClass
  else
    errors << 'sudo_for_wheel is not boolean.'
  end

  if CONFIG[:partitioning][:auto] == true
    # Checks if disk exists.
    if `lsblk -d '#{CONFIG[:partitioning][:disk]}' | grep disk`.empty?
      errors << "Disk #{CONFIG[:partitioning][:disk]} does not exist."
    end

    # Checks that swap size is not 0.
    if CONFIG[:partitioning][:swap] =~ /0+[a-zA-Z]*/
      errors << 'The swap size cannot be empty or 0.'\
        ' Use `false` for no swap parition.'
    end

  elsif CONFIG[:partitioning][:auto] == false
    #Checks if partitions exist.
    CONFIG[:partitioning].except(:auto) do |_, partition|
      if `lsblk -d '#{partition}' | grep part`.empty?
        errors << "Partition #{partition} does not exist."
      end
    end
  
  else
    errors << 'partitioning:auto is not boolean.'
    
  end

  # Asserts that all passwords are correctly configured.
  CONFIG[:passwords].each do |user, password|
    errors << "Password for user #{user} is empty." if password.empty?

    unless (CONFIG[:users]+CONFIG[:wheel_users]+['root']).include? user.to_s
      errors << "User #{user} whose password is specified does not exist."
    end
  end

  errors
end
