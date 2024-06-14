class Target < ISM::Software
    
    def prepare
        super

        fileReplaceLineContaining(  path:       "#{buildDirectoryPath}/Makefile",
                                    text:       "ARPD",
                                    newText:    "")

        deleteFile("#{buildDirectoryPath}/man/man8/arpd.8")
    end
    
    def build
        super

        makeSource( arguments:  "NETNS_RUN_DIR=/run/netns",
                    path:       buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "SBINDIR=/usr/sbin DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
