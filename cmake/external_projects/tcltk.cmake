if(APPLE)
  set(HOME $ENV{HOME})
  set(tcl_prefix ${CMAKE_INSTALL_PREFIX}/../../)
  ExternalProject_Add(project_tcl
    URL "http://sourceforge.net/projects/tcl/files/Tcl/8.6.4/tcl8.6.4-src.tar.gz"
    URL_MD5 d7cbb91f1ded1919370a30edd1534304
    DOWNLOAD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external_dependencies
    UPDATE_COMMAND "" # Disable update
    CONFIGURE_COMMAND ../project_tcl/macosx/configure --enable-threads --enable-framework --prefix=${tcl_prefix} --libdir=${tcl_prefix}/Contents/Frameworks --bindir=${tcl_prefix}/Contents/Frameworks/Tcl.framework/bin
    BUILD_COMMAND make -j4 binaries libraries
    INSTALL_COMMAND make install-binaries install-headers install-libraries install-private-headers
    LOG_DOWNLOAD 1
    LOG_BUILD 1
    LOG_CONFIGURE 1
    LOG_INSTALL 1
    )

  ExternalProject_Add(project_tk
    DEPENDS project_tcl
    URL "http://sourceforge.net/projects/tcl/files/Tcl/8.6.4/tk8.6.4-src.tar.gz"
    URL_MD5 261754d7dc2a582f00e35547777e1fea
    DOWNLOAD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external_dependencies
    UPDATE_COMMAND "" # Disable update
    CONFIGURE_COMMAND ../project_tk/macosx/configure --enable-aqua=yes --enable-threads --enable-framework --prefix=${tcl_prefix} --libdir=${tcl_prefix}/Contents/Frameworks --bindir=${tcl_prefix}/Contents/Frameworks/Tcl.framework/bin --with-tcl=${tcl_prefix}/Contents/Frameworks/Tcl.framework
    BUILD_COMMAND make -j4 binaries libraries
    INSTALL_COMMAND make install-binaries install-headers install-libraries install-private-headers
    LOG_DOWNLOAD 1
    LOG_BUILD 1
    LOG_CONFIGURE 1
    LOG_INSTALL 1
    )

  #ExternalProject_Add(tkdnd
    #DEPENDS tcl tk
    #URL "http://sourceforge.net/projects/tkdnd/files/TkDND/TkDND%202.8/tkdnd2.8-src.tar.gz"
    #URL_MD5 a6d47a996ea957416469b12965d4db91
    #DOWNLOAD_DIR ${CMAKE_CURRENT_SOURCE_DIR}/external_dependencies
    #PATCH_COMMAND  patch -p1 < ${CMAKE_CURRENT_LIST_DIR}/tkdnd_macosx.patch
    #UPDATE_COMMAND "" # Disable update
    #BUILD_IN_SOURCE 1
    #CONFIGURE_COMMAND ./configure --with-tcl=${CMAKE_INSTALL_PREFIX}/../Frameworks/Tcl.framework --with-tk=${CMAKE_INSTALL_PREFIX}/../Frameworks/Tk.framework --prefix=${CMAKE_INSTALL_PREFIX}/../MacOS --libdir=${CMAKE_INSTALL_PREFIX}/../MacOS
    #BUILD_COMMAND make
    #INSTALL_COMMAND make install
    #LOG_DOWNLOAD 1
    #LOG_CONFIGURE 1
    #LOG_BUILD 1
    #LOG_INSTALL 1
    #)
 
  list(APPEND NETGEN_DEPENDENCIES project_tcl project_tk)
  list(APPEND CMAKE_PREFIX_PATH ${CMAKE_INSTALL_PREFIX}../Frameworks)
  set(TCL_INCLUDE_PATH ${CMAKE_INSTALL_PREFIX}/../Frameworks/Tcl.framework/Headers)
  set(TCL_LIBRARY ${CMAKE_INSTALL_PREFIX}/../Frameworks/Tcl.framework)
  set(TK_LIBRARY ${CMAKE_INSTALL_PREFIX}/../Frameworks/Tk.framework)
  set(TK_INCLUDE_PATH ${CMAKE_INSTALL_PREFIX}/../Frameworks/Tk.framework/Headers)

elseif(WIN32)

  # ExternalProject_Add(project_win_extlibs
  #   URL ${EXT_LIBS_DOWNLOAD_URL_WIN}
  #   UPDATE_COMMAND "" # Disable update
  #   BUILD_IN_SOURCE 1
  #   CONFIGURE_COMMAND ""
  #   BUILD_COMMAND ""
  #   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory . ${INSTALL_DIR}
  #   LOG_DOWNLOAD 1
  #   )

  # list(APPEND NETGEN_DEPENDENCIES project_win_extlibs)
    find_package(TCL 8.5 REQUIRED)
else(WIN32)
    find_package(TCL 8.5 REQUIRED)
endif(APPLE)

# Propagate settings to Netgen subproject
set_vars(NETGEN_CMAKE_ARGS TCL_INCLUDE_PATH TCL_LIBRARY TK_LIBRARY TK_INCLUDE_PATH TCL_TCLSH TK_WISH)
