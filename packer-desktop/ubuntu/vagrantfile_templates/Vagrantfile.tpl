Vagrant.require_version ">= 1.7.3"

Vagrant.configure(2) do |config|
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider "virtualbox" do |v, override|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    vb.name = "lubuntu-docker-python"

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
end

