require 'formula'

class Httpd24 < Formula
	homepage 'http://httpd.apache.org'
    url 'http://www.apache.org/dist/httpd/httpd-2.4.10.tar.bz2'
    sha1 '00f5c3f8274139bd6160eda2cf514fa9b74549e5'
    version '2.4.10'

	skip_clean ['bin', 'sbin']

    depends_on 'pcre'
    depends_on 'libtool'

	def options
	 [
	 	['--with-lua', 'Include Lua support']
	 ]
	end

	def install
		args = [
			"--disable-debug",
			"--disable-dependency-tracking",
			"--prefix=#{prefix}",
			"--mandir=#{man}",
			"--enable-layout=GNU",
			"--with-mpm=prefork"
		]

		if ARGV.include? '--with-lua'
			args << "--with-lua"
		end

		system "./configure", "LTFLAGS=--tag=cc", *args
		system "make"
		system "make install"

		plist_path.write startup_plist
		plist_path.chmod 0644
	end

	def startup_plist
		return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.apache.httpd</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{sbin}/apachectl</string>
    <string>start</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOS
    end
end
