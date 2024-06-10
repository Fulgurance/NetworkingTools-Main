class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--libexecdir=/usr/lib/dhcpcd",
                            "--dbdir=/var/lib/dhcpcd",
                            "--runstatedir=/run",
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

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}var/lib/dhcpcd")

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Dhcpcd-Init.d","dhcpcd")
        end
    end

    def install
        super

        runChmodCommand(["0700","/var/lib/dhcpcd"])
    end

end
