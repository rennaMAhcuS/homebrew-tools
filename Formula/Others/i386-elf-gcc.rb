class I386ElfGcc < Formula
  desc "GNU Compiler Collection targetting i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"

  depends_on "gmp" => :build
  depends_on "mpfr" => :build
  depends_on "libmpc"
  depends_on "rennaMAhcuS/tools/i386-elf-binutils"

  def install
    on_macos do
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-14"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-14"

      mkdir "gcc-build" do
        system "../configure", "--prefix=#{prefix}",
                               "--target=i386-elf",
                               "--disable-multilib",
                               "--disable-nls",
                               "--disable-werror",
                               "--without-headers",
                               "--without-isl",
                               "--with-gmp=#{Formula["gmp"].opt_prefix}",
                               "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                               "--with-mpc=#{Formula["libmpc"].opt_prefix}",
                               "--enable-languages=c,c++"

        system "make", "-j#{`sysctl -n hw.ncpu`.chomp}", "all-gcc"
        system "make", "install-gcc"
        system "make", "-j#{`sysctl -n hw.ncpu`.chomp}", "all-target-libgcc"
        system "make", "install-target-libgcc"

        # GCC needs this folder in #{prefix} in order to see the binutils.
        # It doesn't look for i386-elf-as on $PREFIX/bin. Rather, it looks
        # for as on $PREFIX/$TARGET/bin/ ($PREFIX/i386-elf/bin/as).
        binutils = Formula["rennaMAhcuS/tools/i386-elf-binutils"].prefix
        ln_sf "#{binutils}/i386-elf", "#{prefix}/i386-elf"
      end
    end
  end

  test do
    (testpath/"program.c").write <<~DATA
    int sum(int a, int b) {
      return a + b;
    }
    DATA
    system "#{bin}/i386-elf-gcc", "-c", "program.c"
    binutils = Formula["rennaMAhcuS/tools/i386-elf-binutils"].prefix
    assert_match "file format elf32-i386", shell_output("#{binutils}/bin/i386-elf-objdump -D program.o")
  end
end
