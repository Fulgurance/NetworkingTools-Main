class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr",
                            "--sysconfdir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["install"],buildDirectoryPath)
    end

end
