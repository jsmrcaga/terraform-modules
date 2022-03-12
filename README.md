# Jo's Terraform Modules

## Usage
```terraform
module example {
  source = "github.com/hashicorp/example"

  # options
  source = "git@github.com:jsmrcaga/example.git"
  source = "git@github.com:jsmrcaga/example.git?ref=v1.2.0"
    source = "git@github.com:jsmrcaga/example.git//lambda-api?ref=v1.2.0"
}
```
