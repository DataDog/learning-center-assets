# Create a sample EBS snapshot that the attacker will exfiltrate
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_ebs_volume" "volume" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 1

  tags = {
    Name = "psql-database-main-prod-volume"
  }
}
