class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "wpa_supplicant"
        super
    end

    def configure
        super

        configData = <<-CODE
        CONFIG_BACKEND=file
        CONFIG_CTRL_IFACE=y
        CONFIG_DEBUG_FILE=y
        CONFIG_DEBUG_SYSLOG=y
        CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
        CONFIG_DRIVER_NL80211=y
        CONFIG_DRIVER_WEXT=y
        CONFIG_DRIVER_WIRED=y
        CONFIG_EAP_GTC=y
        CONFIG_EAP_LEAP=y
        CONFIG_EAP_MD5=y
        CONFIG_EAP_MSCHAPV2=y
        CONFIG_EAP_OTP=y
        CONFIG_EAP_PEAP=y
        CONFIG_EAP_TLS=y
        CONFIG_EAP_TTLS=y
        CONFIG_IEEE8021X_EAPOL=y
        CONFIG_IPV6=y
        CONFIG_LIBNL32=y
        CONFIG_PEERKEY=y
        CONFIG_PKCS12=y
        CONFIG_READLINE=y
        CONFIG_SMARTCARD=y
        CONFIG_WPS=y
        CFLAGS += -I/usr/include/libnl3
        CODE
        fileWriteData("#{buildDirectoryPath}/.config",configData)
    end

    def build
        super

        makeSource(["BINDIR=/usr/sbin","LIBDIR=/usr/lib"],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin")

        moveFile("#{buildDirectoryPath}/wpa_cli","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/wpa_cli")
        moveFile("#{buildDirectoryPath}/wpa_passphrase","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/wpa_passphrase")
        moveFile("#{buildDirectoryPath}/wpa_supplicant","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/sbin/wpa_supplicant")

        if option("Dbus")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/dbus-1/system-services")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/dbus-1/system.d")

            moveFile("#{buildDirectoryPath}/dbus/fi.w1.wpa_supplicant1.service","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service")
            moveFile("#{buildDirectoryPath}/dbus/dbus-wpa_supplicant.conf","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/dbus-1/system.d/wpa_supplicant.conf")
        end

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Wpa-Supplicant-Init.d","wpa_supplicant")
        end
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/sbin",0o755)

        if option("Dbus")
            setPermissions("#{Ism.settings.rootPath}usr/share/dbus-1/system-services",0o644)
            setPermissions("#{Ism.settings.rootPath}etc/dbus-1/system.d",0o755)
            setPermissions("#{Ism.settings.rootPath}etc/dbus-1/system.d/wpa_supplicant.conf",0o644)
        end

        runUpdateDesktopDatabaseCommand(["-q"])
    end

end
