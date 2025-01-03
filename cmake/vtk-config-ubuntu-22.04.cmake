# vtk-config.cmake

# Set VTK version
set(VTK_MAJOR_VERSION 9)
set(VTK_MINOR_VERSION 3)
set(VTK_BUILD_VERSION 1)

# Set full VTK version
set(VTK_VERSION "${VTK_MAJOR_VERSION}.${VTK_MINOR_VERSION}.${VTK_BUILD_VERSION}")

# Set include and library directories
if(WIN32)
  set(HOME_DIR "$ENV{USERPROFILE}")
else()
  set(HOME_DIR "$ENV{HOME}")
endif()

set(VTK_INCLUDE_DIRS "${HOME_DIR}/opt/local/vtk-${VTK_VERSION}/include/vtk-${VTK_MAJOR_VERSION}.${VTK_MINOR_VERSION}")
set(VTK_LIBRARY_DIRS "${HOME_DIR}/opt/local/vtk-${VTK_VERSION}/lib")

# Find Python interpreter and get version
find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(PYTHON_VERSION "${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}")

# Define the components
set(VTK_MODULES_ENABLED
    CommonCore
    WebCore
    CommonMath
    CommonTransforms
    CommonDataModel
    CommonExecutionModel
    IOCore
    ImagingCore
    IOImage
    IOXMLParser
    IOXML
    CommonMisc
    FiltersCore
    RenderingCore
    RenderingContext2D
    RenderingFreeType
    RenderingSceneGraph
    RenderingVtkJS
    IOExport
    WebGLExporter
    CommonComputationalGeometry
    CommonSystem
    IOLegacy
    DomainsChemistry
    FiltersSources
    FiltersGeneral
    RenderingHyperTreeGrid
    RenderingUI
    RenderingOpenGL2
    RenderingContextOpenGL2
    RenderingVolume
    ImagingMath
    RenderingVolumeOpenGL2
    InteractionWidgets
    ViewsCore
    ViewsContext2D
    TestingRendering
    InteractionStyle
    ViewsInfovis
    RenderingVolumeAMR
    PythonContext2D
    RenderingParallel
    RenderingVR
    RenderingMatplotlib
    RenderingLabel
    RenderingLOD
    RenderingLICOpenGL2
    RenderingImage
    RenderingExternal
    FiltersCellGrid
    RenderingCellGrid
    IOXdmf2
    IOVeraOut
    IOVPIC
    IOTecplotTable
    IOTRUCHAS
    IOSegY
    IOParallelXML
    IOLSDyna
    IOParallelLSDyna
    IOExodus
    IOParallelExodus
    IOPLY
    IOPIO
    IOMovie
    IOOggTheora
    IOOMF
    IONetCDF
    IOMotionFX
    IOGeometry
    IOParallel
    IOMINC
    IOInfovis
    IOImport
    ParallelCore
    IOIOSS
    IOH5part
    IOH5Rage
    IOGeoJSON
    IOFLUENTCFF
    IOVideo
    IOExportPDF
    RenderingGL2PSOpenGL2
    IOExportGL2PS
    IOEnSight
    IOCityGML
    IOChemistry
    IOCesium3DTiles
    IOCellGrid
    IOCONVERGECFD
    IOHDF
    IOCGNSReader
    IOAsynchronous
    IOAMR
    InteractionImage
    ImagingStencil
    ImagingStatistics
    ImagingGeneral
    ImagingOpenGL2
    ImagingMorphological
    ImagingFourier
    IOSQL
    CommonColor
    ImagingSources
    InfovisCore
    GeovisCore
    InfovisLayout
    RenderingAnnotation
    ImagingHybrid
    ImagingColor
    FiltersTopology
    FiltersTensor
    FiltersSelection
    FiltersSMP
    FiltersReduction
    FiltersPython
    FiltersProgrammable
    FiltersModeling
    FiltersPoints
    FiltersStatistics
    FiltersParallelStatistics
    FiltersImaging
    FiltersExtraction
    FiltersGeometry
    FiltersHybrid
    FiltersHyperTree
    FiltersTexture
    FiltersParallel
    FiltersParallelImaging
    FiltersParallelDIY2
    FiltersGeometryPreview
    FiltersGeneric
    FiltersFlowPaths
    FiltersAMR
    DomainsChemistryOpenGL2
    CommonPython
    ChartsCore
    AcceleratorsVTKmCore
    AcceleratorsVTKmDataModel
    AcceleratorsVTKmFilters
    FiltersVerdict
    WrappingPythonCore
)

# Create imported targets for each module
foreach(module ${VTK_MODULES_ENABLED})
    if(NOT TARGET VTK::${module})
        add_library(VTK::${module} SHARED IMPORTED)
        if(${module} STREQUAL "WrappingPythonCore")
            set_target_properties(VTK::${module} PROPERTIES
                IMPORTED_LOCATION "${VTK_LIBRARY_DIRS}/libvtkWrappingPythonCore${PYTHON_VERSION}-${VTK_MAJOR_VERSION}.${VTK_MINOR_VERSION}.so"
                INTERFACE_INCLUDE_DIRECTORIES "${VTK_INCLUDE_DIRS}"
            )
        else()
            set_target_properties(VTK::${module} PROPERTIES
                IMPORTED_LOCATION "${VTK_LIBRARY_DIRS}/libvtk${module}-${VTK_MAJOR_VERSION}.${VTK_MINOR_VERSION}.so"
                INTERFACE_INCLUDE_DIRECTORIES "${VTK_INCLUDE_DIRS}"
            )
        endif()
    endif()
endforeach()

# Set VTK_LIBRARIES
set(VTK_LIBRARIES "")
foreach(module ${VTK_MODULES_ENABLED})
    list(APPEND VTK_LIBRARIES VTK::${module})
endforeach()

# Set VTK_FOUND
set(VTK_FOUND TRUE)

# Set VTK_USE_FILE (for backward compatibility)
set(VTK_USE_FILE "${CMAKE_CURRENT_LIST_DIR}/UseVTK.cmake")

# Print status
message(STATUS "Found VTK ${VTK_VERSION}")
message(STATUS "  Includes: ${VTK_INCLUDE_DIRS}")
message(STATUS "  Libraries: ${VTK_LIBRARIES}")
message(STATUS "  Python Version: ${Python3_VERSION}")
