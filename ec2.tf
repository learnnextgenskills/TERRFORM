resource "aws_eip" "default" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

resource "aws_instance" "web" {
  ami           = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids = ["${aws_security_group.FrontEnd.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "MY_TF_EC2_Public"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd24 php56 php56-mysqlnd",
      "sudo service httpd start",
      "sudo chkconfig httpd on",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www",
    ]
    connection {
            type     = "ssh"
            user     = "ec2-user"
            private_key = "${file("/home/vagrant/terra_practise/Murali_Keypair.pem")}"
        }
  }
  provisioner "file" {
        source      = "zerotype/"
        destination = "/var/www/html"

        connection {
            type     = "ssh"
            user     = "ec2-user"
            private_key = "${file("/home/vagrant/terra_practise/Murali_Keypair.pem")}"
        }
    }

 
}
