class Target < ISM::Software

    def prepare
        super
        fileReplaceText("#{buildDirectoryPath}/intltool-update.in","\${","\$\{")
    end

    def configure
        super
        configureSource([   "--prefix=/usr"],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/intltool-0.51.0")
        copyFile("#{buildDirectoryPath}doc/I18N-HOWTO","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/intltool-0.51.0/I18N-HOWTO")
        setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/intltool-0.51.0/I18N-HOWTO",644)
    end

end
