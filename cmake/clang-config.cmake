set(PREFIX "/Library/Developer/CommandLineTools")
set(SDK_PATH "${PREFIX}/SDKs/MacOSX15.sdk")


# Set the LLVM installation directory
set(CLANG_INSTALL_PREFIX "${PREFIX}/usr")

# Set the path to libclang
set(LIBCLANG_PATH "${PREFIX}/usr/lib/libclang.dylib")

# Set the Clang include directories
set(CLANG_INCLUDE_DIRS "${CLANG_INSTALL_PREFIX}/include")

# Create an imported target for libclang
add_library(libclang SHARED IMPORTED)
set_target_properties(libclang PROPERTIES
    IMPORTED_LOCATION_RELEASE "${LIBCLANG_PATH}"
    INTERFACE_INCLUDE_DIRECTORIES "${CLANG_INCLUDE_DIRS}"
)

# Set LLVM_FOUND to indicate successful package find
set(LLVM_FOUND TRUE)

# Print some debug information
message(STATUS "SDK Path: ${SDK_PATH}")
message(STATUS "LLVM Install Prefix: ${CLANG_INSTALL_PREFIX}")
message(STATUS "LibClang Path: ${LIBCLANG_PATH}")
message(STATUS "Clang Include Dirs: ${CLANG_INCLUDE_DIRS}")