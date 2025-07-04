class I386ElfGcc < Formula
  desc "GNU Compiler Collection targetting i386-elf"
  homepage "https://gcc.gnu.org"
  # url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  # mirror "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"

  depends_on "gmp"
  depends_on "libmpc"
  depends_on :macos
  depends_on "mpfr"
  depends_on "rennamahcus/tools/i386-elf-binutils"

  def install
    mkdir "build" do
      system "../configure", *std_configure_args,
                            "--target=i386-elf",
                            "--with-system-zlib",
                            "--enable-languages=c,c++",
                            "--with-gmp=#{Formula["gmp"].opt_prefix}",
                            "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                            "--with-mpc=#{Formula["libmpc"].opt_prefix}"

      system "make", "-j#{ENV.make_jobs}", "all-gcc"
      system "make", "install-gcc"
      system "make", "-j#{ENV.make_jobs}", "all-target-libgcc"
      system "make", "install-target-libgcc"
    end

    # Link binutils for GCC to find
    binutils = Formula["rennamahcus/tools/i386-elf-binutils"].prefix
    ln_s "#{binutils}/i386-elf", "#{prefix}/i386-elf"
  end

  test do
    (testpath/"program.c").write <<~DATA
      int sum(int a, int b) {
        return a + b;
      }
    DATA
    system bin/"i386-elf-gcc", "-c", "program.c"
    binutils = Formula["rennamahcus/tools/i386-elf-binutils"].prefix
    assert_match "file format elf32-i386", shell_output("#{binutils}/bin/i386-elf-objdump -D program.o")
  end
end
