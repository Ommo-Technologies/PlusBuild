#-------------------------------------------------------------------------------
# External_gRPC.cmake
# Tailored for the PlusToolkit SuperBuild environment
#-------------------------------------------------------------------------------

# Set the version of gRPC to use
SetGitRepositoryTag(
  gRPC
  "https://github.com/grpc/grpc.git"
  "v1.60.0"
)

# PlusBuild provides ${PLUS_EXTERNALS_PREFIX} as the common install location
set(gRPC_INSTALL_DIR ${PLUS_EXTERNALS_PREFIX})

# Standard PlusBuild source/prefix/bin layout
SET (PLUS_gRPC_src_DIR ${CMAKE_BINARY_DIR}/gRPC CACHE INTERNAL "Path to store gRPC sources.")
SET (PLUS_gRPC_prefix_DIR ${CMAKE_BINARY_DIR}/gRPC-prefix CACHE INTERNAL "Path to store gRPC prefix data.")
SET (PLUS_gRPC_DIR ${CMAKE_BINARY_DIR}/gRPC-bin CACHE INTERNAL "Path to store gRPC binaries")

ExternalProject_Add(gRPC
  PREFIX ${PLUS_gRPC_prefix_DIR}
  SOURCE_DIR "${PLUS_gRPC_src_DIR}"
  BINARY_DIR "${PLUS_gRPC_DIR}"
  INSTALL_DIR ${gRPC_INSTALL_DIR}

  # Git clone the grpc repository and use the requested tag
  GIT_REPOSITORY ${gRPC_GIT_REPOSITORY}
  GIT_TAG ${gRPC_GIT_TAG}

  # Ensure submodules are initialized (protobuf, absl, re2, etc.)
  UPDATE_COMMAND "${GIT_EXECUTABLE}" submodule update --init --recursive

  # Configure args: use common ep args so C++ standard and other flags match the SuperBuild
  CMAKE_ARGS
    ${ep_common_args}
    -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
    -DCMAKE_INSTALL_PREFIX:PATH=${gRPC_INSTALL_DIR}
    -DgRPC_INSTALL:BOOL=ON
    -DgRPC_BUILD_TESTS:BOOL=OFF
    -DgRPC_ABSL_PROVIDER:STRING=module
    -DgRPC_CARES_PROVIDER:STRING=module
    -DgRPC_PROTOBUF_PROVIDER:STRING=module
    -DgRPC_RE2_PROVIDER:STRING=module
    -DgRPC_SSL_PROVIDER:STRING=module
    -DgRPC_ZLIB_PROVIDER:STRING=module

  LOG_DOWNLOAD 1
  LOG_CONFIGURE 1
  LOG_BUILD 1
  LOG_INSTALL 1
)
# Make CMake find-installed configs for downstream projects (Ommo expects these)
# The CMake package configs produced by gRPC/protobuf are placed under <install-prefix>/lib/cmake
set(gRPC_DIR ${gRPC_INSTALL_DIR}/lib/cmake/grpc CACHE PATH "Path to gRPC config" FORCE)
set(Protobuf_DIR ${gRPC_INSTALL_DIR}/cmake CACHE PATH "Path to Protobuf config" FORCE)
set(absl_DIR ${gRPC_INSTALL_DIR}/lib/cmake/absl CACHE PATH "Path to absl config" FORCE)
set(utf8_range_DIR ${gRPC_INSTALL_DIR}/lib/cmake/utf8_range CACHE PATH "Path to utf8_range config" FORCE)
