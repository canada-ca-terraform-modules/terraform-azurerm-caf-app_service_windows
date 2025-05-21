locals {
  cert_url = strcontains(var.env, "G3") ? "https://g3pceslzresentdfa0353e.blob.core.windows.net/publicresources/GOC-GDC-ROOT-A.cer" : "https://gcpcenteslzpublicblob4df.blob.core.windows.net/publicresources/GOC-GDC-ROOT-A.cer" 
}

data "http" "cert" {
  count = try(var.appServiceWindows.inject_root_cert, false) ? 1 : 0
  url = local.cert_url
}