#pragma once

#include "Core.hpp"

namespace RealEngine {

	class RE_API Application
	{
	public:
		Application();
		virtual ~Application();

		void Run();
	};

	// Will be defined in our client - Sandbox app class instance return
	Application* CreateApplication();
}