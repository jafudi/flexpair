Vagrant.require_version ">= 1.7.3"

Vagrant.configure(2) do |config|
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider "virtualbox" do |vb, override|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    vb.name = "lubuntu-docker-python"

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/home/vagrant/host", automount: true
end

