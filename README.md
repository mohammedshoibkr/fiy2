From cmd (admin), go to location:C:\Program Files\Java\jre1.8.0_261\bin\
$keytool -genkey -v -keystore fiy.keystore -alias simpfofiy2keystore -keyalg RSA -keysize 2048 -validity 10000

Keystore password:
S!mpf0@2019

$cd android; ./gradlew signingReport

Variant: debug
Config: debug
Store: D:\src\fiy\fiy2\android\app\fiy.keystore
Alias: simpfofiy2keystore
MD5: 97:4F:81:26:A8:C7:F5:47:3B:B5:18:B9:AA:CB:78:E5
SHA1: 6A:A5:A5:D4:8F:69:88:AF:70:8E:8E:39:9B:64:9A:3F:E7:7B:BC:3E
SHA-256: 38:5D:CA:CF:2F:BC:DE:06:38:C1:EC:EC:A9:EE:8F:A0:14:93:6D:ED:22:BD:15:F5:34:FA:21:9E:36:A4:65:10
Valid until: Saturday, February 20, 2049
----------
Variant: release
Config: release
Store: D:\src\fiy\fiy2\android\app\fiy.keystore
Alias: simpfofiy2keystore
MD5: 97:4F:81:26:A8:C7:F5:47:3B:B5:18:B9:AA:CB:78:E5
SHA1: 6A:A5:A5:D4:8F:69:88:AF:70:8E:8E:39:9B:64:9A:3F:E7:7B:BC:3E
SHA-256: 38:5D:CA:CF:2F:BC:DE:06:38:C1:EC:EC:A9:EE:8F:A0:14:93:6D:ED:22:BD:15:F5:34:FA:21:9E:36:A4:65:10
Valid until: Saturday, February 20, 2049

