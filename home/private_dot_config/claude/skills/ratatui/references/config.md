# Configuration Management

How to handle config files, CLI arguments, and user data in ratatui apps.

## Table of Contents

1. [Setup](#setup)
2. [Config File Location](#config-file-location)
3. [Config File Format](#config-file-format)
4. [CLI Arguments with Clap](#cli-arguments-with-clap)
5. [Three-Layer Merge](#three-layer-merge)
6. [Config Struct Patterns](#config-struct-patterns)
7. [Embedded Defaults](#embedded-defaults)
8. [Validation](#validation)

---

## Setup

Install the latest versions of:
- `serde` (with `derive` feature) — serialization/deserialization
- `toml` — config file parsing (the dominant format in the ratatui ecosystem)
- `clap` (with `derive` feature) — CLI argument parsing
- `directories` — platform-correct config/data/cache paths (recommended by ratatui docs)

---

## Config File Location

Use the `directories` crate to find platform-appropriate paths. It follows XDG on Linux, `~/Library/Application Support` on macOS, and `%APPDATA%` on Windows.

```rust
use directories::ProjectDirs;
use std::path::PathBuf;

fn config_dir() -> PathBuf {
    // Check env var override first
    if let Ok(path) = std::env::var("MYAPP_CONFIG") {
        return PathBuf::from(path);
    }

    ProjectDirs::from("", "", "myapp")
        .map(|dirs| dirs.config_local_dir().to_path_buf())
        .unwrap_or_else(|| PathBuf::from(".").join(".config"))
}

fn data_dir() -> PathBuf {
    ProjectDirs::from("", "", "myapp")
        .map(|dirs| dirs.data_local_dir().to_path_buf())
        .unwrap_or_else(|| PathBuf::from(".").join(".data"))
}
```

### Platform paths for `ProjectDirs::from("", "", "myapp")`

| Platform | Config | Data |
|---|---|---|
| Linux | `~/.config/myapp/` | `~/.local/share/myapp/` |
| macOS | `~/Library/Application Support/myapp/` | `~/Library/Application Support/myapp/` |
| Windows | `%APPDATA%\myapp\config\` | `%APPDATA%\myapp\data\` |

### macOS: always use ~/.config (gitui pattern)

On macOS, `directories` defaults to `~/Library/Application Support/` which is hidden and unfamiliar to CLI users. Always override to `~/.config/` for consistency with Linux — this is what gitui and most terminal-native apps do:

```rust
fn config_dir() -> PathBuf {
    if cfg!(target_os = "macos") {
        dirs::home_dir()
            .map(|h| h.join(".config").join("myapp"))
            .expect("failed to get home dir")
    } else {
        dirs::config_dir()
            .map(|p| p.join("myapp"))
            .expect("failed to get config dir")
    }
}
```

### Always support env var overrides

Every serious app supports overriding paths via environment variables. Trippy supports `TRIP_*` per field, yazi has `YAZI_CONFIG_HOME`:

```rust
fn config_dir() -> PathBuf {
    std::env::var("MYAPP_CONFIG_HOME")
        .map(PathBuf::from)
        .unwrap_or_else(|_| default_config_dir())
}
```

---

## Config File Format

TOML is the standard — 4 out of 5 ratatui apps with config files use it. It's human-readable, well-supported in Rust, and familiar to Rust developers from `Cargo.toml`.

```toml
# myapp.toml
[general]
refresh_rate = 250
mouse_support = true

[theme]
selected_fg = "yellow"
border_color = "blue"

[keybindings]
quit = "q"
scroll_up = "k"
scroll_down = "j"
```

### Loading a TOML config

```rust
use serde::Deserialize;
use std::fs;
use std::path::Path;

#[derive(Debug, Deserialize)]
pub struct ConfigFile {
    pub general: Option<GeneralConfig>,
    pub theme: Option<ThemeConfig>,
    pub keybindings: Option<KeybindingConfig>,
}

pub fn load_config(path: &Path) -> color_eyre::Result<Option<ConfigFile>> {
    if !path.exists() {
        return Ok(None);
    }
    let content = fs::read_to_string(path)?;
    let config: ConfigFile = toml::from_str(&content)?;
    Ok(Some(config))
}
```

---

## CLI Arguments with Clap

Use clap's derive API for CLI argument parsing:

```rust
use clap::Parser;
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "myapp", about = "A terminal UI app")]
pub struct Args {
    /// Path to config file
    #[arg(short, long)]
    pub config: Option<PathBuf>,

    /// Refresh rate in milliseconds
    #[arg(short, long)]
    pub refresh_rate: Option<u64>,

    /// Enable mouse support
    #[arg(long)]
    pub mouse: bool,

    /// Enable logging
    #[arg(short, long)]
    pub log: bool,
}
```

---

## Three-Layer Merge

The gold standard: CLI args override config file, config file overrides defaults. Implement this as a `merge` method on your runtime config struct.

```rust
/// Runtime config — all defaults resolved, no Options.
pub struct AppConfig {
    pub refresh_rate: u64,
    pub mouse_support: bool,
    pub theme: ThemeConfig,
}

impl Default for AppConfig {
    fn default() -> Self {
        Self {
            refresh_rate: 250,
            mouse_support: false,
            theme: ThemeConfig::default(),
        }
    }
}

impl AppConfig {
    /// Build from layers: defaults <- config file <- CLI args
    pub fn build(args: &Args, file: Option<ConfigFile>) -> Self {
        let mut config = Self::default();

        // Layer 2: config file overrides defaults
        if let Some(file) = file {
            if let Some(general) = file.general {
                if let Some(v) = general.refresh_rate { config.refresh_rate = v; }
                if let Some(v) = general.mouse_support { config.mouse_support = v; }
            }
            if let Some(theme) = file.theme {
                config.theme = theme;
            }
        }

        // Layer 3: CLI args override everything
        if let Some(v) = args.refresh_rate { config.refresh_rate = v; }
        if args.mouse { config.mouse_support = true; }

        config
    }
}
```

The pattern is straightforward: start with defaults, overlay config file values if present, then overlay CLI args if present. Each layer only overwrites what it explicitly sets — `Option::None` in the config file and missing CLI flags leave the previous value intact.

---

## Config Struct Patterns

### Config file struct: all fields Optional

Config file fields must be `Option<T>` to distinguish "not specified" from "set to default". This is critical for correct three-layer merging:

```rust
#[derive(Debug, Deserialize)]
pub struct GeneralConfig {
    pub refresh_rate: Option<u64>,
    pub mouse_support: Option<bool>,
    pub tick_rate: Option<u64>,
}
```

### Runtime config struct: no Options

The runtime config (after merging) has concrete types — all defaults resolved:

```rust
pub struct AppConfig {
    pub refresh_rate: u64,    // not Option
    pub mouse_support: bool,  // not Option
    pub tick_rate: u64,       // not Option
}
```

### Nested config sections

Organize config into sections that mirror your TOML structure:

```rust
#[derive(Debug, Deserialize)]
pub struct ConfigFile {
    pub general: Option<GeneralConfig>,
    pub theme: Option<ThemeConfig>,
    pub keybindings: Option<KeybindingConfig>,
    pub database: Option<DatabaseConfig>,
}
```

### Partial config patching (gitui pattern)

GitUI uses `struct_patch` so users only need to specify fields they want to change:

```rust
// User's theme.ron only contains:
// { selected_fg: Yellow }
// All other fields keep their defaults
```

The `struct_patch` crate generates a `ThemePatch` with all-`Option` fields from your `Theme` struct, then applies the patch over defaults.

---

## Embedded Defaults

Prefer embedding default configs in the binary over auto-creating config files. This keeps user directories clean and makes defaults always available.

### include_str! pattern (rainfrog)

```rust
const DEFAULT_CONFIG: &str = include_str!("../config/default.toml");

pub fn load_config(path: &Path) -> color_eyre::Result<AppConfig> {
    let defaults: ConfigFile = toml::from_str(DEFAULT_CONFIG)?;

    if path.exists() {
        let user: ConfigFile = toml::from_str(&fs::read_to_string(path)?)?;
        Ok(merge_configs(defaults, user))
    } else {
        Ok(defaults.into())
    }
}
```

### Preset overlay pattern (yazi)

Yazi embeds preset TOML files and overlays user config on top using a custom `DeserializeOver` derive macro. The user's config only needs to contain the fields they want to change — everything else inherits from the preset.

---

## Validation

### Post-deserialization validation

Serde handles type checking, but business logic constraints need manual validation. Do this after deserialization, before the app starts:

```rust
impl AppConfig {
    pub fn validate(&self) -> color_eyre::Result<()> {
        if self.refresh_rate < 50 {
            color_eyre::eyre::bail!("refresh_rate must be >= 50ms");
        }
        if self.refresh_rate > 5000 {
            color_eyre::eyre::bail!("refresh_rate must be <= 5000ms");
        }
        Ok(())
    }
}

// In main:
let config = AppConfig::build(&args, config_file.as_ref());
config.validate()?;
```

### deny_unknown_fields

Catch typos in config files by rejecting unknown keys:

```rust
#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GeneralConfig {
    pub refresh_rate: Option<u64>,
    pub mouse_support: Option<bool>,
}
```

Trippy uses this in production. Bottom enables it only in test builds to avoid breaking existing users with stricter validation.

### Deprecated field warnings

When renaming or removing config fields, warn users instead of silently ignoring:

```rust
#[derive(Debug, Deserialize)]
pub struct GeneralConfig {
    pub refresh_rate: Option<u64>,

    // Deprecated: use refresh_rate instead
    #[serde(default)]
    pub rate: Option<u64>,
}

impl GeneralConfig {
    pub fn validate_deprecated(&self) {
        if self.rate.is_some() {
            eprintln!("Warning: 'rate' is deprecated, use 'refresh_rate' instead");
        }
    }
}
```

