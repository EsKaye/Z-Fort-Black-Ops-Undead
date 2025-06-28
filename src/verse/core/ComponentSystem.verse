# ComponentSystem.verse
# Unity-style component-based architecture for Z-Fort: Black Ops Undead
# This system provides modular, reusable components that can be attached to game objects

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Base component interface - similar to Unity's MonoBehaviour
class Component : game_simulated_class {
    var GameObject : GameObject
    var IsEnabled : logic = true
    var IsInitialized : logic = false
    
    # Initialize component
    Initialize(GameObj : GameObject) : void {
        GameObject = GameObj
        IsInitialized = true
        OnInitialize()
    }
    
    # Called when component is initialized
    OnInitialize() : void {
        # Override in derived classes
    }
    
    # Update component
    Update(DeltaTime : float) : void {
        if (IsEnabled and IsInitialized) {
            OnUpdate(DeltaTime)
        }
    }
    
    # Called every frame
    OnUpdate(DeltaTime : float) : void {
        # Override in derived classes
    }
    
    # Enable/disable component
    SetEnabled(Enabled : logic) : void {
        IsEnabled = Enabled
        if (Enabled) {
            OnEnable()
        } else {
            OnDisable()
        }
    }
    
    # Called when component is enabled
    OnEnable() : void {
        # Override in derived classes
    }
    
    # Called when component is disabled
    OnDisable() : void {
        # Override in derived classes
    }
    
    # Destroy component
    Destroy() : void {
        OnDestroy()
        IsEnabled = false
        IsInitialized = false
    }
    
    # Called when component is destroyed
    OnDestroy() : void {
        # Override in derived classes
    }
}

# GameObject class - container for components
class GameObject : game_simulated_class {
    var Name : string = ""
    var Position : vector3 = vector3{0.0, 0.0, 0.0}
    var Rotation : rotation = rotation{0.0}
    var Scale : vector3 = vector3{1.0, 1.0, 1.0}
    var IsActive : logic = true
    
    # Component management
    var Components : []Component = array{}
    var Transform : TransformComponent
    
    # Initialize game object
    Initialize(ObjectName : string) : void {
        Name = ObjectName
        Transform = TransformComponent{}
        AddComponent(Transform)
        Print("GameObject initialized: {Name}")
    }
    
    # Add component
    AddComponent<T : Component>(ComponentType : T) : T {
        ComponentType.Initialize(this)
        Components.Add(ComponentType)
        return ComponentType
    }
    
    # Get component by type
    GetComponent<T : Component>() : T {
        for (Component in Components) {
            if (Component is T) {
                return Component as T
            }
        }
        return T{}
    }
    
    # Remove component
    RemoveComponent(Component : Component) : void {
        Component.Destroy()
        Components.Remove(Component)
    }
    
    # Update all components
    Update(DeltaTime : float) : void {
        if (!IsActive) {
            return
        }
        
        for (Component in Components) {
            Component.Update(DeltaTime)
        }
    }
    
    # Set position
    SetPosition(NewPosition : vector3) : void {
        Position = NewPosition
        if (Transform != TransformComponent{}) {
            Transform.SetPosition(NewPosition)
        }
    }
    
    # Set rotation
    SetRotation(NewRotation : rotation) : void {
        Rotation = NewRotation
        if (Transform != TransformComponent{}) {
            Transform.SetRotation(NewRotation)
        }
    }
    
    # Set scale
    SetScale(NewScale : vector3) : void {
        Scale = NewScale
        if (Transform != TransformComponent{}) {
            Transform.SetScale(NewScale)
        }
    }
    
    # Destroy game object
    Destroy() : void {
        for (Component in Components) {
            Component.Destroy()
        }
        Components = array{}
        IsActive = false
    }
}

# Transform component - handles position, rotation, and scale
class TransformComponent : Component {
    var Position : vector3 = vector3{0.0, 0.0, 0.0}
    var Rotation : rotation = rotation{0.0}
    var Scale : vector3 = vector3{1.0, 1.0, 1.0}
    
    # Local and world transforms
    var LocalPosition : vector3 = vector3{0.0, 0.0, 0.0}
    var LocalRotation : rotation = rotation{0.0}
    var LocalScale : vector3 = vector3{1.0, 1.0, 1.0}
    
    # Parent-child relationships
    var Parent : TransformComponent
    var Children : []TransformComponent = array{}
    
    OnInitialize() : void {
        Position = LocalPosition
        Rotation = LocalRotation
        Scale = LocalScale
    }
    
    # Set position
    SetPosition(NewPosition : vector3) : void {
        Position = NewPosition
        LocalPosition = NewPosition
        UpdateChildren()
    }
    
    # Set rotation
    SetRotation(NewRotation : rotation) : void {
        Rotation = NewRotation
        LocalRotation = NewRotation
        UpdateChildren()
    }
    
    # Set scale
    SetScale(NewScale : vector3) : void {
        Scale = NewScale
        LocalScale = NewScale
        UpdateChildren()
    }
    
    # Translate (move relative to current position)
    Translate(Translation : vector3) : void {
        SetPosition(Position + Translation)
    }
    
    # Rotate (rotate relative to current rotation)
    Rotate(RotationDelta : rotation) : void {
        SetRotation(Rotation + RotationDelta)
    }
    
    # Look at target
    LookAt(Target : vector3) : void {
        var Direction : vector3 = (Target - Position).Normalize()
        var LookRotation : rotation = rotation{0.0} # TODO: Convert direction to rotation
        SetRotation(LookRotation)
    }
    
    # Get forward direction
    GetForward() : vector3 {
        # TODO: Convert rotation to forward vector
        return vector3{0.0, 0.0, 1.0}
    }
    
    # Get right direction
    GetRight() : vector3 {
        # TODO: Convert rotation to right vector
        return vector3{1.0, 0.0, 0.0}
    }
    
    # Get up direction
    GetUp() : vector3 {
        # TODO: Convert rotation to up vector
        return vector3{0.0, 1.0, 0.0}
    }
    
    # Set parent
    SetParent(NewParent : TransformComponent) : void {
        if (Parent != TransformComponent{}) {
            Parent.Children.Remove(this)
        }
        
        Parent = NewParent
        if (Parent != TransformComponent{}) {
            Parent.Children.Add(this)
        }
    }
    
    # Update children transforms
    UpdateChildren() : void {
        for (Child in Children) {
            # TODO: Update child transforms based on parent
        }
    }
    
    # Get distance to another transform
    GetDistanceTo(Other : TransformComponent) : float {
        return (Other.Position - Position).Length()
    }
}

# Health component - handles health and damage
class HealthComponent : Component {
    var CurrentHealth : int = 100
    var MaxHealth : int = 100
    var IsInvulnerable : logic = false
    var InvulnerabilityTime : float = 0.0
    
    # Health events
    var OnHealthChanged : (int, int) -> void = (Current : int, Max : int) -> void {}
    var OnDeath : () -> void = () -> void {}
    var OnDamage : (int) -> void = (Amount : int) -> void {}
    
    OnInitialize() : void {
        CurrentHealth = MaxHealth
    }
    
    # Take damage
    TakeDamage(Amount : int) : void {
        if (IsInvulnerable or CurrentHealth <= 0) {
            return
        }
        
        CurrentHealth -= Amount
        OnDamage(Amount)
        OnHealthChanged(CurrentHealth, MaxHealth)
        
        if (CurrentHealth <= 0) {
            Die()
        }
    }
    
    # Heal
    Heal(Amount : int) : void {
        if (CurrentHealth <= 0) {
            return
        }
        
        CurrentHealth = Min(CurrentHealth + Amount, MaxHealth)
        OnHealthChanged(CurrentHealth, MaxHealth)
    }
    
    # Set invulnerable
    SetInvulnerable(Duration : float) : void {
        IsInvulnerable = true
        InvulnerabilityTime = GetGameTime() + Duration
    }
    
    # Die
    Die() : void {
        CurrentHealth = 0
        OnDeath()
    }
    
    # Revive
    Revive(HealthAmount : int) : void {
        CurrentHealth = HealthAmount
        OnHealthChanged(CurrentHealth, MaxHealth)
    }
    
    # Get health percentage
    GetHealthPercentage() : float {
        return Float(CurrentHealth) / Float(MaxHealth)
    }
    
    # Check if alive
    IsAlive() : logic {
        return CurrentHealth > 0
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Update invulnerability
        if (IsInvulnerable and GetGameTime() >= InvulnerabilityTime) {
            IsInvulnerable = false
        }
    }
    
    # Get current game time
    GetGameTime() : float {
        # TODO: Implement game time tracking
        return 0.0
    }
}

# Movement component - handles movement and physics
class MovementComponent : Component {
    var Velocity : vector3 = vector3{0.0, 0.0, 0.0}
    var Acceleration : vector3 = vector3{0.0, 0.0, 0.0}
    var MaxSpeed : float = 10.0
    var AccelerationRate : float = 20.0
    var DecelerationRate : float = 15.0
    
    # Ground detection
    var IsGrounded : logic = true
    var GroundNormal : vector3 = vector3{0.0, 1.0, 0.0}
    
    # Jump properties
    var CanJump : logic = true
    var JumpForce : float = 10.0
    var Gravity : float = -20.0
    
    OnInitialize() : void {
        # Initialize movement properties
    }
    
    # Move in direction
    Move(Direction : vector3) : void {
        var TargetVelocity : vector3 = Direction * MaxSpeed
        var VelocityDifference : vector3 = TargetVelocity - Velocity
        
        if (VelocityDifference.Length() > 0.1) {
            Acceleration = VelocityDifference.Normalize() * AccelerationRate
        } else {
            Acceleration = vector3{0.0, 0.0, 0.0}
        }
    }
    
    # Stop movement
    Stop() : void {
        Velocity = vector3{0.0, 0.0, 0.0}
        Acceleration = vector3{0.0, 0.0, 0.0}
    }
    
    # Jump
    Jump() : void {
        if (CanJump and IsGrounded) {
            Velocity.Y = JumpForce
            IsGrounded = false
        }
    }
    
    # Apply force
    ApplyForce(Force : vector3) : void {
        Acceleration += Force
    }
    
    # Set velocity
    SetVelocity(NewVelocity : vector3) : void {
        Velocity = NewVelocity
    }
    
    # Get velocity
    GetVelocity() : vector3 {
        return Velocity
    }
    
    # Get speed
    GetSpeed() : float {
        return Velocity.Length()
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Apply acceleration
        Velocity += Acceleration * DeltaTime
        
        # Apply gravity
        if (!IsGrounded) {
            Velocity.Y += Gravity * DeltaTime
        }
        
        # Clamp velocity to max speed
        if (Velocity.Length() > MaxSpeed) {
            Velocity = Velocity.Normalize() * MaxSpeed
        }
        
        # Apply deceleration when no input
        if (Acceleration.Length() < 0.1) {
            var Deceleration : vector3 = -Velocity.Normalize() * DecelerationRate * DeltaTime
            if (Deceleration.Length() > Velocity.Length()) {
                Velocity = vector3{0.0, 0.0, 0.0}
            } else {
                Velocity += Deceleration
            }
        }
        
        # Update transform position
        if (GameObject != GameObject{}) {
            var Transform : TransformComponent = GameObject.GetComponent<TransformComponent>()
            if (Transform != TransformComponent{}) {
                Transform.Translate(Velocity * DeltaTime)
            }
        }
        
        # Reset acceleration
        Acceleration = vector3{0.0, 0.0, 0.0}
    }
}

# AI component - handles AI behavior
class AIComponent : Component {
    var CurrentState : string = "Idle"
    var Target : GameObject
    var DetectionRange : float = 10.0
    var AttackRange : float = 2.0
    var MoveSpeed : float = 5.0
    
    # AI states
    var States : []AIState = array{}
    var CurrentStateIndex : int = 0
    
    # Pathfinding
    var Path : []vector3 = array{}
    var CurrentPathIndex : int = 0
    var PathUpdateInterval : float = 0.5
    var LastPathUpdate : float = 0.0
    
    OnInitialize() : void {
        # Initialize AI states
        InitializeStates()
    }
    
    # Initialize AI states
    InitializeStates() : void {
        States = array{
            AIState{Name = "Idle", UpdateFunction = IdleUpdate},
            AIState{Name = "Chase", UpdateFunction = ChaseUpdate},
            AIState{Name = "Attack", UpdateFunction = AttackUpdate},
            AIState{Name = "Patrol", UpdateFunction = PatrolUpdate}
        }
    }
    
    # Change AI state
    ChangeState(StateName : string) : void {
        for (i, State in States) {
            if (State.Name == StateName) {
                CurrentStateIndex = i
                CurrentState = StateName
                State.OnEnter()
                break
            }
        }
    }
    
    # Update AI
    OnUpdate(DeltaTime : float) : void {
        if (States.Length > 0 and CurrentStateIndex < States.Length) {
            States[CurrentStateIndex].UpdateFunction(DeltaTime)
        }
    }
    
    # Idle state update
    IdleUpdate(DeltaTime : float) : void {
        # Look for targets
        var NearestTarget : GameObject = FindNearestTarget()
        if (NearestTarget != GameObject{}) {
            Target = NearestTarget
            ChangeState("Chase")
        }
    }
    
    # Chase state update
    ChaseUpdate(DeltaTime : float) : void {
        if (Target == GameObject{}) {
            ChangeState("Idle")
            return
        }
        
        var Distance : float = GetDistanceToTarget()
        
        if (Distance <= AttackRange) {
            ChangeState("Attack")
        } else if (Distance <= DetectionRange) {
            MoveTowardsTarget(DeltaTime)
        } else {
            Target = GameObject{}
            ChangeState("Idle")
        }
    }
    
    # Attack state update
    AttackUpdate(DeltaTime : float) : void {
        if (Target == GameObject{}) {
            ChangeState("Idle")
            return
        }
        
        var Distance : float = GetDistanceToTarget()
        
        if (Distance > AttackRange) {
            ChangeState("Chase")
        } else {
            PerformAttack()
        }
    }
    
    # Patrol state update
    PatrolUpdate(DeltaTime : float) : void {
        # TODO: Implement patrol behavior
    }
    
    # Find nearest target
    FindNearestTarget() : GameObject {
        # TODO: Implement target finding logic
        return GameObject{}
    }
    
    # Get distance to target
    GetDistanceToTarget() : float {
        if (Target == GameObject{}) {
            return 999999.0
        }
        
        var Transform : TransformComponent = GameObject.GetComponent<TransformComponent>()
        var TargetTransform : TransformComponent = Target.GetComponent<TransformComponent>()
        
        if (Transform != TransformComponent{} and TargetTransform != TransformComponent{}) {
            return Transform.GetDistanceTo(TargetTransform)
        }
        
        return 999999.0
    }
    
    # Move towards target
    MoveTowardsTarget(DeltaTime : float) : void {
        if (Target == GameObject{}) {
            return
        }
        
        var Transform : TransformComponent = GameObject.GetComponent<TransformComponent>()
        var TargetTransform : TransformComponent = Target.GetComponent<TransformComponent>()
        var Movement : MovementComponent = GameObject.GetComponent<MovementComponent>()
        
        if (Transform != TransformComponent{} and TargetTransform != TransformComponent{} and Movement != MovementComponent{}) {
            var Direction : vector3 = (TargetTransform.Position - Transform.Position).Normalize()
            Movement.Move(Direction)
        }
    }
    
    # Perform attack
    PerformAttack() : void {
        # TODO: Implement attack logic
    }
}

# AI state structure
struct AIState {
    var Name : string
    var UpdateFunction : (float) -> void
    var OnEnter : () -> void = () -> void {}
    var OnExit : () -> void = () -> void {}
}

# Weapon component - handles weapon behavior
class WeaponComponent : Component {
    var WeaponType : string = ""
    var Damage : int = 10
    var FireRate : float = 1.0
    var Range : float = 100.0
    var AmmoCapacity : int = 30
    var CurrentAmmo : int = 30
    var ReloadTime : float = 2.0
    
    # Firing properties
    var LastFireTime : float = 0.0
    var IsReloading : logic = false
    var ReloadStartTime : float = 0.0
    
    # Weapon events
    var OnFire : () -> void = () -> void {}
    var OnReload : () -> void = () -> void {}
    var OnAmmoChanged : (int, int) -> void = (Current : int, Max : int) -> void {}
    
    OnInitialize() : void {
        CurrentAmmo = AmmoCapacity
    }
    
    # Fire weapon
    Fire() : void {
        if (CanFire()) {
            CurrentAmmo -= 1
            LastFireTime = GetGameTime()
            OnFire()
            OnAmmoChanged(CurrentAmmo, AmmoCapacity)
        }
    }
    
    # Check if can fire
    CanFire() : logic {
        return CurrentAmmo > 0 and !IsReloading and (GetGameTime() - LastFireTime) >= (1.0 / FireRate)
    }
    
    # Reload weapon
    Reload() : void {
        if (!IsReloading and CurrentAmmo < AmmoCapacity) {
            IsReloading = true
            ReloadStartTime = GetGameTime()
            OnReload()
        }
    }
    
    # Add ammo
    AddAmmo(Amount : int) : void {
        CurrentAmmo = Min(CurrentAmmo + Amount, AmmoCapacity)
        OnAmmoChanged(CurrentAmmo, AmmoCapacity)
    }
    
    # Get ammo percentage
    GetAmmoPercentage() : float {
        return Float(CurrentAmmo) / Float(AmmoCapacity)
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Update reload
        if (IsReloading and (GetGameTime() - ReloadStartTime) >= ReloadTime) {
            IsReloading = false
            CurrentAmmo = AmmoCapacity
            OnAmmoChanged(CurrentAmmo, AmmoCapacity)
        }
    }
    
    # Get current game time
    GetGameTime() : float {
        # TODO: Implement game time tracking
        return 0.0
    }
}

# Component factory - creates and manages components
class ComponentFactory : game_simulated_class {
    # Create health component
    static CreateHealthComponent(MaxHealth : int) : HealthComponent {
        var Health : HealthComponent = HealthComponent{}
        Health.MaxHealth = MaxHealth
        return Health
    }
    
    # Create movement component
    static CreateMovementComponent(MaxSpeed : float) : MovementComponent {
        var Movement : MovementComponent = MovementComponent{}
        Movement.MaxSpeed = MaxSpeed
        return Movement
    }
    
    # Create AI component
    static CreateAIComponent(DetectionRange : float, AttackRange : float) : AIComponent {
        var AI : AIComponent = AIComponent{}
        AI.DetectionRange = DetectionRange
        AI.AttackRange = AttackRange
        return AI
    }
    
    # Create weapon component
    static CreateWeaponComponent(WeaponType : string, Damage : int, FireRate : float) : WeaponComponent {
        var Weapon : WeaponComponent = WeaponComponent{}
        Weapon.WeaponType = WeaponType
        Weapon.Damage = Damage
        Weapon.FireRate = FireRate
        return Weapon
    }
} 