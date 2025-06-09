# ExoMovementConfig.verse
# Default configuration for Exo movement system

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }

# Default Exo movement configuration
var DefaultExoConfig : ExoMovementConfig = ExoMovementConfig{
    DoubleJumpForce = 500.0,
    WallRunDuration = 2.0,
    WallRunSpeed = 800.0,
    SlideSpeed = 1000.0,
    SlideDuration = 1.0,
    BoostDashForce = 1500.0,
    BoostDashCooldown = 3.0,
    HoverDuration = 2.0,
    HoverHeight = 100.0,
    MaxAirJumps = 2
}

# Advanced Exo movement configuration (unlocked through progression)
var AdvancedExoConfig : ExoMovementConfig = ExoMovementConfig{
    DoubleJumpForce = 600.0,
    WallRunDuration = 3.0,
    WallRunSpeed = 1000.0,
    SlideSpeed = 1200.0,
    SlideDuration = 1.5,
    BoostDashForce = 2000.0,
    BoostDashCooldown = 2.0,
    HoverDuration = 3.0,
    HoverHeight = 150.0,
    MaxAirJumps = 3
}

# Boss Exo movement configuration (for special events)
var BossExoConfig : ExoMovementConfig = ExoMovementConfig{
    DoubleJumpForce = 800.0,
    WallRunDuration = 4.0,
    WallRunSpeed = 1200.0,
    SlideSpeed = 1500.0,
    SlideDuration = 2.0,
    BoostDashForce = 2500.0,
    BoostDashCooldown = 1.5,
    HoverDuration = 4.0,
    HoverHeight = 200.0,
    MaxAirJumps = 4
} 