
Reggae init test regression

Use `cbsd up` to start VM + tests.

Most likely you will want to edit some values in CBSDfile (e.g. vm_os_profile/network settings ..). You can overwrite it via command line as well:

```
cbsd up vm_os_profile="cloud-FreeBSD-ufs-x64-13.1" ip4_addr="10.0.0.2"
```

