# ZombieRefactored.verse
# Refactored Zombie entity using Unity-style component-based architecture
# This implementation follows modern game development best practices

using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

# Zombie types enum
enum ZombieType {
    Basic
    Runner
    Brute
    Elemental
    Boss
}

# Zombie states enum
enum ZombieState {
    Idle
    Chasing
    Attacking
    Stunned
    Dead
}

# Elemental types enum
enum ElementalType {
    None
    Fire
    Lightning
    Poison
}

# Zombie configuration structure
struct ZombieConfig {
    var Type : ZombieType
    var Health : int
    var Speed : float
    var Damage : int
    var AttackRange : float
    var DetectionRange : float
    var ElementalType : ElementalType
    var SpecialAbility : string
}

# Zombie-specific health component
class ZombieHealthComponent : HealthComponent {
    var ZombieType : ZombieType
    var ElementalType : ElementalType
    var IsStunned : logic = false
    var StunEndTime : float = 0.0
    
    # Zombie-specific damage events
    var OnZombieDamaged : (int, ZombieType) -> void = (Amount : int, Type : ZombieType) -> void {}
    var OnZombieStunned : (float) -> void = (Duration : float) -> void {}
    var OnZombieDeath : (ZombieType) -> void = (Type : ZombieType) -> void {}
    
    Initialize(ZombieType : ZombieType, MaxHealth : int, ElementalType : ElementalType) : void {
        this.ZombieType = ZombieType
        this.ElementalType = ElementalType
        MaxHealth = MaxHealth
        CurrentHealth = MaxHealth
    }
    
    # Override damage to include zombie-specific logic
    TakeDamage(Amount : int) : void {
        if (IsInvulnerable or CurrentHealth <= 0 or IsStunned) {
            return
        }
        
        CurrentHealth -= Amount
        OnZombieDamaged(Amount, ZombieType)
        
        if (CurrentHealth <= 0) {
            Die()
        }
    }
    
    # Apply stun effect
    ApplyStun(Duration : float) : void {
        IsStunned = true
        StunEndTime = GetGameTime() + Duration
        OnZombieStunned(Duration)
    }
    
    # Override death to include zombie-specific logic
    Die() : void {
        CurrentHealth = 0
        OnZombieDeath(ZombieType)
        
        # Emit death event to game manager
        var GameManager : GameManager = GameManager.GetInstance()
        if (GameManager != GameManager{}) {
            GameManager.EmitEvent(GameEvent::ZombieKilled, Player{}, 0, 10, GameObject.Position)
        }
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Update stun state
        if (IsStunned and GetGameTime() >= StunEndTime) {
            IsStunned = false
        }
        
        # Call parent update
        super.OnUpdate(DeltaTime)
    }
    
    GetGameTime() : float {
        # TODO: Implement game time tracking
        return 0.0
    }
}

# Zombie-specific movement component
class ZombieMovementComponent : MovementComponent {
    var Target : GameObject
    var DetectionRange : float = 10.0
    var AttackRange : float = 2.0
    var PathUpdateInterval : float = 0.5
    var LastPathUpdate : float = 0.0
    
    # Pathfinding properties
    var Path : []vector3 = array{}
    var CurrentPathIndex : int = 0
    
    # Set target
    SetTarget(NewTarget : GameObject) : void {
        Target = NewTarget
    }
    
    # Clear target
    ClearTarget() : void {
        Target = GameObject{}
        Path = array{}
        CurrentPathIndex = 0
    }
    
    # Get distance to target
    GetDistanceToTarget() : float {
        if (Target == GameObject{}) {
            return 999999.0
        }
        
        return (Target.Position - GameObject.Position).Length()
    }
    
    # Move towards target
    MoveTowardsTarget(DeltaTime : float) : void {
        if (Target == GameObject{}) {
            return
        }
        
        var Distance : float = GetDistanceToTarget()
        
        if (Distance > AttackRange) {
            var Direction : vector3 = (Target.Position - GameObject.Position).Normalize()
            Move(Direction)
        } else {
            Stop()
        }
    }
    
    # Update path to target
    UpdatePath() : void {
        if (Target == GameObject{}) {
            return
        }
        
        # Simple direct path for now
        Path = array{Target.Position}
        CurrentPathIndex = 0
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Update path if needed
        if (GetGameTime() - LastPathUpdate >= PathUpdateInterval) {
            UpdatePath()
            LastPathUpdate = GetGameTime()
        }
        
        # Move towards target
        MoveTowardsTarget(DeltaTime)
        
        # Call parent update
        super.OnUpdate(DeltaTime)
    }
    
    GetGameTime() : float {
        # TODO: Implement game time tracking
        return 0.0
    }
}

# Zombie AI component
class ZombieAIComponent : Component {
    var CurrentState : ZombieState = ZombieState::Idle
    var Target : GameObject
    var DetectionRange : float = 10.0
    var AttackRange : float = 2.0
    var AttackCooldown : float = 1.0
    var LastAttackTime : float = 0.0
    
    # Component references
    var HealthComponent : ZombieHealthComponent
    var MovementComponent : ZombieMovementComponent
    
    OnInitialize() : void {
        # Get component references
        HealthComponent = GameObject.GetComponent<ZombieHealthComponent>()
        MovementComponent = GameObject.GetComponent<ZombieMovementComponent>()
    }
    
    # Set target
    SetTarget(NewTarget : GameObject) : void {
        Target = NewTarget
        if (MovementComponent != ZombieMovementComponent{}) {
            MovementComponent.SetTarget(NewTarget)
        }
    }
    
    # Change state
    ChangeState(NewState : ZombieState) : void {
        CurrentState = NewState
    }
    
    # Find nearest player
    FindNearestPlayer() : GameObject {
        var GameManager : GameManager = GameManager.GetInstance()
        if (GameManager == GameManager{}) {
            var Players : []Player = GameManager.GetActivePlayers()
            var NearestPlayer : Player
            var NearestDistance : float = 999999.0
            
            for (Player in Players) {
                var Distance : float = (Player.Position - GameObject.Position).Length()
                if (Distance < NearestDistance) {
                    NearestDistance = Distance
                    NearestPlayer = Player
                }
            }
            
            # Convert Player to GameObject (simplified)
            if (NearestPlayer != Player{}) {
                var PlayerGameObject : GameObject = GameObject{}
                PlayerGameObject.Position = NearestPlayer.Position
                return PlayerGameObject
            }
        }
        
        return GameObject{}
    }
    
    # Get distance to target
    GetDistanceToTarget() : float {
        if (Target == GameObject{}) {
            return 999999.0
        }
        
        return (Target.Position - GameObject.Position).Length()
    }
    
    # Perform attack
    PerformAttack() : void {
        if (GetGameTime() - LastAttackTime >= AttackCooldown) {
            if (Target != GameObject{}) {
                # TODO: Implement attack logic
                LastAttackTime = GetGameTime()
            }
        }
    }
    
    OnUpdate(DeltaTime : float) : void {
        # Don't update if dead or stunned
        if (HealthComponent != ZombieHealthComponent{}) {
            if (!HealthComponent.IsAlive() or HealthComponent.IsStunned) {
                return
            }
        }
        
        # Find target if none
        if (Target == GameObject{}) {
            Target = FindNearestPlayer()
            SetTarget(Target)
        }
        
        # Update state based on conditions
        UpdateState()
        
        # Perform actions based on state
        if (CurrentState == ZombieState::Chasing) {
            # Movement is handled by MovementComponent
        } else if (CurrentState == ZombieState::Attacking) {
            PerformAttack()
        }
    }
    
    # Update AI state
    UpdateState() : void {
        if (Target == GameObject{}) {
            ChangeState(ZombieState::Idle)
            return
        }
        
        var Distance : float = GetDistanceToTarget()
        
        if (Distance <= AttackRange) {
            ChangeState(ZombieState::Attacking)
        } else if (Distance <= DetectionRange) {
            ChangeState(ZombieState::Chasing)
        } else {
            ChangeState(ZombieState::Idle)
        }
    }
    
    GetGameTime() : float {
        # TODO: Implement game time tracking
        return 0.0
    }
}

# Main Zombie class using component-based architecture
class ZombieRefactored : GameObject {
    # Zombie properties
    var Type : ZombieType
    var ElementalType : ElementalType
    var SpecialAbility : string
    
    # Component references
    var HealthComponent : ZombieHealthComponent
    var MovementComponent : ZombieMovementComponent
    var AIComponent : ZombieAIComponent
    
    # Initialize zombie with configuration
    Initialize(Config : ZombieConfig) : void {
        # Initialize base GameObject
        super.Initialize("Zombie_{Config.Type}")
        
        # Set zombie properties
        Type = Config.Type
        ElementalType = Config.ElementalType
        SpecialAbility = Config.SpecialAbility
        
        # Create and add components
        CreateComponents(Config)
        
        Print("ZombieRefactored initialized: {Type}")
    }
    
    # Create and add all components
    CreateComponents(Config : ZombieConfig) : void {
        # Create health component
        HealthComponent = ZombieHealthComponent{}
        HealthComponent.Initialize(Type, Config.Health, ElementalType)
        AddComponent(HealthComponent)
        
        # Create movement component
        MovementComponent = ZombieMovementComponent{}
        MovementComponent.MaxSpeed = Config.Speed
        MovementComponent.DetectionRange = Config.DetectionRange
        MovementComponent.AttackRange = Config.AttackRange
        AddComponent(MovementComponent)
        
        # Create AI component
        AIComponent = ZombieAIComponent{}
        AIComponent.DetectionRange = Config.DetectionRange
        AIComponent.AttackRange = Config.AttackRange
        AddComponent(AIComponent)
    }
    
    # Take damage
    TakeDamage(Amount : int) : void {
        if (HealthComponent != ZombieHealthComponent{}) {
            HealthComponent.TakeDamage(Amount)
        }
    }
    
    # Apply stun
    ApplyStun(Duration : float) : void {
        if (HealthComponent != ZombieHealthComponent{}) {
            HealthComponent.ApplyStun(Duration)
        }
    }
    
    # Set target
    SetTarget(Target : GameObject) : void {
        if (AIComponent != ZombieAIComponent{}) {
            AIComponent.SetTarget(Target)
        }
    }
    
    # Get current state
    GetCurrentState() : ZombieState {
        if (AIComponent != ZombieAIComponent{}) {
            return AIComponent.CurrentState
        }
        return ZombieState::Idle
    }
    
    # Check if alive
    IsAlive() : logic {
        if (HealthComponent != ZombieHealthComponent{}) {
            return HealthComponent.IsAlive()
        }
        return false
    }
    
    # Check if stunned
    IsStunned() : logic {
        if (HealthComponent != ZombieHealthComponent{}) {
            return HealthComponent.IsStunned
        }
        return false
    }
    
    # Get health percentage
    GetHealthPercentage() : float {
        if (HealthComponent != ZombieHealthComponent{}) {
            return HealthComponent.GetHealthPercentage()
        }
        return 0.0
    }
}

# Zombie factory - creates zombies with different configurations
class ZombieFactory : game_simulated_class {
    # Create basic zombie
    static CreateBasicZombie() : ZombieRefactored {
        var Config : ZombieConfig = ZombieConfig{
            Type = ZombieType::Basic,
            Health = 100,
            Speed = 3.0,
            Damage = 25,
            AttackRange = 2.0,
            DetectionRange = 15.0,
            ElementalType = ElementalType::None,
            SpecialAbility = ""
        }
        
        var Zombie : ZombieRefactored = ZombieRefactored{}
        Zombie.Initialize(Config)
        return Zombie
    }
    
    # Create runner zombie
    static CreateRunnerZombie() : ZombieRefactored {
        var Config : ZombieConfig = ZombieConfig{
            Type = ZombieType::Runner,
            Health = 75,
            Speed = 6.0,
            Damage = 15,
            AttackRange = 1.5,
            DetectionRange = 20.0,
            ElementalType = ElementalType::None,
            SpecialAbility = "Fast Movement"
        }
        
        var Zombie : ZombieRefactored = ZombieRefactored{}
        Zombie.Initialize(Config)
        return Zombie
    }
    
    # Create brute zombie
    static CreateBruteZombie() : ZombieRefactored {
        var Config : ZombieConfig = ZombieConfig{
            Type = ZombieType::Brute,
            Health = 200,
            Speed = 2.0,
            Damage = 50,
            AttackRange = 2.5,
            DetectionRange = 12.0,
            ElementalType = ElementalType::None,
            SpecialAbility = "High Health"
        }
        
        var Zombie : ZombieRefactored = ZombieRefactored{}
        Zombie.Initialize(Config)
        return Zombie
    }
    
    # Create elemental zombie
    static CreateElementalZombie(ElementalType : ElementalType) : ZombieRefactored {
        var Config : ZombieConfig = ZombieConfig{
            Type = ZombieType::Elemental,
            Health = 150,
            Speed = 4.0,
            Damage = 30,
            AttackRange = 2.0,
            DetectionRange = 18.0,
            ElementalType = ElementalType,
            SpecialAbility = "Elemental Damage"
        }
        
        var Zombie : ZombieRefactored = ZombieRefactored{}
        Zombie.Initialize(Config)
        return Zombie
    }
    
    # Create boss zombie
    static CreateBossZombie() : ZombieRefactored {
        var Config : ZombieConfig = ZombieConfig{
            Type = ZombieType::Boss,
            Health = 500,
            Speed = 3.5,
            Damage = 75,
            AttackRange = 3.0,
            DetectionRange = 25.0,
            ElementalType = ElementalType::None,
            SpecialAbility = "Boss Abilities"
        }
        
        var Zombie : ZombieRefactored = ZombieRefactored{}
        Zombie.Initialize(Config)
        return Zombie
    }
    
    # Create zombie by type
    static CreateZombieByType(ZombieType : ZombieType) : ZombieRefactored {
        if (ZombieType == ZombieType::Basic) {
            return CreateBasicZombie()
        } else if (ZombieType == ZombieType::Runner) {
            return CreateRunnerZombie()
        } else if (ZombieType == ZombieType::Brute) {
            return CreateBruteZombie()
        } else if (ZombieType == ZombieType::Elemental) {
            return CreateElementalZombie(ElementalType::Fire)
        } else if (ZombieType == ZombieType::Boss) {
            return CreateBossZombie()
        }
        
        return CreateBasicZombie()
    }
} 