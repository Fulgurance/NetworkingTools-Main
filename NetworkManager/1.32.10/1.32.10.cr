class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand([   "--prefix=/usr",
                            "--buildtype=release",
                            "-Dlibaudit=no",
                            "-Dlibpsl=false",
                            "-Dnmtui=#{option("Newt") ? "true" : "false"}",
                            "-Dovs=false",
                            "-Dppp=#{option("Ppp") ? "true" : "false"}",
                            "-Dselinux=false",
                            "-Dsession_tracking=elogind",
                            "-Dmodem_manager=#{option("ModemManager") ? "true" : "false"}",
                            "-Dsystemdsystemunitdir=no",
                            "-Dsystemd_journal=false",
                            "-Dqt=false",
                            ".."],
                            buildDirectoryPath,
                            {"CXXFLAGS+" => "-O2 -fPIC"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        moveFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/NetworkManager","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/NetworkManager-1.32.10")

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/")

        moveFile("#{mainWorkDirectoryPath(false)}/10-openrc-status","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/10-openrc-status")

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/NetworkManager-Init.d","networkmanager")
        end
    end

    def install
        super

        runGroupAddCommand(["-fg","86","netdev"])
    end

end
