#include <pgmspace.h>
 
#define SECRET
#define THINGNAME "feeder1"                         //change this
 
const char WIFI_SSID[] = "iPhone";               //change this
const char WIFI_PASSWORD[] = "1234qwer";           //change this
const char AWS_IOT_ENDPOINT[] = "a3s8fm7ruabocj-ats.iot.eu-west-1.amazonaws.com";       //change this
 
// Amazon Root CA 1
static const char AWS_CERT_CA[] PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIDQTCCAimgAwIBAgITBmyfz5m/jAo54vB4ikPmljZbyjANBgkqhkiG9w0BAQsF
ADA5MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRkwFwYDVQQDExBBbWF6
b24gUm9vdCBDQSAxMB4XDTE1MDUyNjAwMDAwMFoXDTM4MDExNzAwMDAwMFowOTEL
MAkGA1UEBhMCVVMxDzANBgNVBAoTBkFtYXpvbjEZMBcGA1UEAxMQQW1hem9uIFJv
b3QgQ0EgMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALJ4gHHKeNXj
ca9HgFB0fW7Y14h29Jlo91ghYPl0hAEvrAIthtOgQ3pOsqTQNroBvo3bSMgHFzZM
9O6II8c+6zf1tRn4SWiw3te5djgdYZ6k/oI2peVKVuRF4fn9tBb6dNqcmzU5L/qw
IFAGbHrQgLKm+a/sRxmPUDgH3KKHOVj4utWp+UhnMJbulHheb4mjUcAwhmahRWa6
VOujw5H5SNz/0egwLX0tdHA114gk957EWW67c4cX8jJGKLhD+rcdqsq08p8kDi1L
93FcXmn/6pUCyziKrlA4b9v7LWIbxcceVOF34GfID5yHI9Y/QCB/IIDEgEw+OyQm
jgSubJrIqg0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMC
AYYwHQYDVR0OBBYEFIQYzIU07LwMlJQuCFmcx7IQTgoIMA0GCSqGSIb3DQEBCwUA
A4IBAQCY8jdaQZChGsV2USggNiMOruYou6r4lK5IpDB/G/wkjUu0yKGX9rbxenDI
U5PMCCjjmCXPI6T53iHTfIUJrU6adTrCC2qJeHZERxhlbI1Bjjt/msv0tadQ1wUs
N+gDS63pYaACbvXy8MWy7Vu33PqUXHeeE6V/Uq2V8viTO96LXFvKWlJbYK8U90vv
o/ufQJVtMVT8QtPHRh8jrdkPSHCa2XV4cdFyQzR1bldZwgJcJmApzyMZFo6IQ6XU
5MsI+yMRQ+hDKXJioaldXgjUkK642M4UwtBV8ob2xJNDd2ZhwLnoQdeXeGADbkpy
rqXRfboQnoZsG4q5WTP468SQvvG5
-----END CERTIFICATE-----
)EOF";
 
// Device Certificate                                               //change this
static const char AWS_CERT_CRT[] PROGMEM = R"KEY(
-----BEGIN CERTIFICATE-----
MIIDWjCCAkKgAwIBAgIVANIZ+ZgYEvzVUS949aTBaCnIj0qmMA0GCSqGSIb3DQEB
CwUAME0xSzBJBgNVBAsMQkFtYXpvbiBXZWIgU2VydmljZXMgTz1BbWF6b24uY29t
IEluYy4gTD1TZWF0dGxlIFNUPVdhc2hpbmd0b24gQz1VUzAeFw0yMzAzMjExMzM5
NThaFw00OTEyMzEyMzU5NTlaMB4xHDAaBgNVBAMME0FXUyBJb1QgQ2VydGlmaWNh
dGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDa+s0eKxA0+cRlntQv
GH0MBsyJbKCCl/eLrazewzmfDAXadmKmSif/LbbVxIInmNsovjoe3ZLcXNrhOlbE
DJPQVkty8FG6n88ds7+AMw0LQdnzNlYIF8aKmvQmV7hIxLVo3YZ82zyCOSvq6yJ4
dsLiqhGcwnIlLwyJO0XXH/EgGKtllhXFhN5dUBErQESbbaVYOyR6Yz0Nd/vaoM+R
QeYyR0w2eJYUq5k5sSDDxPoM73PyieATBSxX8AddHCYW80w0090B1W8/l1m5+ayz
gQjVu1ZmoqWnHg/yCDYNmqdL+ALr11NfucZsExLV8ijOVpLJk5qeYyX6ZgXdiwYy
H0aJAgMBAAGjYDBeMB8GA1UdIwQYMBaAFEw2Ciede56e7aBWkY77vtT93C9UMB0G
A1UdDgQWBBR/2k5PqBrSnBl9mrXAnpJnlLmToTAMBgNVHRMBAf8EAjAAMA4GA1Ud
DwEB/wQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAQEAhjczsFpHz0/sDgjOpy4kcYiv
J2Dmlzg5QUPMrpR+PXKTgeW8cGxgJ16s3wilDFuAZ34YJMuVGFKz4QWMPYvZNHQX
+hCZsfjORbQXb74+YBN9rh8/7SKBZHj0mBcPXuM0ltnaWUTgscE7EqeoP/GFtKJ1
6fJUoYR16DHzN8IH5fjBtWMyD++0CXI88k+qCI6zzaDuuIeddIGurSx2UfRuKVt3
Maf6mhtCD99m3mMWFuxxi3mtLOcLj/Zc8ag84Ga3k5VSi+jxPeNV+BuyoSsrF+mz
hybSrlmYK3hDTXUaAIAAmyWgJZkNjnoVKoaCoeTaEsU/RNknIjkeZkTPjzz0tg==
-----END CERTIFICATE----- 
)KEY";
 
// Device Private Key                                               //change this
static const char AWS_CERT_PRIVATE[] PROGMEM = R"KEY(
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA2vrNHisQNPnEZZ7ULxh9DAbMiWyggpf3i62s3sM5nwwF2nZi
pkon/y221cSCJ5jbKL46Ht2S3Fza4TpWxAyT0FZLcvBRup/PHbO/gDMNC0HZ8zZW
CBfGipr0Jle4SMS1aN2GfNs8gjkr6usieHbC4qoRnMJyJS8MiTtF1x/xIBirZZYV
xYTeXVARK0BEm22lWDskemM9DXf72qDPkUHmMkdMNniWFKuZObEgw8T6DO9z8ong
EwUsV/AHXRwmFvNMNNPdAdVvP5dZufmss4EI1btWZqKlpx4P8gg2DZqnS/gC69dT
X7nGbBMS1fIozlaSyZOanmMl+mYF3YsGMh9GiQIDAQABAoIBAQDQl2+keSjrDbED
jBRa+FzFhAR6M7uCKvhnWXz+hcDxvCYnP/YgqSsIbKdpYdMJnRXG7c23cSFgQCNP
wJ6+Ca0UG9+rETkJKQnGJV8Z44ddXdEbWHsDIoLBrXE8xPqKdrbHuZ1Oehhdg9BN
6sXfMmHaQF6ekKriuLqcTpXsokSyaIpmUuH+27bPR2903heyGJNXBeN9q7SS3dcG
sHhC6Bsu7N/wnsgiNpp2LOSnN8Y4ZdYVTbUbxYyr5/ClP5WniUGYHWJbGWBi/Ves
Ej4czc42MaaMuhRSuZodJ4AtBfnsD+CvRrosW+YDVtxwXHMA2qyvDL70i+Nge1J9
XXp2hx5xAoGBAO4mZ2d7KMZn9JVsG1um6khE+SY5KMEP5ax4oQ0j4gYzFwTsuccB
2izlLW9hgNBNCYdP0gBSk3lrcQGlzavqkz+am9S0jWFIcil0bLJ/Iiet0yn2gDLg
NWCbs0wEEmQJMpwoUXeOk5Dq1qpFnF7L6meAiNPNGT++dtrCKI2tozYLAoGBAOtk
jy2BEqJzw+jO6tuaNs4swl5LqftlzVHoHHgGuUMfneuKYMSauKK4DMKjpX3x6QwR
LRyus6MBzRCm4uUoGTeF7sRXuzBHXV+8Yb8sqV59jAkUfS9TMeufe2PTm2z3DEZ4
TTao9CM8MU36V+hdqjs4zCAxDbN3NAgusOTLArY7AoGBAIfRXyelFZwRrWuKPBAJ
IZQVwgIKlzOD3Xh/U1orHLxsZrRoTYsxgzwXd9INyWkChmylGR8V+QVGQSyvYpyp
K1Ea28RzNC5HItSBkXw7BT+b4tILwxFAzTBLm/W+XL6wgCyO0eddaMs9Iy/4gzWN
FiHxLBee4Md52E7qbDZg0LQBAoGBAMR3ItVc9FuoeawW/4iYdwOv8e5YAqC0ACFL
tG8tVXVDrz/HOCr/4/jT2rqdcWPkA5mxwFA/M+lqeGhckeWniRyBaZ5whuitt65P
AdpZAWe/K6Dse+uC6Zh6fLb+B6xzqcgrYm6rp1C9TX2C49oqSwmwxxZbOs8+P6xQ
pA3hrvq/AoGAVxCp90ONrKiznW3aQ+oiJr5DntATVJa3veSuOXNjs4ePeX6J+fQ+
6yqgIWuNH8CRG7WQsXthtKNajNmoyMPhAkTnYIhu/BCOjL5cFCG7uiVGU5dZk4Oa
1Y524n6d8UY3bAmKQQQr6k+i87LxuxHz4snjtE6Ka9BuFKfHcDxKH34=
-----END RSA PRIVATE KEY----- 
)KEY";