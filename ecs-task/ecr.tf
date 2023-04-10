resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr.name

  image_tag_mutability = var.ecr.image_tag_mutability 
}
