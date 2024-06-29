workspace "RealEngine"
    architecture "x64"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

-- Variable for Output Directory - Will generate debug windows x64
    -- cfg.buildcf = whether it is debug/release
    -- cfg.system = Windows/Mac or something
    -- cfg.architecture x64 or something

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "RealEngine" -- Project name
    location "RealEngine" -- Location 
    kind "SharedLib" -- Since we are dealing with a DLL file 
    language "C++" -- The language we are programming in 

    targetdir ("bin/" .. outputdir .. "/%{prj.name}") -- binary folder | variable subsitution prj.name = 
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}") -- binary intermediary folder    

    files
    {
        "%{prj.name}/src/**.hpp", -- note that ** means recursive
        "%{prj.name}/src/**.cpp" 
    }

    includedirs
    {
        "%{prj.name}/vendor/spdlog/include" 
    }

    filter "system:windows" -- Certain project props for certain platform
        cppdialect "C++17" -- C++ version
        staticruntime "On" -- Linking the runtime library 
        systemversion "latest" -- Windows SDK version

        defines -- 
        {
            "RE_PLATFORM_WINDOWS",
            "RE_BUILD_DLL"
        }

        -- Need to add a post build command to move DLL file
            -- cfg.buildtarget.relpath gives us DLL path
        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox") -- In RE copy RealEngine/bin/Debug-x64/RealEngine.dll -> Sandbox/bin/Debug-x64/RealEngine.dll
        }
    
    filter "configurations:Debug"
        defines "RE_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "RE_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "RE_DIST"
        optimize "On"
    
project "Sandbox"

    location "Sandbox" -- Location 
    kind "ConsoleApp" -- Since we are dealing with a Application
    language "C++" -- The language we are programming in 

    targetdir ("bin/" .. outputdir .. "/%{prj.name}") -- binary folder | variable subsitution prj.name = 
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}") -- binary intermediary folder    

    files
    {
        "%{prj.name}/src/**.hpp", -- note that ** means recursive
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "RealEngine/vendor/spdlog/include",
        "RealEngine/src" -- Note that this is a different solution that RealEngine
    }

    links 
    {
        "RealEngine"
    }

    filter "system:windows" -- Certain project props for certain platform
        cppdialect "C++17" -- C++ version
        staticruntime "On" -- Linking the runtime library 
        systemversion "latest" -- Windows SDK version

        defines 
        {
            "RE_PLATFORM_WINDOWS",
            "RE_BUILD_DLL"
        }

        -- Need to add a post build command to move DLL file
            -- cfg.buildtarget 
        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox") -- In RE copy RealEngine/bin/Debug-x64/RealEngine.dll -> Sandbox/bin/Debug-x64/RealEngine.dll
        }
    
    filter "configurations:Debug"
        defines "RE_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "RE_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "RE_DIST"
        optimize "On"
