class Dineroiv < Formula
  desc "Cache simulator dineroIV by Mark D. Hill"
  homepage "https://github.com/atos-tools/dineroIV"
  url "https://github.com/atos-tools/dineroIV/archive/refs/heads/master.tar.gz"
  version "4"
  sha256 "6f1b5e2049b061663432aa2d89659258cfa1d857d93f5cd1aa681105ac9110df"
  # license "LicenseRef-DineroIV"

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
    system "#{bin}/dineroIV", "-help"
  end
end
