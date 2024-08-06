class Ekg2 < Formula
  desc "Multiplatform, multiprotocol, plugin-based instant messenger"
  homepage "https://github.com/ekg2/ekg2"
  license "GPL-2.0"
  revision 4

  stable do
    url "https://src.fedoraproject.org/lookaside/extras/ekg2/ekg2-0.3.1.tar.gz/68fc05b432c34622df6561eaabef5a40/ekg2-0.3.1.tar.gz"
    mirror "https://web.archive.org/web/20161227025528/pl.ekg2.org/ekg2-0.3.1.tar.gz"
    sha256 "6ad360f8ca788d4f5baff226200f56922031ceda1ce0814e650fa4d877099c63"

    # Fix the build on OS X 10.9+
    # bugs.ekg2.org/issues/152 [LOST LINK]
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/ekg2/0.3.1.patch"
      sha256 "6efbb25e57581c56fe52cf7b70dbb9c91c9217525b402f0647db820df9a14daa"
    end

    # Upstream commit, fix build against OpenSSL 1.1
    patch do
      url "https://github.com/ekg2/ekg2/commit/f05815.patch?full_index=1"
      sha256 "207639edc5e6576c8a67301c63f0b28814d9885f0d4fca5d9d9fc465f4427cd7"
    end
  end

  livecheck do
    url :homepage
    regex(/^ekg2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "e11dd5263d14ca6151025f5d9ca8172301df336a1ec3d412617767f0c2ce7a11"
    sha256 arm64_monterey: "d233462650d03da68cc1acf4df091c2bd724cdfb124b8514161555ca731237a0"
    sha256 arm64_big_sur:  "513f5f60b4c91957d35a569665d9f55000dded765f4515e9581f291d2abfcb36"
    sha256 ventura:        "cf60041384bf67e252fbe27d60baceb48ea590d22184854c1990072c3948df71"
    sha256 monterey:       "6c4d6e4a126cb31c7dda87f6080a11911ca1f153c44d26ee86ce11147f8667b3"
    sha256 big_sur:        "d5f9ac13e6ef527cf44f51bad2461976f7a0007bdbc5ded0515720793771cb57"
    sha256 x86_64_linux:   "b4bc5fe81b146a00416646862a5e723eae0d0c218a9373d28e9794a4f3accf16"
  end

  head do
    url "https://github.com/ekg2/ekg2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
    depends_on "glib"

    on_macos do
      depends_on "gettext"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "readline"

  def install
    # Workaround for Xcode 15
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-implicit-function-declaration"
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types"
    end

    args = %W[
      --enable-unicode
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-gtk
      --without-libgadu
      --without-perl
      --without-python
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ekg2", "--help"
  end
end
