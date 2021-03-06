cmake_minimum_required(VERSION 3.7.0 FATAL_ERROR)

project( PUMEX LANGUAGES CXX VERSION 0.2.0 )
set( PUMEX_SOVERSION 1 )

message( STATUS "Building PUMEX library version ${PUMEX_VERSION_MAJOR}.${PUMEX_VERSION_MINOR}.${PUMEX_VERSION_PATCH}" )

option( PUMEX_BUILD_EXAMPLES             "Build examples" ON )
if(WIN32)
  option( PUMEX_DOWNLOAD_EXTERNAL_GLM      "Download GLM library"       ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_GLI      "Download GLI library"       ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_ARGS     "Download ARGS library"      ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_ASSIMP   "Download Assimp library"    ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_FREETYPE "Download Freetype2 library" ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_TBB      "Download TBB library"       ON )
else()
  option( PUMEX_DOWNLOAD_EXTERNAL_GLM      "Download GLM library"       ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_GLI      "Download GLI library"       ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_ARGS     "Download ARGS library"      ON )
  option( PUMEX_DOWNLOAD_EXTERNAL_ASSIMP   "Download Assimp library"    OFF )
  option( PUMEX_DOWNLOAD_EXTERNAL_FREETYPE "Download Freetype2 library" OFF )
  option( PUMEX_DOWNLOAD_EXTERNAL_TBB      "Download TBB library"       OFF )
endif()


list( APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" )
list( APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules" )

set( CMAKE_CXX_STANDARD 14 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )
set( CMAKE_CXX_EXTENSIONS OFF )

configure_file (
  "${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Version.in"
  "${CMAKE_CURRENT_BINARY_DIR}/include/pumex/Version.h"
  )

include( pumex_macros )
include( pumex_externals )

set( PUMEXLIB_SHADER_NAMES 
  shaders/text_draw.vert
  shaders/text_draw.geom
  shaders/text_draw.frag
  shaders/stat_draw.vert
  shaders/stat_draw.frag
)
process_shaders( ${CMAKE_CURRENT_LIST_DIR} PUMEXLIB_SHADER_NAMES PUMEXLIB_INPUT_SHADERS PUMEXLIB_OUTPUT_SHADERS )
add_custom_target ( pumexlib-shaders DEPENDS ${PUMEXLIB_OUTPUT_SHADERS} SOURCES ${PUMEXLIB_INPUT_SHADERS} )
add_custom_command(TARGET pumexlib-shaders PRE_BUILD COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/shaders")

set( PUMEXLIB_HEADERS )
list( APPEND PUMEXLIB_HEADERS 
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Asset.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/AssetBuffer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/AssetBufferNode.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/AssetLoaderAssimp.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/AssetNode.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/BoundingBox.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Camera.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/CombinedImageSampler.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Command.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Descriptor.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Device.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/DeviceMemoryAllocator.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/DispatchNode.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/DrawNode.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/DrawVerticesNode.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Export.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/FrameBuffer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/HPClock.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Image.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/InputAttachment.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/InputEvent.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Kinematic.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/MaterialSet.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/MemoryBuffer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/MemoryImage.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/MemoryObject.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/MemoryObjectBarrier.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Node.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/NodeVisitor.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/PerObjectData.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/PhysicalDevice.h 
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Pipeline.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Pumex.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Query.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/RenderContext.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/RenderPass.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/RenderVisitors.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/RenderWorkflow.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Resource.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/SampledImage.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Sampler.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/StandardHandlers.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/StorageBuffer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/StorageImage.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Surface.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Text.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/TextureLoaderGli.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/TimeStatistics.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/UniformBuffer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Viewer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/Window.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/utils/ActionQueue.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/utils/Buffer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/utils/HashCombine.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/utils/Log.h
  ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/utils/Shapes.h  
  ${CMAKE_CURRENT_BINARY_DIR}/include/pumex/Version.h
)
if(WIN32)
  list( APPEND PUMEXLIB_HEADERS 
    ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/platform/win32/HPClockWin32.h
    ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/platform/win32/WindowWin32.h
  )
elseif(UNIX AND NOT APPLE)
  list( APPEND PUMEXLIB_HEADERS 
    ${CMAKE_CURRENT_SOURCE_DIR}/include/pumex/platform/linux/WindowXcb.h
  )
endif()

set( PUMEXLIB_SOURCES )
list( APPEND PUMEXLIB_SOURCES 
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Asset.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/AssetBuffer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/AssetBufferNode.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/AssetLoaderAssimp.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/AssetNode.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/BoundingBox.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Camera.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/CombinedImageSampler.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Command.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Descriptor.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Device.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/DeviceMemoryAllocator.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/DispatchNode.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/DrawNode.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/DrawVerticesNode.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/FrameBuffer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Image.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/InputEvent.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/InputAttachment.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Kinematic.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/MaterialSet.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/MemoryBuffer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/MemoryImage.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/MemoryObject.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/MemoryObjectBarrier.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Node.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/NodeVisitor.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/PerObjectData.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/PhysicalDevice.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Pipeline.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Query.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/RenderContext.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/RenderPass.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/RenderVisitors.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/RenderWorkflow.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Resource.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/SampledImage.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Sampler.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/StandardHandlers.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/StorageBuffer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/StorageImage.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Surface.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Text.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/TextureLoaderGli.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/TimeStatistics.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/UniformBuffer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Viewer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/Window.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/utils/Buffer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/utils/Log.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/utils/Shapes.cpp
)
if(WIN32)
  list( APPEND PUMEXLIB_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/platform/win32/HPClockWin32.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/platform/win32/WindowWin32.cpp
  )
elseif(UNIX AND NOT APPLE)
  list( APPEND PUMEXLIB_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/pumex/platform/linux/WindowXcb.cpp
  )
endif()

add_library( pumexlib SHARED "" )
target_sources( pumexlib 
  PUBLIC 
    $<BUILD_INTERFACE:${PUMEXLIB_HEADERS}> 
  PRIVATE 
    ${PUMEXLIB_SOURCES} 
)
target_include_directories( pumexlib 
  PUBLIC 
    $<BUILD_INTERFACE:${PUMEXLIB_PUBLIC_INCLUDES}> 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  PRIVATE 
    $<BUILD_INTERFACE:${PUMEXLIB_PRIVATE_INCLUDES}> 
)
target_compile_definitions( pumexlib 
  PUBLIC 
    NOMINMAX GLM_ENABLE_EXPERIMENTAL GLM_FORCE_RADIANS GLM_FORCE_DEPTH_ZERO_TO_ONE 
  PRIVATE
    PUMEX_EXPORTS
)
if(WIN32)
  target_compile_definitions( pumexlib PUBLIC VK_USE_PLATFORM_WIN32_KHR )
elseif(UNIX AND NOT APPLE)
  target_compile_definitions( pumexlib PUBLIC VK_USE_PLATFORM_XCB_KHR )
endif()
add_dependencies( pumexlib pumexlib-shaders ${PUMEXLIB_EXTERNALS} )
set_target_properties( pumexlib PROPERTIES VERSION ${PUMEX_VERSION} SOVERSION ${PUMEX_SOVERSION} )
set_target_properties( pumexlib PROPERTIES RESOURCE "${PUMEXLIB_OUTPUT_SHADERS}" )
target_link_libraries( pumexlib ${PUMEXLIB_LIBRARIES} )
set_target_postfixes( pumexlib )

if( PUMEX_BUILD_EXAMPLES )
  add_subdirectory( examples )
endif()

install( TARGETS pumexlib EXPORT PumexTargets
         ARCHIVE DESTINATION lib COMPONENT libraries
         LIBRARY DESTINATION lib COMPONENT libraries
         RUNTIME DESTINATION bin COMPONENT libraries
         RESOURCE DESTINATION share/pumex/shaders COMPONENT libraries
         )
install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/ DESTINATION include COMPONENT headers FILES_MATCHING PATTERN "*.h"  )
install( FILES ${CMAKE_CURRENT_BINARY_DIR}/include/pumex/Version.h DESTINATION include/pumex COMPONENT headers )
install( DIRECTORY ${INTERMEDIATE_INSTALL_DIR}/include/ DESTINATION include COMPONENT dependencies )
install( DIRECTORY ${INTERMEDIATE_INSTALL_DIR}/bin/ DESTINATION bin COMPONENT dependencies )
install( DIRECTORY ${INTERMEDIATE_INSTALL_DIR}/lib/ DESTINATION lib COMPONENT dependencies )
install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/data/fonts/ DESTINATION share/pumex/fonts COMPONENT examples )
install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/data/people/ DESTINATION share/pumex/people COMPONENT examples )
install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/data/sponza/ DESTINATION share/pumex/sponza COMPONENT examples )
install( EXPORT PumexTargets
  FILE pumex-config.cmake
  NAMESPACE pumex::
  DESTINATION lib/cmake/pumex
  COMPONENT cmake_files
)  

include( CMakePackageConfigHelpers )
write_basic_package_version_file( ${CMAKE_CURRENT_BINARY_DIR}/pumex-config-version.cmake
  VERSION ${PUMEX_VERSION}
  COMPATIBILITY SameMajorVersion
)
install( FILES ${CMAKE_CURRENT_BINARY_DIR}/pumex-config-version.cmake DESTINATION lib/cmake/pumex COMPONENT cmake_files )

set( CPACK_PACKAGE_NAME "pumex" )
set( CPACK_PACKAGE_VENDOR "CMake.org" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "Pumex - Vulkan library oriented on high speed rendering" )
set( CPACK_PACKAGE_VERSION ${PUMEX_VERSION} )
set( CPACK_PACKAGE_VERSION_MAJOR ${PUMEX_VERSION_MAJOR} )
set( CPACK_PACKAGE_VERSION_MINOR ${PUMEX_VERSION_MINOR} )
set( CPACK_PACKAGE_VERSION_PATCH ${PUMEX_VERSION_PATCH} )
set( CPACK_PACKAGE_INSTALL_DIRECTORY "Pumex" )
set( CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE" )

include(CPack)

cpack_add_install_type( Full      DISPLAY_NAME "Full install ( development files with examples )" )
cpack_add_install_type( Developer DISPLAY_NAME "Development files WITHOUT examples" )

cpack_add_component_group( DevGroup DISPLAY_NAME "Development files" DESCRIPTION "All files required to develop your applications using Pumex library" )
cpack_add_component_group( ExampleApps DISPLAY_NAME "Example applications" DESCRIPTION "Example applications show Pumex library in action" )

cpack_add_component( dependencies 
  DISPLAY_NAME "3rd party libraries" 
  DESCRIPTION "Libraries that must be installed in order to run Pumex library" 
  GROUP DevGroup 
  INSTALL_TYPES Developer Full
)  
cpack_add_component( libraries
  DISPLAY_NAME "Library files" 
  DESCRIPTION "Dynamic libraries used to build applications with Pumex library. Libraries are also used by example applications" 
  GROUP DevGroup 
  INSTALL_TYPES Developer Full
  DEPENDS dependencies
)  
cpack_add_component( headers
  DISPLAY_NAME "Header files" 
  DESCRIPTION "Header files required to write and build applications with Pumex library" 
  GROUP DevGroup 
  INSTALL_TYPES Developer Full
  DEPENDS libraries
)  
cpack_add_component( cmake_files
  DISPLAY_NAME "CMake configuration files" 
  DESCRIPTION "Files that help find Pumex library and use it in your application" 
  GROUP DevGroup 
  INSTALL_TYPES Developer Full
  DEPENDS libraries
)  
cpack_add_component( examples
  DISPLAY_NAME "Example applications" 
  DESCRIPTION "Example applications show Pumex library in action" 
  GROUP ExampleApps 
  INSTALL_TYPES Full
  DEPENDS libraries
)  
