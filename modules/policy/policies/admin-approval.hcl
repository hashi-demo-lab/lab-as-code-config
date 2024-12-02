# Permission to approve control group requests.
path "sys/control-group/authorize" {
    capabilities = ["create", "update"]
}

# Permission to check control group request status
path "sys/control-group/request" {
    capabilities = ["create", "update"]
}