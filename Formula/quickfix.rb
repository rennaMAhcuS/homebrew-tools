class Quickfix < Formula
  desc "QuickFIX is a free and open source implementation of the FIX protocol."
  homepage "https://quickfixengine.org"
  url "https://github.com/quickfix/quickfix/archive/4e89249a90f5c8a140ffdd6eeb5e5cbf7a8e224b.tar.gz"
  sha256 "f46144a202da9d8b3ca0e6f18f3b2a3f7e8426c5e1e7b28ef5560386908fa19a"
  # license "QuickFIX Software License"

  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make"
    system "make check"
    system "make install"
  end

  test do
    (testpath/"TestQuickFIX.cpp").write <<~EOS
      #include <quickfix/SessionSettings.h>
      int main() {
        try {
          FIX::SessionSettings settings;
          return 0;
        } catch (...) {
          return 1;
        }
      }
    EOS

    system "clang++", "TestQuickFIX.cpp", "-I#{include}",
            "-L#{lib}", "-lquickfix", "-o", "test_qf"
    system "./test_qf"
  end
end
