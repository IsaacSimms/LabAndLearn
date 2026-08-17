# Windows + VS Code C++ Development Environment

CMake + Ninja + a compiler. This is the stack used under `TrainC++/`. Same three commands every project.

---

## The three tools

| Tool | Role |
| --- | --- |
| **CMake** | Build-system *generator*. Reads `CMakeLists.txt`, picks a compiler, writes a recipe. Does **not** compile your code. |
| **Ninja** | Fast task *runner*. Reads `build.ninja` and runs the compile/link **commands**. |
| **clang++** | The LLVM C++ compiler and linker. Only used if you ask for it (or it is first on `PATH`). |
| **cl.exe** | The Visual Studio C++ compiler. What this environment uses by default once the VS Dev Shell is wired into VS Code. |

CMake decides *what* to build and *with what*. Ninja *runs* that recipe. The compiler is a third thing. Mixing them up is how you get a surprise toolchain.

---

## What you must install

### 1. Visual Studio (the C++ build kit)

You need the **C++ workload from Visual Studio proper**, not just VS Code.

- Install **Visual Studio Community** (this box uses **18 / Community**).
- Workload: **Desktop development with C++**.
- That installs `cl.exe`, the Windows SDK, and `Launch-VsDevShell.ps1`.

`cl.exe` lives under the VS install tree. A **Developer PowerShell / Developer Command Prompt** sees it. A normal PowerShell, CMD, or a default VS Code terminal **does not**. If you skip the terminal profile below, CMake either fails to find a compiler or picks whatever else is on `PATH` (often a 32-bit Hostx86 `cl.exe`, or nothing).

### 2. CMake and Ninja (WinGet)

```powershell
winget install Kitware.CMake
winget install Ninja-build.Ninja
```

Close and reopen the terminal after install so `PATH` updates. Confirm:

```powershell
cmake --version
ninja --version
```

### 3. LLVM / Clang (optional)

Only needed if you want `clang++` instead of `cl.exe`.

```powershell
winget install LLVM.LLVM
```

Confirm:

```powershell
clang++ --version
```

Installing LLVM does **not** make CMake use Clang. CMake walks `PATH` and takes the first working C++ compiler. With the VS Dev Shell profile below, that is `cl.exe`. See [Force Clang](#force-clang-instead-of-cl) if you want LLVM.

### 4. VS Code extensions

| Extension | Why |
| --- | --- |
| **C/C++** (`ms-vscode.cpptools`) | IntelliSense, debug, error squiggles |
| **CMake Tools** (`ms-vscode.cmake-tools`) | Optional. Configure/build from the status bar. The CLI below is enough. |

You do **not** need the Visual Studio IDE open to build. You need its **toolchain** on `PATH`.

---

## Make every VS Code terminal a VS Dev Shell

Without this, VS Code's integrated terminal is a normal PowerShell and will not see `cl.exe`.

Edit:

```
C:\Users\primi\AppData\Roaming\Code\User\settings.json
```

Add:

```json
"terminal.integrated.profiles.windows": {
    "x64 Native Tools": {
        "source": "PowerShell",
        "icon": "terminal-powershell",
        "args": [
            "-NoExit",
            "-Command",
            "& 'C:\\Program Files\\Microsoft Visual Studio\\18\\Community\\Common7\\Tools\\Launch-VsDevShell.ps1' -Arch amd64 -HostArch amd64 -SkipAutomaticLocation"
        ]
    }
},
"terminal.integrated.defaultProfile.windows": "x64 Native Tools"
```

| Flag | Meaning |
| --- | --- |
| `-Arch amd64` | Build **64-bit** binaries. |
| `-HostArch amd64` | Use the **64-bit** compiler host. Avoids the `Hostx86\x86` 32-bit accident. |
| `-SkipAutomaticLocation` | Do **not** `cd` into the VS install directory. Stay in the workspace. |

The `18\Community` segment is this machine's VS version and edition. If you install a different year or edition, change the path to match.

**This profile puts you on the VS `cl.exe` compiler.** That is intentional. New terminals in VS Code should show the VS Dev Shell banner and `where.exe cl` should resolve.

After saving `settings.json`, open a **new** terminal (`Ctrl+Shift+\``). Existing terminals keep the old environment.

Confirm:

```powershell
where.exe cl
where.exe cmake
where.exe ninja
```

---

## Project skeleton

Every CMake project here needs **both** files in the same folder:

| File | Role |
| --- | --- |
| `main.cpp` | Source |
| `CMakeLists.txt` | What CMake reads to generate the recipe |

The output `.exe` name comes from `add_executable(...)`, **not** from the folder name.

Example `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.20)   # refuse older CMake
project(HelloWorld LANGUAGES CXX)      # this is a C++ project named HelloWorld
set(CMAKE_CXX_STANDARD 20)             # compile as C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON)    # fail if the compiler cannot do C++20
add_executable(HelloWorld main.cpp)    # target HelloWorld.exe comes from main.cpp
```

`add_executable(HelloWorld ...)` is why the output is named `HelloWorld.exe`. That name is not magic and is not taken from the folder.

---

## Phase 1 — configure (generate the recipe)

From the folder that contains `CMakeLists.txt`:

```powershell
cd C:\LabAndLearn\LabAndLearn\TrainC++\HelloWorld
cmake -G Ninja -B build -S .
```

| Flag | Meaning |
| --- | --- |
| `-G Ninja` | Generate Ninja files, not a Visual Studio `.sln` or Makefiles |
| `-B build` | Put generated files in `build/` |
| `-S .` | Source root is here (the folder that contains `CMakeLists.txt`) |

CMake then:

1. Reads `CMakeLists.txt`
2. Picks a compiler, linker, and `ninja.exe`
3. Writes `build/CMakeCache.txt` (decisions, **frozen**)
4. Writes `build/build.ninja` (the recipe)
5. Does **not** compile `main.cpp`

---

## Phase 2 — build (run the recipe)

```powershell
cmake --build build
```

That is a wrapper. It finds Ninja inside `build/` and runs it. Equivalent:

```powershell
ninja -C build
```

Ninja then does exactly two steps (see `build/.ninja_log`):

1. `main.cpp` → `build/CMakeFiles/HelloWorld.dir/main.cpp.obj`
2. that `.obj` → `build/HelloWorld.exe`

After that:

| You changed | What to re-run |
| --- | --- |
| `main.cpp` (or other source) | Phase 2 only |
| `CMakeLists.txt` (new file, new flag, new target) | Phase 1 again, **or** just phase 2 — Ninja will re-run CMake if the recipe is stale |

---

## How to run the exe

The exe lives next to the recipe, **not** next to `main.cpp`:

```
C:\LabAndLearn\LabAndLearn\TrainC++\HelloWorld\build\HelloWorld.exe
```

From the project root:

```powershell
.\build\HelloWorld.exe
```

From inside `build/`:

```powershell
.\HelloWorld.exe
```

Expected output:

```
Hello, World!
```

Do **not** double-click it in Explorer if you want to see the text. A console program prints and exits; the window closes immediately. Run it from a terminal.

---

## What CMake actually picked (the important surprise)

You can install LLVM and expect `clang++`. CMake will not use it just because it is installed.

CMake's rule on Windows: walk `PATH`, take the **first working C++ compiler**. Visual Studio Build Tools / the Dev Shell make `cl.exe` visible, so it takes `cl.exe`. LLVM binutils may also be visible, so the linker can become `lld-link`. That is a **mixed toolchain**. It is not "an LLVM build."

Typical first-configure result (from `build/CMakeCache.txt` / `CMakeCXXCompiler.cmake`), *before* the x64 Dev Shell profile:

| Role | Tool it used |
| --- | --- |
| C++ compiler | MSVC `cl.exe` (`Hostx86/x86`, 32-bit) |
| Linker | LLVM `lld-link.exe` |
| Archiver / objcopy / etc. | LLVM `llvm-ar`, `llvm-objcopy`, ... |
| Build runner | WinGet `ninja.exe` |
| Build type | Debug |

With the **x64 Native Tools** profile (`-Arch amd64 -HostArch amd64`), you still get `cl.exe`, but the **64-bit** host/target, not `Hostx86\x86`.

Always open `build/CMakeCache.txt` after configure and check `CMAKE_CXX_COMPILER`. Trust the cache, not what you *think* you installed.

---

## Force Clang instead of cl

Say so at configure time. **Delete `build/` first** so the old cache cannot win:

```powershell
Remove-Item -Recurse -Force build
cmake -G Ninja -B build -S . -DCMAKE_CXX_COMPILER=clang++
cmake --build build
```

Then open `build/CMakeCache.txt` and confirm `CMAKE_CXX_COMPILER` ends in `clang++.exe`. If you skip the delete, CMake keeps the old `cl.exe` decision.

---

## Skip CMake entirely (talk to the compiler)

```powershell
clang++ -Wall -Wextra -Werror -std=c++20 main.cpp -o hello.exe
.\hello.exe
```

That is the same program. CMake is optional machinery on top. Use the raw command when you want to see the compiler. Use CMake when the project grows past one file.

Equivalent with MSVC (from a Dev Shell):

```powershell
cl /EHsc /std:c++20 main.cpp /Fe:hello.exe
.\hello.exe
```

---

## The recipe to keep in your head

Same three lines, every CMake + Ninja project, forever:

```powershell
cd <folder-that-contains-CMakeLists.txt>
cmake -G Ninja -B build -S .          # once, or after CMakeLists.txt changes
cmake --build build                   # every time source changes
.\build\<TargetName>.exe              # TargetName == first arg of add_executable()
```

Clean start:

```powershell
Remove-Item -Recurse -Force build
```

---

## Troubleshooting

| Symptom | Cause | Fix |
| --- | --- | --- |
| `cl` / `cmake` / `ninja` not found in VS Code | Terminal is a normal PowerShell, not the Dev Shell | Add the **x64 Native Tools** profile; open a **new** terminal |
| `Hostx86\x86` / 32-bit `cl.exe` in the cache | Dev Shell launched without `-HostArch amd64` | Fix the profile flags; delete `build/` and reconfigure |
| CMake still uses `cl.exe` after installing LLVM | Cache is frozen; `cl` is first on `PATH` | Delete `build/`; pass `-DCMAKE_CXX_COMPILER=clang++` |
| Configure works, link looks like LLVM | Mixed toolchain — CMake picked MSVC compiler + LLVM linker | Expected if both are on `PATH`. Force a full Clang configure if you want a consistent LLVM build |
| Double-clicking the exe flashes a window | Console app exits immediately | Run it from a terminal |
| IntelliSense red squiggles but the build works | C/C++ extension is not using the same compiler as CMake | Point `C_Cpp.default.compilerPath` at the same `cl.exe` or `clang++.exe` CMake used |
| `Launch-VsDevShell.ps1` path not found | Different VS year or edition | Update the path under `Program Files\Microsoft Visual Studio\<version>\<edition>\` |

---

## Mental model

```
CMakeLists.txt + compiler on PATH
        │
        ▼
 cmake -G Ninja -B build -S .     ← Phase 1: write the recipe (no compile)
        │
        ├── build/CMakeCache.txt  (frozen decisions)
        └── build/build.ninja     (the recipe)
                │
                ▼
     cmake --build build          ← Phase 2: Ninja runs compile + link
                │
                ▼
     build/<TargetName>.exe
```
)
