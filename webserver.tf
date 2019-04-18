provider "aws"{
region 	="us-west-1"
}
resource "aws_security_group" "websg" {
 name ="terraform-webserver-websg"
ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_key_pair" "tf-demokey" {
               key_name	= "tf-demokey"
               public_key	= "${file("/home/ubuntu/tf-demo.pub")}"
}
resource "aws_instance" "LT_Web_server" {
	ami	= "ami-069339bea0125f50d"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.websg.id}"]
	tags  {
	      Name = "LT_Web_server"
	}
               connection {
	user		= "ubuntu"
	private_key	= "${file("/home/ubuntu/tf-demo")}"
}
             provisioner "remote-exec" {
	inline = [
	"sudo apt-get update",
	"sudo apt-get install apache2 -y",
	"sudo systemctl enable apache2",
	"sudo systemctl start apache2",	
	"sudo chmod 777 /var/www/html/index.html"
	]
}
provisioner "file" {
    source = "index.html"
    destination = "/var/www/html/index.html"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 644 /var/www/html/index.html"
    ]
  }
}

