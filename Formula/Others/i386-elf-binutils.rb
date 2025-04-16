class I386ElfBinutils < Formula
  desc "GNU Binutils targetting i386-elf"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.xz"
  sha256 "ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237"

  depends_on "texinfo" => :build
  depends_on "gcc"

  def install
    on_macos do
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-14"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-14"

      mkdir "binutils-build" do
        system "../configure", "--prefix=#{prefix}",
                               "--target=i386-elf",
                               "--disable-multilib",
                               "--disable-nls",
                               "--disable-werror",
                               "--enable-interwork"
        system "make", "-j#{`sysctl -n hw.ncpu`.chomp}"
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"program.S").write <<~DATA
    .text
    example:
        movl 0x80, %eax
        movl 0x40, %ebx     
    DATA
    system "#{bin}/i386-elf-as", "program.S"
    assert_match "file format elf32-i386", shell_output("#{bin}/i386-elf-objdump -D a.out")
  end
end
