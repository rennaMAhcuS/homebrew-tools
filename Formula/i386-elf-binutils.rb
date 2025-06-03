class I386ElfBinutils < Formula
  desc "GNU Binutils targetting i386-elf"
  homepage "https://www.gnu.org/software/binutils"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.44.tar.xz"
  sha256 "ce2017e059d63e67ddb9240e9d4ec49c2893605035cd60e92ad53177f4377237"

  on_macos do
    def install
      mkdir "binutils-build" do
        system "../configure", "--prefix=#{prefix}",
                               "--target=i386-elf",
                               "--with-system-zlib"

        system "make", "-j#{ENV.make_jobs}"
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
