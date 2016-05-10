require 'formula'

class Ethereum < Formula
  version '1.4.3'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 16
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '9ec5cba8f95a6d4fd0dc865b9c6b32d9b7b1360bbb938d84fe42313f9b02badc' => :yosemite
    sha256 '7c83599b03dcf3350957ab6f49ae7b9e69c9413ecbd2b37a919cc27c5b95d8f2' => :el_capitan
  end

  devel do
    bottle do
      revision 181
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '66eaea80e755408a9b53d5d580e1d14005cb0f91c0312b945fed0e918ff5d967' => :yosemite
      sha256 '470fc03c2168eb8fd7c7ad2b085f2969240a0078c35a96d52d11c45ed4e40b5a' => :el_capitan
    end

    version '1.5.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
