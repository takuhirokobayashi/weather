class AppState < ApplicationRecord
  ACTIVE = 'Active'
  OVERLOADED = 'Overloaded'
  DOWN = 'Down'
  OUT_OF_SERVICE = 'OutOfService'
  THROTTLED_OPERATION = 'Throttled Operation'

  def self.set_active!
    app_state = AppState.first_or_initialize
    app_state.update( state: ACTIVE )
  end

  def self.set_active
    ActiveRecord::Base.uncached do
      app_state = AppState.first_or_initialize
      if OUT_OF_SERVICE != app_state.state
        app_state.update( state: ACTIVE )
      end
    end
  end

  def self.set_overloaded
    ActiveRecord::Base.uncached do
      app_state = AppState.first_or_initialize
      if OUT_OF_SERVICE != app_state.state
        app_state.update( state: OVERLOADED )
      end
    end
  end

  def self.set_down
    ActiveRecord::Base.uncached do
      app_state = AppState.first_or_initialize
      if OUT_OF_SERVICE != app_state.state
        app_state.update( state: DOWN )
      end
    end
  end

  def self.set_out_of_service
    app_state = AppState.first_or_initialize
    app_state.update( state: OUT_OF_SERVICE )
  end

  def self.set_throttled_operation
    ActiveRecord::Base.uncached do
      app_state = AppState.first_or_initialize
      if OUT_OF_SERVICE != app_state.state
        app_state.update( state: THROTTLED_OPERATION )
      end
    end
  end

  def self.active?
    ActiveRecord::Base.uncached do
      app_state = AppState.first
      app_state && ACTIVE == app_state.state
    end
  end

  def self.overloaded?
    ActiveRecord::Base.uncached do
      app_state = AppState.first
      app_state && OVERLOADED == app_state.state
    end
  end

  def self.down?
    ActiveRecord::Base.uncached do
      app_state = AppState.first
      app_state && DOWN == app_state.state
    end
  end

  def self.out_of_service?
    ActiveRecord::Base.uncached do
      app_state = AppState.first
      app_state && OUT_OF_SERVICE == app_state.state
    end
  end

  def self.throttled_operation?
    ActiveRecord::Base.uncached do
      app_state = AppState.first
      app_state && THROTTLED_OPERATION == app_state.state
    end
  end
end
