# Unity Package Template

A scaffold for reusable Unity (UPM) packages that are shared as Git repositories.

[English](#english) · [Türkçe](#türkçe)

---

<a name="english"></a>
# English

## Create a package

In PowerShell, from this folder:

```powershell
.\new-package.ps1 -Name VehiclePhysics -DisplayName "Vehicle Physics" -Description "Raycast car physics."
```

This creates `..\VehiclePhysics\` with:

| Path | Contents |
|---|---|
| `package.json` | `com.atthree.vehicle-physics`, version `0.1.0` |
| `Runtime/` | Game code + `Atthree.VehiclePhysics.asmdef` |
| `Editor/` | Editor-only tools + `Atthree.VehiclePhysics.Editor.asmdef` |
| `Tests/Runtime/` | PlayMode tests + an example test |
| `Documentation~/` | Images and docs (Unity ignores folders ending in `~`) |
| `README.md`, `CHANGELOG.md`, `LICENSE.md` (MIT) | English + Turkish README skeleton |

It also runs `git init` and makes the first commit. Add `-GitHub` to create a public repository and
push it (requires the [GitHub CLI](https://cli.github.com), `gh auth login`).

Options: `-Author` (default `Atthree`), `-Namespace`, `-PackageId`, `-Unity` (default `6000.0`),
`-OutDir`.

## Development loop

1. Reference the package from a game project while you work on it, in `Packages/manifest.json`:

   ```json
   "com.atthree.vehicle-physics": "file:../../VehiclePhysics",
   ```

   Edits show up in Unity right away. Unity creates `.meta` files in the package; commit them.
2. To run the package's tests, add to the same file:

   ```json
   "testables": [ "com.atthree.vehicle-physics" ]
   ```

   Then **Window > General > Test Runner > PlayMode**.
3. To release: raise `version` in `package.json`, write `CHANGELOG.md`, commit, then

   ```
   git tag v0.2.0
   git push origin main --tags
   ```

4. In other games install it with
   `https://github.com/Atthree/VehiclePhysics.git#v0.2.0`.

Versioning ([SemVer](https://semver.org)): bug fix → `0.2.1`, new feature → `0.3.0`, breaking change → `1.0.0`.

---

<a name="türkçe"></a>
# Türkçe

## Paket oluşturmak

PowerShell'de, bu klasörde:

```powershell
.\new-package.ps1 -Name VehiclePhysics -DisplayName "Vehicle Physics" -Description "Raycast car physics."
```

Bu komut `..\VehiclePhysics\` klasörünü şunlarla oluşturur:

| Yol | İçerik |
|---|---|
| `package.json` | `com.atthree.vehicle-physics`, sürüm `0.1.0` |
| `Runtime/` | Oyun kodu + `Atthree.VehiclePhysics.asmdef` |
| `Editor/` | Sadece editör araçları + `Atthree.VehiclePhysics.Editor.asmdef` |
| `Tests/Runtime/` | PlayMode testleri + örnek test |
| `Documentation~/` | Görseller, dokümanlar (`~` ile biten klasörleri Unity görmez) |
| `README.md`, `CHANGELOG.md`, `LICENSE.md` (MIT) | İngilizce + Türkçe README iskeleti |

Ayrıca `git init` yapar ve ilk commit'i atar. `-GitHub` eklersen herkese açık repo açıp push eder
([GitHub CLI](https://cli.github.com) ve `gh auth login` gerekir).

Seçenekler: `-Author` (varsayılan `Atthree`), `-Namespace`, `-PackageId`, `-Unity` (varsayılan
`6000.0`), `-OutDir`.

## Geliştirme döngüsü

1. Üzerinde çalışırken paketi bir oyun projesine bağla, `Packages/manifest.json` içinde:

   ```json
   "com.atthree.vehicle-physics": "file:../../VehiclePhysics",
   ```

   Değişiklikler Unity'de anında görünür. Unity paketin içinde `.meta` dosyaları oluşturur; bunları
   da commit'le.
2. Paketin testlerini çalıştırmak için aynı dosyaya ekle:

   ```json
   "testables": [ "com.atthree.vehicle-physics" ]
   ```

   Sonra **Window > General > Test Runner > PlayMode**.
3. Sürüm çıkarmak için: `package.json`'daki `version`'ı artır, `CHANGELOG.md`'yi yaz, commit'le, sonra

   ```
   git tag v0.2.0
   git push origin main --tags
   ```

4. Diğer oyunlarda şu adresle kur:
   `https://github.com/Atthree/VehiclePhysics.git#v0.2.0`.

Sürümleme ([SemVer](https://semver.org)): hata düzeltme → `0.2.1`, yeni özellik → `0.3.0`, eski
kodu bozan değişiklik → `1.0.0`.
