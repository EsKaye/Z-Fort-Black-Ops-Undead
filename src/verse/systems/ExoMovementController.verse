# ExoMovementController.verse
# Handles player input and integrates with ExoMovement system

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

# Exo movement controller class
class ExoMovementController : game_simulated_class {
    # Movement system
    var ExoMovement : ExoMovement
    
    # Input tracking
    var IsJumpPressed : logic
    var IsSlidePressed : logic
    var IsBoostPressed : logic
    var IsHoverPressed : logic
    var MovementInput : vector2
    var LookInput : vector2
    
    # Initialize controller
    Initialize(Player : Player, Config : ExoMovementConfig) : void {
        ExoMovement = ExoMovement{Player, Config}
        IsJumpPressed = false
        IsSlidePressed = false
        IsBoostPressed = false
        IsHoverPressed = false
        MovementInput = vector2{0.0, 0.0}
        LookInput = vector2{0.0, 0.0}
        
        Print("Exo Movement Controller initialized")
    }
    
    # Update controller
    Update(DeltaTime : float) : void {
        # Update movement system
        ExoMovement.Update(DeltaTime)
        
        # Handle movement input
        HandleMovementInput()
        
        # Handle special movement
        HandleSpecialMovement()
    }
    
    # Handle movement input
    HandleMovementInput() : void {
        # Calculate movement direction
        var Forward : vector3 = Player.GetForwardVector()
        var Right : vector3 = Player.GetRightVector()
        
        # Apply movement input
        var MovementDirection : vector3 = Forward * MovementInput.Y + Right * MovementInput.X
        MovementDirection = Normalize(MovementDirection)
        
        # Update velocity
        ExoMovement.Velocity = MovementDirection * ExoMovement.Config.WallRunSpeed
    }
    
    # Handle special movement
    HandleSpecialMovement() : void {
        # Double jump
        if (IsJumpPressed && ExoMovement.CurrentState == ExoMovementState::Airborne) {
            ExoMovement.DoubleJump()
        }
        
        # Wall run
        if (IsFacingWall() && ExoMovement.CurrentState == ExoMovementState::Airborne) {
            ExoMovement.StartWallRun(GetWallNormal())
        }
        
        # Slide
        if (IsSlidePressed && ExoMovement.CurrentState == ExoMovementState::Grounded) {
            ExoMovement.StartSlide()
        }
        
        # Boost dash
        if (IsBoostPressed && ExoMovement.BoostCooldown <= 0.0) {
            ExoMovement.BoostDash()
        }
        
        # Hover
        if (IsHoverPressed && ExoMovement.CurrentState == ExoMovementState::Airborne) {
            ExoMovement.StartHover()
        }
    }
    
    # Input handlers
    OnJumpPressed() : void {
        IsJumpPressed = true
    }
    
    OnJumpReleased() : void {
        IsJumpPressed = false
    }
    
    OnSlidePressed() : void {
        IsSlidePressed = true
    }
    
    OnSlideReleased() : void {
        IsSlidePressed = false
    }
    
    OnBoostPressed() : void {
        IsBoostPressed = true
    }
    
    OnBoostReleased() : void {
        IsBoostPressed = false
    }
    
    OnHoverPressed() : void {
        IsHoverPressed = true
    }
    
    OnHoverReleased() : void {
        IsHoverPressed = false
    }
    
    OnMovementInput(Input : vector2) : void {
        MovementInput = Input
    }
    
    OnLookInput(Input : vector2) : void {
        LookInput = Input
    }
    
    # Helper functions
    IsFacingWall() : logic {
        # TODO: Implement wall detection
        return false
    }
    
    GetWallNormal() : vector3 {
        # TODO: Implement wall normal calculation
        return vector3{0.0, 0.0, 0.0}
    }
    
    Normalize(Vector : vector3) : vector3 {
        # TODO: Implement vector normalization
        return Vector
    }
} 