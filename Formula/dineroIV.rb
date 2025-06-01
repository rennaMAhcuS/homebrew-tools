class Dineroiv < Formula
  desc "Cache simulator dineroIV by Mark D. Hill"
  homepage "https://github.com/atos-tools/dineroIV"
  url "https://github.com/atos-tools/dineroIV/archive/refs/heads/master.tar.gz"
  version "4"
  sha256 "6f1b5e2049b061663432aa2d89659258cfa1d857d93f5cd1aa681105ac9110df"

  depends_on "gcc"

  def install
    on_macos do
      mkdir "dineroIV-build" do
        system "../configure", "--prefix=#{prefix}"
        system "make", "-j#{`sysctl -n hw.ncpu`.chomp}"
        system "make", "install"

        man1.install buildpath/"d4.1" => "dineroIV.1"
        man3.install buildpath/"d4.3" => "dineroIV.3"
      end
    end
  end

  test do
    resource_url = "https://github.com/atos-tools/dineroIV/archive/refs/heads/master.tar.gz"
    tarball = "dineroIV.tar.gz"
    repo_dir = testpath/"dineroIV"
  
    system "curl", "-L", resource_url, "-o", tarball
    system "mkdir", "-p", repo_dir
    system "tar", "-xzf", tarball, "-C", repo_dir, "--strip-components=1"

    cd repo_dir do
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-14"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-14"
      system "./configure"
      cd "testing" do
        system "make"
        system "env", "PATH=#{ENV["PATH"]}:#{bin}", "./testscript"
        system "env", "D4_SRC=#{bin}", "PATH=#{ENV["PATH"]}:#{bin}", "./testscript", "-c"
      end
    end
  end
end