// Defining default network vpc resources for later references
resource "aws_default_vpc" "default_vpc" {

}
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-1a"
}
resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "eu-west-1c"
}