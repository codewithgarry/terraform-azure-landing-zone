# Replace <tfstate-account> with the output of bootstrap/.
resource_group_name  = "rg-tfstate"
storage_account_name = "<tfstate-account>"
container_name       = "tfstate"
key                  = "landing-zone/dev.tfstate"
use_azuread_auth     = true
