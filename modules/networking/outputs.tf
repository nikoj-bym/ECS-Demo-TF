output "subnets" {
    description = "Subnets to be used for ECS network config"
    value = ["${aws_default_subnet.default_subnet_a.id}","${aws_default_subnet.default_subnet_c.id}"]
}