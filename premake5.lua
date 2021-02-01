idasdk = path.translate((os.getenv("IDASDK") or "C:\\idasdk") .. "/")

workspace "ida_plugin"
	configurations
	{
		"ida32 Debug",
		"ida32 Release",
		"ida64 Debug",
		"ida64 Release",
	}

	startproject "ida_plugin"

	location "build"
	architecture "amd64"
	characterset ("MBCS")

	defines { "__NT__", "_CONSOLE" }

	includedirs { idasdk .. "include" }
	includedirs { idasdk .. "ldr" }
	includedirs { idasdk .. "module" }

	filter "configurations:ida32*"
		libdirs { idasdk .. "lib/x64_win_vc_32" }

	filter "configurations:ida64*"
		defines { "__EA64__" }
		libdirs { idasdk .. "lib/x64_win_vc_64" }

	filter "configurations:*Debug"
		defines { "_DEBUG" }
		symbols "full"
		optimize "off"
		runtime "debug"

	filter "configurations:*Release"
		defines { "NDEBUG" }
		symbols "on"
		optimize "speed"
		runtime "release"
		flags { "LinkTimeOptimization" }

project "ida_plugin"
	kind "SharedLib"
	language "C++"
	targetname "ida_plugin"
	targetdir "bin/%{cfg.buildcfg}"
	targetextension ".dll"

	links { "ida" }

	files { "src/*.cpp" }
	files { "src/*.c" }
	includedirs { "src" }
