Instructions to Use
Setup Chef Environment: Ensure you have Chef installed and your workstation is configured to use AWS.
Add AWS Credentials: Store your AWS credentials in the node attributes or use an IAM role if running on an EC2 instance.

Replace Placeholders:
Update the image_id with the latest Windows Server AMI ID.
Change the instance_type and key_name to match your setup.
Adjust the security_group_ids to include your existing security group.
Install Required Gems: Ensure the aws-sdk-ec2 gem is available in your Chef environment.

Run the Recipe: Execute the recipe using your Chef setup:
bash>chef-client --local-mode --runlist 'recipe[YOUR_COOKBOOK_NAME]'

Notes
The user_data section in the run_instances call includes PowerShell commands that install Windows Update services and apply the latest updates.
You may need to adjust the permissions of your IAM user or role to allow instance creation and management.
Ensure that the required ports (e.g., RDP) are open in the security group associated with the instance for remote access.
