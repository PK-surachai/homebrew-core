class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.7.0.tar.gz"
  sha256 "fa0a6f44a50451115d1499b3f2aa597e0092a07afce1068750260fa7dd2c85cb"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on "libtorch"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/cpp/hello_world/main.cpp", testpath
    libtorch = Formula["libtorch"]
    system ENV.cxx, "-std=c++14", "main.cpp", "-o", "test",
                    "-I#{libtorch.opt_include}",
                    "-I#{libtorch.opt_include}/torch/csrc/api/include",
                    "-L#{libtorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"
    assert_match "[ CPUFloatType{1,1000} ]", shell_output("./test")
  end
end
