class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        runMesonCommand([   "setup",
                            "--reconfigure",
                            @buildDirectoryNames["MainBuild"],
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
                            path: mainWorkDirectoryPath)
    end

    def configure
        super

        runMesonCommand([   "configure",
                            @buildDirectoryNames["MainBuild"],
                            "--prefix=/usr",
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
                            environment: {"CXXFLAGS" => "${CXXFLAGS} -O2 -fPIC"})
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/")

        moveFile("#{mainWorkDirectoryPath}/10-openrc-status","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/10-openrc-status")

        runChmodCommand(["+x","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/10-openrc-status"])
        setOwner("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/NetworkManager/dispatcher.d/10-openrc-status","root","root")

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath}/NetworkManager-Init.d","networkmanager")
        end
    end

end
