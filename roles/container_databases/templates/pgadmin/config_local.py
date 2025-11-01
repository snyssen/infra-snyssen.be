OAUTH2_CONFIG = [
    {
        'OAUTH2_NAME': 'Authelia',
        'OAUTH2_DISPLAY_NAME': 'Authelia',
        'OAUTH2_CLIENT_ID': '{{ backbone__authelia__oidc_pgadmin_clientid }}',
        'OAUTH2_CLIENT_SECRET': '{{ backbone__authelia__oidc_pgadmin_clientsecret }}',
        'OAUTH2_TOKEN_URL': 'https://auth.{{ main_domain }}/api/oidc/token',
        'OAUTH2_AUTHORIZATION_URL': 'https:/auth.{{ main_domain }}/api/oidc/authorization',
        'OAUTH2_SERVER_METADATA_URL': 'https://auth.{{ main_domain }}/.well-known/oauth-authorization-server',
        'OAUTH2_API_BASE_URL': 'https://auth.{{ main_domain }}',
        'OAUTH2_USERINFO_ENDPOINT': 'https://auth.{{ main_domain }}/api/oidc/userinfo',
        'OAUTH2_SCOPE': 'openid profile groups email',
        'OAUTH2_USERNAME_CLAIM': 'preferred_username',
        'OAUTH2_AUTO_CREATE_USER': "False",
        # 'OAUTH2_ADDITIONAL_CLAIMS':
        "OAUTH2_BUTTON_COLOR": "None",
        "OAUTH2_ICON": "None"
    }
]
OAUTH2_AUTO_CREATE_USER = True
