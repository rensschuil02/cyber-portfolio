---
title: 'Unity IL2CPP Game Overlay & Modding Project'
date: '30-01-2026'
tags: ['Game Modding', 'C#', 'C++', 'Unity', 'Reverse Engineering']
layout: '../../layouts/MarkdownLayout.astro'
---

> **EDUCATIONAL USE ONLY** — Local research project analyzing Unity IL2CPP internals. 
> Not intended for production use, competitive gaming, or unauthorized modification of commercial software.


# Unity IL2CPP Game Overlay & Modding Project

**Date:** January 25, 2026  
**Duration:** 1 week  
**Scope:** Client-side overlay and modding toolkit for a Unity IL2CPP-based multiplayer game

---

## Executive Summary

This project documents the development of a client-side game overlay and modding toolkit built with C# and C++ for a Unity IL2CPP-based game. The goal was to better understand game internals, memory structures, and engine behavior by injecting a custom menu, monitoring game state, and experimenting with controlled modifications in a lab environment.

### Key Findings

- **Critical learning areas:** IL2CPP interop, runtime type injection, and Unity object introspection
- **High impact skills:** Custom in-game UI design, debugging complex runtime behavior, safe use of hooks and reflection 
- **Medium focus:** Performance considerations of overlays and ESP-like visuals
- **Low risk (by design):** No distribution of cheats or production use; project scoped to local, educational experimentation

---

## Methodology

The project followed a structured, research-oriented workflow:

1. **Environment Setup:** Configuring a Unity IL2CPP game with a modding framework and required interop libraries.
2. **Runtime Injection:** Loading a custom C# assembly into the game process and registering new MonoBehaviour components.
3. **State Inspection:** Enumerating players, roles, tasks, and match state to understand internal data structures.
4. **Overlay Development:** Building an in-game menu with multiple tabs, sliders, toggles, and visual overlays.
5. **Experimentation & Hardening:** Testing movement, vision, cosmetic and role-visualization features while monitoring stability and performance.

---

## Tools Used

**BepInEx 6 IL2CPP Injection Flow**
```
Unity Game Process
     ↓
[BepInEx.Core] ──► Plugin DLL loaded
     ↓ (Plugin.Load())
[Il2CppInterop.Runtime] ──► ClassInjector.RegisterTypeInIl2Cpp<MenuComponent>()
     ↓
GameObject("OdinMenuObject") ──► AddComponent<MenuComponent>()
     ↓ (Unity lifecycle)
MenuComponent.Awake() → Start() → Update() → OnGUI()
```
**BepInEx Architecture:**

**Plugin Loader:** Hooks Unity's AppDomain.Load() before main game loop
**IL2CPP Bridge:** Translates C# types to native Unity IL2CPP runtime objects
**Lifecycle Manager:** Calls BasePlugin.Load() → MonoBehaviour.Awake() → Update() → OnGUI()
**Harmony Patcher:** Enables method interception and runtime modification

```bash
# .NET / C# development
dotnet build
MSBuild

# Unity IL2CPP modding stack (example)
BepInEx 6 (IL2CPP)
Il2CppInterop.Runtime
UnityEngine.* assemblies

# Analysis & debugging
dnSpy / ILSpy (assembly inspection)
Text-based debug logging to file
In-game debug overlay
```

---

## Findings

### 1. Runtime Menu Injection & Debugging

**Severity:** High (in terms of learning value) 
**Description:** BepInEx calls Plugin.Load() during Unity startup, which registers MenuComponent in the IL2CPP runtime via ClassInjector.RegisterTypeInIl2Cpp<>. This creates a persistent GameObject with DontDestroyOnLoad() that survives scene changes. The OnGUI() method renders a tabbed interface with custom styling (gradients, iOS toggles).

**Evidence:**
```
[BepInPlugin("com.odin.gameoverlay", "Odin Game Overlay", "1.0.0")]
public class Plugin : BasePlugin
{
    internal static ManualLogSource Logger;
    private static GameObject menuObject;

    public override void Load()  // Called by BepInEx at Unity startup
    {
        Logger = Log.LogInfo("Odin Game Overlay loading...");
        
        // CRITICAL: Registers C# class in IL2CPP native runtime
        Il2CppInterop.Runtime.Injection.ClassInjector.RegisterTypeInIl2Cpp<MenuComponent>();
        
        menuObject = new GameObject("OdinMenuObject");
        menuObject.hideFlags = HideFlags.HideAndDontSave;
        menuObject.AddComponent<MenuComponent>();  // Now works due to ClassInjector
        GameObject.DontDestroyOnLoad(menuObject);  // Survives scene changes
    }
}
```

**Recommendation:** ClassInjector is the key enabler for IL2CPP modding. Without it, AddComponent<T>() fails because Unity's native runtime can't find your C# type. This pattern works for QA tools, spectator HUDs, accessibility overlays.

---

### 2. Game State Introspection & Player Visualization

**Severity:** Medium  
**Description:** Update() runs every frame (60 FPS) to monitor game state changes, player enumeration, and feature toggles. Periodic logging (every 300 frames ≈ 5 seconds) captures frame rate, player count, match state. Hotkeys (Insert/F1) toggle the overlay visibility.

**Evidence:**
```
public class MenuComponent : MonoBehaviour
{
    private int frameCounter = 0;
    
    void Update()
    {
        frameCounter++;

        // Health monitoring every ~5 seconds (300 frames @ 60 FPS)
        if (frameCounter % 300 == 0)
        {
            var gameState = /* read current game state */;
            var playerCount = /* read current player list count */;
    
            Plugin.WriteDebugLog($"[HEALTH] Frame: {frameCounter} | Players: {playerCount}");
}


        // Insert/F1 toggles overlay (persists across frames)
        if (Input.GetKeyDown(KeyCode.Insert) || Input.GetKeyDown(KeyCode.F1))
        {
            _visible = !_visible;
            Plugin.Logger.LogInfo($"Overlay: {(_visible ? "VISIBLE" : "HIDDEN")}");
        }
    }
}
```

**Recommendation:** Frame-based state polling is standard for game debugging/telemetry. The Update() → OnGUI() lifecycle mirrors Unity's MonoBehaviour pattern.

---

### 3. Movement, Vision, and Cosmetic Experimentation

**Severity:** Low (controlled test environment)
**Description:** OnGUI() renders tabbed interface controlling experimental features: speed multipliers, physics bypass (Collider.enabled = false), free camera (transform.position), vision range (lightSource.viewDistance). Reflection unlocks cosmetics by setting Reflection unlocks cosmetics by setting cosmeticManager.allItems.Free = true.


**Evidence:**
```
void OnGUI()
{
    if (_visible)
    {
        // Renders draggable tabbed menu (Movement, Visuals, Players)
        _menuRect = GUI.Window(0, _menuRect, DrawMenu, "ODIN OVERLAY", _windowStyle);
    }
}

void DrawMovementTab()
{
    GUILayout.Label($"Speed: {_speedValue:F2}x");
    _speedValue = GUILayout.HorizontalSlider(_speedValue, 0.5f, 20.0f);
    
    _noClip = DrawIOSToggle(_noClip, "No Clip");
    _flyMode = DrawIOSToggle(_flyMode, "Fly Mode");
    
    // Direct transform manipulation (bypasses physics)
    if (_flyMode && player != null)
    {
        Vector3 pos = player.transform.position;
        if (Input.GetKey(KeyCode.Space)) pos.y += _flySpeed * Time.deltaTime;
        player.transform.position = pos;
    }
}
```

**Recommendation:** Frame these as Unity physics/rendering experiments, not cheats. Transform manipulation demonstrates understanding of Unity's coordinate systems and component lifecycle.

---

## Traffic / Behavior Analysis

BepInEx Debug Pipeline:
```
Unity Frame (60 FPS) → Update() → Feature Logic → WriteDebugLog() → OdinMenu_Debug.txt

```
- **Frame Snapshots:** [HEALTH] Frame: 1800 | State: Playing | Players: 10 | FPS: 58
- **Feature State:** [TOGGLE] NoClip: ON | Speed: 5.2x | Fly: OFF
- **Lifecycle Events:** [LIFECYCLE] MenuComponent.Awake() → Start() → Update()
- **Error Recovery:** Null checks prevent crashes from IL2CPP interop failures

---

## Remediation Plan

### Immediate Actions (Portfolio Safety)
- [X] Replace game-specific types (`GameStateManager`, `PlayerList`) with generic comments
- [X] Publish only **anonymized code snippets** — no full source or binaries
- [X] Add **EDUCATIONAL USE ONLY** disclaimer (visible at top of page)

### Short-term Actions (1-2 weeks)
- [ ] Create **"IL2CPP Debug Overlay Template"** GitHub repo (generic Unity demo)
- [ ] Implement **anti-cheat detection signatures** for similar overlays

### Long-term Actions (1-3 months)
- [ ] Build **self-contained Unity demo** showcasing overlay techniques legally
- [ ] Research **runtime detection** of BepInEx injection (for game devs)
- [ ] Develop **C++ native plugin** for advanced memory profiling
- [ ] Prototype **obfuscation countermeasures** against Il2CppDumper/Il2CppInspector

---

## Conclusion

This project achieved its core objectives: **mastery of Unity IL2CPP reverse engineering** through BepInEx runtime injection, `ClassInjector` type registration, persistent `MonoBehaviour` lifecycle management, and custom `OnGUI` overlay development. 

**Risk Rating (Public Portfolio):** **LOW**  
Fully anonymized, educational framing, no game-specific identifiers, no exploitable binaries. Technical content mirrors industry-standard reverse engineering research.

---

## References

- BepInEx 6 Documentation: IL2CPP plugin framework  
- Unity Manual – Scripting, MonoBehaviour, and OnGUI
- Il2CppInterop: C# ↔ Native IL2CPP bridging  
- Il2CppDumper: Unity IL2CPP binary analysis  
- dnSpy: .NET assembly debugging  

---

*Report prepared by: Rens Schuil*  
*Cybersecurity Student @ HvA Amsterdam*
