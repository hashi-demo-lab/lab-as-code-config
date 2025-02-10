path "intermediate-ca"               { capabilities = ["read", "list"] }
path "intermediate-ca/sign/base"     { capabilities = ["create", "update"] }
path "intermediate-ca/issue/base"    { capabilities = ["create"] }
path "intermediate-ca/sign/dev-role" { capabilities = ["create", "update"] }