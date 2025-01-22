import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import LandingPagesController from "./landing_pages_controller"
application.register("landing-pages", LandingPagesController)
