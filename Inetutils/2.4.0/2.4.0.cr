class Target < ISM::Software

    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--bindir=/usr/bin",
                            "--localstatedir=/var",
                            "--disable-logger",
                            "--disable-whois",
                            "--disable-rcp",
                            "--disable-rexec",
                            "--disable-rlogin",
                            "--disable-rsh",
                            "--disable-server"],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeDirectory("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/sbin")
        moveFile("#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/bin/ifconfig","#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr/sbin/ifconfig")
    end

end
