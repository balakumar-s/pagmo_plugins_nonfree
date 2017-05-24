set(_PAGMO_PLUGINS_NONFREE_REQUIRED_BOOST_LIBS)
if(PAGMO_PLUGINS_NONFREE_BUILD_PYGMO)
    list(APPEND _PAGMO_PLUGINS_NONFREE_REQUIRED_BOOST_LIBS python)
endif()
list(APPEND _PAGMO_PLUGINS_NONFREE_REQUIRED_BOOST_LIBS system filesystem)
message(STATUS "Required Boost libraries: ${_PAGMO_PLUGINS_NONFREE_REQUIRED_BOOST_LIBS}")
find_package(Boost 1.55.0 REQUIRED COMPONENTS "${_PAGMO_PLUGINS_NONFREE_REQUIRED_BOOST_LIBS}")
if(NOT Boost_FOUND)
    message(FATAL_ERROR "Not all requested Boost components were found, exiting.")
endif()
message(STATUS "Detected Boost version: ${Boost_VERSION}")
message(STATUS "Boost include dirs: ${Boost_INCLUDE_DIRS}")
# Might need to recreate targets if they are missing (e.g., older CMake versions).
if(NOT TARGET Boost::boost)
    message(STATUS "The 'Boost::boost' target is missing, creating it.")
    add_library(Boost::boost INTERFACE IMPORTED)
    set_target_properties(Boost::boost PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}")
endif()
if(NOT TARGET Boost::disable_autolinking)
    message(STATUS "The 'Boost::disable_autolinking' target is missing, creating it.")
    add_library(Boost::disable_autolinking INTERFACE IMPORTED)
    if(WIN32)
        set_target_properties(Boost::disable_autolinking PROPERTIES INTERFACE_COMPILE_DEFINITIONS "BOOST_ALL_NO_LIB")
    endif()
endif()
foreach(_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT ${_PAGMO_PLUGINS_NONFREE_REQUIRED_BOOST_LIBS})
    if(NOT TARGET Boost::${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT})
        message(STATUS "The 'Boost::${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT}' imported target is missing, creating it.")
        string(TOUPPER ${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT} _PAGMO_PLUGINS_NONFREE_BOOST_UPPER_COMPONENT)
        if(Boost_USE_STATIC_LIBS)
            add_library(Boost::${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT} STATIC IMPORTED)
        else()
            add_library(Boost::${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT} UNKNOWN IMPORTED)
        endif()
        set_target_properties(Boost::${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT} PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${Boost_INCLUDE_DIRS}")
        set_target_properties(Boost::${_PAGMO_PLUGINS_NONFREE_BOOST_COMPONENT} PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
            IMPORTED_LOCATION "${Boost_${_PAGMO_PLUGINS_NONFREE_BOOST_UPPER_COMPONENT}_LIBRARY}")
    endif()
endforeach()
