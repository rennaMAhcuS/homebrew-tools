class Dineroiv < Formula
  desc "Cache simulator dineroIV by Mark D. Hill"
  homepage "https://github.com/atos-tools/dineroIV"
  url "https://github.com/atos-tools/dineroIV/archive/refs/heads/master.tar.gz"
  version "4"
  sha256 "6f1b5e2049b061663432aa2d89659258cfa1d857d93f5cd1aa681105ac9110df"
  
  def install
    mkdir "dineroIV-build" do
      system "../configure", "--prefix=#{prefix}"
      system "make", "-j#{ENV.make_jobs}"
      system "make", "install"

      man1.install buildpath/"d4.1" => "dineroIV.1"
      man3.install buildpath/"d4.3" => "dineroIV.3"
    end
  end

  test do
    resource_url = "https://github.com/atos-tools/dineroIV/archive/refs/heads/master.tar.gz"
    tarball = "dineroIV.tar.gz"
    repo_dir = testpath/"dineroIV"
  
    system "curl", "-L", resource_url, "-o", tarball
    system "mkdir", "-p", repo_dir
    system "tar", "-xvf", tarball, "-C", repo_dir, "--strip-components=1"

    cd repo_dir do
      system "./configure"
      cd "testing" do
        system "make"
        system "./testscript"
        system "./testscript", "-c"
      end
    end
  end
end
