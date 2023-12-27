class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        runMesonCommand([   "setup",
                            @buildDirectoryNames["MainBuild"],
                            "-Dppp=#{option("Ppp") ? "true" : "false"}",
                            "-Dpolkit=#{option("Polkit") ? "true" : "false"}",
                            "-Dsystemdsystemunitdir=no",
                            "-Dsystemd_journal=false",
                            "-Dselinux=false",
                            "-Dlibaudit=no"],
                            path: mainWorkDirectoryPath)
    end

    def configure
        super

        runMesonCommand([   "--prefix=/usr",
                            "--buildtype=release",
                            "-Dlibaudit=no",
                            "-Dlibpsl=#{option("Libpsl") ? "true" : "false"}",
                            "-Dnmtui=#{option("Newt") ? "true" : "false"}",
                            "-Dovs=false",
                            "-Dppp=#{option("Ppp") ? "true" : "false"}",
                            "-Dselinux=false",
                            "-Dsession_tracking=elogind",
                            "-Dmodem_manager=#{option("ModemManager") ? "true" : "false"}",
                            "-Dsystemdsystemunitdir=no",
                            "-Dsystemd_journal=false",
                            "-Dqt=false",
                            "-Dpolkit=#{option("Polkit") ? "true" : "false"}",
                            "-Dselinux=false",
                            "-Dlibaudit=no"],
                            path: mainWorkDirectoryPath,
                            environment: {"CXXFLAGS+" => "-O2 -fPIC"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

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
