# detection for OSX (look for R framework)
if(APPLE)

   find_library(R_LIBRARIES R)
   if(R_LIBRARIES)
      set(R_HOME "${R_LIBRARIES}/Resources" CACHE PATH "R home directory")
      set(R_INCLUDE_DIRS "${R_HOME}/include" CACHE PATH "R include directory")
      set(R_DOC_DIR "${R_HOME}/doc" CACHE PATH "R doc directory")
      set(R_EXECUTABLE "${R_HOME}/R" CACHE PATH "R executable")
   endif()

# detection for UNIX & Win32
else()

   # Find R executable and paths (UNIX)
   if(UNIX)

      # find executable
      find_program(R_EXECUTABLE R)
      if(R_EXECUTABLE-NOTFOUND)
         message(STATUS "Unable to locate R executable")
      endif()

      # ask R for the home path
      if(NOT R_HOME)
         execute_process(
            COMMAND ${R_EXECUTABLE} "--slave" "--vanilla" "-e" "cat(R.home())"
                      OUTPUT_VARIABLE R_HOME
         )
         if(R_HOME)
           set(R_HOME ${R_HOME} CACHE PATH "R home directory")
         endif()
      endif()

      # ask R for the include dir
      if(NOT R_INCLUDE_DIRS)
         execute_process(
            COMMAND ${R_EXECUTABLE} "--slave" "--no-save" "-e" "cat(R.home('include'))"
            OUTPUT_VARIABLE R_INCLUDE_DIRS
         )
         if(R_INCLUDE_DIRS)
           set(R_INCLUDE_DIRS ${R_INCLUDE_DIRS} CACHE PATH "R include directory")
         endif()
      endif()

      # ask R for the doc dir
      if(NOT R_DOC_DIR)
         execute_process(
            COMMAND ${R_EXECUTABLE} "--slave" "--no-save" "-e" "cat(R.home('doc'))"
            OUTPUT_VARIABLE R_DOC_DIR
         )
         if(R_DOC_DIR)
           set(R_DOC_DIR ${R_DOC_DIR} CACHE PATH "R doc directory")
         endif()
      endif()

      # ask R for the lib dir
      if(NOT R_LIB_DIR)
         execute_process(
            COMMAND ${R_EXECUTABLE} "--slave" "--no-save" "-e" "cat(R.home('lib'))"
            OUTPUT_VARIABLE R_LIB_DIR
         )
      endif()

   # Find R executable and paths (Win32)
   else()

      # find the home path
      if(NOT R_HOME)

         # read home from the registry
         get_filename_component(R_HOME
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\R-core\\R;InstallPath]"
            ABSOLUTE CACHE)

         # print message if not found
         if(NOT R_HOME)
            message(STATUS "Unable to locate R home (not written to registry)")
         endif()

      endif()

      # set other R paths based on home path
      set(R_INCLUDE_DIRS "${R_HOME}/include" CACHE PATH "R include directory")
      set(R_DOC_DIR "${R_HOME}/doc" CACHE PATH "R doc directory")

      # set library hint path based on whether  we are doing a special session 64 build
      if(R_FIND_WINDOWS_64BIT)
         set(LIBRARY_ARCH_HINT_PATH "${R_HOME}/bin/x64")
      else()
         set(LIBRARY_ARCH_HINT_PATH "${R_HOME}/bin/i386")
      endif()

   endif()

   # look for the R executable
   find_program(R_EXECUTABLE R
                HINTS ${LIBRARY_ARCH_HINT_PATH} ${R_HOME}/bin)
   if(R_EXECUTABLE-NOTFOUND)
      message(STATUS "Unable to locate R executable")
   endif()

   # look for the core R library
   find_library(R_CORE_LIBRARY NAMES R
                HINTS ${R_LIB_DIR} ${LIBRARY_ARCH_HINT_PATH} ${R_HOME}/bin)
   if(R_CORE_LIBRARY)
      set(R_LIBRARIES ${R_CORE_LIBRARY})
   else()
      message(STATUS "Could not find libR shared library.")
   endif()

   if(WIN32)
      # look for lapack
      find_library(R_LAPACK_LIBRARY NAMES Rlapack
                   HINTS ${R_LIB_DIR} ${LIBRARY_ARCH_HINT_PATH} ${R_HOME}/bin)
      if(R_LAPACK_LIBRARY)
         set(R_LIBRARIES ${R_LIBRARIES} ${R_LAPACK_LIBRARY})
         if(UNIX)
            set(R_LIBRARIES ${R_LIBRARIES} gfortran)
         endif()
      endif()

      # look for blas
      find_library(R_BLAS_LIBRARY NAMES Rblas
                   HINTS ${R_LIB_DIR} ${LIBRARY_ARCH_HINT_PATH} ${R_HOME}/bin)
      if(R_BLAS_LIBRARY)
         set(R_LIBRARIES ${R_LIBRARIES} ${R_BLAS_LIBRARY})
      endif()

      # look for rgraphapp
      find_library(R_GRAPHAPP_LIBRARY NAMES Rgraphapp
                   HINTS ${R_LIB_DIR} ${LIBRARY_ARCH_HINT_PATH} ${R_HOME}/bin)
      if(R_GRAPHAPP_LIBRARY)
         set(R_LIBRARIES ${R_LIBRARIES} ${R_GRAPHAPP_LIBRARY})
      endif()
   endif()

   # cache R_LIBRARIES
   if(R_LIBRARIES)
      set(R_LIBRARIES ${R_LIBRARIES} CACHE PATH "R runtime libraries")
   endif()

endif()

# define find requirements
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibR DEFAULT_MSG
   R_HOME
   R_EXECUTABLE
   R_INCLUDE_DIRS
   R_LIBRARIES
   R_DOC_DIR
)

if(R_FOUND)
   message(STATUS "Found R: ${R_HOME}")
endif()

# mark low-level variables from FIND_* calls as advanced
mark_as_advanced(
   R_CORE_LIBRARY
   R_LAPACK_LIBRARY
   R_BLAS_LIBRARY
)
