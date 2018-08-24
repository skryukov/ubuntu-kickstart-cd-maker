# Original project

https://github.com/tnishimura/ubuntu-kickstart-cd-maker

# How to run

```ssh
vagrant up
vagrant ssh

sudo su
cd /vagrant/ubuntu-kickstart-cd-maker/
./make-automated-install-cd.sh
```

Default usename is `root` and password is `secret`.

# How to add new ISO

- download it to `ubuntu-kickstart-cd-maker` folder
- make MD5 hash `md5sum foobar.iso > foobar.iso.MD5SUM` or use one from ubuntu site
- fix 3 variables in `make-automated-install-cd.sh`: `ISO`, `OUTPUT` and `URL`
