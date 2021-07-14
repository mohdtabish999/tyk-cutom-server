# tyk-cutom-server

Add Tyk Policy in docker app folder /opt/tyk-gateway/apps/translator-service-api.json
````
 
 "jwt_policy_field_name":"pol",
 "jwt_default_policies": [
                        "keycloak2"
  ],
  "jwt_scope_to_policy_mapping": {
      "message.read": "keycloak2"
  },
  "jwt_scope_claim_name": "scope",
````
