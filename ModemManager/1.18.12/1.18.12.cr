class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--localstatedir=/var",
                            "--disable-static",
                            "--disable-maintainer-mode",
                            "--with-systemd-journal=no",
                            "--with-systemd-suspend-resume",
                            "#{option("Libmbim") ? "--with-mbim" : "--without-mbim"}",
                            "#{option("Libqmi") ? "--with-qmi" : "--without-qmi"}"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
