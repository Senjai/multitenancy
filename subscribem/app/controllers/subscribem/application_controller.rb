module Subscribem
  class ApplicationController < ::ApplicationController
    #This inherits from the applications ApplicationController. All Shared behavior
    #between the engine and application should be placed in the relevant extender
    #that monkey patches the applications controller.
    #
    #Only put engine specific code here..
  end
end
