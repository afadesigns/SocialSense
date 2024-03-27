import zipfile
import json

def create_manifest(name, version, manifest_version, permissions, background_scripts, minimum_chrome_version):
    return {
        "version": version,
        "manifest_version": manifest_version,
        "name": name,
        "permissions": permissions,
        "background": {
            "scripts": background_scripts
        },
        "minimum_chrome_version": minimum_chrome_version
    }

def create_background_script(proxy_config, bypass_list):
    config = {
        "mode": "fixed_servers",
        "rules": {
            "singleProxy": proxy_config,
            "bypassList": bypass_list
        }
    }

    def auth_callback(details):
        return {
            "authCredentials": {
                "username": proxy_config["username"],
                "password": proxy_config["password"]
            }
        }

    return {
        "config": config,
        "auth_callback": auth_callback
    }

def get_proxy_extension(PROXY_HOST, PROXY_PORT, PROXY_USER, PROXY_PASS):
    print(PROXY_HOST, PROXY_PORT, PROXY_USER, PROXY_PASS)
    pluginfile = "proxy_auth_plugin.zip"

    manifest = create_manifest(
        name="Chrome Proxy",
        version="1.0.0",
        manifest_version=2,
        permissions=[
            "proxy",
            "tabs",
            "unlimitedStorage",
            "storage",
            "<all_urls>",
            "webRequest",
            "webRequestBlocking"
        ],
        background_scripts=["background.js"],
        minimum_chrome_version="22.0.0"
    )

    background = create_background_script(
        proxy_config={
            "scheme": "http",
            "host": PROXY_HOST,
            "port": PROXY_PORT,
            "username": PROXY_USER,
            "password": PROXY_PASS
        },
        bypass_list=["localhost"]
    )

    with zipfile.ZipFile(pluginfile, "w") as zp:
        zp.writestr("manifest.json", json.dumps(manifest))
        zp.writestr("background.js", f"{background['config']
