# For testing we build a fake library that we will call snopt7_c
# and that does nothing useful.
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/bogus_libs/snopt7_c_lib)
add_library(snopt7_c SHARED ../bogus_libs/snopt7_c_lib/snopt7_c.c)

function(ADD_PAGMO_SNOPT7_TESTCASE arg1)
    add_executable(${arg1} ${arg1}.cpp)
    target_link_libraries(${arg1} pagmo_plugins_nonfree)
    target_compile_options(${arg1} PRIVATE "$<$<CONFIG:DEBUG>:${PAGMO_SNOPT7_CXX_FLAGS_DEBUG}>" "$<$<CONFIG:RELEASE>:${PAGMO_SNOPT7_CXX_FLAGS_RELEASE}>")
    set_property(TARGET ${arg1} PROPERTY CXX_STANDARD 11)
    set_property(TARGET ${arg1} PROPERTY CXX_STANDARD_REQUIRED YES)
    set_property(TARGET ${arg1} PROPERTY CXX_EXTENSIONS NO)
    add_test(${arg1} ${arg1})
endfunction()

# Tests
ADD_PAGMO_SNOPT7_TESTCASE(snopt7)
ADD_PAGMO_SNOPT7_TESTCASE(snopt7_lib_test)
