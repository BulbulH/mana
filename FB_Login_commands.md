FB login:
    Signed Undevelopment testing :
        keytool -exportcert -alias "applipiewoo" -storepass "applipiewoo" -keystore "/Users/applipie/EnvatoProject/wooflux\ WCFM/code\ wooflux/android/app/keystore.jks" | openssl sha1 -binary | openssl base64
    PlayStore Build :
        Go to Release Management here
        Select Release Management  -> App Signing
        You can see SHA1 key in hex format App signing certificate. 
        Copy the SHA1 in hex format and convert it in to base64 format, you can use this link do that without the SHA1: part of the hex. 
        Go to Facebook developer console and add the key(after convert to base 64) in the settings —> basic –> key hashes.
        