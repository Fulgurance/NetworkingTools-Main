class Target < ISM::Software
    
    def prepareInstallation
        super

        moveFile(   path:       "#{buildDirectoryPath}/etc",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/etc")

        moveFile(   path:       "#{buildDirectoryPath}/usr",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/usr")

        moveFile(   path:       "#{buildDirectoryPath}/var",
                    newPath:    "#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}/var")

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Nordvpn-Init.d",
                                                name:   "nordvpn")
        end
    end

end
