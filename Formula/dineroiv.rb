class Dineroiv < Formula
  desc "Cache simulator dineroIV by Mark D. Hill"
  homepage "https://github.com/atos-tools/dineroIV"
  # Patched updated dineroIV
  url "https://github.com/atos-tools/dineroIV/archive/cb3724c72915c1634db8434d4fbb45e536a78e78.tar.gz"
  version "4"
  sha256 "f3239e5b313ff5d1b2a3ec113fcfa410986bb012d0e2c7e349b00f02d515999c"

  def install
    system "./configure", *std_configure_args
    system "make", "-j#{ENV.make_jobs}"

    cd "testing" do
      system "make"
      with_env(PATH: "#{ENV["PATH"]}:..") do
        system "./testscript"
        with_env(D4_SRC: "..") do
          system "./testscript", "-c"
        end
      end
    end

    system "make", "install"

    man1.install "./d4.1" => "dineroIV.1"
    man3.install "./d4.3" => "dineroIV.3"
  end

  test do
    system bin/"dineroIV", "-help"
  end
end
