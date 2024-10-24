# Made by Lord Madan Babu
# @linkedin.com/in/madan-babu
# recipes/default.rb

# Ensure the aws-sdk gem is available
chef_gem 'aws-sdk-ec2' do
  compile_time true
end

require 'aws-sdk-ec2'

# AWS EC2 Client Configuration
aws_client = Aws::EC2::Client.new(
  region: 'us-west-2', # Change to your preferred region
  access_key_id: node['aws']['access_key_id'],
  secret_access_key: node['aws']['secret_access_key']
)

# Create a new EC2 instance
response = aws_client.run_instances({
  image_id: 'ami-xxxxxxxx', # Replace with the latest Windows Server AMI ID
  min_count: 1,
  max_count: 1,
  instance_type: 't2.micro', # Change as needed
  key_name: 'your-key-pair', # Replace with your key pair name
  security_group_ids: ['sg-xxxxxxxx'], # Replace with your security group ID
  user_data: <<-EOF
    <powershell>
      # Install Windows Updates
      Install-WindowsFeature -Name UpdateServices -IncludeManagementTools
      Start-Service -Name wuauserv
      Start-Service -Name bits
      Start-Service -Name msiserver
      Invoke-Expression -Command "Get-WindowsUpdate -Install -AcceptAll -AutoReboot"
    </powershell>
  EOF
})

instance_id = response.instances[0].instance_id

# Wait for the instance to be running
aws_client.wait_until(:instance_running, instance_ids: [instance_id])

# Output the instance information
instance_info = aws_client.describe_instances(instance_ids: [instance_id])
instance_public_ip = instance_info.reservations[0].instances[0].public_ip_address

log "Windows Server instance created with ID: #{instance_id} and Public IP: #{instance_public_ip}"
