###################################
#
# CFME Automate Method: Satellite5_AddSystem
#
#
# Notes: This method adds a VM to Satellite v5
# useful for new vms but using something like cloud-init would be preferred.
# 
#
###################################
begin
  # Method for logging
  def log(level, message)
    @method = 'getsystemid'
    $evm.log(level, "#{@method}: #{message}")
  end

  log(:info, "CFME Automate Method Started")

  # Dump all root attributes
  log(:info, "Listing Root Object Attributes:")
  $evm.root.attributes.sort.each { |k, v| log(:info, "\t#{k}: #{v}") }
  log(:info, "===========================================")
  
  # Get vm object from the VM class versus the VmOrTemplate class for vm.remove_from_service to work
  vm = $evm.vmdb("vm", $evm.root['vm_id'])
  raise "$evm.root['vm'] not found" if vm.nil?
  log(:info, "Found VM:<#{vm.ipaddresses}>")
  
    
  # Get Satellite server from model else set it here
  satellite = 'satellite.rdu.salab.redhat.com'
  satellite ||= $evm.object['servername']
  
  # Satellite activation key from model else set it here
  satellite_key ='2-demo'
  satellite_key ||= $evm.object['activationkey']
  
  #vm root user
  vmroot = 'root'
  vmroot ||= $evm.object['vmuser']
  
  #vm root password
  vmpassword = 'Redhat1!'
  vmpassword ||= $evm.object['vmpassword']
  
  
  # Require CFME rubygems and xmlrpc/client
  require "rubygems"
  require "net/ssh"
  
  #use net/ssh to login to the new VM and activate with satellite
  Net::SSH.start(vm.ip, vmroot, :password => vmpassword) do|ssh|
  	runcommand = ssh.exec('ls -l /var/log')
  	log(:info, "ran command:#{runcommand}")
  end  

  
  # Exit method
  log(:info, "CFME Automate Method Ended")
  exit MIQ_OK

  # Ruby rescue
rescue => err
  log(:error, "[#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_STOP
end