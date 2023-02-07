locals {
  pages = var.pages == null ? [] : [merge(var.pages, {
    source = var.pages.github_actions ? {
      branch = "master"
      path = "/"
    } : var.pages.source
  })]
}
