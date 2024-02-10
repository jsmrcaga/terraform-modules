locals {
  pi_map = {
    for pi in var.pis:
    pi.host => pi
  }
}
