# Define the IP range of your Windows servers
ip_range = '192.168.1.10'..'192.168.1.100'

# Retrieve installed packages from each server
installed_packages = {}

ip_range.each do |ip_address|
  powershell_script = <<-EOH
    Get-Package | Select-Object Name, Version | Format-Table -HideTableHeaders
  EOH

  package_info = powershell_out("Invoke-Command -ComputerName #{ip_address} -ScriptBlock {#{powershell_script}}")
  installed_packages[ip_address] = package_info.stdout.split("\n")
end

# Compare packages and identify mismatches
base_packages = installed_packages[ip_range.first]

mismatched_servers = {}

installed_packages.each do |ip_address, packages|
  unless packages == base_packages
    mismatched_servers[ip_address] = packages
  end
end

# Report results
if mismatched_servers.empty?
  Chef::Log.info('All servers have the same packages installed.')
else
  mismatched_servers.each do |ip_address, packages|
    Chef::Log.warn("Server #{ip_address} has mismatched packages: #{packages}")
  end
  raise 'Package mismatch found!'
end
