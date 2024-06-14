class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr \
                                    --sysconfdir=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "install",
                    path:       buildDirectoryPath)
    end

end
