#Skeleton
{% for instance in instances %}
resource "aws_instance" "{{ instance.name }}" {
  ami           							= "{{ instance.ami }}"
  instance_type 							= "{{ intance.instance_type }}"
  subnet_id 									= "{{ instance.subnet_id }}"
  key_name 										= "{{ intance.key_name }}"
  vpc_security_group_ids 			= ["{{ instance.security_groups_id }}"]
  associate_public_ip_address = {{ instance.enable_public_ip }}
  tags {
    Name = "prod-nodeJS"
  }
}
{% endfor %}
