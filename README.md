# tyk-cutom-server
Add Tyk Policy

 "jwt_signing_method": "rsa",
 "jwt_source": "https://keycloak-auth-server.apps.tas.uat.lnd.hclcnlabs.com/auth/realms/oauth2-sample/protocol/openid-connect/certs",
 "jwt_identity_base_field": "sub",
 "jwt_client_base_field": "",
 "jwt_policy_field_name":"pol",
 "jwt_default_policies": [
                        "keycloak2"
  ],
  "jwt_scope_to_policy_mapping": {
      "message.read": "keycloak2"
  },
  "jwt_scope_claim_name": "scope",
