# spdlog and gRPC dependencies are handled at PlusBuild level
# In PlusBuild superbuild context, these are always built as ExternalProjects
SET(Ommo_DEPENDENCIES)
LIST(APPEND Ommo_DEPENDENCIES spdlog gRPC)

IF(Ommo_DIR)
  # Ommo has been provided by user (pre-built SDK)
  FIND_PACKAGE(Ommo REQUIRED)

  MESSAGE(STATUS "Using Ommo available at: ${Ommo_DIR}")

  # Copy libraries to CMAKE_RUNTIME_OUTPUT_DIRECTORY
  PlusCopyLibrariesToDirectory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${Ommo_LIBRARIES})

  SET (PLUS_Ommo_DIR ${Ommo_DIR} CACHE INTERNAL "Path to store Ommo binaries")
ELSE()
  # Ommo has not been built yet, so download and build it as an external project
  SetGitRepositoryTag(
    Ommo
    "https://github.com/Ommo-Technologies/ommo_sdk_external.git"
    "main"
    )

  SET (PLUS_Ommo_SRC_DIR "${CMAKE_BINARY_DIR}/Deps/Ommo")
  SET (PLUS_Ommo_DIR "${CMAKE_BINARY_DIR}/Deps/Ommo-bin" CACHE INTERNAL "Path to store Ommo binaries")
  ExternalProject_Add( Ommo
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    PREFIX "${CMAKE_BINARY_DIR}/Deps/Ommo-prefix"
    SOURCE_DIR "${PLUS_Ommo_SRC_DIR}"
    BINARY_DIR "${PLUS_Ommo_DIR}"
    #--Download step--------------
    GIT_REPOSITORY ${Ommo_GIT_REPOSITORY}
    GIT_TAG ${Ommo_GIT_TAG}
    #--Configure step-------------
    CMAKE_ARGS 
      ${ep_common_args}
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
      -DBUILD_SHARED_LIBS:BOOL=${PLUSBUILD_BUILD_SHARED_LIBS}
      -Dspdlog_DIR:PATH=${PLUS_spdlog_DIR}
      -DProtobuf_DIR:PATH=${Protobuf_DIR}
      -DgRPC_DIR:PATH=${gRPC_DIR}
      -Dabsl_DIR:PATH=${absl_DIR}
      -Dutf8_range_DIR:PATH=${utf8_range_DIR}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
    #--Build step-----------------
    BUILD_ALWAYS 1
    #--Install step-----------------
    INSTALL_COMMAND ""
    DEPENDS ${Ommo_DEPENDENCIES}
    )
ENDIF()