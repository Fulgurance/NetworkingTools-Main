class Target < ISM::Software
    
    def prepare
        super

        fileReplaceLineContaining("#{buildDirectoryPath}/Makefile","ARPD","")
        deleteFile("#{buildDirectoryPath}/man/man8/arpd.8")
    end
    
    def build
        super

        makeSource(["NETNS_RUN_DIR=/run/netns"],path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["SBINDIR=/usr/sbin","DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
