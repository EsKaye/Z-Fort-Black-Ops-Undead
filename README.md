# 🧟‍♂️ Z-Fort: Black Ops Undead

> _"Where reality bends, bullets fly, and souls get eaten."_

## 🎯 Project Overview

Z-Fort: Black Ops Undead is an innovative fusion of Call of Duty Zombies' round-based survival horror with Fortnite's creative sandbox, built using UEFN (Unreal Editor for Fortnite) and Verse scripting. The project has been completely refactored using Unity best practices and modern game development patterns.

### 🌟 Key Features

* **Wave-Based Survival**: Progressive difficulty with increasing zombie counts and intensity
* **Co-op Gameplay**: 1-4 player cooperative survival
* **Component-Based Architecture**: Unity-style modular system design
* **Event-Driven Systems**: Loose coupling between game systems
* **Advanced AI**: Intelligent zombie behavior with pathfinding
* **Weapon System**: Comprehensive weapon management with ammo and upgrades
* **Performance Optimized**: Efficient update loops and memory management

### 🏗️ Architecture Highlights

* **Singleton Pattern**: Global managers for game state and spawning
* **Component System**: Modular, reusable components for entity behavior
* **Factory Pattern**: Flexible entity creation with configuration
* **State Machine**: Robust state management for game and entities
* **Event System**: Decoupled communication between systems

## 🚀 Recent Major Refactoring (December 2024)

### ✅ Completed Refactoring

1. **GameManager System** 🔄
   - Implemented Unity-style singleton pattern
   - Added comprehensive event-driven architecture
   - Enhanced state management with proper transitions
   - Added performance tracking and real-time updates
   - Improved player management system

2. **Component-Based Architecture** 🧩
   - Created comprehensive ComponentSystem.verse
   - Implemented Unity-style GameObject and Component classes
   - Added HealthComponent, MovementComponent, WeaponComponent
   - Created ComponentFactory for easy component creation
   - Established proper component lifecycle management

3. **Zombie Entity System** 🧟‍♂️
   - Refactored using component architecture (ZombieRefactored.verse)
   - Implemented ZombieHealthComponent with stun mechanics
   - Added ZombieMovementComponent with pathfinding
   - Created ZombieAIComponent for intelligent behavior
   - Implemented ZombieFactory for easy zombie creation
   - Support for multiple zombie types (Basic, Runner, Brute, Elemental, Boss)

4. **Spawner System** 🎯
   - Refactored spawner using component architecture (ZombieSpawnerRefactored.verse)
   - Implemented weighted spawn system
   - Added spawn point management
   - Created SpawnerManager for multiple spawner coordination
   - Added performance tracking and statistics

### 🔄 In Progress

1. **Weapon System Refactoring** 🔫
   - Converting weapon entities to component architecture
   - Implementing weapon switching and inventory
   - Adding ammo management and weapon factories

2. **UI System Development** 🖥️
   - Creating component-based UI system
   - Implementing HUD components
   - Adding menu system with state management

3. **Performance Optimization** ⚡
   - Implementing object pooling
   - Adding performance monitoring
   - Optimizing update loops

## 🏗️ Project Structure

```
Z-Fort-Black-Ops-Undead/
├── @docs/                    # Project documentation
│   ├── ARCHITECTURE.md      # System design documentation
│   ├── GDD.md              # Game design document
│   └── ROADMAP.md          # Development roadmap
├── @.cursor/                # AI assistant files
│   ├── memories.md         # Session tracking and progress
│   ├── lessons-learned.md  # Best practices and insights
│   └── scratchpad.md       # Current work and ideas
├── src/                     # Source code
│   └── verse/              # Verse scripts
│       ├── core/           # Core systems
│       │   ├── GameManager.verse           # Main game manager (refactored)
│       │   ├── ComponentSystem.verse       # Component architecture
│       │   ├── PointsSystem.verse          # Economy system
│       │   └── WaveSystem.verse            # Wave management
│       ├── entities/       # Game entities
│       │   ├── ZombieRefactored.verse      # Refactored zombie system
│       │   ├── Zombie.verse                # Legacy zombie system
│       │   ├── Weapon.verse                # Weapon base class
│       │   ├── RayGun.verse                # Ray Gun weapon
│       │   ├── Thundergun.verse            # Thundergun weapon
│       │   └── ...                         # Other weapon types
│       ├── systems/        # Game systems
│       │   ├── ZombieSpawnerRefactored.verse # Refactored spawner
│       │   ├── ZombieSpawner.verse         # Legacy spawner
│       │   ├── ZombieAI.verse              # AI behavior
│       │   ├── WeaponManager.verse         # Weapon management
│       │   └── ExoMovement.verse           # Movement system
│       └── config/         # Configuration files
│           └── ExoMovementConfig.verse     # Movement configuration
├── tests/                   # Test files
├── README.md               # This file
├── .gitignore             # Git ignore rules
└── CHANGELOG.md           # Version history
```

## 🎮 Gameplay Systems

### Core Systems (Refactored)

* **GameManager**: Central game state management with event system
* **ComponentSystem**: Unity-style component-based architecture
* **ZombieRefactored**: Modular zombie system with AI and behavior
* **ZombieSpawnerRefactored**: Advanced spawning with weighted types
* **PointsSystem**: Economy and progression management
* **WaveSystem**: Wave-based difficulty progression

### Game Modes

* **Classic Survival**: 1-4 player co-op (refactored)
* **PvPvE**: Optional competitive mode (planned)
* **Boss Rush**: Special challenge mode (planned)

### Zombie Types

* **Basic**: Standard zombie with balanced stats
* **Runner**: Fast but weak zombie
* **Brute**: Slow but strong zombie
* **Elemental**: Zombie with special elemental abilities
* **Boss**: Powerful zombie with unique abilities

## 🚀 Getting Started

### Prerequisites

* Unreal Editor for Fortnite (UEFN)
* Fortnite Creative 2.0
* Basic understanding of Verse programming

### Installation

1. Clone this repository
2. Open the project in UEFN
3. Follow the setup instructions in `@docs/setup.md`

### Development Setup

1. **Initialize Systems**: The GameManager and SpawnerManager use singleton patterns
2. **Component Architecture**: All new entities should use the component system
3. **Event System**: Use events for communication between systems
4. **Performance**: Monitor performance with the built-in tracking systems

## 📝 Documentation

### Architecture Documentation
* **ARCHITECTURE.md**: Comprehensive system design and patterns
* **Component System**: Unity-style component architecture guide
* **Event System**: Event-driven communication patterns
* **Performance Guide**: Optimization and best practices

### Development Documentation
* **Game Design Document**: Detailed game mechanics and features
* **API Reference**: Verse API documentation
* **Asset Guidelines**: Asset creation and management
* **Testing Guide**: Unit testing and integration testing

### AI Assistant Documentation
* **@.cursor/memories.md**: Session tracking and progress history
* **@.cursor/lessons-learned.md**: Best practices and insights
* **@.cursor/scratchpad.md**: Current work and immediate tasks

## 🔧 Technical Specifications

### Performance Targets
* **Target FPS**: 60 FPS
* **Max Entities**: 100 zombies + 4 players
* **Memory Usage**: < 512MB
* **Load Times**: < 5 seconds

### Architecture Patterns
* **Singleton Pattern**: Global managers
* **Component Pattern**: Entity behavior
* **Factory Pattern**: Entity creation
* **Observer Pattern**: Event system
* **State Machine**: Game and entity states

### Code Quality Standards
* Unity-style naming conventions
* Comprehensive inline documentation
* Component-based architecture
* Event-driven communication
* Performance considerations

## 🤝 Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

### Development Guidelines
1. Follow the component-based architecture
2. Use the event system for communication
3. Implement proper error handling
4. Add comprehensive documentation
5. Consider performance implications
6. Test thoroughly before submitting

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

* Inspired by Call of Duty Zombies
* Built with Fortnite Creative 2.0
* Powered by UEFN and Verse
* Refactored using Unity best practices

## 📊 Project Status

### ✅ Completed (Refactored)
- [x] GameManager system
- [x] Component architecture
- [x] Zombie entity system
- [x] Spawner system
- [x] Event system
- [x] State management

### 🔄 In Progress
- [ ] Weapon system refactoring
- [ ] UI system development
- [ ] Performance optimization

### 📋 Planned
- [ ] Sound system
- [ ] Visual effects
- [ ] Save/load system
- [ ] Multiplayer sync
- [ ] Achievement system

---

_"You must turn on the power first..."_ 😈

**Last Updated:** December 2024
**Version:** 2.0.0 (Major Refactor)
**Status:** Active Development 