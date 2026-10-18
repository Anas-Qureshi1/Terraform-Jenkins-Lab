data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = "t3.micro"

  tags = {
    Name      = "terraform-jenkins-lab"
    ManagedBy = "Terraform"
    Project   = "Lab23"
  }
}
