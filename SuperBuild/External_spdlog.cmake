# spdlog is a header-only C++ logging library
# Since it's header-only, we just need to download it, no build step required

IF(spdlog_DIR)
  # spdlog has been provided by user
  MESSAGE(STATUS "Using spdlog available at: ${spdlog_DIR}")
  SET(PLUS_spdlog_DIR ${spdlog_DIR} CACHE INTERNAL "Path to spdlog include directory")
  SET(spdlog_FOUND TRUE CACHE INTERNAL "spdlog found flag")
ELSE()
  # spdlog has not been provided, so download it as an external project
  SET(PLUS_spdlog_SRC_DIR "${CMAKE_BINARY_DIR}/Deps/spdlog")
  SET(PLUS_spdlog_DIR "${PLUS_spdlog_SRC_DIR}/include" CACHE INTERNAL "Path to spdlog include directory")
  SET(spdlog_FOUND FALSE CACHE INTERNAL "spdlog found flag")
  
  SetGitRepositoryTag(
    spdlog
    "https://github.com/gabime/spdlog.git"
    "v1.14.1"
    )
  
  ExternalProject_Add(spdlog
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    PREFIX "${CMAKE_BINARY_DIR}/Deps/spdlog-prefix"
    SOURCE_DIR "${PLUS_spdlog_SRC_DIR}"
    #--Download step--------------
    GIT_REPOSITORY ${spdlog_GIT_REPOSITORY}
    GIT_TAG ${spdlog_GIT_TAG}
    #--Configure step-------------
    CONFIGURE_COMMAND ""
    #--Build step-----------------
    BUILD_COMMAND ""
    #--Install step---------------
    INSTALL_COMMAND ""
    )
ENDIF()
