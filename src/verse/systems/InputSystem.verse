# InputSystem.verse
# Component-based input system for Z-Fort: Black Ops Undead
# This system manages all input handling using Unity-style component architecture

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Input types
enum InputType {
    Keyboard
    Mouse
    Gamepad
    Touch
}

# Input actions
enum InputAction {
    MoveForward
    MoveBackward
    MoveLeft
    MoveRight
    Jump
    Crouch
    Sprint
    Fire
    Reload
    Interact
    Menu
    Pause
    Weapon1
    Weapon2
    Weapon3
    Weapon4
    Grenade
    Melee
    UseAbility
    ToggleAim
}

# Input states
enum InputState {
    None
    Pressed
    Held
    Released
}

# Input device types
enum InputDevice {
    Keyboard
    Mouse
    Gamepad
    Touch
    Auto
}

# Input configuration structure
struct InputConfig {
    var Action : InputAction
    var PrimaryKey : string
    var SecondaryKey : string
    var GamepadButton : string
    var Device : InputDevice
    var Enabled : logic = true
    var RepeatDelay : float = 0.0
    var RepeatRate : float = 0.0
}

# Input data structure
struct InputData {
    var Action : InputAction
    var State : InputState
    var Value : float
    var Device : InputDevice
    var Timestamp : float
    var Position : vector2 = vector2{0.0, 0.0}
}

# Base input component
class InputComponent : Component {
    var InputType : InputType
    var IsEnabled : logic = true
    var IsActive : logic = false
    
    # Input events
    var OnInputReceived : (InputData) -> void = (Data : InputData) -> void {}
    var OnInputStateChanged : (InputState, InputState) -> void = (OldState : InputState, NewState : InputState) -> void {}
    
    Initialize(InputType : InputType) : void {
        this.InputType = InputType
    }
    
    # Enable input
    Enable() : void {
        IsEnabled = true
    }
    
    # Disable input
    Disable() : void {
        IsEnabled = false
        IsActive = false
    }
    
    # Process input
    ProcessInput(InputData : InputData) : void {
        if (IsEnabled) {
            OnInputReceived(InputData)
        }
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Base input update logic
    }
}

# Keyboard input component
class KeyboardInputComponent : InputComponent {
    var KeyBindings : []InputConfig = array{}
    var KeyStates : []logic = array{}
    var LastKeyStates : []logic = array{}
    
    Initialize() : void {
        super.Initialize(InputType::Keyboard)
        SetupDefaultKeyBindings()
    }
    
    # Setup default key bindings
    SetupDefaultKeyBindings() : void {
        KeyBindings.Add(InputConfig{
            Action = InputAction::MoveForward,
            PrimaryKey = "W",
            SecondaryKey = "Up",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::MoveBackward,
            PrimaryKey = "S",
            SecondaryKey = "Down",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::MoveLeft,
            PrimaryKey = "A",
            SecondaryKey = "Left",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::MoveRight,
            PrimaryKey = "D",
            SecondaryKey = "Right",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::Fire,
            PrimaryKey = "Mouse1",
            SecondaryKey = "",
            GamepadButton = "",
            Device = InputDevice::Mouse,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::Reload,
            PrimaryKey = "R",
            SecondaryKey = "",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::Jump,
            PrimaryKey = "Space",
            SecondaryKey = "",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
        
        KeyBindings.Add(InputConfig{
            Action = InputAction::Sprint,
            PrimaryKey = "Shift",
            SecondaryKey = "",
            GamepadButton = "",
            Device = InputDevice::Keyboard,
            Enabled = true
        })
    }
    
    # Get key binding for action
    GetKeyBinding(Action : InputAction) : InputConfig {
        for (Binding in KeyBindings) {
            if (Binding.Action == Action) {
                return Binding
            }
        }
        return InputConfig{}
    }
    
    # Check if key is pressed
    IsKeyPressed(Key : string) : logic {
        # TODO: Implement actual key checking
        return false
    }
    
    # Check if action is pressed
    IsActionPressed(Action : InputAction) : logic {
        var Binding : InputConfig = GetKeyBinding(Action)
        if (Binding.Enabled) {
            return IsKeyPressed(Binding.PrimaryKey) or IsKeyPressed(Binding.SecondaryKey)
        }
        return false
    }
    
    # Get input value for action
    GetInputValue(Action : InputAction) : float {
        if (IsActionPressed(Action)) {
            return 1.0
        }
        return 0.0
    }
}

# Mouse input component
class MouseInputComponent : InputComponent {
    var MousePosition : vector2 = vector2{0.0, 0.0}
    var MouseDelta : vector2 = vector2{0.0, 0.0}
    var MouseSensitivity : float = 1.0
    var InvertY : logic = false
    
    # Mouse button states
    var LeftButtonPressed : logic = false
    var RightButtonPressed : logic = false
    var MiddleButtonPressed : logic = false
    
    # Mouse events
    var OnMouseMove : (vector2) -> void = (Delta : vector2) -> void {}
    var OnMouseClick : (string, vector2) -> void = (Button : string, Position : vector2) -> void {}
    
    Initialize() : void {
        super.Initialize(InputType::Mouse)
    }
    
    # Set mouse sensitivity
    SetMouseSensitivity(Sensitivity : float) : void {
        MouseSensitivity = Clamp(Sensitivity, 0.1, 5.0)
    }
    
    # Set mouse position
    SetMousePosition(Position : vector2) : void {
        MouseDelta = Position - MousePosition
        MousePosition = Position
        
        if (MouseDelta.Length() > 0.0) {
            OnMouseMove(MouseDelta * MouseSensitivity)
        }
    }
    
    # Handle mouse button press
    HandleMouseButton(Button : string, Pressed : logic) : void {
        case (Button) {
            "Left" => LeftButtonPressed = Pressed
            "Right" => RightButtonPressed = Pressed
            "Middle" => MiddleButtonPressed = Pressed
        }
        
        if (Pressed) {
            OnMouseClick(Button, MousePosition)
        }
    }
    
    # Get mouse position
    GetMousePosition() : vector2 {
        return MousePosition
    }
    
    # Get mouse delta
    GetMouseDelta() : vector2 {
        return MouseDelta
    }
    
    # Check if mouse button is pressed
    IsMouseButtonPressed(Button : string) : logic {
        case (Button) {
            "Left" => return LeftButtonPressed
            "Right" => return RightButtonPressed
            "Middle" => return MiddleButtonPressed
        }
        return false
    }
}

# Gamepad input component
class GamepadInputComponent : InputComponent {
    var GamepadID : int = 0
    var IsConnected : logic = false
    
    # Gamepad button states
    var ButtonStates : []logic = array{}
    var AxisValues : []float = array{}
    
    # Gamepad events
    var OnGamepadConnected : (int) -> void = (ID : int) -> void {}
    var OnGamepadDisconnected : (int) -> void = (ID : int) -> void {}
    var OnGamepadButton : (string, logic) -> void = (Button : string, Pressed : logic) -> void {}
    var OnGamepadAxis : (string, float) -> void = (Axis : string, Value : float) -> void {}
    
    Initialize(GamepadID : int) : void {
        super.Initialize(InputType::Gamepad)
        this.GamepadID = GamepadID
        SetupGamepadBindings()
    }
    
    # Setup gamepad bindings
    SetupGamepadBindings() : void {
        # TODO: Implement gamepad button and axis bindings
        Print("Gamepad bindings setup for ID: {GamepadID}")
    }
    
    # Connect gamepad
    Connect() : void {
        IsConnected = true
        OnGamepadConnected(GamepadID)
    }
    
    # Disconnect gamepad
    Disconnect() : void {
        IsConnected = false
        OnGamepadDisconnected(GamepadID)
    }
    
    # Handle gamepad button
    HandleGamepadButton(Button : string, Pressed : logic) : void {
        if (IsConnected) {
            OnGamepadButton(Button, Pressed)
        }
    }
    
    # Handle gamepad axis
    HandleGamepadAxis(Axis : string, Value : float) : void {
        if (IsConnected) {
            OnGamepadAxis(Axis, Value)
        }
    }
    
    # Check if gamepad button is pressed
    IsGamepadButtonPressed(Button : string) : logic {
        # TODO: Implement actual gamepad button checking
        return false
    }
    
    # Get gamepad axis value
    GetGamepadAxisValue(Axis : string) : float {
        # TODO: Implement actual gamepad axis checking
        return 0.0
    }
}

# Input action component
class InputActionComponent : Component {
    var Action : InputAction
    var CurrentState : InputState = InputState::None
    var LastState : InputState = InputState::None
    var Value : float = 0.0
    var LastValue : float = 0.0
    
    # Action events
    var OnActionPressed : () -> void = () -> void {}
    var OnActionHeld : () -> void = () -> void {}
    var OnActionReleased : () -> void = () -> void {}
    var OnActionValueChanged : (float) -> void = (Value : float) -> void {}
    
    Initialize(Action : InputAction) : void {
        this.Action = Action
    }
    
    # Update action state
    UpdateActionState(NewState : InputState, NewValue : float) : void {
        LastState = CurrentState
        LastValue = Value
        CurrentState = NewState
        Value = NewValue
        
        # Handle state changes
        if (CurrentState == InputState::Pressed and LastState == InputState::None) {
            OnActionPressed()
        } else if (CurrentState == InputState::Held) {
            OnActionHeld()
        } else if (CurrentState == InputState::Released and LastState == InputState::Held) {
            OnActionReleased()
        }
        
        # Handle value changes
        if (Value != LastValue) {
            OnActionValueChanged(Value)
        }
    }
    
    # Get action state
    GetActionState() : InputState {
        return CurrentState
    }
    
    # Get action value
    GetActionValue() : float {
        return Value
    }
    
    # Check if action is pressed
    IsActionPressed() : logic {
        return CurrentState == InputState::Pressed or CurrentState == InputState::Held
    }
    
    # Check if action was just pressed
    WasActionJustPressed() : logic {
        return CurrentState == InputState::Pressed and LastState == InputState::None
    }
    
    # Check if action was just released
    WasActionJustReleased() : logic {
        return CurrentState == InputState::Released and LastState == InputState::Held
    }
}

# Main input system class
class InputSystem : GameObject {
    # Input components
    var KeyboardInput : KeyboardInputComponent
    var MouseInput : MouseInputComponent
    var GamepadInputs : []GamepadInputComponent = array{}
    var InputActions : []InputActionComponent = array{}
    
    # Input system properties
    var IsInitialized : logic = false
    var InputEnabled : logic = true
    var InputBuffer : []InputData = array{}
    var MaxInputBufferSize : int = 10
    
    # Initialize input system
    Initialize() : void {
        # Initialize base GameObject
        super.Initialize("InputSystem")
        
        # Create input components
        CreateInputComponents()
        
        # Setup input actions
        SetupInputActions()
        
        IsInitialized = true
        Print("InputSystem initialized")
    }
    
    # Create input components
    CreateInputComponents() : void {
        # Create keyboard input
        KeyboardInput = KeyboardInputComponent{}
        KeyboardInput.Initialize()
        AddComponent(KeyboardInput)
        
        # Create mouse input
        MouseInput = MouseInputComponent{}
        MouseInput.Initialize()
        AddComponent(MouseInput)
        
        # Create gamepad inputs (up to 4 controllers)
        for (i in 0..3) {
            var GamepadInput : GamepadInputComponent = GamepadInputComponent{}
            GamepadInput.Initialize(i)
            AddComponent(GamepadInput)
            GamepadInputs.Add(GamepadInput)
        }
    }
    
    # Setup input actions
    SetupInputActions() : void {
        # Create input actions for all actions
        for (Action in InputAction) {
            var InputAction : InputActionComponent = InputActionComponent{}
            InputAction.Initialize(Action)
            AddComponent(InputAction)
            InputActions.Add(InputAction)
        }
    }
    
    # Get input action component
    GetInputAction(Action : InputAction) : InputActionComponent {
        for (InputAction in InputActions) {
            if (InputAction.Action == Action) {
                return InputAction
            }
        }
        return InputActionComponent{}
    }
    
    # Check if action is pressed
    IsActionPressed(Action : InputAction) : logic {
        var InputAction : InputActionComponent = GetInputAction(Action)
        if (InputAction != InputActionComponent{}) {
            return InputAction.IsActionPressed()
        }
        return false
    }
    
    # Check if action was just pressed
    WasActionJustPressed(Action : InputAction) : logic {
        var InputAction : InputActionComponent = GetInputAction(Action)
        if (InputAction != InputActionComponent{}) {
            return InputAction.WasActionJustPressed()
        }
        return false
    }
    
    # Check if action was just released
    WasActionJustReleased(Action : InputAction) : logic {
        var InputAction : InputActionComponent = GetInputAction(Action)
        if (InputAction != InputActionComponent{}) {
            return InputAction.WasActionJustReleased()
        }
        return false
    }
    
    # Get action value
    GetActionValue(Action : InputAction) : float {
        var InputAction : InputActionComponent = GetInputAction(Action)
        if (InputAction != InputActionComponent{}) {
            return InputAction.GetActionValue()
        }
        return 0.0
    }
    
    # Get mouse position
    GetMousePosition() : vector2 {
        if (MouseInput != MouseInputComponent{}) {
            return MouseInput.GetMousePosition()
        }
        return vector2{0.0, 0.0}
    }
    
    # Get mouse delta
    GetMouseDelta() : vector2 {
        if (MouseInput != MouseInputComponent{}) {
            return MouseInput.GetMouseDelta()
        }
        return vector2{0.0, 0.0}
    }
    
    # Enable input
    EnableInput() : void {
        InputEnabled = true
        if (KeyboardInput != KeyboardInputComponent{}) {
            KeyboardInput.Enable()
        }
        if (MouseInput != MouseInputComponent{}) {
            MouseInput.Enable()
        }
        for (GamepadInput in GamepadInputs) {
            GamepadInput.Enable()
        }
    }
    
    # Disable input
    DisableInput() : void {
        InputEnabled = false
        if (KeyboardInput != KeyboardInputComponent{}) {
            KeyboardInput.Disable()
        }
        if (MouseInput != MouseInputComponent{}) {
            MouseInput.Disable()
        }
        for (GamepadInput in GamepadInputs) {
            GamepadInput.Disable()
        }
    }
    
    # Get input statistics
    GetInputStats() : string {
        var Stats : string = "Input Statistics:\n"
        Stats = "{Stats}Input Enabled: {InputEnabled}\n"
        Stats = "{Stats}Keyboard Active: {KeyboardInput.IsActive}\n"
        Stats = "{Stats}Mouse Active: {MouseInput.IsActive}\n"
        Stats = "{Stats}Gamepads Connected: {GamepadInputs.Length}\n"
        Stats = "{Stats}Input Actions: {InputActions.Length}\n"
        return Stats
    }
    
    # Update input system
    Update(DeltaTime : float) : void {
        if (!IsInitialized or !InputEnabled) {
            return
        }
        
        # Process input from all devices
        ProcessKeyboardInput()
        ProcessMouseInput()
        ProcessGamepadInput()
        
        # Call base update
        super.Update(DeltaTime)
    }
    
    # Process keyboard input
    ProcessKeyboardInput() : void {
        if (KeyboardInput != KeyboardInputComponent{}) {
            # Update movement actions
            UpdateMovementActions()
            
            # Update action actions
            UpdateActionActions()
        }
    }
    
    # Process mouse input
    ProcessMouseInput() : void {
        if (MouseInput != MouseInputComponent{}) {
            # Mouse input is handled by the component itself
        }
    }
    
    # Process gamepad input
    ProcessGamepadInput() : void {
        for (GamepadInput in GamepadInputs) {
            if (GamepadInput.IsConnected) {
                # Gamepad input is handled by the component itself
            }
        }
    }
    
    # Update movement actions
    UpdateMovementActions() : void {
        # Update movement input values
        var ForwardValue : float = KeyboardInput.GetInputValue(InputAction::MoveForward)
        var BackwardValue : float = KeyboardInput.GetInputValue(InputAction::MoveBackward)
        var LeftValue : float = KeyboardInput.GetInputValue(InputAction::MoveLeft)
        var RightValue : float = KeyboardInput.GetInputValue(InputAction::MoveRight)
        
        # Update action components
        UpdateActionValue(InputAction::MoveForward, ForwardValue)
        UpdateActionValue(InputAction::MoveBackward, BackwardValue)
        UpdateActionValue(InputAction::MoveLeft, LeftValue)
        UpdateActionValue(InputAction::MoveRight, RightValue)
    }
    
    # Update action actions
    UpdateActionActions() : void {
        # Update other action inputs
        var FireValue : float = KeyboardInput.GetInputValue(InputAction::Fire)
        var ReloadValue : float = KeyboardInput.GetInputValue(InputAction::Reload)
        var JumpValue : float = KeyboardInput.GetInputValue(InputAction::Jump)
        var SprintValue : float = KeyboardInput.GetInputValue(InputAction::Sprint)
        
        # Update action components
        UpdateActionValue(InputAction::Fire, FireValue)
        UpdateActionValue(InputAction::Reload, ReloadValue)
        UpdateActionValue(InputAction::Jump, JumpValue)
        UpdateActionValue(InputAction::Sprint, SprintValue)
    }
    
    # Update action value
    UpdateActionValue(Action : InputAction, Value : float) : void {
        var InputAction : InputActionComponent = GetInputAction(Action)
        if (InputAction != InputActionComponent{}) {
            var NewState : InputState = if (Value > 0.0) { InputState::Held } else { InputState::None }
            InputAction.UpdateActionState(NewState, Value)
        }
    }
}

# Input manager - manages multiple input systems
class InputManager : game_simulated_class {
    static var Instance : InputManager = InputManager{}
    
    var InputSystems : []InputSystem = array{}
    var IsInitialized : logic = false
    
    # Initialize input manager
    static Initialize() : void {
        if (Instance == InputManager{}) {
            Instance = InputManager{}
            Instance.SetupInputManager()
        }
    }
    
    # Get singleton instance
    static GetInstance() : InputManager {
        return Instance
    }
    
    # Setup input manager
    SetupInputManager() : void {
        # Create main input system
        var MainInputSystem : InputSystem = InputSystem{}
        MainInputSystem.Initialize()
        InputSystems.Add(MainInputSystem)
        
        IsInitialized = true
        Print("InputManager initialized")
    }
    
    # Update all input systems
    UpdateAll(DeltaTime : float) : void {
        for (InputSystem in InputSystems) {
            InputSystem.Update(DeltaTime)
        }
    }
    
    # Get main input system
    GetMainInputSystem() : InputSystem {
        if (InputSystems.Length > 0) {
            return InputSystems[0]
        }
        return InputSystem{}
    }
    
    # Global input checking methods
    static IsActionPressed(Action : InputAction) : logic {
        var MainInputSystem : InputSystem = Instance.GetMainInputSystem()
        if (MainInputSystem != InputSystem{}) {
            return MainInputSystem.IsActionPressed(Action)
        }
        return false
    }
    
    static WasActionJustPressed(Action : InputAction) : logic {
        var MainInputSystem : InputSystem = Instance.GetMainInputSystem()
        if (MainInputSystem != InputSystem{}) {
            return MainInputSystem.WasActionJustPressed(Action)
        }
        return false
    }
    
    static GetActionValue(Action : InputAction) : float {
        var MainInputSystem : InputSystem = Instance.GetMainInputSystem()
        if (MainInputSystem != InputSystem{}) {
            return MainInputSystem.GetActionValue(Action)
        }
        return 0.0
    }
    
    static GetMousePosition() : vector2 {
        var MainInputSystem : InputSystem = Instance.GetMainInputSystem()
        if (MainInputSystem != InputSystem{}) {
            return MainInputSystem.GetMousePosition()
        }
        return vector2{0.0, 0.0}
    }
} 