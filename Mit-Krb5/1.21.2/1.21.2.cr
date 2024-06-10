class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--sysconfdir=/etc",
                            "--localstatedir=/var/lib",
                            "--runstatedir=/run",
                            "--with-system-et",
                            "--with-system-ss",
                            "--with-system-verto=no",
                            "--enable-dns-for-realm"],
                            path: buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d")

        mitKrb5kadmindData = <<-CODE
        KADMIND_OPTS=""
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/mit-krb5kadmind",mitKrb5kadmindData)

        mitKrb5kdcData = <<-CODE
        KDC_OPTS=""
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/mit-krb5kdc",mitKrb5kdcData)

        mitKrb5kpropdData = <<-CODE
        KPROPD_OPTS=""
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/conf.d/mit-krb5kpropd",mitKrb5kpropdData)

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Mit-Krb5kadmind-Init.d","mit-krb5kadmind")

            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Mit-Krb5kdc-Init.d","mit-krb5kdc")

            prepareOpenrcServiceInstallation("#{workDirectoryPath}/Mit-Krb5kpropd-Init.d","mit-krb5kpropd")
        end
    end

end
