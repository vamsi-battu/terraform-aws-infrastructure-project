resource "aws_key_pair" "openvpn" {
    key_name = "openvpn"
    public_key = file("~/.ssh/openvpn.pub")
} 

resource "aws_instance" "vpn" {
  ami                    = local.ami
  key_name = aws_key_pair.openvpn.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [local.security_group_id]
  subnet_id = local.public_subnet_ids[0]
  #Giving the userdata path
  user_data = file("user-data.sh")
  tags = merge(
     var.common_tags,
     
    {
      Name = "${local.name_prefix}-vpn"
    }
  )
}