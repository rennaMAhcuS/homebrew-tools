class Quickfix < Formula
  desc "Free and open source implementation of the FIX protocol"
  homepage "https://quickfixengine.org"
  url "https://github.com/quickfix/quickfix/archive/4e89249a90f5c8a140ffdd6eeb5e5cbf7a8e224b.tar.gz"
  version "1.51.unstable"
  sha256 "f46144a202da9d8b3ca0e6f18f3b2a3f7e8426c5e1e7b28ef5560386908fa19a"
  # license "QuickFIX Software License"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "-j#{ENV.make_jobs}"
    # system "make", "check" - Skipping
    system "make", "install"
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

    system ENV.cxx, "TestQuickFIX.cpp", "-I#{include}",
            "-L#{lib}", "-lquickfix", "-o", "test_qf"
    system "./test_qf"
  end
end
