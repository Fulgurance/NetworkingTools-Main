class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryName = "wpa_supplicant"
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

        makeSource([Ism.settings.makeOptions,"BINDIR=/usr/sbin","LIBDIR=/usr/lib"],buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/sbin")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man5")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8")

        moveFile("#{buildDirectoryPath(false)}wpa_cli","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/sbin/wpa_cli")
        moveFile("#{buildDirectoryPath(false)}wpa_passphrase","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/sbin/wpa_cli")
        moveFile("#{buildDirectoryPath(false)}wpa_supplicant","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/sbin/wpa_cli")
        moveFile("#{buildDirectoryPath(false)}doc/docbook/wpa_supplicant.conf.5","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man5/wpa_supplicant.conf.5")
        moveFile("#{buildDirectoryPath(false)}doc/docbook/wpa_cli.8","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8/wpa_cli.8")
        moveFile("#{buildDirectoryPath(false)}doc/docbook/wpa_passphrase.8","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8/wpa_passphrase.8")
        moveFile("#{buildDirectoryPath(false)}doc/docbook/wpa_supplicant.8","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/man/man8/wpa_supplicant.8")

        if option("Dbus")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/dbus-1/system-services")
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/dbus-1/system.d")

            moveFile("#{buildDirectoryPath(false)}dbus/fi.w1.wpa_supplicant1.service","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/dbus-1/system-services/fi.w1.wpa_supplicant1.service")
            moveFile("#{buildDirectoryPath(false)}dbus/dbus-wpa_supplicant.conf","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/dbus-1/system.d/wpa_supplicant.conf")
        end
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/sbin",0o755)
        setPermissions("#{Ism.settings.rootPath}usr/share/man/man5",0o644)
        setPermissions("#{Ism.settings.rootPath}usr/share/man/man8",0o644)

        if option("Dbus")
            setPermissions("#{Ism.settings.rootPath}usr/share/dbus-1/system-services",0o644)
            setPermissions("#{Ism.settings.rootPath}etc/dbus-1/system.d",0o755)
            setPermissions("#{Ism.settings.rootPath}etc/dbus-1/system.d/wpa_supplicant.conf",0o644)
        end
    end

end
