class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--libexecdir=/usr/lib/dhcpcd",
                            "--dbdir=/var/lib/dhcpcd",
                            "--privsepuser=dhcpcd"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}var/lib/dhcpcd")

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/dhcpcd.initd-r1","dhcpcd")
        end
    end

    def install
        super

        runGroupAddCommand(["-g","52","dhcpcd"])
        runUserAddCommand([ "-c","\'dhcpcd PrivSep\'",
                            "-d","/var/lib/dhcpcd",
                            "-g","dhcpcd",
                            "-s","/bin/false",
                            "-u","52","dhcpcd"])
        setPermissions("#{Ism.settings.rootPath}var/lib/dhcpcd",0o700)
        setOwner("#{Ism.settings.rootPath}var/lib/dhcpcd","dhcpcd","dhcpcd")
    end

end
